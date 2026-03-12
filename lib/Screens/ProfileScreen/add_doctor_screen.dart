import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Data/dotor_model.dart';
import 'package:skin_firts/Global/coustom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';
import 'package:skin_firts/Screens/DoctorScreens/doctor_screen.dart';

import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Global/enums.dart';

class AddDoctorScreen extends StatelessWidget {
  AddDoctorScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController specializationController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController availybilityController = TextEditingController();
  TextEditingController careerpathController = TextEditingController();
  TextEditingController heighlightsController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();

  final doctorKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                      SizedBox(height: 10),
                      Title(title: "Name"),
                      AddDoctorField(hint: "Name", controller: nameController),
                      SizedBox(height: 7),
                      Title(title: "Profile"),
                      AddDoctorField(
                        hint: "Profile",
                        controller: profileController,
                      ),
                      SizedBox(height: 7),
                      Title(title: "Specialization"),
                      AddDoctorField(
                        hint: "Specialization",
                        controller: specializationController,
                      ),
                      SizedBox(height: 7),
                      Title(title: "qualification"),
                      AddDoctorField(
                        hint: "qualification",
                        controller: qualificationController,
                      ),
                      SizedBox(height: 7),
                      Title(title: "Availybility"),
                      AddDoctorField(
                        hint: "Availybility",
                        controller: availybilityController,
                      ),
                      SizedBox(height: 7),
                      Title(title: "Career Path"),
                      AddDoctorField(
                        hint: "Career Path",
                        controller: careerpathController,
                        isParagraph: true,
                      ),
                      SizedBox(height: 7),
                      Title(title: "Highlights"),
                      AddDoctorField(
                        hint: "Highlights",
                        controller: heighlightsController,
                        isParagraph: true,
                      ),
                      SizedBox(height: 7),
                      Title(title: "Experience"),
                      AddDoctorField(
                        hint: "Experience",
                        controller: experienceController,
                        isParagraph: true,
                      ),
                      SizedBox(height: 7),
                      Title(title: "Description"),
                      AddDoctorField(
                        hint: "Description",
                        controller: discriptionController,
                        isParagraph: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                BlocConsumer<DoctorScreenBloc, DoctorScreenState>(
                  listener: (context, state) {
                    if (state.doctorStatus == DoctorStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Doctor Added Successfully"),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.doctorStatus == DoctorStatus.loading) {
                      return const CircularProgressIndicator();
                    }

                    return customButton(
                      text: "Add Doctor",
                      backgroundColor: const Color(0xff2260FF),
                      textColor: Colors.white,
                      onPressed: () {
                        if (!doctorKey.currentState!.validate()) return;

                        final doctor = AddDoctor(
                          qualification: "",
                          doctorName: nameController.text,
                          experience: experienceController.text,
                          specialization: specializationController.text,
                          availability: availybilityController.text,
                          description: discriptionController.text,
                          profile: profileController.text,
                          careerPath: careerpathController.text,
                          highlights: heighlightsController.text,
                        );

                        context.read<DoctorScreenBloc>().add(
                          AddDoctorEvent(doctor),
                        );
                        nameController.clear();
                        experienceController.clear();
                        specializationController.clear();
                        availybilityController.clear();
                        discriptionController.clear();
                        profileController.clear();
                        careerpathController.clear();
                        heighlightsController.clear();
                        qualificationController.clear();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget AddDoctorField({
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
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Color(0xffCAD6FF),
    ),
  );
}

Widget Title({required String title}) {
  return Row(
    children: [
      SizedBox(width: 8),
      Text(
        title,
        style: GoogleFonts.leagueSpartan(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
