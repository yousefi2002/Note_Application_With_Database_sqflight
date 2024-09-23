import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_notes.dart';
import 'log_in_page.dart';
import 'dart:async';
import 'note.dart';
import 'database_helper.dart';
import 'package:sqflite/sqflite.dart';

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = [];
  int? count;
  bool isDarkMode = false;
  String fontStyle = 'Kalnia_Glaze';
  double fontSize = 12.0;

  @override
  void initState() {
    super.initState();
    saveFont();
    updateListView();
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = [];
      updateListView();
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        shadowColor: Colors.white,
        title: Text('Notes'),
        actions: [
          IconButton(onPressed: ()=> _deleteAll, icon: Icon(Icons.delete_forever_rounded)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: noteList.isEmpty ?
      Center(child: Text('No Notes Available', style: TextStyle(fontSize: 35),))
          :ListView.builder(
              itemCount: count,
              itemBuilder: (context, index) {
                // Map<String, dynamic> note = notes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      navigateToAddNote(this.noteList[index],'Edit Detail');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500]!,
                            offset: Offset(-4, -4),
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(4, 4),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  noteList[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    noteList[index].date,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            noteList[index].description,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontFamily: fontStyle,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.red.withOpacity(0.8)),
                              onPressed: () {
                                _delete(context, noteList[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[400],
        onPressed: () {
          navigateToAddNote(Note('', ''),'Add Note');
        },
        child: Icon(Icons.add, color: Colors.black,),
      ),
    );
  }
  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('log_in', false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> saveFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fontStyle = prefs.getString('fontStyle') ?? 'Kalnia_Glaze';
      fontSize = prefs.getDouble('fontSize') ?? 12.0;
    });
  }

  void _delete(BuildContext context, Note note) async {
    var result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          backgroundColor: Colors.grey[400],
          content: Text('Note got deleted',style: TextStyle(color: Colors.black),)));
      updateListView();
    }
  }
  void _deleteAll(BuildContext context) async {
    var result = await databaseHelper.trancateDatabase();
    if (result != 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          backgroundColor: Colors.grey[400],
          content: Text('Note got deleted',style: TextStyle(color: Colors.black),)));
      updateListView();
    }
  }

  void updateListView() {
    Future<Database> dbFuture = databaseHelper.initialize();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }
  void navigateToAddNote(Note note, String title) async{
    bool result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddNotePage(note, title)));
    if( result == true){
      updateListView();
    }
  }
}
