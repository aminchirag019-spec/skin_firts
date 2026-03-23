import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';
import 'package:skin_firts/Data/dotor_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Utilities/firebase_message.dart';

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
  TextEditingController nameController = TextEditingController();

  TextEditingController specializationController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController profileController = TextEditingController();

  TextEditingController experienceController = TextEditingController();

  TextEditingController availabilityController = TextEditingController();

  TextEditingController careerPathController = TextEditingController();

  TextEditingController highlightsController = TextEditingController();

  TextEditingController qualificationController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController serviceController = TextEditingController();

  TextEditingController ratingController = TextEditingController();

  TextEditingController likeController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  final doctorKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              horizontal: AppSize.width(context) * 0.064, // 25
              vertical: AppSize.height(context) * 0.023, // 20
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
                    text: "Add Doctor",
                  ),
                  Form(
                    key: doctorKey,
                    child: Column(
                      children: [
                        SizedBox(height: AppSize.height(context) * 0.011), // 10
                        title(context, title: "Name"),
                        AddDoctorField(
                          context,
                          hint: "Name",
                          controller: nameController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Profile"),
                        AddDoctorField(
                          context,
                          hint: "Profile",
                          controller: profileController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Specialization"),
                        AddDoctorField(
                          context,
                          hint: "Specialization",
                          controller: specializationController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "qualification"),
                        AddDoctorField(
                          context,
                          hint: "qualification",
                          controller: qualificationController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Availybility"),
                        AddDoctorField(
                          context,
                          hint: "Availybility",
                          controller: availabilityController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Career Path"),
                        AddDoctorField(
                          context,
                          hint: "Career Path",
                          controller: careerPathController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Highlights"),
                        AddDoctorField(
                          context,
                          hint: "Highlights",
                          controller: highlightsController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Experience"),
                        AddDoctorField(
                          context,
                          hint: "Experience",
                          controller: experienceController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Description"),
                        AddDoctorField(
                          context,
                          hint: "Description",
                          controller: descriptionController,
                          isParagraph: true,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Gender"),
                        AddDoctorField(
                          context,
                          hint: "Gender",
                          controller: genderController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "Rating"),
                        AddDoctorField(
                          context,
                          hint: "Rating",
                          controller: ratingController,
                        ),
                        SizedBox(height: AppSize.height(context) * 0.008), // 7
                        title(context, title: "liked"),
                        AddDoctorField(
                          context,
                          hint: "liked",
                          controller: likeController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.height(context) * 0.011), // 10
                  BlocConsumer<DoctorScreenBloc, DoctorScreenState>(
                    listener: (context, state) {
                      if (state.doctorStatus == DoctorStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Doctor Added Successfully"),
                          ),
                        );
                      }
                      if (state.doctorStatus == DoctorStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Something went wrong")),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.doctorStatus == DoctorStatus.loading) {
                        return const CircularProgressIndicator();
                      }
                      return customButton(
                        context,
                        text: "Add Doctor",
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
                            isLiked: likeController.text == "true"
                                ? true
                                : false,
                            rating: double.parse(ratingController.text),
                            email: emailController.text,
                            gender: genderController.text,
                          );

                          context.read<DoctorScreenBloc>().add(
                            AddDoctorEvent(doctor),
                          );
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
                                body:
                                    "You successfully added a ${doctor.doctorName}",
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
        ), // 15
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: AppColors.lightPurple
    ),
  );
}

Widget title(BuildContext context, {required String title, double? size}) {
  return Row(
    children: [
      SizedBox(width: AppSize.width(context) * 0.020), // 8
      Text(
        title,
        style: GoogleFonts.leagueSpartan(
          fontSize: AppSize.width(context) * 0.046, // 18
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
