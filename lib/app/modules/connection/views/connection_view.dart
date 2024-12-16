import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';

class ConnectionView extends StatelessWidget {
  final ConnectionController connectionController = Get.put(ConnectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Status'),
      ),
      body: Center(
        child: Obx(
          () {
            // Menampilkan status koneksi
            return connectionController.isConnected.value
                ? Text('You are connected to the internet',
                    style: TextStyle(color: Colors.green, fontSize: 20))
                : Text('No internet connection',
                    style: TextStyle(color: Colors.red, fontSize: 20));
          },
        ),
      ),
    );
  }
}
