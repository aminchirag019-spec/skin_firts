import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Data/auth_model.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Global/custom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';

import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Helper/app_localizations.dart';
import '../../Utilities/media_query.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(LoadCurrentUser());
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
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.currentUser != null) {
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
              horizontal: AppSize.width(context) * 0.064,
              vertical: AppSize.height(context) * 0.023,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  topRow(
                    context,
                    onPressed: () => context.go(RouterName.profileScreen.path),
                    text: localization?.translate('editUser') ?? "Edit User",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: AppSize.width(context) * 0.153,
                        backgroundImage: const AssetImage(
                          "assets/images/doctor_1.png",
                        ),
                      ),
                      Positioned(
                        right: AppSize.width(context) * 0.007,
                        bottom: AppSize.height(context) * 0.009,
                        child: Container(
                          height: AppSize.width(context) * 0.076,
                          width: AppSize.width(context) * 0.076,
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
                  title(context, title: localization?.translate('fullname') ?? "Full Name"),
                  customTextField(
                    context: context,
                    controller: nameController,
                    hintText: "",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  title(context, title: localization?.translate('email') ?? "Email"),
                  customTextField(
                    context: context,
                    controller: _emailController,
                    hintText: "",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  title(context, title: localization?.translate('mobile') ?? "Phone Number"),
                  customTextField(
                    context: context,
                    controller: phoneController,
                    hintText: "",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  title(context, title: localization?.translate('dob') ?? "Date of birth"),
                  customTextField(
                    context: context,
                    controller: dobController,
                    hintText: "",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.1),
                  customButton(
                    context,
                    text: localization?.translate('update') ?? "Update Profile",
                    backgroundColor: AppColors.darkPurple,
                    textColor: AppColors.white,
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        UpdateProfileEvent(
                          signupModel: SignupModel(
                            email: _emailController.text,
                            password: pass.text,
                            name: nameController.text,
                            phone: phoneController.text,
                            dob: dobController.text,
                            role: '',
                            uid: '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget title(BuildContext context, {required String title, double? size}) {
    return Row(
      children: [
        SizedBox(width: AppSize.width(context) * 0.020),
        Text(
          title,
          style: GoogleFonts.leagueSpartan(
            fontSize: AppSize.width(context) * 0.046,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
