
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:floor_db_sample/data/person.dart';
import 'package:floor_db_sample/data/person_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part "app_db.g.dart";

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {

  PersonDao get personDao;

  // this static variable and methods are used to keep the first
  // instance created of the database (mimicking singleton behaviour)
  // database is created once on app launching via setInstance
  // and then used via getInstance when needed.
  static late AppDatabase _instance;
  static void setInstance(AppDatabase database){ _instance = database; }
  static AppDatabase getInstance(){ return _instance; }
}