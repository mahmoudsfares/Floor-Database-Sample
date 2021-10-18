
import 'package:floor/floor.dart';

@entity
class Person {

  @primaryKey
  final int phone;
  final String name;

  Person(this.name, this.phone);
}