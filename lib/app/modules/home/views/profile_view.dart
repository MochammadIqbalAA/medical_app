import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/home/controllers/profile_controller.dart';
import 'package:myapp/app/modules/login_page/views/login_page_view.dart';
import 'package:video_player/video_player.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController()); // Bind controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Be Vietnam Pro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFFA9D6EB),
      ),
      body: Container(
        color: const Color(0xFFA9D6EB),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Stack for displaying the profile image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(() {
                      // Display profile image if available, otherwise show default image
                      return CircleAvatar(
                        radius: 120,
                        backgroundImage: controller.selectedImagePath.isNotEmpty
                            ? FileImage(File(controller.selectedImagePath.value))
                            : const AssetImage('assets/default_profile.png'), // Update with your default asset
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Button to pick an image from the gallery
                ElevatedButton(
                  onPressed: () {
                    controller.pickImage(ImageSource.gallery); // Picking image from gallery
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151855),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Pick Image from Gallery',
                    style: TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                  ),
                ),

                // Button to capture an image with the camera
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.pickImage(ImageSource.camera); // Capturing image with camera
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151855),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Capture Image from Camera',
                    style: TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                  ),
                ),

                // Button to reset the profile image
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    controller.resetImage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151855),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Reset Profile Image',
                    style: TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                  ),
                ),

                // Video section
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.selectedVideoPath.isNotEmpty) {
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(controller.videoPlayerController!), // Display the video
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (controller.isVideoPlaying.value) {
                              controller.videoPlayerController?.pause();
                            } else {
                              controller.videoPlayerController?.play();
                            }
                            controller.isVideoPlaying.toggle(); // Toggle play/pause state
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF151855),
                            foregroundColor: Colors.white,
                          ),
                          child: Obx(() => Text(
                                controller.isVideoPlaying.value ? 'Pause Video' : 'Play Video',
                                style: const TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                              )),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.pickVideo(ImageSource.gallery); // Pick video from gallery
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF151855),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Pick Video from Gallery',
                            style: TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            controller.pickVideo(ImageSource.camera); // Record video using camera
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF151855),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Record Video from Camera',
                            style: TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                          ),
                        ),
                      ],
                    );
                  }
                }),

                // Logout button
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut(); // Logout
                    Get.offAll(LoginPageView()); // Navigate to login page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF151855),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontFamily: 'Be Vietnam Pro', fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
