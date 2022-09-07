// ignore_for_file: prefer_const_constructors, prefer_final_fields, await_only_futures

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  TextEditingController _userInput = TextEditingController();
  TextEditingController _updateTODO = TextEditingController();
  Box? todoList;
  @override
  void initState() {
    todoList = Hive.box('user');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            children: [
              TextField(
                controller: _userInput,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter New TO_DO',
                ),
              ),
              SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () async {
                      todoList!.add(_userInput.text);
                    },
                    child: Text('Add to-do List'),
                  )),
              Expanded(
                child: ValueListenableBuilder(
                    valueListenable: Hive.box('user').listenable(),
                    builder: (context, box, widget) {
                      return ListView.builder(
                          itemCount: todoList!.keys.toList().length,
                          itemBuilder: (_, index) {
                            return Card(
                              elevation: 10,
                              child: ListTile(
                                title: Text(
                                  todoList!.getAt(index).toString(),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: Text("Update TO_DO"),
                                                  content: Column(
                                                    children: [
                                                      TextField(
                                                        controller: _updateTODO,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText:
                                                              'Update TO_DO',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: 350,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              final _updateValue =
                                                                  _updateTODO
                                                                      .text;
                                                              todoList!.putAt(
                                                                  index,
                                                                  _updateValue);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                                'Update to-do List'),
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          todoList!.deleteAt(index);
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
