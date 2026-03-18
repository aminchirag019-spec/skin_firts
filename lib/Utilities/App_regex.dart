class AppRegex {
  static final RegExp email =
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static final RegExp password =
  RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$');

  static final RegExp phone =
  RegExp(r'^[0-9]{10}$');
}