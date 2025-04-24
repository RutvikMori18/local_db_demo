import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../category/category_screen.dart';
import '../contact/controller/cotacts_controller.dart';
import '../contact/create_contact_screen.dart';
import '../contact/show_contacts_screen.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final controller = Get.find<ContactController>();
  AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('LocalDB',
                style: TextStyle(color: Colors.black, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            selected: currentRoute == '/categories',
            onTap: () {
              if (currentRoute != '/categories') {
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => CategoryScreen()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Add Contact'),
            selected: currentRoute == '/add_contact',
            onTap: () {
              if (currentRoute != '/add_contact') {
                Navigator.pop(context);
                controller.loadContacts();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => AddContactScreen()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('All Contacts'),
            selected: currentRoute == '/contacts_list',
            onTap: () {
              if (currentRoute != '/contacts_list') {
                Navigator.pop(context);
                controller.loadContacts();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => ContactsListScreen()));
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
