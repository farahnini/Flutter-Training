import 'package:permission_handler/permission_handler.dart';

class CheckPermissionUtils {
  // Check the status of a specific permission
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  // Request a specific permission
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  // Check and request multiple permissions
  Future<Map<Permission, PermissionStatus>> checkAndRequestPermissions(
      List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = {};

    for (var permission in permissions) {
      statuses[permission] = await checkPermission(permission);
      if (statuses[permission]!.isDenied ||
          statuses[permission]!.isRestricted) {
        statuses[permission] = await requestPermission(permission);
      }
    }
    return statuses;
  }

  // Example method to check and request common permissions
  Future<void> checkAndRequestCommonPermissions() async {
    List<Permission> permissions = [
      Permission.notification,
      Permission.camera,
      Permission.microphone,
      Permission.location,
      // Add more permissions as needed
    ];

    final statuses = await checkAndRequestPermissions(permissions);

    // Handle the permission statuses as needed
    for (var permission in statuses.keys) {
      if (statuses[permission]!.isGranted) {
        print('${permission.toString()} granted');
      } else if (statuses[permission]!.isDenied) {
        print('${permission.toString()} denied');
      } else if (statuses[permission]!.isPermanentlyDenied) {
        print('${permission.toString()} permanently denied');
        // You might want to show a dialog prompting the user to enable this permission in settings
      }
    }
  }
}
