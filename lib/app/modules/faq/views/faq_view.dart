import 'package:flutter/material.dart';

class FAQView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('What is this app about?'),
            subtitle: Text('This app provides lab test results and FAQs.'),
          ),
          ListTile(
            title: Text('How to use the app?'),
            subtitle: Text('Navigate through the menu to access different features.'),
          ),
          // Add more FAQs as needed
        ],
      ),
    );
  }
}
