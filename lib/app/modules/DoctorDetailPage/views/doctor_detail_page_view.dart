import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/appointment/views/appointment_page.dart';

class DoctorDetailPageView extends StatelessWidget {
  final String nama_dokter;

  const DoctorDetailPageView({
    Key? key,
    required this.nama_dokter,
  }) : super(key: key);

  // Fungsi untuk mengambil detail dokter berdasarkan field `nama_dokter`
  Future<QuerySnapshot> getDoctorDetails() async {
    return FirebaseFirestore.instance
        .collection('doctor') // Nama koleksi di Firestore
        .where('nama_dokter', isEqualTo: nama_dokter) // Query berdasarkan nama dokter
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          nama_dokter,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getDoctorDetails(), // Mengambil data dokter
        builder: (context, snapshot) {
          // Jika sedang memuat data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Jika terjadi error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Jika data tidak ditemukan
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Dokter tidak ditemukan'));
          }

          // Ambil data dari dokumen pertama yang ditemukan
          var doctorData = snapshot.data!.docs.first;
          var spesialis = doctorData['spesialis'] ?? 'Spesialis tidak tersedia';
          var deskripsi = doctorData['description'] ?? 'Deskripsi tidak tersedia';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Circle Avatar untuk gambar profil
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/default_profile.png'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama Dokter
                  Center(
                    child: Text(
                      nama_dokter,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Spesialisasi Dokter
                  Center(
                    child: Text(
                      spesialis,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Center untuk Card
                  Center(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About $nama_dokter',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              deskripsi,
                              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Navigasi ke AppointmentView
                                Get.to(() => AppointmentView());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 141, 205, 235),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              ),
                              child: Text(
                                'Book an Appointment',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
