import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/enums.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/Utilities/textfield_validators.dart';
import '../../Bloc/AuthBloc/auth_bloc.dart';
import '../../Bloc/ChatBloc/chat_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Data/auth_model.dart';
import '../../Global/custom_widgets.dart';
import '../../Helper/app_localizations.dart';
import '../../router/router_class.dart';
import '../../Utilities/media_query.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Doctor specific controllers
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController profileController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController careerPathController = TextEditingController();
  final TextEditingController highlightsController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    dobController.dispose();
    phoneController.dispose();
    specializationController.dispose();
    qualificationController.dispose();
    experienceController.dispose();
    availabilityController.dispose();
    profileController.dispose();
    descriptionController.dispose();
    careerPathController.dispose();
    highlightsController.dispose();
    ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.loginScreen.path);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width(context) * 0.064,
              vertical: AppSize.height(context) * 0.017,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ChoiceChip(
                            label: Text(
                              localization?.translate("user") ?? "User",
                            ),
                            selected: state.selectedRole == "user",
                            onSelected: (_) {
                              context.read<AuthBloc>().add(
                                SelectRoleEvent("user"),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: Text(
                              localization?.translate('doctors') ?? "Doctor",
                            ),
                            selected: state.selectedRole == "doctor",
                            onSelected: (_) {
                              context.read<AuthBloc>().add(
                                SelectRoleEvent("doctor"),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  topRow(
                    context,
                    onPressed: () {
                      context.go(RouterName.loginScreen.path);
                    },
                    text:
                        localization?.translate('newAccount') ?? "New Account",
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Form(
                    key: formKey,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(
                              theme,
                              localization?.translate('Full Name') ??
                                  "Full name",
                            ),
                            customTextField(
                              context: context,
                              controller: nameController,
                              validator: (value) =>
                                  Validators().validateName(context, value),
                              hintText:
                                  localization?.translate('nameExample') ??
                                  "Enter Your Name",
                              size: 20,
                            ),
                            SizedBox(height: AppSize.height(context) * 0.014),
                            _buildLabel(
                              theme,
                              localization?.translate('password') ?? "password",
                            ),
                            BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                              builder: (context, docState) {
                                return customTextField(
                                  context: context,
                                  hintText: "••••••••",
                                  obscureText: docState.isPasswordHidden,
                                  controller: passwordController,
                                  validator: (value) => Validators()
                                      .validatePassword(context, value),
                                  image: const AssetImage(
                                    "assets/images/obsecure_image.png",
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: AppSize.height(context) * 0.014),
                            _buildLabel(
                              theme,
                              localization?.translate('email') ?? "Email",
                            ),
                            customTextField(
                              context: context,
                              validator: (value) =>
                                  Validators().validateEmail(context, value),
                              hintText:
                                  localization?.translate('emailExample') ??
                                  "example@example.com",
                              controller: emailController,
                              size: 20,
                            ),
                            SizedBox(height: AppSize.height(context) * 0.014),
                            _buildLabel(
                              theme,
                              localization?.translate('mobile') ??
                                  "Mobile Number",
                            ),
                            customTextField(
                              context: context,
                              maxLength: 10,
                              validator: (value) =>
                                  Validators().validateMobile(context, value),
                              textInputType: TextInputType.number,
                              hintText:
                                  localization?.translate('numberExample') ??
                                  "+91 0000000000",
                              h: 16,
                              w: 13,
                              controller: phoneController,
                              size: 18,
                            ),
                            SizedBox(height: AppSize.height(context) * 0.014),
                            _buildLabel(
                              theme,
                              localization?.translate('dob') ?? "Date of birth",
                            ),
                            customTextField(
                              context: context,
                              validator: (value) =>
                                  Validators().validateDob(context, value),
                              hintText:
                                  localization?.translate('DD/MM/YYYY') ??
                                  "DD/MM/YYY",
                              isBold: true,
                              controller: dobController,
                              size: 20,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  dobController.text =
                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                }
                              },
                            ),

                            if (state.selectedRole == "doctor") ...[
                              SizedBox(height: AppSize.height(context) * 0.02),
                              _sectionTitle(
                                context,
                                localization?.translate(
                                      "Professional Details",
                                    ) ??
                                    "Professional Details",
                              ),
                              _buildLabel(
                                theme,
                                localization?.translate("Specialization") ??
                                    "Specialization",
                              ),
                              customTextField(
                                context: context,
                                controller: specializationController,
                                hintText: "Dermatologist",
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("qualification") ??
                                    "Qualification",
                              ),
                              customTextField(
                                context: context,
                                controller: qualificationController,
                                hintText: "MD, MBBS",
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("Experience") ??
                                    "Experience",
                              ),
                              customTextField(
                                context: context,
                                controller: experienceController,
                                hintText: "10+ years of experience",
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("Availybility") ??
                                    "Availability",
                              ),
                              customTextField(
                                context: context,
                                controller: availabilityController,
                                hintText: "Mon - Fri, 9 AM - 5 PM",
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("profile") ??
                                    "Profile Image URL",
                              ),
                              customTextField(
                                context: context,
                                controller: profileController,
                                hintText: "https://example.com/photo.jpg",
                              ),
                              SizedBox(height: AppSize.height(context) * 0.02),
                              _buildGenderDropdown(context, localization),
                              SizedBox(height: AppSize.height(context) * 0.02),
                              _sectionTitle(
                                context,
                                localization?.translate("Extra Details") ??
                                    "Extra Details",
                              ),
                              _buildLabel(
                                theme,
                                localization?.translate("Description") ??
                                    "Description",
                              ),
                              customTextField(
                                context: context,
                                controller: descriptionController,
                                hintText: "Brief description...",
                                size: 20,
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("careerPath") ??
                                    "Career Path",
                              ),
                              customTextField(
                                context: context,
                                controller: careerPathController,
                                hintText: "Career journey...",
                                size: 20,
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("highlights") ??
                                    "Highlights",
                              ),
                              customTextField(
                                context: context,
                                controller: highlightsController,
                                hintText: "Key achievements...",
                                size: 20,
                              ),
                              SizedBox(height: AppSize.height(context) * 0.014),
                              _buildLabel(
                                theme,
                                localization?.translate("Rating") ?? "Rating",
                              ),
                              customTextField(
                                context: context,
                                controller: ratingController,
                                hintText: "4.5",
                                textInputType: TextInputType.number,
                              ),
                            ],
                            SizedBox(height: AppSize.height(context) * 0.017),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  localization?.translate('byContinuing') ??
                                      "By continuing, you agree to",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: -0.3,
                                    height: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localization?.translate('terms') ?? "Terms of Use",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      Text(
                        localization?.translate('and') ?? "and",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      Text(
                        localization?.translate('privacy') ?? "Privacy Policy",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.signupStatus == SignupStatus.success) {
                        if (state.selectedRole == "doctor") {
                          final doctorState = context
                              .read<DoctorScreenBloc>()
                              .state;
                          final doctor = AddDoctor(
                            id: "",
                            doctorName: nameController.text,
                            experience: experienceController.text,
                            specialization: specializationController.text,
                            availability: availabilityController.text,
                            description: descriptionController.text,
                            profile: profileController.text,
                            careerPath: careerPathController.text,
                            highlights: highlightsController.text,
                            qualification: qualificationController.text,
                            isLiked: doctorState.addDoctorIsLiked,
                            rating:
                                double.tryParse(ratingController.text) ?? 0.0,
                            email: emailController.text,
                            gender: doctorState.addDoctorGender,
                          );
                          context.read<DoctorScreenBloc>().add(
                            AddDoctorEvent(doctor),
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localization?.translate("Signup Successful") ??
                                  "Signup Successful",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        context.go(RouterName.fingerAuthenticationScreen.path);
                      } else if (state.signupStatus == SignupStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localization?.translate("Signup Failed") ??
                                  "Signup Failed. Please try again.",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.signupStatus == SignupStatus.loading) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                      return customButton(
                        context,
                        text: localization?.translate('signUp') ?? "Sign Up",
                        backgroundColor: colorScheme.primary,
                        width: AppSize.width(context) * 0.538,
                        textColor: Colors.white,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                            SignUpEvent(
                              signupModel: SignupModel(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                dob: dobController.text,
                                phone: phoneController.text,
                                role: state.selectedRole,
                                uid: "",
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          localization?.translate('signupOptionTitle') ??
                              "or sign up with",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.009),
                  loginRow(
                    context,
                    icons: [
                      LoginRow(
                        svgPath: "assets/images/goole_svg.svg",
                        iconSize: 26,
                      ),
                      LoginRow(svgPath: "assets/images/facebook_svg.svg"),
                      LoginRow(
                        svgPath: "assets/images/finger_svg.svg",
                        onTap: () => context.go(
                          RouterName.fingerAuthenticationScreen.path,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.height(context) * 0.035),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localization?.translate('already') ??
                            "already have an account?",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: AppSize.width(context) * 0.005),
                      GestureDetector(
                        onTap: () {
                          context.go(RouterName.loginScreen.path);
                        },
                        child: Text(
                          localization?.translate('logIn') ?? "Log In",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSize.height(context) * 0.015,
        top: AppSize.height(context) * 0.01,
      ),
      child: Text(
        text,
        style: GoogleFonts.leagueSpartan(
          fontSize: AppSize.width(context) * 0.05,
          fontWeight: FontWeight.bold,
          color: AppColors.darkPurple,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(
    BuildContext context,
    AppLocalizations? localization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(
          Theme.of(context),
          localization?.translate("Gender") ?? "Gender",
        ),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.lightPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
              buildWhen: (previous, current) =>
                  previous.addDoctorGender != current.addDoctorGender,
              builder: (context, state) {
                return DropdownButton<String>(
                  value: state.addDoctorGender,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.darkPurple,
                  ),
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.leagueSpartan(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<DoctorScreenBloc>().add(
                        ChangeAddDoctorGenderEvent(val),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
