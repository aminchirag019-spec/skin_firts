import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Helper/app_localizations.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Utilities/colors.dart';
import '../../Global/enums.dart';
import '../../Utilities/media_query.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController profileController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController careerPathController = TextEditingController();
  final TextEditingController highlightsController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController likeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final doctorKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        context.go(RouterName.profileScreen.path);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
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
                    onPressed: () {
                      context.go(RouterName.profileScreen.path);
                    },
                    text: localization?.translate("addDoctor") ?? "Add Doctor",
                  ),
                  Form(
                    key: doctorKey,
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.height(context) * 0.011),
                        title(context, title: localization?.translate("fullname") ?? "Name"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("fullname") ?? "Name",
                          controller: nameController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("profile") ?? "Profile"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("profile") ?? "Profile",
                          controller: profileController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("Specialization") ?? "Specialization"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("Specialization") ?? "Specialization",
                          controller: specializationController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("qualification") ?? "qualification"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("qualification") ?? "qualification",
                          controller: qualificationController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("Availybility") ?? "Availybility"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("Availybility") ?? "Availybility",
                          controller: availabilityController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("careerPath") ?? "Career Path"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("careerPath") ?? "Career Path",
                          controller: careerPathController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("highlights") ?? "Highlights"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("highlights") ?? "Highlights",
                          controller: highlightsController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("Experience") ?? "Experience"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("Experience") ?? "Experience",
                          controller: experienceController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("Description") ?? "Description"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("Description") ?? "Description",
                          controller: descriptionController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("Gender") ?? "Gender"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("Gender") ?? "Gender",
                          controller: genderController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("Rating") ?? "Rating"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("Rating") ?? "Rating",
                          controller: ratingController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008),
                        title(context, title: localization?.translate("liked") ?? "liked"),
                        AddDoctorField(
                          context,
                          hint: localization?.translate("liked") ?? "liked",
                          controller: likeController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011),
                  BlocConsumer<DoctorScreenBloc, DoctorScreenState>(
                    listener: (context, state) {
                      if (state.doctorStatus == DoctorStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localization?.translate("Doctor Added Successfully") ?? "Doctor Added Successfully"),
                          ),
                        );
                      }
                      if (state.doctorStatus == DoctorStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization?.translate("Something went wrong") ?? "Something went wrong")),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.doctorStatus == DoctorStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      return customButton(
                        context,
                        text: localization?.translate("addDoctor") ?? "Add Doctor",
                        backgroundColor: AppColors.darkPurple,
                        textColor: AppColors.white,
                        onPressed: () {
                          if (!doctorKey.currentState!.validate()) return;

                          final doctor = AddDoctor(
                            id: "",
                            qualification: qualificationController.text,
                            doctorName: nameController.text,
                            experience: experienceController.text,
                            specialization: specializationController.text,
                            availability: availabilityController.text,
                            description: descriptionController.text,
                            profile: profileController.text,
                            careerPath: careerPathController.text,
                            highlights: highlightsController.text,
                            isLiked: likeController.text == "true",
                            rating: double.tryParse(ratingController.text) ?? 0.0,
                            email: emailController.text,
                            gender: genderController.text,
                          );

                          context.read<DoctorScreenBloc>().add(
                            AddDoctorEvent(doctor),
                          );
                          // Clear controllers...
                          nameController.clear();
                          experienceController.clear();
                          specializationController.clear();
                          availabilityController.clear();
                          descriptionController.clear();
                          profileController.clear();
                          careerPathController.clear();
                          highlightsController.clear();
                          qualificationController.clear();
                          likeController.clear();
                          ratingController.clear();
                          emailController.clear();
                          genderController.clear();
                          
                          context.read<NotificationBloc>().add(
                            SendNotificationEvent(
                              doctor,
                              NotificationModel(
                                title: "Add Doctor",
                                body: "You successfully added a ${doctor.doctorName}",
                              ),
                            ),
                          );
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
    );
  }
}

Widget AddDoctorField(
  BuildContext context, {
  required String hint,
  required TextEditingController controller,
  bool isParagraph = false,
}) {
  return TextField(
    controller: controller,
    keyboardType: isParagraph ? TextInputType.multiline : TextInputType.text,
    minLines: isParagraph ? 3 : 1,
    maxLines: isParagraph ? null : 1,
    decoration: InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSize.width(context) * 0.038,
        ),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: AppColors.lightPurple,
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
