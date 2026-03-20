import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../../Data/auth_model.dart';
import '../../Data/dotor_model.dart';
import '../../Network/auth_repository.dart';
import '../../Router/router_class.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<SignupModel> doctors = [];
  List<SignupModel> users = [];

  String? role;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final repo = AuthRepository();

    final currentUser = await repo.getCurrentUserDetails();
    role = currentUser!.role;

    if (role == "user") {
      doctors = await repo.getAllDoctors();
    } else if (role == "doctor") {
      users = await repo.getAllUsers();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      body: role == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    role == "doctor" ? "Patients" : "Doctors",
                    style:  TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

             SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: role == "user"
                    ? doctors.length
                    : users.length,
                itemBuilder: (context, index) {

                  final item = role == "user"
                      ? doctors[index]
                      : users[index];

                  return GestureDetector(
                    onTap: () async {
                      final repo = AuthRepository();

                      final currentUser = await repo.getCurrentUserDetails();
                      final otherUserId = item.uid;
                      context.push(RouterName.chatScreen.path, extra: {
                        "currentUserId": currentUser?.uid,
                        "otherUserId": otherUserId,
                      },);

                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: Row(
                        children: [

                          Stack(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Color(0xffE0E7FF),
                                child: Icon(Icons.person, size: 30),
                              ),

                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              )
                            ],
                          ),

                           SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ,
                                  style:  TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                 SizedBox(height: 4),
                                Text(
                                  item.email,
                                  style:  TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                               Text(
                                "2:30 PM",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                               SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration:  BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child:  Text(
                                  "2",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
