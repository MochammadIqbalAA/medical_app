import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Package untuk mengambil lokasi
import 'package:url_launcher/url_launcher.dart'; // Package untuk membuka aplikasi lainnya seperti Google Maps

class FindUsPage extends StatefulWidget {
  const FindUsPage({Key? key}) : super(key: key);

  @override
  _FindUsPageState createState() => _FindUsPageState();
}

class _FindUsPageState extends State<FindUsPage> {
  String _latitude = '0.0';
  String _longitude = '0.0';
  String _message = 'Titik Koordinat Anda Sekarang';
  List<Map<String, String>> nearbyHospitals = [];

  final List<Map<String, String>> hospitalList = [
    {
      "name": "Rumah Sakit Universitas Muhammadiyah Malang",
      "address":
          "Jl. Raya Tlogomas No.45, Dusun Rambaan, Landungsari, Kec. Dau, Kota Malang, Jawa Timur",
      "latitude": "-7.925970",
      "longitude": "112.599250"
    },
    {
      "name": "Rumah Sakit Saiful Anwar (RSSA)",
      "address":
          "Jl. Jaksa Agung Suprapto No.2, Klojen, Kec. Klojen, Kota Malang, Jawa Timur",
      "latitude": "-7.972300",
      "longitude": "112.631249"
    },
    {
      "name": "RS Lavalette",
      "address":
          "Jl. W.R. Supratman No.10, Rampal Celaket, Kec. Klojen, Kota Malang, Jawa Timur",
      "latitude": "-7.966040",
      "longitude": "112.637932"
    },
  ];

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _message = 'Location services are disabled.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _message = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _message = 'Location permissions are permanently denied';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latitude = position.latitude.toString();
      _longitude = position.longitude.toString();
      _message = 'Latitude: $_latitude, Longitude: $_longitude';
    });
  }

  void _findNearbyHospitals() {
    setState(() {
      nearbyHospitals =
          hospitalList; 
    });
  }

  void _openGoogleMaps(String latitude, String longitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Us')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('Cari Lokasi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 141, 205, 235), // Ganti warna latar belakang button
                foregroundColor: Colors.white, // Ganti warna teks pada button
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _findNearbyHospitals,
              child: const Text('Cari Rumah Sakit Terdekat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 141, 205, 235), // Ganti warna latar belakang button
                foregroundColor: Colors.white, // Ganti warna teks pada button
              ),
            ),
            const SizedBox(height: 20),
            if (nearbyHospitals.isNotEmpty)
              Column(
                children: nearbyHospitals.map((hospital) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(hospital['name'] ?? 'Unknown'),
                      subtitle: Text(hospital['address'] ?? 'No address'),
                      trailing: IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed: () {
                          String latitude = hospital['latitude'] ?? '0.0';
                          String longitude = hospital['longitude'] ?? '0.0';
                          // Membuka Google Maps dengan koordinat rumah sakit
                          _openGoogleMaps(latitude, longitude);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
