import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skin_firts/Data/auth_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Screens/ProfileScreen/add_doctor_screen.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Utilities/media_query.dart';
import '../../main.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController pass = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadCurrentUser());
    print("_----------------${nameController.text}");
  }

  @override
  void dispose() {
    nameController.dispose();
        _emailController.dispose();
        dobController.dispose();
        phoneController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
        return BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if(state.currentUser != null) {
      nameController.text = state.currentUser!.name;
      _emailController.text = state.currentUser!.email;
      phoneController.text = state.currentUser!.phone;
      dobController.text = state.currentUser!.dob;

    }
  },
  child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width(context) * 0.064, // 25
                vertical: AppSize.height(context) * 0.023,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    topRow(
                      context,
                      onPressed: () => context.go(RouterName.profileScreen.path),
                      text: "Profile",
                    ),
                    SizedBox(height: AppSize.height(context) * 0.011), // 10
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          child: CircleAvatar(
                            radius: AppSize.width(context) * 0.153, // 60
                            backgroundImage: const AssetImage(
                              "assets/images/doctor_1.png",
                            ),
                          ),
                        ),
                        Positioned(
                          right: AppSize.width(context) * 0.007, // 3
                          bottom: AppSize.height(context) * 0.009, // 8
                          child: Container(
                            height: AppSize.width(context) * 0.076, // 30
                            width: AppSize.width(context) * 0.076, // 30
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff2260FF),
                            ),
                            child: const Image(
                              image: AssetImage("assets/images/pen.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    title(context, title: "Full Name",),
                    coustomTextField(context: context,
                        controller: nameController,
                        hintText: ""),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    title(context, title: "Email"),
                    coustomTextField(context: context,
                        controller: _emailController,
                        hintText: ""),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    title(context, title: "Phone Number"),
                    coustomTextField(context: context,
                        controller: phoneController,
                        hintText: ""),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    title(context, title: "Date of birth"),
                    coustomTextField(context: context,
                        controller: dobController,
                        hintText: ""),
                    SizedBox(height: AppSize.height(context) * 0.2),
                    customButton(context, text: "Update Profile", backgroundColor: Color(0xff2260FF), textColor: Colors.white, onPressed: () {
                      context.read<AuthBloc>().add(UpdateProfileEvent(signupModel: SignupModel(
                          email:_emailController.text,
                          password: pass.text,
                          name: nameController.text,
                          phone: phoneController.text,
                          dob: dobController.text,
                          role: '', uid: ''
                      )));
                    },)

                  ],
                ),
              ),
            ),
          ),
        ),
);
  }
}
