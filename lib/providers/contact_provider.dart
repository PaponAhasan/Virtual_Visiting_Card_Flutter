import 'package:flutter/foundation.dart';

import '../db/db_helper.dart';
import '../models/contact.dart';

class ContactProvider extends ChangeNotifier{
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

    Future<int> updateFavorite(Contact contact) async {
      contact.favorite = !contact.favorite;
      final rowId = await db.updateFavorite(contact);
      notifyListeners();
      return rowId;
    }
}