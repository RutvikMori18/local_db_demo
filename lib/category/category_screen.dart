import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../contact/controller/cotacts_controller.dart';
import '../utils/drawer.dart';
import 'controller/category_controller.dart';

class CategoryScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());
  final ContactController contactController = Get.put(ContactController());

  CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    // Sync controller.categoryName with textController
    controller.categoryName.listen((val) {
      if (textController.text != val) {
        textController.text = val;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      }
    });

    void showEditDialog(int id, String currentName) {
      final editController = TextEditingController(text: currentName);

      Get.defaultDialog(
        title: 'Edit Category',
        content: TextField(
          controller: editController,
          decoration: InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(),
          ),
        ),
        textConfirm: 'Update',
        textCancel: 'Cancel',
        onConfirm: () {
          controller.updateCategory(id, editController.text);
          Get.back();
        },
        onCancel: () {},
      );
    }

    void showDeleteDialog(int id, String name) {
      Get.defaultDialog(
        title: 'Delete Category',
        middleText: 'Are you sure you want to delete "$name"?',
        textConfirm: 'Delete',
        textCancel: 'Cancel',
        confirmTextColor: Colors.white,
        onConfirm: () {
          controller.deleteCategory(id);
          Get.back();
        },
        onCancel: () {},
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Create and store category')),
      drawer: AppDrawer(
        currentRoute: '/categories',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => controller.categoryName.value = val,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.saveCategory,
              child: Text('Save'),
            ),
            SizedBox(height: 30),
            Text('Saved Categories:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Obx(() {
                if (controller.categories.isEmpty) {
                  return Center(child: Text('No categories saved yet.'));
                }
                return ListView.separated(
                  itemCount: controller.categories.length,
                  itemBuilder: (_, index) {
                    final category = controller.categories[index];
                    return ListTile(
                      title: Text(category['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => showEditDialog(
                                category['id'], category['name']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => showDeleteDialog(
                                category['id'], category['name']),
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
      ),
    );
  }
}
