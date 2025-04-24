import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Utility {
  static Future<void> saveContact(
      {required String name,
      required String number,
      required String image,
      required String emailId}) async {
    ContactInfo newContact = ContactInfo(
        givenName: name,
        phones: [ValueItem(label: "mobile", value: number)],
        emails: [ValueItem(label: "email", value: emailId)],
        avatar: await XFile(image).readAsBytes());

    PermissionStatus status =
        await Permission.contacts.request().then((value) async {
      if (value.isGranted) {
        await FlutterContactsService.addContact(newContact);
        showSuccessSnackBar("Successfully added number");
        return value;
      }
      return value;
    });
    if (status.isGranted) {
      await FlutterContactsService.addContact(newContact);
      showSuccessSnackBar("Successfully added number");
      // Permission granted, proceed with your logic
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      await openAppSettings();
    } else {
      // Permission denied (but not permanently), you can show a dialog or try again
      showErrorSnackBar("Please give permission from the setting.");
    }
  }

  static showSuccessSnackBar(String message) {
    Get.snackbar("Success", message,
        borderWidth: 1,
        borderColor: Colors.green,
        backgroundColor: Colors.green.withAlpha(50));
  }

  static showErrorSnackBar(String message) {
    Get.snackbar("Error", message,
        borderWidth: 1,
        borderColor: Colors.red,
        backgroundColor: Colors.red.withAlpha(50));
  }
}
