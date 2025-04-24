import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_database_demo/contact/show_contacts_screen.dart';

import '../utils/drawer.dart';
import 'controller/cotacts_controller.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final controller = Get.find<ContactController>();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final mobileController = TextEditingController();

  final emailController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync controllers with GetX
    controller.firstName.listen((v) => firstNameController.text = v);
    controller.lastName.listen((v) => lastNameController.text = v);
    controller.mobile.listen((v) => mobileController.text = v);
    controller.email.listen((v) => emailController.text = v);

    return Scaffold(
      appBar: AppBar(title: Text('Add Contact')),
      drawer: AppDrawer(
        currentRoute: '/add_contact',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      backgroundColor: Colors.white,
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Camera'),
                              onTap: () async {
                                Get.back();
                                await controller.pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Gallery'),
                              onTap: () async {
                                Get.back();
                                await controller.pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: controller.imagePath.value.isNotEmpty
                        ? FileImage(File(controller.imagePath.value))
                        : null,
                    child: controller.imagePath.value.isEmpty
                        ? Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                )),
            SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                  labelText: 'First Name', border: OutlineInputBorder()),
              onChanged: (v) => controller.firstName.value = v,
            ),
            SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                  labelText: 'Last Name', border: OutlineInputBorder()),
              onChanged: (v) => controller.lastName.value = v,
            ),
            SizedBox(height: 10),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(
                  labelText: 'Mobile', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              onChanged: (v) => controller.mobile.value = v,
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) => controller.email.value = v,
            ),
            SizedBox(height: 10),
            Obx(() => DropdownButtonFormField<int>(
                  value: controller.selectedCategoryId.value,
                  decoration: InputDecoration(
                      labelText: 'Category', border: OutlineInputBorder()),
                  items: controller.categories
                      .map((cat) => DropdownMenuItem<int>(
                            value: cat.id as int,
                            child: Text(cat.name ?? "N/A"),
                          ))
                      .toList(),
                  onChanged: (val) => controller.selectedCategoryId.value = val,
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final res = await controller.saveContact();
                if (res) {
                  controller.loadContacts();

                  Get.to(() => ContactsListScreen());
                }
              },
              child: Text('Save Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
