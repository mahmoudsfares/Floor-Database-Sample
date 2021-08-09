import 'package:floor_db_sample/data/app_db.dart';
import 'package:floor_db_sample/data/person.dart';
import 'package:floor_db_sample/view_model/my_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // instantiate database in the entry point of the app to use it later
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.setInstance(await $FloorAppDatabase.databaseBuilder('app_db.db').build());
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyViewModel viewModel = MyViewModel();

  final nameTfController = TextEditingController();
  final phoneTfController = TextEditingController();
  final searchTfController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // as adding new data to the database returns nothing, we just need to listen to
    // the stream broadcast to show a snackbar to the user that confirms whether the new
    // data was added properly or not
    viewModel.addStream.listen((event) {
      if (event == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Added successfully"),
        ));
      } else if (event == -1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Duplicate person"),
        ));
      }
    });


    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [

              //---------------- NEW PERSON ENTRY LAYOUT ----------------//
              TextField(
                controller: nameTfController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter name'),
              ),
              TextField(
                controller: phoneTfController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter phone'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Person p = Person(nameTfController.text,
                        int.parse(phoneTfController.text));
                    viewModel.addNewPersonToDatabase(p);
                  },
                  child: Text('SAVE')),

              //---------------- SEARCH LAYOUT ----------------//
              TextField(
                controller: searchTfController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Search by phone'),
              ),
              ElevatedButton(
                  onPressed: () => viewModel
                      .getPersonFromDatabaseByPhone(searchTfController.text),
                  child: Text('SEARCH')),

              //---------------- SEARCH RESULT TEXT WRAPPED IN STREAMBUILDER ----------------//
              StreamBuilder(
                  stream: viewModel.searchStream,
                  builder: (context, snapshot) {
                    // initial state
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Text('person name will appear here...');
                    // error
                    else if (snapshot.hasError) {
                      final error = snapshot.error as Exception;
                      return Text(error.toString());
                    }
                    // normal case (person found)
                    else
                      return Text(snapshot.data as String);
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
