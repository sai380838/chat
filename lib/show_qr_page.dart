import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShowQrPage extends StatelessWidget {
  const ShowQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseMessaging.instance.getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final token = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text("Your QR Code")),
          body: Center(
            child: QrImageView(
              data: token,
              size: 300,
              version: QrVersions.auto,
            ),
          ),
        );
      },
    );
  }
}
