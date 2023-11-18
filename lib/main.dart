import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = '90hhlwIoaixMRVx1cESXcTBArw6hWMNxukoZdgtD';
  final keyClientKey = 'GcRd2yBkJobW0hfenKrbqpss24YxIhz55cs8eSII';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final taskController = TextEditingController();
  final taskdescriptionController = TextEditingController();
  final editTitleController = TextEditingController();
  final editDescriptionController = TextEditingController();
  String selectedObjectId = '';

    void updateTaskDetails() async {
    if (editTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    else if (editDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty description"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await updateTask(selectedObjectId, editTitleController.text, editDescriptionController.text);
    setState(() {
      editTitleController.clear();
      taskdescriptionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks List"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getTask(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator()),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error..."),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("No Data..."),
                          );
                        } else {
                          return ListView.builder(
                              padding: EdgeInsets.only(top: 10.0),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final varTask = snapshot.data![index];
                                final varTitle = varTask.get<String>('title')!;
                                final varDescription = varTask.get<String>('description')!;

                                return ListTile(
                                  title: Text(varTitle),
                                  subtitle: Text(varDescription),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            selectedObjectId = varTask.objectId!;
                                            editTitleController.text = varTitle;
                                            editDescriptionController.text = varDescription;
                                          });
                                          updateAlertBuilder(context);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () async {
                                          await deleteTask(varTask.objectId!);
                                          setState(() {
                                            final snackBar = SnackBar(
                                              content: Text("Task deleted!"),
                                              duration: Duration(seconds: 2),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    viewAlertBuilder(context, varTitle, varDescription);
                                  }
                                );
                              });
                        }
                    }
                  })),
        ],
      ),
      floatingActionButton: FloatingActionButton(
                  onPressed: () {
                      Navigator.push( context, MaterialPageRoute( builder: (context) => AddTaskRoute()), ).then((value) => setState(() {}));
                  },
                  child: const Icon(Icons.add),
                )
    );
  }

  Future<void> updateAlertBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: Container(
              padding: EdgeInsets.only(left: 7.0, right: 7.0),
              height: 250,
              child: Column(
                children: <Widget>[
                  SizedBox(width: 260, child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: editTitleController,
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    )),
                  SizedBox(width: 260, child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: editDescriptionController,
                      decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                       minLines: 1,
                       maxLines: 3
                    ))
                ],
              )),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                updateTaskDetails();
              },
            ),
          ],
        );
      },
    );
  }

   Future<void> viewAlertBuilder(BuildContext context, String title, String description) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task Details'),
          content: Container(
              padding: EdgeInsets.only(left: 7.0, right: 7.0),
              height: 250,
              child: Column(
                children: <Widget>[
                  Align(
                    child: Text(title),
                    alignment: Alignment.centerLeft
                  ),
                  SizedBox(height: 10),
                  Align(
                    child: Text(description),
                    alignment: Alignment.centerLeft
                  )
                ],
              )),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<List<ParseObject>> getTask() async {
    QueryBuilder<ParseObject> queryTask =
        QueryBuilder<ParseObject>(ParseObject('Task'));
    final ParseResponse apiResponse = await queryTask.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTask(String id, String title, String description) async {
       var task = ParseObject('Task')
      ..objectId = id
      ..set('title', title)
      ..set('description', description);
    await task.save();
  }

  Future<void> deleteTask(String id) async {
    var task = ParseObject('Task')..objectId = id;
    await task.delete();
    }
}

class AddTaskRoute extends StatefulWidget {
  @override
  _AddTaskRoute createState() => _AddTaskRoute();
}

class _AddTaskRoute extends State<AddTaskRoute> {
 final taskController = TextEditingController();
  final taskdescriptionController = TextEditingController();

  void addTask() async {
    if (taskController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty title"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    else if (taskdescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty description"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTask(taskController.text, taskdescriptionController.text);
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Center(
        child: Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Column(
                children: <Widget>[
                  SizedBox(width: 260, child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: taskController,
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    )),
                  SizedBox(width: 260, child: TextField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.sentences,
                      controller: taskdescriptionController,
                      decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                       minLines: 1,
                       maxLines: 3
                    )),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.blueAccent,
                      ),
                      onPressed: addTask,
                      child: Text("ADD"))
                  ),
                ],
              )),
      ),
    );
  }

    Future<void> saveTask(String title, String description) async {
     final task = ParseObject('Task')..set('title', title)..set('description', description);
    await task.save();
  }
}