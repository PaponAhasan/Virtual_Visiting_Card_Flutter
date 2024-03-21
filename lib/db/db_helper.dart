import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DbHelper {
  final String _createContactTable = '''create table $tableContact(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColLandline text,
  $tblContactColEmail text,
  $tblContactColAddress text,
  $tblContactColCompany text,
  $tblContactColDesignation text,
  $tblContactColWebsite text,
  $tblContactColImage text,
  $tblContactColFavorite integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = path.join(root, 'contact.db');
    return openDatabase(dbPath, version: 2, onCreate: (db, version) {
      db.execute(_createContactTable);
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion == 1 && newVersion == 2) {
        db.execute('alter table $tableContact add column $tblContactColLandline text default ""');
      }
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

  Future<Contact> getSingleContacts(int id) async {
    final db = await _open();
    final mapList = await db
        .query(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return Contact.fromMap(mapList.first);
  }

  Future<int> updateFavorite(Contact contact) async {
    final db = await _open();
    return db.update(tableContact, contact.toMap(),
        where: '$tblContactColId = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    return db
        .delete(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  Future<int> updateContactField(int id, Map<String, dynamic> field) async {
    final db = await _open();
    return db.update(tableContact, field,
        where: '$tblContactColId = ?', whereArgs: [id]);
  }
}
