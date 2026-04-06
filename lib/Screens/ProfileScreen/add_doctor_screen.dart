import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Bloc/DoctorBloc/doctor_screen_event.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_bloc.dart';
import 'package:skin_firts/Bloc/NotificationBloc/notification_event.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/custom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Helper/app_localizations.dart';
import 'package:skin_firts/Utilities/textfield_validators.dart';

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
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final doctorKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    specializationController.dispose();
    descriptionController.dispose();
    profileController.dispose();
    experienceController.dispose();
    availabilityController.dispose();
    careerPathController.dispose();
    highlightsController.dispose();
    qualificationController.dispose();
    ratingController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _clearForm() {
    nameController.clear();
    experienceController.clear();
    specializationController.clear();
    availabilityController.clear();
    descriptionController.clear();
    profileController.clear();
    careerPathController.clear();
    highlightsController.clear();
    qualificationController.clear();
    ratingController.clear();
    emailController.clear();
    context.read<DoctorScreenBloc>().add(ClearAddDoctorFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RouterName.profileScreen.path);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width(context) * 0.064,
                  vertical: AppSize.height(context) * 0.023,
                ),
                child: topRow(
                  context,
                  onPressed: () {
                    context.go(RouterName.profileScreen.path);
                  },
                  text: localization?.translate("addDoctor") ?? "Add Doctor",
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width(context) * 0.064,
                  ),
                  child: Form(
                    key: doctorKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(context, localization?.translate("Personal Information") ?? "Personal Information"),
                        _buildField(
                          context,
                          label: localization?.translate("fullname") ?? "Full Name",
                          controller: nameController,
                          hint: "Dr. John Doe",
                          validator: (value) => value == null || value.isEmpty ? "Please enter name" : null,
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("email") ?? "Email",
                          controller: emailController,
                          hint: "doctor@example.com",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Validators().validateEmail(context, value),
                        ),
                        _buildGenderDropdown(context, localization),
                        SizedBox(height: AppSize.height(context) * 0.02),

                        _sectionTitle(context, localization?.translate("Professional Details") ?? "Professional Details"),
                        _buildField(
                          context,
                          label: localization?.translate("Specialization") ?? "Specialization",
                          controller: specializationController,
                          hint: "Dermatologist",
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("qualification") ?? "Qualification",
                          controller: qualificationController,
                          hint: "MD, MBBS",
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("Experience") ?? "Experience",
                          controller: experienceController,
                          hint: "10+ years of experience",
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("Availybility") ?? "Availability",
                          controller: availabilityController,
                          hint: "Mon - Fri, 9 AM - 5 PM",
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("profile") ?? "Profile Image URL",
                          controller: profileController,
                          hint: "https://example.com/photo.jpg",
                        ),
                        SizedBox(height: AppSize.height(context) * 0.02),

                        _sectionTitle(context, localization?.translate("Extra Details") ?? "Extra Details"),
                        _buildField(
                          context,
                          label: localization?.translate("Description") ?? "Description",
                          controller: descriptionController,
                          hint: "Brief description about the doctor...",
                          isParagraph: true,
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("careerPath") ?? "Career Path",
                          controller: careerPathController,
                          hint: "Academic and professional journey...",
                          isParagraph: true,
                        ),
                        _buildField(
                          context,
                          label: localization?.translate("highlights") ?? "Highlights",
                          controller: highlightsController,
                          hint: "Key achievements...",
                          isParagraph: true,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                context,
                                label: localization?.translate("Rating") ?? "Rating",
                                controller: ratingController,
                                hint: "4.5",
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: AppSize.width(context) * 0.05),
                            BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
                              buildWhen: (previous, current) => previous.addDoctorIsLiked != current.addDoctorIsLiked,
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localization?.translate("liked") ?? "Liked",
                                      style: GoogleFonts.leagueSpartan(
                                        fontSize: AppSize.width(context) * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.darkPurple,
                                      ),
                                    ),
                                    Switch(
                                      value: state.addDoctorIsLiked,
                                      activeColor: AppColors.darkPurple,
                                      onChanged: (val) {
                                        context.read<DoctorScreenBloc>().add(ToggleAddDoctorLikedEvent(val));
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: AppSize.height(context) * 0.04),
                        _buildSubmitButton(context, localization),
                        SizedBox(height: AppSize.height(context) * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.height(context) * 0.015, top: AppSize.height(context) * 0.01),
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

  Widget _buildField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
        required String hint,
        bool isParagraph = false,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.height(context) * 0.015),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.leagueSpartan(
              fontSize: AppSize.width(context) * 0.04,
              fontWeight: FontWeight.w500,
              color: AppColors.darkPurple.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: isParagraph ? TextInputType.multiline : keyboardType,
            minLines: isParagraph ? 3 : 1,
            maxLines: isParagraph ? 5 : 1,
            validator: validator,
            style: GoogleFonts.leagueSpartan(fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.leagueSpartan(color: Colors.grey.shade400),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isParagraph ? 12 : 0),
              filled: true,
              fillColor: AppColors.lightPurple.withOpacity(0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.darkPurple, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(BuildContext context, AppLocalizations? localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization?.translate("Gender") ?? "Gender",
          style: GoogleFonts.leagueSpartan(
            fontSize: AppSize.width(context) * 0.04,
            fontWeight: FontWeight.w500,
            color: AppColors.darkPurple.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.lightPurple.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
              buildWhen: (previous, current) => previous.addDoctorGender != current.addDoctorGender,
              builder: (context, state) {
                return DropdownButton<String>(
                  value: state.addDoctorGender,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.darkPurple),
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.leagueSpartan(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<DoctorScreenBloc>().add(ChangeAddDoctorGenderEvent(val));
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

  Widget _buildSubmitButton(BuildContext context, AppLocalizations? localization) {
    return BlocConsumer<DoctorScreenBloc, DoctorScreenState>(
      listenWhen: (previous, current) => previous.addDoctorStatus != current.addDoctorStatus,
      listener: (context, state) {
        if (state.addDoctorStatus == DoctorStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(localization?.translate("Doctor Added Successfully") ?? "Doctor Added Successfully"),
            ),
          );
          _clearForm();
        }
        if (state.addDoctorStatus == DoctorStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(localization?.translate("Something went wrong") ?? "Something went wrong"),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.addDoctorStatus == DoctorStatus.loading) {
          return Center(child: CircularProgressIndicator(color: AppColors.darkPurple));
        }
        return customButton(
          context,
          text: localization?.translate("addDoctor") ?? "Add Doctor",
          backgroundColor: AppColors.darkPurple,
          textColor: AppColors.white,
          width: double.infinity,
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
              isLiked: state.addDoctorIsLiked,
              rating: double.tryParse(ratingController.text) ?? 0.0,
              email: emailController.text,
              gender: state.addDoctorGender,
            );

            context.read<DoctorScreenBloc>().add(AddDoctorEvent(doctor));

            context.read<NotificationBloc>().add(
              SendNotificationEvent(
                doctor,
                NotificationModel(
                  title: localization?.translate("Add Doctor") ?? "Add Doctor",
                  body: "${localization?.translate("add_doctor_prefix") ?? "You successfully added a"} ${doctor.doctorName}",
                ),
              ),
            );
          },
        );
      },
    );
  }
}
