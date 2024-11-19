import 'package:flutter/material.dart';
import '../models/medic_model.dart';
import '../page/detailPage.dart'; // Pastikan path ini sesuai dengan lokasi DetailPage Anda

class MedicCard extends StatelessWidget {
  final Medic medic;

  const MedicCard({super.key, required this.medic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke DetailPage dengan objek medic
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(medic: medic),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Drug Group: ${medic.drugGroup.name ?? 'No Name'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Concept Groups:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              ...medic.drugGroup.conceptGroup.map((concept) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TTY: ${concept.tty}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (concept.conceptProperties != null && concept.conceptProperties!.isNotEmpty)
                        ...concept.conceptProperties!.map((property) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(property.name ?? 'No Name'),
                            subtitle: Text('Synonym: ${property.synonym ?? 'No Synonym'}'),
                            trailing: Text('RXCUI: ${property.rxcui}'),
                          );
                        }),
                      if (concept.conceptProperties == null || concept.conceptProperties!.isEmpty)
                        const Text(
                          'No Concept Properties Available',
                          style: TextStyle(color: Colors.grey),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
