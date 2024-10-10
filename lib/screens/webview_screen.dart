import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  double loadingPercentage = 0;

  @override
  void initState(){
    super.initState();
    controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress){
            setState(() {
              loadingPercentage = progress.toDouble();
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          // when block certain url
          onNavigationRequest: (navigation) {
            final host = Uri.parse(navigation.url).host;
            if(host.contains('youtube.com')){
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Blokcing navigation to $host'),
                  backgroundColor: Colors.red,
                )
              );
              return NavigationDecision.prevent;
            }
            else{
              return NavigationDecision.navigate;
            }
          }
        ),
      )
      // block certain url
    ..loadRequest(
      Uri.parse('https://www.google.com/'),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: IconButton(
          onPressed : () {
            Navigator.pop(context);
            }, 
          icon: Icon(Icons.close)),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async {
              final message = ScaffoldMessenger.of(context);
              if(await controller.canGoBack()){
                controller.goBack();
              }else{
                message.showSnackBar(
                  SnackBar(
                    content: Text('No back history item'),
                    )
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () async {
              final message = ScaffoldMessenger.of(context);

              if(await controller.canGoBack()){
                controller.goForward();
              }else{
                message.showSnackBar(
                  SnackBar(
                    content: Text('No forward history item'),
                    )
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          loadingPercentage < 100
            ? LinearProgressIndicator(backgroundColor: const Color.fromARGB(255, 208, 6, 73), color: Colors.black, minHeight: 10,value: loadingPercentage / 100.0)
            : Container(),
        ],
      ),
    );
  }
}