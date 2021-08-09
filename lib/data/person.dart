
import 'package:floor/floor.dart';

@entity
class Person {

  final String name;

  @primaryKey
  final int phone;

  Person(this.name, this.phone);
}