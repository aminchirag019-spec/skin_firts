import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Screens/ProfileScreen/add_doctor_screen.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Global/app_string.dart';
import '../../Global/coustom_widgets.dart';
import '../../Global/enums.dart';
import '../../Router/router_class.dart';
import '../../Utilities/media_query.dart';

class PasswordManagerScreen extends StatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  State<PasswordManagerScreen> createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(LoadCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.settingScreen.path);
        return false;
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {},
        child: Scaffold(
          backgroundColor: Colors.white,
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
                      onPressed: () =>
                          context.go(RouterName.settingScreen.path),
                      text: " Password Manager",
                    ),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    title(context, title: "Current Password"),
                    coustomTextField(
                      context: context,
                      controller: currentPassController,
                      hintText: "••••••••",
                      image: AssetImage("assets/images/obsecure_image.png"),
                    ),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go(RouterName.setPasswordScreen.path);
                          },
                          child: Text(
                            "${AppString.forgotPass}?",
                            style: GoogleFonts.leagueSpartan(
                              fontSize: AppSize.width(context) * 0.043, // 13
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff2260FF),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.width(context) * 0.025), // 10
                      ],
                    ),
                    SizedBox(height: AppSize.height(context) * 0.011),
                    title(context, title: "New Password"),
                    coustomTextField(
                      context: context,
                      controller: newPassController,
                      hintText: "••••••••",
                      image: AssetImage("assets/images/obsecure_image.png"),
                    ),
                    SizedBox(height: AppSize.height(context) * 0.021),
                    title(context, title: "Confirm Password"),
                    coustomTextField(
                      context: context,
                      controller: confirmPassController,
                      hintText: "••••••••",
                      image: AssetImage("assets/images/obsecure_image.png"),
                    ),
                    SizedBox(height: AppSize.height(context) * 0.4),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state.passwordStatus == PasswordStatus.success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Password changed successfully")),
                          );
                        }
                        if (state.passwordStatus == PasswordStatus.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Something went wrong")),
                          );
                        }
                      },
                      builder: (context, state) {
                        return customButton(
                          context,
                          text: "Change Password",
                          backgroundColor: Color(0xff2260FF),
                          fontSize: 20,
                          width: 280,
                          textColor: Colors.white,
                          onPressed: () {
                            print(newPassController.text);
                            context.read<AuthBloc>().add(UpdatePasswordEvent(
                                currentPassword: currentPassController.text,
                                newPassword: newPassController.text,
                                confirmPassword: confirmPassController.text));

                            currentPassController.clear();
                            newPassController.clear();
                            confirmPassController.clear();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
