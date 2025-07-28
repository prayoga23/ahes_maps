import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';  // Fixed import path
import 'facility_list_screen.dart';

class PanduanHajiPage extends StatelessWidget {
  const PanduanHajiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Panduan Haji'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_in_ar),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FacilityListScreen(),
                ),
              );
            },
            tooltip: 'AR Fasilitas',
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        'assets/pdf/buku_panduan_haji.pdf',
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
      ),
    );
  }
}