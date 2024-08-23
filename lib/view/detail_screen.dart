import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../ui-components/rounded_appbar.dart';

class DetailScreen extends StatelessWidget {
  final dynamic item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(item['webcontent']));

    return Scaffold(
      appBar: RoundAppBar(
        titleName: "",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Logo Image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage(item['logoUrl'] ?? ''),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            item['appname'] ?? '',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            item['description'] ?? '',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          // Other Details (if applicable)
          SizedBox(
            height: 300, // Adjust height as needed
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ]),
      ),
    );
  }
}
