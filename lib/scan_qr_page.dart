import 'package:chat/token_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class ScanQrPage extends StatelessWidget {
  const ScanQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR")),
      body: MobileScanner(
        onDetect: (capture) async {
          final barcode = capture.barcodes.first;
          final token = barcode.rawValue;

          if (token != null && token.length > 50) {
            await TokenService.savePeerToken(token);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Token saved!")),
            );
          }
        },
      ),
    );
  }
}
