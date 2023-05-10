import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lady_rakshak/db/db_services.dart';
import 'package:lady_rakshak/model/contacts_model.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Utils/constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _requestPermissionsAndLoadContacts();
    searchController.addListener(filterContacts);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _requestPermissionsAndLoadContacts() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
    if (permissionStatus == PermissionStatus.granted) {
      _loadContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "Maybe contact does not exist on this device");
    }
  }

  void _loadContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts(
      withThumbnails: false,
    );
    setState(() {
      contacts = _contacts;
    });
  }

  filterContacts() {
    setState(() {
      if (searchController.text.isNotEmpty) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlattened = flattenPhoneNumber(searchTerm);

        contactsFiltered = contacts.where((contact) {
          String contactName = contact.displayName?.toLowerCase() ?? '';
          bool nameMatch = contactName.contains(searchTerm);

          if (nameMatch) {
            return true;
          }

          if (searchTermFlattened.isEmpty) {
            return false;
          }

          var phone = contact.phones!.firstWhere(
            (p) =>
                flattenPhoneNumber(p.value ?? '').contains(searchTermFlattened),
            orElse: () => Item(label: 'No Phone', value: ''),
          );

          return phone.value != null;
        }).toList();
      } else {
        contactsFiltered = [...contacts];
      }
    });
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool hasContacts = contactsFiltered.isNotEmpty || contacts.isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search contact",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            hasContacts
                ? Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: isSearching
                          ? contactsFiltered
                              .map((contact) => ListTile(
                                    title: Text(contact.displayName ?? ''),
                                    leading: contact.avatar != null &&
                                            contact.avatar!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundColor: primaryColor,
                                            backgroundImage:
                                                MemoryImage(contact.avatar!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: primaryColor,
                                            child: Text(contact.initials()),
                                          ),
                                  ))
                              .toList()
                          : contacts
                              .map((contact) => ListTile(
                                    title: Text(contact.displayName ?? ''),
                                    leading: contact.avatar != null &&
                                            contact.avatar!.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundColor: primaryColor,
                                            backgroundImage:
                                                MemoryImage(contact.avatar!),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: primaryColor,
                                            child: Text(contact.initials()),
                                          ),
                                    onTap: () {
                                      if (contact.phones != null &&
                                          contact.phones!.isNotEmpty) {
                                        final String phoneNum = contact.phones!
                                                .elementAt(0)
                                                .value ??
                                            '';
                                        final String name =
                                            contact.displayName ?? '';
                                        _addContact(TContact(phoneNum, name));
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Oops! phone number of this contact does not exist",
                                        );
                                      }
                                    },
                                  ))
                              .toList(),
                    ),
                  )
                : Container(
                    child: Text("No contacts available"),
                  ),
          ],
        ),
      ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contacts");
    }
    Navigator.of(context).pop(true);
  }
}
