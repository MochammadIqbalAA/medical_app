import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Buat Janji Temu'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan nama';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Tanggal (DD/MM/YYYY)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan tanggal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _complaintController,
                    decoration: InputDecoration(labelText: 'Keluhan'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan keluhan';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9 .,]+$').hasMatch(value)) {
                        return 'Masukkan hanya karakter yang valid';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _addAppointment();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _addAppointment() {
  if (_formKey.currentState!.validate()) {
    FirebaseFirestore.instance.collection('appointments').add({
      'name': _nameController.text,
      'date': _dateController.text,
      'complaint': _complaintController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Janji temu berhasil dibuat')));
      _nameController.clear();
      _dateController.clear();
      _complaintController.clear();
      Navigator.of(context).pop(); // Menutup dialog setelah data ditambahkan
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan janji temu: $error')));
      print('Gagal menambahkan data ke Firestore: $error');
    });
  }
}


  void _deleteAppointment(String id) {
    FirebaseFirestore.instance.collection('appointments').doc(id).delete();
  }

  void _editAppointment(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Janji Temu'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nama'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan nama';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Tanggal (DD/MM/YYYY)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan tanggal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _complaintController,
                    decoration: InputDecoration(labelText: 'Keluhan'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan keluhan';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9 .,]+$').hasMatch(value)) {
                        return 'Masukkan hanya karakter yang valid';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  FirebaseFirestore.instance
                      .collection('appointments')
                      .doc(id)
                      .update({
                    'name': _nameController.text,
                    'date': _dateController.text,
                    'complaint': _complaintController.text,
                  }).then((value) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Janji temu berhasil diubah')));
                    _nameController.clear();
                    _dateController.clear();
                    _complaintController.clear();
                  });
                }
              },
              child: Text('Simpan'),
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
            onPressed: _showAddAppointmentDialog,
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue[50],
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final appointments = snapshot.data!.docs;

            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nama : ${appointment['name']}'),
                        Text('Tanggal : ${appointment['date']}'),
                        Text('Keluhan : "${appointment['complaint']}"'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                _nameController.text = appointment['name'];
                                _dateController.text = appointment['date'];
                                _complaintController.text = appointment['complaint'];
                                _editAppointment(appointment.id);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteAppointment(appointment.id);
                              },
                            ),
                          ],
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
    );
  }
}