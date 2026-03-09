

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
  welcomeScreen('/WelcomeScreen','WelcomeScreen');


  final String path;
  final String name;

  const RouterName(this.path,this.name);
}