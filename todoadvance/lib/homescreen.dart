import 'dart:async';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import "database.dart";
import 'taskmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isEdit = false;
  List<ModalTaskCard> taskCardList = [];
  int isfinished = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () async {
      await createDatabase();
      taskCardList = await getTaskData();
      setState(() {});
    });
  }

  void submit(bool isEdit, [ModalTaskCard? taskCardobj])async {
    if (_titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty &&
        _dateController.text.trim().isNotEmpty) {
      if (!isEdit) {
        
          ModalTaskCard newobj = ModalTaskCard(
              isfinished: isfinished,
              title: _titleController.text,
              description: _descriptionController.text,
              date: _dateController.text);

          insertTaskData(newobj);
          taskCardList = await getTaskData(); 
          print(taskCardList);
        setState(() {
          
        },);
      } else {
        setState(() {
          taskCardobj!.title = _titleController.text.trim();
          taskCardobj.description = _descriptionController.text.trim();
          taskCardobj.date = _dateController.text;
          taskCardobj.isfinished = isfinished;
          
        });
      }
    }
    clearController();
  }

  void clearController() {
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
  }

  void editTask(ModalTaskCard taskCardobj) {
    setState(() {
      _titleController.text = taskCardobj.title;
      _descriptionController.text = taskCardobj.description;
      _dateController.text = taskCardobj.date;
      popbottomSheet(true, taskCardobj);
      updateCardlist(taskCardobj);
    });
  }
  
  Future<void> deleteTask(ModalTaskCard taskCard) async {
  await deleteTaskData(taskCard); // Delete the task from the database
  taskCardList.remove(taskCard); // Remove the task from the local list
  setState(() {}); // Update the UI
}

  void popbottomSheet(bool isEdit, [ModalTaskCard? taskCardobj]) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create Task",
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  TextField(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    maxLines: 4,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _dateController,
                    readOnly: false,
                    onTap: () async {
                      //Pick date from date picker
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2025));
                      //formate the date into required formate of thr date i.e year month date
                      String formateDate =
                          DateFormat.yMMMd().format(pickedDate!);
                      setState(() {
                        _dateController.text = formateDate;
                      });
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(
                        Icons.date_range_outlined,
                        color: Color.fromRGBO(
                          111,
                          81,
                          255,
                          1,
                        ),
                      ),
                      hintText: "Date",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      (isEdit) ? submit(isEdit, taskCardobj) : submit(isEdit);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(
                          111,
                          81,
                          255,
                          1,
                        ),
                        fixedSize: const Size(300, 40)),
                    child: Text(
                      "Submit",
                      style: GoogleFonts.quicksand(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(
        111,
        81,
        255,
        1,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Text("Good Morning",
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Text("Akshay",
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(217, 217, 217, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text("CREATE TO DO LIST",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: taskCardList.length,
                          itemBuilder: (context, index) {
                            return Slidable(
                              enabled: true,
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        IconButton(
                                          color: const Color.fromRGBO(
                                            111,
                                            81,
                                            255,
                                            1,
                                          ),
                                          onPressed: () {
                                            print(isfinished);
                                            editTask(taskCardList[index]);
                                            print(isfinished);
                                          },
                                          icon: const Icon(Icons.edit),
                                          iconSize: 20,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        IconButton(
                                          color: const Color.fromRGBO(
                                            111,
                                            81,
                                            255,
                                            1,
                                          ),
                                          onPressed: () {
                                            deleteTask(taskCardList[index]);

                                          },
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(10),
                                height: 110,
                                width: 400,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 230, 227, 227),
                                      spreadRadius: 2,
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                key: ValueKey(index),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: SizedBox(
                                            child: Text(
                                              taskCardList[index].title,
                                              style: GoogleFonts.quicksand(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: 220,
                                          child: Text(
                                            taskCardList[index].description,
                                            style: GoogleFonts.quicksand(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          taskCardList[index].date,
                                          style: GoogleFonts.quicksand(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Checkbox(
                                      value:
                                          (taskCardList[index].isfinished == 0)
                                              ? false
                                              : true,
                                      activeColor:
                                          (taskCardList[index].isfinished == 1)
                                              ? Colors.green
                                              : Colors.white,
                                      shape: const CircleBorder(),
                                      onChanged: (bool) {
                                        setState(() {
                                          (taskCardList[index].isfinished == 0)
                                              ? taskCardList[index].isfinished =
                                                  1
                                              : taskCardList[index].isfinished =
                                                  0;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clearController();
          popbottomSheet(false);
          setState(() {});
        },
        backgroundColor: const Color.fromRGBO(
          111,
          81,
          255,
          1,
        ),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
