
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();

String? selectedImage;
String? selectedFile;


Future<String?> pickFromCamera() async {
  final XFile? image =
  await picker.pickImage(source: ImageSource.camera);
  return image?.path;
}

Future<String?> pickFromGallery() async {
  final XFile? image =
  await picker.pickImage(source: ImageSource.gallery);
  return image?.path;
}

Future<String?> pickDocument() async {
  final result = await FilePicker.platform.pickFiles();
  return result?.files.single.path;
}