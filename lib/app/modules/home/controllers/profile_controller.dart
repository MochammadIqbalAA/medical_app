import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var profileImage = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image from gallery
  Future<void> pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage.value = pickedImage.path;
    }
  }

  // Reset profile picture
  void resetImage() {
    profileImage.value = '';
  }
}
