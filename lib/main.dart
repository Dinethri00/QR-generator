import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home:  QrPage(),
    );
  }
}

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {

  @override
  Widget build(BuildContext context) {
    const message = 'My QR';

    Future<ui.Image> _loadImage() async {
      final completer = Completer<ui.Image>();
      final data = await rootBundle.load('assets/qr_code');
      ui.decodeImageFromList(data.buffer.asUint8List(), completer.complete);

      return completer.future;
    }

    final qrCode = FutureBuilder(
        future: _loadImage(),
        builder: (ctx, snapshot){
          const size = 350.0;
          if(!snapshot.hasData){
            return Container(
              color: Colors.teal,
              height: size,
              width: size,
            );
          }
          return CustomPaint(
            size: const Size.square(size),
            painter: QrPainter(
                data: message,
                version: QrVersions.auto,
                color: Colors.black,
                emptyColor: Colors.white70,
                embeddedImage: snapshot.data,
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size.square(50),
                )
            ),
          );

        }
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 280,
              child: qrCode,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(message,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),)

          ],
        ),
      ),
    );
  }
}


