import 'package:get/get.dart';
import 'package:local_database_demo/repository/local_db_repo.dart';
import 'package:local_database_demo/utils/utility.dart';

class CategoryController extends GetxController {
  var categoryName = ''.obs;
  var categories = <Map<String, dynamic>>[].obs;

  final dbHelper = LocalDBRepository.instance;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    final data = await dbHelper.getCategories();
    categories.assignAll(data);
  }

  void saveCategory() async {
    final name = categoryName.value.trim();
    if (name.isEmpty) {
      Utility.showErrorSnackBar('Category name cannot be empty');
      return;
    }

    await dbHelper.insertCategory(name);
    categoryName.value = '';
    loadCategories();
    Utility.showSuccessSnackBar('Category saved');
  }

  Future<void> updateCategory(int id, String newName) async {
    if (newName.trim().isEmpty) {
      Utility.showErrorSnackBar('Category name cannot be empty');
      return;
    }

    await dbHelper.updateCategory(id, newName.trim());
    loadCategories();
    Utility.showSuccessSnackBar('Category updated');
  }

  Future<void> deleteCategory(int id) async {
    await dbHelper.deleteCategory(id);
    loadCategories();
    Utility.showSuccessSnackBar('Category deleted');
  }
}
