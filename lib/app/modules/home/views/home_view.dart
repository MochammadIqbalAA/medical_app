import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/views/profile_view.dart';
import 'package:myapp/app/page/home_page.dart'; // Pastikan untuk mengimpor halaman Medic
import 'package:myapp/app/modules/appointment/views/appointment_page.dart';
import 'package:myapp/app/modules/Forum/views/ForumPage.dart';
import 'package:myapp/app/modules/FindUsPage/views/find_us_page_view.dart';

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
            Text('Hi, Diddy’s!', style: TextStyle(fontSize: 18)),
            Text('How Are you today?', style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Tambahkan fungsi notifikasi di sini
            },
          ),
          IconButton(
            icon: const Icon(Icons.forum), // Icon forum
            onPressed: () {
              // Navigasi ke halaman forum
              Get.to(ForumPage()); // Ganti dengan halaman forum Anda
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
            // Rectangle with text
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

            // Doctor Specialty title
            const Text(
              'Doctor Speciality',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 4 Circular Menu
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSpecialityCircle('General'),
                _buildSpecialityCircle('Neurologic'),
                _buildSpecialityCircle('Pediatric'),
                _buildSpecialityCircle('Radiology'),
              ],
            ),
            const SizedBox(height: 20),

            // Recommendation Doctor title
            const Text(
              'Recommendation Doctor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Doctor Recommendation cards
            Expanded(
              child: ListView(
                children: [
                  _buildDoctorCard('Dr. John Doe', 'Cardiologist'),
                  _buildDoctorCard('Dr. Jane Smith', 'Pediatrician'),
                ],
              ),
            ),
            // Tombol untuk membuka halaman lokasi (FindUsPage)
            ElevatedButton(
              onPressed: () {
                Get.to(FindUsPage()); // Menavigasi ke FindUsPage
              },
              child: const Text('Find Us', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),

      // Sticky Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
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
          if (index == 3) {
            // Jika Schedule ditekan
            Get.to(HomePage()); // Navigasi ke halaman Medic
          } else if (index == 4) {
            // Jika Profile ditekan
            Get.to(ProfileView());
          } else if (index == 2) {
            // Jika Profile ditekan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppointmentView()),
            );
          }
        },
      ),
    );
  }

  // Circle for Doctor Speciality
  Widget _buildSpecialityCircle(String text) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.local_hospital,
              color: Color(0xFF151855),
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  // Doctor Card for Recommendation Section
  Widget _buildDoctorCard(String name, String speciality) {
    return Card(
      child: SizedBox(
        height: 120,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/default_profile.png'),
          ),
          title: Text(name),
          subtitle: Text(speciality),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            // Navigasi ke detail dokter atau fungsionalitas lainnya
          },
        ),
      ),
    );
  }
}
