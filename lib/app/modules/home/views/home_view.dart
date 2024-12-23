// lib/app/modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/home/views/profile_view.dart';
import 'package:myapp/app/page/home_page.dart';
import 'package:myapp/app/modules/appointment/views/appointment_page.dart';
import 'package:myapp/app/modules/Forum/views/ForumPage.dart';
import 'package:myapp/app/modules/FindUsPage/views/find_us_page_view.dart';
import 'package:myapp/app/modules/DoctorDetailPage/views/doctor_detail_page_view.dart'; // Impor halaman DoctorDetailPage

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF5FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, Friends !', style: TextStyle(fontSize: 18)),
            Text('How Are you today?', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          
          IconButton(
            icon: const Icon(Icons.forum),
            onPressed: () {
              Get.to(ForumPage());
            },
          ),
        ],
        backgroundColor: const Color(0xFFDDF5FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFA9D6EB),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const Text(
                'News portal \nfor your health',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Be Vietnam Pro'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Doctor Speciality',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSpecialityCircle('General',
                    imagePath: 'lib/app/assets/umum.png'),
                _buildSpecialityCircle('Neurologic',
                    imagePath: 'lib/app/assets/neurologic.png'),
                _buildSpecialityCircle('Pediatric',
                    imagePath: 'lib/app/assets/pediatric.png'),
                _buildSpecialityCircle('Radiology',
                    imagePath: 'lib/app/assets/radiology.png'),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Recommendation Doctor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('doctor').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return _buildDoctorCard(
                        data['nama_dokter'] ?? '',
                        data['spesialis'] ?? '',
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.to(FindUsPage());
              },
              child: const Text('Find Us',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(255, 141, 205, 235))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.healing),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF151855),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            Get.to(HomePage());
          } else if (index == 3) {
            Get.to(ProfileView());
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentView()),
            );
          }
        },
      ),
    );
  }

  Widget _buildSpecialityCircle(String text, {String imagePath = ''}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(
              17), // Menambahkan padding di Container utama
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              image: imagePath.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildDoctorCard(String name, String speciality) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/default_profile.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    speciality,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigasi ke halaman DoctorDetailPage
                Get.to(() => DoctorDetailPageView(
                      nama_dokter: name,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
