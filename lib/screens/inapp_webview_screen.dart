import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({super.key});

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () async {
              final message = ScaffoldMessenger.of(context);
              if (await controller.canGoBack()) {
                controller.goBack();
              } else {
                message.showSnackBar(SnackBar(
                  content: Text('No back history item'),
                ));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () async {
              final message = ScaffoldMessenger.of(context);
              if (await controller.canGoForward()) {
                controller.goForward();
              } else {
                message.showSnackBar(SnackBar(
                  content: Text('No forward history item'),
                ));
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
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              onProgressChanged: (InAppWebViewController inAppWebViewController,
                  int progress) {
                controller.setProgress(progress);
              },
              onWebViewCreated:
                  (InAppWebViewController inAppWebViewController) {
                controller.setWebViewController(inAppWebViewController);
              },
              onPermissionRequest: (InAppWebViewController controller,
                  PermissionRequest permissionRequest) async {
                if (permissionRequest.resources
                    .contains(PermissionResourceType.CAMERA)) {
                  final PermissionStatus permissionStatus =
                      await Permission.camera.request();
                  if (permissionStatus.isGranted) {
                    return PermissionResponse(
                      resources: permissionRequest.resources,
                      action: PermissionResponseAction.GRANT,
                    );
                  } else if (permissionStatus.isDenied) {
                    return PermissionResponse(
                      resources: permissionRequest.resources,
                      action: PermissionResponseAction.DENY,
                    );
                  }
                }
                return null;
              },
              initialUrlRequest: URLRequest(
                url: WebUri.uri(Uri.parse("https://sps.bioinfohub.dev/")),
              ),
            ),
            Obx(() {
              final double progress = controller.progress.value;
              if (progress < 1) {
                return LinearProgressIndicator(value: progress);
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  RxDouble progress = 0.0.obs;
  InAppWebViewController? _inAppWebViewController;

  setProgress(int newProgress) {
    progress.value = newProgress / 100;
  }

  setWebViewController(InAppWebViewController controller) {
    _inAppWebViewController = controller;
  }

  Future<void> goBack() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.goBack();
    }
  }

  Future<void> goForward() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.goForward();
    }
  }

  Future<bool> canGoBack() async {
    if (_inAppWebViewController != null) {
      return await _inAppWebViewController!.canGoBack();
    }
    return false;
  }

  Future<bool> canGoForward() async {
    if (_inAppWebViewController != null) {
      return await _inAppWebViewController!.canGoForward();
    }
    return false;
  }

  Future<void> reload() async {
    if (_inAppWebViewController != null) {
      await _inAppWebViewController!.reload();
    }
  }

  @override
  void dispose() {
    _inAppWebViewController?.dispose();
    super.dispose();
  }
}
