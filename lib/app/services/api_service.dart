import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medic_model.dart'; // Pastikan ini mengimpor model Medic Anda

class ApiService {
  final String apiUrl = 'https://rxnav.nlm.nih.gov/REST/drugs.json?name=cymbalta'; // Ganti dengan URL API Anda

  Future<Medic> fetchMedicData() async {
  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Jika API merespons dengan status 200 (OK)
      return Medic.fromJson(json.decode(response.body)); // Kembalikan objek Medic
    } else {
      throw Exception('Failed to load medic data');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
}

}
