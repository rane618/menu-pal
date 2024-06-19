import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String initialUrl;

  InAppWebViewPage({required this.initialUrl});

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Article')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
        onWebViewCreated: (controller) {
          setState(() {
            _webViewController = controller;
          });
        },
      ),
    );
  }
}
