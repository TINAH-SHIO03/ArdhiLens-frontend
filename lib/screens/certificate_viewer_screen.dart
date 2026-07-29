import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class CertificateViewerScreen extends StatefulWidget {
  const CertificateViewerScreen({super.key});

  @override
  State<CertificateViewerScreen> createState() =>
      _CertificateViewerScreenState();
}

class _CertificateViewerScreenState extends State<CertificateViewerScreen> {
  late final String _title;
  late final PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    final args = (Get.arguments as Map?)?.cast<String, dynamic>() ?? {};
    _title = args['title']?.toString() ?? 'cert_title'.tr;
    final bytes = args['bytes'] as Uint8List? ?? Uint8List(0);
    _controller = PdfControllerPinch(
      document: PdfDocument.openData(bytes),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFF0A3D2E),
        foregroundColor: Colors.white,
      ),
      body: PdfViewPinch(
        controller: _controller,
        padding: 12,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
