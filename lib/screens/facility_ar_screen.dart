import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class FacilityARScreen extends StatefulWidget {
  final Map<String, dynamic> facility;
  
  const FacilityARScreen({
    super.key,
    required this.facility,
  });

  @override
  State<FacilityARScreen> createState() => _FacilityARScreenState();
}

class _FacilityARScreenState extends State<FacilityARScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Create WebView controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            // Set AR parameters after page loads
            _setARParameters();
          },
        ),
      )
      ..loadFlutterAsset('lib/WebAR/advanced_template.html');
  }

  void _setARParameters() {
    final coordinates = widget.facility['coordinates'];
    final latitude = coordinates['latitude'];
    final longitude = coordinates['longitude'];
    final facilityName = widget.facility['name'];

    final params = {
      'latitude': latitude,
      'longitude': longitude,
      'facilityName': facilityName,
    };

    final jsonParams = jsonEncode(params);
    
    controller.runJavaScript('''
      if (window.setARParameters) {
        window.setARParameters($jsonParams);
      }
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR ${widget.facility['name']}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              controller.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              _showFacilityInfo();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Memuat AR...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFacilityInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.facility['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.facility['image'],
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text('ID: ${widget.facility['id']}'),
              const SizedBox(height: 8),
              Text('Latitude: ${widget.facility['coordinates']['latitude']}'),
              const SizedBox(height: 8),
              Text('Longitude: ${widget.facility['coordinates']['longitude']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
} 