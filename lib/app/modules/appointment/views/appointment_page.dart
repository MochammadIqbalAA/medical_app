import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/appointment/controllers/appointment_controller.dart';

class AppointmentView extends StatelessWidget {
  final AppointmentController _controller = Get.put(AppointmentController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  // Dialog Tambah atau Update Janji Temu
  void _showAppointmentDialog(BuildContext context, {String? id, Map<String, dynamic>? data}) {
    if (data != null) {
      // Jika Update, isi form dengan data yang ada
      _nameController.text = data['name'];
      _dateController.text = data['date'];
      _complaintController.text = data['complaint'];
    } else {
      // Jika Tambah, kosongkan form
      _nameController.clear();
      _dateController.clear();
      _complaintController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Buat Janji Temu' : 'Edit Janji Temu'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) =>
                        value!.isEmpty ? 'Silakan masukkan nama' : null,
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Tanggal (DD/MM/YYYY)'),
                    validator: (value) =>
                        value!.isEmpty ? 'Silakan masukkan tanggal' : null,
                  ),
                  TextFormField(
                    controller: _complaintController,
                    decoration: InputDecoration(labelText: 'Keluhan'),
                    validator: (value) =>
                        value!.isEmpty ? 'Silakan masukkan keluhan' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final appointmentData = {
                    'name': _nameController.text,
                    'date': _dateController.text,
                    'complaint': _complaintController.text,
                  };
                  if (id == null) {
                    _controller.addAppointment(appointmentData); // Tambah data
                  } else {
                    _controller.updateAppointment(id, appointmentData); // Update data
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Konfirmasi Hapus Janji Temu
  void _showDeleteConfirmation(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Janji Temu'),
          content: Text('Apakah Anda yakin ingin menghapus janji temu ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.deleteAppointment(id);
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Janji Temu'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAppointmentDialog(context), // Dialog Tambah Janji Temu
          ),
        ],
      ),
      body: Column(
        children: [
          // Status koneksi
          Obx(() {
            return Container(
              color: _controller.isConnected.value ? Colors.green : Colors.red,
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  _controller.isConnected.value
                      ? 'Terhubung ke Internet'
                      : 'Tidak ada koneksi Internet',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
          // Data janji temu dari Firestore
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final appointments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Nama: ${appointment['name']}'),
                        subtitle: Text('Tanggal: ${appointment['date']} \nKeluhan: ${appointment['complaint']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showAppointmentDialog(
                                  context,
                                  id: appointment.id,
                                  data: {
                                    'name': appointment['name'],
                                    'date': appointment['date'],
                                    'complaint': appointment['complaint'],
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmation(context, appointment.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
