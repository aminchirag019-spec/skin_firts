import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skin_firts/Data/appointment_model.dart';
import 'package:skin_firts/Data/doctor_model.dart';
import 'package:skin_firts/Global/custom_widgets.dart';
import 'package:skin_firts/Router/router_class.dart';
import 'package:skin_firts/Utilities/colors.dart';
import 'package:skin_firts/main.dart';
import '../../Bloc/DoctorBloc/doctor_screen_bloc.dart';
import '../../Bloc/DoctorBloc/doctor_screen_state.dart';
import '../../Bloc/DoctorBloc/doctor_screen_event.dart';
import '../../Global/dummy_data.dart';
import '../../Global/enums.dart';
import '../../Helper/app_localizations.dart';
import '../ChatScreens/chat_widget.dart';
import 'doctor_info_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final AddDoctor? doctor;
  const ScheduleScreen({super.key, this.doctor});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localization = AppLocalizations.of(context);
    final langCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<DoctorScreenBloc, DoctorScreenState>(
          listenWhen: (previous, current) => 
              previous.bookingStatus != current.bookingStatus,
          listener: (context, state) {
            if (state.bookingStatus == DoctorStatus.success && state.lastBookedAppointment != null) {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Appointment Booked Successfully"), backgroundColor: Colors.green),
              );
              
              final appointment = state.lastBookedAppointment;
              
              context.go(RouterName.appointmentDetails.path, extra: appointment);
              // Pass the appointment model to the details screen
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context, doctor: widget.doctor, langCode: langCode, localization: localization),
                    _buildDateSelection(context, colorScheme, localization, state),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization?.translate('availableTime') ?? "Available Time",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           SizedBox(height: 15),
                          _buildTimeGrid(context, colorScheme, localization, state),
                           SizedBox(height: 20),
                           Divider(height: 1),
                           SizedBox(height: 20),
                          Text(
                            localization?.translate('Patient Details') ?? "Patient Details",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           SizedBox(height: 10),
                          _buildPatientSelection(context, colorScheme, localization, state),
                           SizedBox(height: 20),
                          Text(localization?.translate('Full Name') ?? "Full Name", style: theme.textTheme.bodySmall),
                           SizedBox(height: 5),
                          customTextField(
                            context: context,
                            hintText: localization?.translate('Full Name') ?? "Full Name",
                            controller: _nameController,
                            isBold: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization?.translate('nameRequired') ?? "Name is required";
                              }
                              return null;
                            },
                          ),
                           SizedBox(height: 15),
                          Text(localization?.translate('Age') ?? "Age", style: theme.textTheme.bodySmall),
                           SizedBox(height: 5),
                          customTextField(
                            context: context,
                            hintText: localization?.formatNumber("30") ?? "30",
                            controller: _ageController,
                            isBold: false,
                            textInputType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization?.translate('ageRequired') ?? "Age is required";
                              }
                              if (int.tryParse(value) == null) {
                                  return localization?.translate('invalidAge') ?? "Please enter a valid age";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          Text(localization?.translate('Gender') ?? "Gender", style: theme.textTheme.bodySmall),
                           SizedBox(height: 10),
                          _buildGenderSelection(context, colorScheme, localization, state),
                           SizedBox(height: 20),
                           Divider(height: 1),
                           SizedBox(height: 20),
                          Text(localization?.translate('Enter Your Problem Here...') ?? "Enter Your Problem Here...", style: theme.textTheme.bodySmall),
                           SizedBox(height: 10),
                          _buildProblemDescription(context, localization),
                           SizedBox(height: 30),
                          state.bookingStatus == DoctorStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : customButton(
                            context,
                            text: localization?.translate('Book Now') ?? "Book Now",
                            backgroundColor: colorScheme.primary,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState!.validate() && widget.doctor != null) {
                                final selectedDate = DateTime.now().add(Duration(days: state.selectedDateIndex));
                                final dateStr = "${_getDayFullName(selectedDate.weekday, localization)}, ${selectedDate.day} ${_getMonthName(selectedDate.month)}";

                                final appointment = AppointmentModel(
                                  id: "",
                                  doctorId: widget.doctor!.id,
                                  doctorName: widget.doctor!.getLocalized(widget.doctor!.doctorName, langCode, localization),
                                  doctorQualification: widget.doctor!.getLocalized(widget.doctor!.qualification, langCode, localization),
                                  doctorSpecialization: widget.doctor!.getLocalized(widget.doctor!.specialization, langCode, localization),
                                  doctorImage: widget.doctor!.profile ?? "",
                                  userId: user!.uid,
                                  patientName: _nameController.text,
                                  patientAge: _ageController.text,
                                  patientGender: state.selectedGender,
                                  problem: _problemController.text,
                                  date: dateStr,
                                  time: state.selectedTime,
                                  status: "upcoming",
                                  createdAt: Timestamp.now(),
                                );

                                context.read<DoctorScreenBloc>().add(BookAppointmentEvent(appointment));
                              }
                            },
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, {AddDoctor? doctor, required String langCode, AppLocalizations? localization}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                context.go(RouterName.doctorInfoScreen.path, extra: doctor);
              },
              child: Icon(Icons.arrow_back_ios, color: colorScheme.primary, size: 20)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.white, size: 16),
                 SizedBox(width: 4),
                Text(
                  doctor != null 
                      ? (doctor.getLocalized(doctor.doctorName, langCode, localization) ?? "")
                      : (localization?.translate("schedule") ?? "Schedule"),
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          chatBarIcons(
            context,
            svgPath: "assets/images/audio.svg.svg",
            color: AppColors.darkPurple,
            imgColor: AppColors.white,
            imgWidth: 15,
            imgHeight: 15,
            width: 6,
          ),
          chatBarIcons(
            context,
            svgPath: "assets/images/video.svg.svg",
            color: AppColors.darkPurple,
            imgColor: AppColors.white,
            imgWidth: 10,
            imgHeight: 10,
            height: 7,
            width: 6,
          ),
          chatBarIcons(
            context,
            svgPath: "assets/images/bottom_message.svg",
            color: AppColors.darkPurple,
            imgColor: AppColors.white,
            imgHeight: 15,
            imgWidth: 15,
            width: 6,
          ),
           Spacer(),
          servicesOptions(context, color: AppColors.lightPurple, icon: Icons.question_mark, size: 15,),
           SizedBox(width: 3),
          BlocBuilder<DoctorScreenBloc, DoctorScreenState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  if (doctor != null) {
                    context.read<DoctorScreenBloc>().add(
                      LikedEvent(doctor.id, !doctor.isLiked),
                    );
                  }
                },
                child: servicesOptions(
                  context,
                  color: AppColors.lightPurple,
                  icon: (doctor?.isLiked ?? false)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  size: state.selectedFilter == DoctorFilter.liked ? 18 : 15,
                ),
              );
            },
          ),
          SizedBox(width: 2),
        ],
      ),
    );
  }

  Widget _buildDateSelection(BuildContext context, ColorScheme colorScheme, AppLocalizations? localization, DoctorScreenState state) {
    return Container(
      color: colorScheme.secondary.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(localization?.translate('month') ?? "Month", style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                 SizedBox(width: 5,),
                Icon(Icons.keyboard_arrow_down, color: colorScheme.primary),
              ],
            ),
          ),
           SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: colorScheme.primary, size: 16),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 14,
                    itemBuilder: (context, index) {
                      DateTime date = DateTime.now().add(Duration(days: index));
                      bool isSelected = state.selectedDateIndex == index;
                      return GestureDetector(
                        onTap: () {
                          context.read<DoctorScreenBloc>().add(SelectDateEvent(index));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal:12,vertical:0),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: isSelected ? colorScheme.primary : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localization?.formatNumber("${date.day}") ?? "${date.day}",
                                style: GoogleFonts.leagueSpartan(
                                  color: isSelected ? AppColors.white : AppColors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1
                                ),
                              ),
                              Text(
                                _getDayName(date.weekday, localization),
                                style: GoogleFonts.leagueSpartan(
                                  color: isSelected ? AppColors.white : AppColors.black,
                                  fontSize: 15,
                                ),
                              )],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: colorScheme.primary, size: 16),
                ],
              ),
            ),
          ],
        ),
      );
    }
  
    String _getDayName(int weekday, AppLocalizations? localization) {
      switch (weekday) {
        case 1: return localization?.translate("mon") ?? "MON";
        case 2: return localization?.translate("tue") ?? "TUE";
        case 3: return localization?.translate("wed") ?? "WED";
        case 4: return localization?.translate("thu") ?? "THU";
        case 5: return localization?.translate("fri") ?? "FRI";
        case 6: return localization?.translate("sat") ?? "SAT";
        case 7: return localization?.translate("sun") ?? "SUN";
        default: return "";
      }
    }
  
    String _getDayFullName(int weekday, AppLocalizations? localization) {
      switch (weekday) {
        case 1: return "Monday";
        case 2: return "Tuesday";
        case 3: return "Wednesday";
        case 4: return "Thursday";
        case 5: return "Friday";
        case 6: return "Saturday";
        case 7: return "Sunday";
        default: return "";
      }
    }
  
    String _getMonthName(int month) {
      const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
      return months[month - 1];
    }
  
    Widget _buildTimeGrid(BuildContext context, ColorScheme colorScheme, AppLocalizations? localization, DoctorScreenState state) {
      List<String> times = ["9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "1:00 PM", "1:30 PM", "2:00 PM", "2:30 PM", "3:00 PM", "3:30 PM", "4:00 PM"];
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
        ),
        itemCount: times.length,
        itemBuilder: (context, index) {
          bool isSelected = times[index] == state.selectedTime;
          bool isBooked = times[index] == "10:30 AM" || times[index] == "12:00 PM";
          
          return GestureDetector(
            onTap: isBooked ? null : () {
              context.read<DoctorScreenBloc>().add(SelectTimeEvent(times[index]));
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected 
                    ? colorScheme.primary 
                    : (isBooked ? Colors.grey.shade300 : colorScheme.secondary.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  localization?.formatNumber(times[index]) ?? times[index],
                  style: GoogleFonts.leagueSpartan(
                    color: isSelected ? Colors.white : (isBooked ? Colors.grey : AppColors.black) ,
                    fontSize: 10,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  
    Widget _buildPatientSelection(BuildContext context, ColorScheme colorScheme, AppLocalizations? localization, DoctorScreenState state) {
      return Row(
        children: [
          _buildChoiceChip(
            localization?.translate('your self') ?? "your self",
            state.selectedPatient == "Yourself", 
            colorScheme,
            () => context.read<DoctorScreenBloc>().add(SelectPatientEvent("Yourself")),
          ),
          const SizedBox(width: 10),
          _buildChoiceChip(
            localization?.translate('Another Person') ?? "Another Person",
            state.selectedPatient == "Another Person", 
            colorScheme,
            () => context.read<DoctorScreenBloc>().add(SelectPatientEvent("Another Person")),
          ),
        ],
      );
    }
  
    Widget _buildChoiceChip(String label, bool isSelected, ColorScheme colorScheme, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.primary, width: 0.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : colorScheme.primary.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ),
      );
    }
  
    Widget _buildGenderSelection(BuildContext context, ColorScheme colorScheme, AppLocalizations? localization, DoctorScreenState state) {
      return Row(
        children: [
          _buildChoiceChip(
            localization?.translate('Male') ?? "Male",
            state.selectedGender == "Male", 
            colorScheme,
            () => context.read<DoctorScreenBloc>().add(SelectGenderEvent("Male")),
          ),
          const SizedBox(width: 10),
          _buildChoiceChip(
            localization?.translate('Female') ?? "Female",
            state.selectedGender == "Female", 
            colorScheme,
            () => context.read<DoctorScreenBloc>().add(SelectGenderEvent("Female")),
          ),
          const SizedBox(width: 10),
          _buildChoiceChip(
            localization?.translate('Other') ?? "Other",
            state.selectedGender == "Other", 
            colorScheme,
            () => context.read<DoctorScreenBloc>().add(SelectGenderEvent("Other")),
          ),
        ],
      );
    }
  
    Widget _buildProblemDescription(BuildContext context, AppLocalizations? localization) {
      return Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xffECF1FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.lightPurple, width: 1),
        ),
        child: TextField(
          controller: _problemController,
          maxLines: null,
          decoration: InputDecoration(
            hintText: localization?.translate('Enter Your Problem Here...') ?? "Enter Your Problem Here...",
            hintStyle: const TextStyle(color: Colors.black26, fontSize: 12),
            border: InputBorder.none,
          ),
        ),
      );
    }
  }
