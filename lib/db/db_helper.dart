import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DbHelper {
  final String _createContactTable = '''create table $tableContact(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColEmail text,
  $tblContactColAddress text,
  $tblContactColCompany text,
  $tblContactColDesignation text,
  $tblContactColWebsite text,
  $tblContactColImage text,
  $tblContactColFavorite integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = p.join(root, 'contact.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(_createContactTable);
    });
  }

  Future<int> insertContact(Contact contactModel) async {
    final db = await _open();
    return db.insert(tableContact, contactModel.toMap());
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await _open();
    final mapList = await db.query(tableContact);
    return List.generate(
        mapList.length, (index) => Contact.fromMap(mapList[index]));
  }

  Future<int> updateFavorite(Contact contactModel) async {
    final db = await _open();
    return db.update(tableContact, contactModel.toMap(),
        where: '$tblContactColId = ?', whereArgs: [contactModel.id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    return db.delete(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }
}
