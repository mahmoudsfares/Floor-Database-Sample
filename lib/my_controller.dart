import 'dart:async';
import 'package:floor_db_sample/data/person.dart';
import 'package:floor_db_sample/my_service.dart';
import 'package:get/get.dart';

class MyController extends GetxController{

  final _searchStreamController = StreamController<String>();
  final _addStreamController = StreamController<int>();
  final _service = MyService();

  Stream<String> get searchStream => _searchStreamController.stream;
  Stream<int> get addStream => _addStreamController.stream;

  void getPersonFromDatabaseByPhone(String phone) async {
    try {
      final results = await _service.getPersonFromDatabaseByPhone(phone);
      _searchStreamController.sink.add(results);
    } catch (e) {
      // the only probable error to occur is not finding the searched person
      _searchStreamController.sink.add("No such person");
    }
  }

  void addNewPersonToDatabase(Person person) async {
    try{
      await _service.addPersonToDatabase(person);
      // add 0 to the stream if the person was added successfully
      _addStreamController.sink.add(0);
    }
    catch (e){
      // add -1 to the stream if the person was not added
      // most probably unique constraint failed (duplicate primary keys)
      _addStreamController.sink.add(-1);
    }
  }

  @override
  void dispose() {
    _searchStreamController.close();
    _addStreamController.close();
    super.dispose();
  }
}
