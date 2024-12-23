import 'package:flutter/material.dart';

class LabTestResultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Test Result'),
      ),
      body: Center(
        child: Text(
          'Lab Test Results will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
