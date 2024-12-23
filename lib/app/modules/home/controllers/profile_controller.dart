import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final box = GetStorage();

  var selectedImagePath = ''.obs;
  var selectedVideoPath = ''.obs;

  var isImageLoading = false.obs;
  var isVideoPlaying = false.obs;
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }

  // Function to pick an image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        box.write('imagePath', pickedFile.path);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Function to reset the profile image
  void resetImage() {
    selectedImagePath.value = '';
    box.remove('imagePath');
  }

  // Function to pick a video from gallery or camera
  Future<void> pickVideo(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(source: source);

      if (pickedFile != null) {
        selectedVideoPath.value = pickedFile.path;
        box.write('videoPath', pickedFile.path);
        await _initializeVideoPlayer(pickedFile.path);
      } else {
        print('No video selected.');
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  // Initialize video player
  Future<void> _initializeVideoPlayer(String videoPath) async {
    videoPlayerController = VideoPlayerController.file(File(videoPath));
    await videoPlayerController!.initialize();
    videoPlayerController!.setLooping(true);
    videoPlayerController!.play();
    isVideoPlaying.value = true;
  }

  // Load stored data from GetStorage
  void _loadStoredData() {
    selectedImagePath.value = box.read('imagePath') ?? '';
    selectedVideoPath.value = box.read('videoPath') ?? '';
    if (selectedVideoPath.value.isNotEmpty) {
      _initializeVideoPlayer(selectedVideoPath.value);
    }
  }
}
