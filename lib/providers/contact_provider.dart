import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contactList = [];
  final db = DbHelper();

  Future<int> insertContact(Contact contact) async {
    final rowId = await db.insertContact(contact);
    contact.id = rowId;
    contactList.add(contact);
    notifyListeners();
    return rowId;
  }

  Future<void> getAllContacts() async {
    contactList = await db.getAllContacts();
    notifyListeners();
  }

  Future<Contact> getSingleContacts(int id) async{
    final contact = await db.getSingleContacts(id);
    return contact;
  }

  Future<int> deleteContact(int id) async {
    final rowId = await db.deleteContact(id);
    contactList.removeWhere((contact) => contact.id == id);
    notifyListeners();
    return rowId;
  }

  Future<int> updateFavorite(Contact contact) async {
    contact.favorite = !contact.favorite;
    final rowId = await db.updateFavorite(contact);
    notifyListeners();
    return rowId;
  }

  Future<void> updateContactField(Contact contact, String field) async {
    final rowId = await db.updateContactField(
        contact.id, {field: contact.favorite ? 0 : 1});
    final index = contactList.indexOf(contact);
    contactList[index].favorite = !contactList[index].favorite;
    notifyListeners();
  }
}
