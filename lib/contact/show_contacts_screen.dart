import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../category/controller/category_controller.dart';
import '../model/contact_model.dart';
import '../utils/drawer.dart';
import '../utils/utility.dart';
import 'controller/cotacts_controller.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final controller = Get.find<ContactController>();

  final CategoryController categoryController = Get.find<CategoryController>();
  TextEditingController searchController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        currentRoute: '/contacts_list',
      ),
      appBar: AppBar(
        title: Text('All Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => showCategoryFilterDialog(context),
            tooltip: 'Filter by Category',
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              controller.clearFilters();
              searchController.clear();
            },
            tooltip: 'Clear Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                controller.searchContacts(query);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredContacts.isEmpty) {
                return Center(child: Text('No contacts found.'));
              }
              return ListView.separated(
                itemCount: controller.filteredContacts.length,
                itemBuilder: (context, index) {
                  final contact = controller.filteredContacts[index];
                  return ListTile(
                    leading: (contact.imagePath != null &&
                            (contact.imagePath?.isNotEmpty ?? false))
                        ? CircleAvatar(
                            backgroundImage:
                                FileImage(File(contact.imagePath!)))
                        : CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                        '${contact.firstName} ${contact.lastName}----${contact.categoryId}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showEditDialog(contact),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteDialog(contact.id as int,
                              '${contact.firstName} ${contact.lastName}'),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void showEditDialog(ContactModel contact) {
    firstNameController = TextEditingController(text: contact.firstName);
    lastNameController = TextEditingController(text: contact.lastName);
    mobileController = TextEditingController(text: contact.mobile);
    emailController = TextEditingController(text: contact.email);

    var selectedCategoryId = contact.categoryId as int?;
    Get.defaultDialog(
      title: 'Edit Contact',
      content: SizedBox(
        height: 280,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(labelText: 'First Name')),
              SizedBox(height: 10),
              TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name')),
              SizedBox(height: 10),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Mobile'),
                maxLength: 10,
              ),
              SizedBox(height: 10),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(labelText: 'Category'),
                    items: categoryController.categories
                        .map((cat) => DropdownMenuItem<int>(
                              value: cat['id'] as int,
                              child: Text(cat['name']),
                            ))
                        .toList(),
                    onChanged: (val) {
                      selectedCategoryId = val;
                    },
                  )),
            ],
          ),
        ),
      ),
      textConfirm: 'Update',
      textCancel: 'Cancel',
      onConfirm: () async {
        if (firstNameController.text.trim().isEmpty ||
            mobileController.text.trim().isEmpty ||
            selectedCategoryId == null) {
          Utility.showErrorSnackBar(
              'First name, mobile, and category are required');
          return;
        }
        final updatedContact = {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'mobile': mobileController.text.trim(),
          'email': emailController.text.trim(),
          'image_path': contact.imagePath, // Keep existing image path
          'category_id': selectedCategoryId,
        };
        controller.updateContact(contact.id as int, updatedContact);
        Get.back();
      },
    );
  }

  void showDeleteDialog(int id, String name) {
    Get.defaultDialog(
      title: 'Delete Contact',
      middleText: 'Are you sure you want to delete "$name"?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteContact(id);
        Get.back();
      },
    );
  }

  void showCategoryFilterDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Filter by Category',
      content: Obx(() {
        return DropdownButtonFormField<int>(
          value: controller.selectedCategoryId.value,
          items: [
            DropdownMenuItem<int>(
              value: null,
              child: Text('All Categories'),
            ),
            ...categoryController.categories.map((cat) {
              return DropdownMenuItem<int>(
                value: cat['id'] as int,
                child: Text(cat['name']),
              );
            }),
          ],
          onChanged: (val) {
            controller.filterByCategory(val);
            Get.back();
          },
        );
      }),
      textCancel: 'Cancel',
      onCancel: () {},
    );
  }
}
