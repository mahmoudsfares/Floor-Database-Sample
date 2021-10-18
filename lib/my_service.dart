import 'package:floor_db_sample/data/app_db.dart';
import 'package:floor_db_sample/data/person.dart';

class MyService {

  Future<String> getPersonFromDatabaseByPhone(String phone) async {
      final Person? person = await AppDatabase.getInstance().personDao.findPersonByPhone(phone);
      return person!.name;
  }

  Future<void> addPersonToDatabase(Person person) async{
    await AppDatabase.getInstance().personDao.insertPerson(person);
  }
}
