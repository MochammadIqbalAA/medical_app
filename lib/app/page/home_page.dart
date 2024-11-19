  import 'package:flutter/material.dart';
  import '../models/medic_model.dart'; // Ensure this imports the file where your Medic model is defined
  import '../widget/card_widget.dart'; // Import the MedicCard widget
  import '../services/api_service.dart';

  class HomePage extends StatefulWidget {
  const HomePage({super.key});

    @override
    _HomePageState createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    late Future<Medic> futureMedic;

    @override
    void initState() {
      super.initState();
      futureMedic = ApiService().fetchMedicData(); // Memanggil fungsi fetchMedicData
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Drug Type'),
        ),
        body: FutureBuilder<Medic>(
          future: futureMedic,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()); // Menampilkan indikator loading
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan error jika ada
            } else {
              final medic = snapshot.data!;
              return MedicCard(medic: medic); // Menggunakan MedicCard widget
            }
          },
        ),
      );
    }
  }
