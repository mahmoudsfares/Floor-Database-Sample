import 'package:floor/floor.dart';
import 'package:floor_db_sample/data/person.dart';

@dao
abstract class PersonDao {

  @Query('SELECT * FROM Person WHERE phone = :phone')
  Future<Person?> findPersonByPhone(String phone);

  @insert
  Future<void> insertPerson(Person person);
}