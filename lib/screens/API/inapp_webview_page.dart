import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewPage extends StatefulWidget {
  final String initialUrl;

  InAppWebViewPage({required this.initialUrl});

  @override
  _InAppWebViewPageState createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Article')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(widget.initialUrl), // Assuming WebUri accepts a String
        ),
        onWebViewCreated: (controller) {
          setState(() {
            _webViewController = controller;
          });
        },
      ),
    );
  }

  void someFunctionUsingWebViewController() {
    if (_webViewController != null) {
      // Use _webViewController safely
      _webViewController!.loadUrl(
        urlRequest: URLRequest(url: WebUri('https://example.com')),
      );
    } else {
      // Handle the case where _webViewController is not set yet
      print('WebViewController is not yet initialized.');
    }
  }
}
