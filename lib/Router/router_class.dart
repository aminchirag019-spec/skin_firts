
enum RouterName {
  loginScreen('/LoginScreen','LoginScreen'),
  signupScreen('/SignupScreen','SignupScreen'),
  splashScreen('/SplashScreen','SplashScreen'),
  setPasswordScreen('/SetPasswordScreen','SetPasswordScreen'),
  homeScreen('/HomeScreen','HomeScreen'),
  fingerAuthenticationScreen('/FingerAuthenticationScreen','FingerAuthenticationScreen'),
  doctorScreen('/DoctorScreen','DoctorScreen'),
  doctorInfoScreen('/DoctorInfoScreen','DoctorInfoScreen'),
  appointmentScreen('/AppointmentScreen','AppointmentScreen'),
  cancelAppointmentScreen('/CancelAppointmentScreen','CancelAppointmentScreen'),
  appointmentDetails('/AppointmentDetails','AppointmentDetails'),
  doctorDetailsScreen('/DoctorDetailsScreen','DoctorDetailsScreen'),
  scheduleScreen('/ScheduleScreen','ScheduleScreen'),
  messageScreen('/MessageScreen','MessageScreen'),
  profileScreen('/ProfileScreen','ProfileScreen'),
  settingScreen('/SettingScreen','SettingScreen'),
  addDoctorScreen('/AddDoctorScreen','AddDoctorScreen'),
  editUserScreen('/EditUserScreen','EditUserScreen'),
  chatScreen('/ChatScreen','ChatScreen'),
  privacyPolicyScreen('/PrivacyPolicyScreen','PrivacyPolicyScreen'),
  termsAndConditionScreen('/TermsAndConditionScreen','TermsAndConditionScreen'),
  helpCentreScreen('/HelpCentreScreen','HelpCentreScreen'),
  chatListScreen('/ChatScreens','ChatScreens'),
  notificationSetting('/NotificationScreen','NotificationScreen'),
  passwordManagerScreen('/PasswordManagerScreen','PasswordManagerScreen'),
  welcomeScreen('/WelcomeScreen','WelcomeScreen'),
  reviewScreen('/ReviewScreen','ReviewScreen');


  final String path;
  final String name;

  const RouterName(this.path,this.name);
}