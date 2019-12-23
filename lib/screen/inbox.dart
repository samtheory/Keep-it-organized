// ?     Dependemcy
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ?     C O M P O N E N T S
import 'package:keep_it_organized/Components/_Drawer.dart';
// ?     DATA  _  BASE   Modul
import 'package:keep_it_organized/database/myTask_db.dart';
// ?     S T A T E S
import 'package:keep_it_organized/store/taskManage/task_manage.dart';

class InboxPage extends StatelessWidget {
  //
  // CLASS variables +++++++++++++++++++++++++++++++++++++++++
  final TaskManage _task = TaskManage();
  //
  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox<Mytask>('customtaskk'),
      builder: (BuildContext contex, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            
            // !! this the body Scafold CODE__________________________________________
            // !
            return Observer(
                builder: (_) => Scaffold(
                      drawer: my_menu(context, 1),
                      appBar: new AppBar(
                        title: Text('KIO'),
                      ),
                      body: _WatchBoxTask(),
                      floatingActionButton: FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            Bmodule(_task).mainBoottomSheet(context);
                          }),
                    ));
            // ! _____________________________________________________________________
          }
        } else {
          return Scaffold();
        }
      },
    );
  }
}

//
//
//
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ! THIS IS BOTTOM SHEET Modal &&&& AND   N E W - T A S K
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class Bmodule {
  //
  // CLASS COSTRUCTOR  ++++++++++++++++++++++++++++++++++++++++++++
  final TaskManage task;
  Bmodule(this.task);
  //
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  mainBoottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: task.newTaskField,
                    decoration: InputDecoration(hintText: 'Task'),
                    autofocus: true,
                  ),
                  ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete_sweep,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // todo: THE FUNCTION SHULD BE WRITE
                          // print(Hive.box<Mytask>('customtaskk').length);
                          // Hive.box('customtaskk').clear();
                        },
                      ),
                      trailing: GestureDetector(
                        child: Icon(Icons.send, color: Colors.blueAccent),
                        onTap: () {
                          if (task.newTaskField.text != '') {
                            task.addTask();
                            Hive.box<Mytask>('customtaskk')
                                .add(Mytask(task.title, false, lable: 'dd'));

                            Navigator.pop(context);
                          }
                        },
                      ))
                ],
              ),
            ),
          );
        });
  }
}

//
//
//
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++
// !      Box WATCH BUILDER Class
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++
class _WatchBoxTask extends StatefulWidget {
  _WatchBoxTask({Key key}) : super(key: key);

  @override
  __WatchBoxTaskState createState() => __WatchBoxTaskState();
}

class __WatchBoxTaskState extends State<_WatchBoxTask> {
  bool statecheck = false;
  final TaskManage _task = TaskManage();
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => WatchBoxBuilder(
        box: Hive.box<Mytask>('customtaskk'),
        builder: (context, contactsBox) {
          return ListView.builder(
            itemCount: contactsBox.length,
            itemBuilder: (BuildContext context, int index) {
              final contact = contactsBox.getAt(index);

              return ListTile(
                leading: Checkbox(
                  value: contact.status,
                  onChanged: (bool value) {
                    setState(() {
                      contactsBox.putAt(
                          index, Mytask(contact.title, !contact.status));
                      // print(contact.status);
                    });
                  },
                ),
                title: Text(contact.title),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => contactsBox.deleteAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
