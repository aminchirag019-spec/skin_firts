

enum RouterName {
  loginScreen('/LoginScreen','LoginScreen'),
  signupScreen('/SignupScreen','SignupScreen'),
  loginScreen1('/LoginScreen_1','LoginScreen'),
  splashScreen('/SplashScreen','SplashScreen'),
  setPasswordScreen('/SetPasswordScreen','SetPasswordScreen'),
  homeScreen('/HomeScreen','HomeScreen'),
  fingerAuthenticationScreen('/FingerAuthenticationScreen','FingerAuthenticationScreen'),
  doctorScreen('/DoctorScreen','DoctorScreen'),
  doctorInfoScreen('/DoctorInfoScreen','DoctorInfoScreen'),
  appointmentScreen('/AppointmentScreen','AppointmentScreen'),
  messageScreen('/MessageScreen','MessageScreen'),
  profileScreen('/ProfileScreen','ProfileScreen'),
  calenderScreen('/CalenderScreen','CalenderScreen'),
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
  welcomeScreen('/WelcomeScreen','WelcomeScreen');


  final String path;
  final String name;

  const RouterName(this.path,this.name);
}