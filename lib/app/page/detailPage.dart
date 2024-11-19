import 'package:flutter/material.dart';
import '../models/medic_model.dart'; // Pastikan ini mengimpor file tempat model Medic Anda didefinisikan

class DetailPage extends StatelessWidget {
  final Medic medic;

  const DetailPage({super.key, required this.medic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medic Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Drug Group: ${medic.drugGroup.name ?? "N/A"}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Concept Groups:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: medic.drugGroup.conceptGroup.length,
                itemBuilder: (context, index) {
                  final conceptGroup = medic.drugGroup.conceptGroup[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TTY: ${conceptGroup.tty}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          if (conceptGroup.conceptProperties != null && 
                              conceptGroup.conceptProperties!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Concept Properties:',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: conceptGroup.conceptProperties!.length,
                                  itemBuilder: (context, propIndex) {
                                    final property = conceptGroup.conceptProperties![propIndex];
                                    return ListTile(
                                      title: Text(property.name ?? 'No Name'),
                                      subtitle: Text('Synonym: ${property.synonym ?? 'N/A'}'),
                                    );
                                  },
                                ),
                              ],
                            )
                          else
                            const Text('No concept properties available.'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
