import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String userTable = "user";
final String columnId = "_id";
final String columnUsername = "username";
final String columnPassword = "password";

class User {
  int id;
  String username;
  String password;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnUsername: username,
      columnPassword: password
    };
    if(id != null) {
      map[columnId] = id;
    }
    return map;
  }

  User(this.username, this.password);

  User.fromMap(Map<String, dynamic> map) {
    id =  map[columnId];
    username = map[columnUsername];
    password = map[columnPassword];
  }
}

class UserProvider {
  Database db;
  Future open() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "voting.db");
    db = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''create table $userTable(
      $columnId integer primary key autoincrement,
      $columnUsername text not null,
      $columnPassword text not null)''');
    });
  }

  Future<int> insert(User user) async {
    await open();
    return await db.insert(userTable, user.toMap());
  }

  Future<User> getUser(String username) async {
    await open();
    List<Map> maps  = await db.query(userTable,
    columns: [columnId, columnUsername, columnPassword],
    where: '$columnUsername = ?',
    whereArgs: [username]);
    if(maps.length > 0) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> getAll() async {
    await open();
    List<Map> maps = await db.query(userTable);
    return maps.map((f) => User.fromMap(f)).toList();
  }

  Future close() async => db.close();
}