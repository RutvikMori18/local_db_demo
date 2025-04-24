// import 'dart:developer';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:local_database_demo/extenions/string_extension.dart';
// import 'package:local_database_demo/repository/local_db_repo.dart';
// import 'package:local_database_demo/utils/utility.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ContactController extends GetxController {
//   var firstName = ''.obs;
//   var lastName = ''.obs;
//   var mobile = ''.obs;
//   var email = ''.obs;
//   var imagePath = ''.obs;
//   var selectedCategoryId = RxnInt();
//   var categories = <Map<String, dynamic>>[].obs;
//   var filteredContacts = <Map<String, dynamic>>[].obs;
//   var allContacts = <Map<String, dynamic>>[].obs;
//   final dbHelper = LocalDBRepository.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadCategories();
//   }
//
//   void loadCategories() async {
//     final data = await dbHelper.getCategories();
//     categories.assignAll(data);
//   }
//
//   Future<void> pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//
//     ///CAMERA
//     if (source == ImageSource.camera) {
//       var status = await Permission.camera.request();
//       if (status.isGranted) {
//         final pickedFile =
//             await ImagePicker().pickImage(source: ImageSource.camera);
//         if (pickedFile != null) {
//           imagePath.value = pickedFile.path;
//         }
//       } else {
//         Utility.showErrorSnackBar(
//             "Please give camera permission from the setting");
//         await openAppSettings();
//       }
//     } else {
//       ///GALLERY
//       final XFile? pickedFile = await picker.pickImage(source: source);
//       if (pickedFile != null) {
//         imagePath.value = pickedFile.path;
//         log("image path-----${imagePath.value}");
//       }
//     }
//   }
//
//   Future<bool> saveContact() async {
//     if (firstName.value.trim().isEmpty ||
//         mobile.value.trim().isEmpty ||
//         selectedCategoryId.value == null) {
//       Utility.showErrorSnackBar('Please fill all the fields');
//       return false;
//     } else if (mobile.value.trim().length != 10) {
//       Utility.showErrorSnackBar("Please enter valid mobile number");
//       return false;
//     } else if (!email.value.trim().isValidEmail()) {
//       Utility.showErrorSnackBar("Please enter valid email");
//       return false;
//     } else if (imagePath.value.isEmpty) {
//       Utility.showErrorSnackBar("Please pick image");
//       return false;
//     }
//     final contact = {
//       'first_name': firstName.value.trim(),
//       'last_name': lastName.value.trim(),
//       'mobile': mobile.value.trim(),
//       'email': email.value.trim(),
//       'image_path': imagePath.value,
//       'category_id': selectedCategoryId.value,
//     };
//     await dbHelper.insertContact(contact);
//
//     ///Store contact info to contact
//     await Utility.saveContact(
//       name: "${firstName.value.trim()} ${lastName.value.trim()}",
//       number: mobile.value.trim(),
//       image: imagePath.value,
//       emailId: email.value.trim(),
//     );
//     clearFields();
//     return true;
//   }
//
//   void clearFields() {
//     firstName.value = '';
//     lastName.value = '';
//     mobile.value = '';
//     email.value = '';
//     imagePath.value = '';
//     selectedCategoryId.value = null;
//   }
//
//   Future<List<Map<String, dynamic>>> loadContacts() async {
//     final db = await dbHelper.database;
//     // Adjust the query as per your schema and join with category if needed
//     loadCategories();
//     filteredContacts.value = await db.query('contacts');
//     allContacts.value = await db.query('contacts');
//     return filteredContacts;
//   }
//
//   void updateContact(int id, Map<String, dynamic> updatedContact) async {
//     ///Validation
//     if (firstName.value.trim().isEmpty ||
//         mobile.value.trim().isEmpty ||
//         selectedCategoryId.value == null) {
//       Utility.showErrorSnackBar('Please fill all the fields');
//       return;
//     } else if (mobile.value.trim().length != 10) {
//       Utility.showErrorSnackBar("Please enter valid mobile number");
//       return;
//     } else if (!email.value.trim().isValidEmail()) {
//       Utility.showErrorSnackBar("Please enter valid email");
//       return;
//     } else if (imagePath.value.isEmpty) {
//       Utility.showErrorSnackBar("Please pick image");
//       return;
//     } else {
//       await dbHelper.updateContact(id, updatedContact);
//       await loadContacts();
//       Utility.showSuccessSnackBar('Contact updated');
//     }
//   }
//
//   void deleteContact(int id) async {
//     await dbHelper.deleteContact(id);
//     loadContacts();
//     Utility.showSuccessSnackBar('Contact deleted');
//   }
//
//   void searchContacts(String query) {
//     final words =
//         query.toLowerCase().split(' ').where((w) => w.isNotEmpty).toList();
//
//     List<Map<String, dynamic>> tempList = filteredContacts;
//
//     if (words.isNotEmpty) {
//       tempList = tempList.where((contact) {
//         final fullName =
//             '${contact['first_name']} ${contact['last_name']}'.toLowerCase();
//         return words.every((word) => fullName.contains(word));
//       }).toList();
//       filteredContacts.value = (tempList);
//     } else {
//       filteredContacts.value = allContacts;
//     }
//
//     // Apply category filter if selected
//     if (selectedCategoryId.value != null) {
//       tempList = tempList
//           .where((c) => c['category_id'] == selectedCategoryId.value)
//           .toList();
//       filteredContacts.value = (tempList);
//     }
//   }
//
//   void clearFilters() {
//     selectedCategoryId.value = null;
//     filteredContacts.value = allContacts;
//   }
//
//   void filterByCategory(int? categoryId) {
//     selectedCategoryId.value = categoryId;
//     searchContacts('');
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_database_demo/extenions/string_extension.dart';
import 'package:local_database_demo/model/category_model.dart';
import 'package:local_database_demo/model/contact_model.dart';
import 'package:local_database_demo/repository/local_db_repo.dart';
import 'package:local_database_demo/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var mobile = ''.obs;
  var email = ''.obs;
  var imagePath = ''.obs;
  var selectedCategoryId = RxnInt();
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ContactModel> filteredContacts = <ContactModel>[].obs;
  RxList<ContactModel> allContacts = <ContactModel>[].obs;
  final dbHelper = LocalDBRepository.instance;

  void loadCategories() async {
    final data = await dbHelper.getCategories();
    categories.value = [];
    for (var e in data) {
      categories.add(CategoryModel.fromJson(e));
    }
    log("category list -----${categories.length}");
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();

    ///CAMERA
    if (source == ImageSource.camera) {
      var status = await Permission.camera.request();
      if (status.isGranted) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          imagePath.value = pickedFile.path;
        }
      } else {
        Utility.showErrorSnackBar(
            "Please give camera permission from the setting");
        await openAppSettings();
      }
    } else {
      ///GALLERY
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
        log("image path-----${imagePath.value}");
      }
    }
  }

  ///CRUD OPERATION OF CONTACT
  Future<bool> saveContact() async {
    if (firstName.value.trim().isEmpty ||
        mobile.value.trim().isEmpty ||
        selectedCategoryId.value == null) {
      Utility.showErrorSnackBar('Please fill all the fields');
      return false;
    } else if (mobile.value.trim().length != 10) {
      Utility.showErrorSnackBar("Please enter valid mobile number");
      return false;
    } else if (!email.value.trim().isValidEmail()) {
      Utility.showErrorSnackBar("Please enter valid email");
      return false;
    } else if (imagePath.value.isEmpty) {
      Utility.showErrorSnackBar("Please pick image");
      return false;
    }
    final contact = {
      'first_name': firstName.value.trim(),
      'last_name': lastName.value.trim(),
      'mobile': mobile.value.trim(),
      'email': email.value.trim(),
      'image_path': imagePath.value,
      'category_id': selectedCategoryId.value,
    };
    await dbHelper.insertContact(contact);

    ///Store contact info to contact
    await Utility.saveContact(
      name: "${firstName.value.trim()} ${lastName.value.trim()}",
      number: mobile.value.trim(),
      image: imagePath.value,
      emailId: email.value.trim(),
    );
    clearFields();
    return true;
  }

  Future<void> loadContacts() async {
    final db = await dbHelper.database;
    loadCategories();
    filteredContacts.value = [];
    allContacts.value = [];
    final res = await db.query('contacts');
    for (var e in res) {
      filteredContacts.add(ContactModel.fromJson(e));
      allContacts.add(ContactModel.fromJson(e));
    }
  }

  void updateContact(int id, Map<String, dynamic> updatedContact) async {
    await dbHelper.updateContact(id, updatedContact);
    clearFields();
    loadContacts();
    Utility.showSuccessSnackBar('Contact updated');
  }

  void deleteContact(int id) async {
    await dbHelper.deleteContact(id);
    loadContacts();
    Utility.showSuccessSnackBar('Contact deleted');
  }

  ///FILTRATION Functions
  void searchContacts(String query) {
    final words =
        query.toLowerCase().split(' ').where((w) => w.isNotEmpty).toList();

    List<ContactModel> tempList = filteredContacts;

    if (words.isNotEmpty) {
      tempList = tempList.where((contact) {
        final fullName =
            '${contact.firstName} ${contact.lastName}'.toLowerCase();
        return words.every((word) => fullName.contains(word));
      }).toList();
      filteredContacts.value = (tempList);
    } else {
      filteredContacts.value = allContacts;
    }

    // Apply category filter if selected
    if (selectedCategoryId.value != null) {
      tempList = tempList
          .where((c) => c.categoryId == selectedCategoryId.value)
          .toList();
      filteredContacts.value = (tempList);
    }
  }

  void clearFilters() {
    selectedCategoryId.value = null;
    filteredContacts.value = allContacts;
  }

  void filterByCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    searchContacts('');
  }

  void clearFields() {
    firstName.value = '';
    lastName.value = '';
    mobile.value = '';
    email.value = '';
    imagePath.value = '';
    selectedCategoryId.value = null;
  }
}
