import 'dart:async';
import 'package:flutter/material.dart';
import 'package:note_app_database/database_helper.dart';
import 'note.dart';


class AddNotePage extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  const AddNotePage(this.note, this.appBarTitle, {super.key});

  @override
  _AddNotePageState createState() =>
      _AddNotePageState(this.note, this.appBarTitle);
}

class _AddNotePageState extends State<AddNotePage> {

  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;
  _AddNotePageState(this.note, this.appBarTitle);

  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _formattedDate = '';
  String? _formattedTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  @override
  Widget build(BuildContext context) {
    _topicController.text = note.title;
    _descriptionController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _topicController,
              decoration: InputDecoration(labelText: 'Topic'),
              onChanged: (value) {setState(() {
                note.title = _topicController.text;
              });
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  note.description = _descriptionController.text;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                  if(_topicController.text.isEmpty){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                        backgroundColor: Colors.grey[400],
                        content: Text('The topic and the description can\'nt be empty', style: TextStyle(color: Colors.black)),),);
                  }else if (_descriptionController.text.isEmpty){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(
                      backgroundColor: Colors.grey[400],
                      content: Text('The topic and the description can\'nt be empty', style: TextStyle(color: Colors.black)),),);
                  }
                  else{
                      saveNote();
                  }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDateTime() {
    Timer.periodic(const Duration(seconds: 0), (Timer t) {
      final now = DateTime.now();
      setState(() {
        _formattedDate = '${now.year}-${now.month}-${now.day}';
        _formattedTime = '${now.hour}:${now.minute}:${now.second}';
      });
    });
  }
  void saveNote() async {

    note.date = '''
    $_formattedDate
    $_formattedTime''';
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note) ;
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(backgroundColor: Colors.grey,content: Text('saved',style: TextStyle(color: Colors.black))));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(backgroundColor: Colors.grey, content: Text('updated',style: TextStyle(color: Colors.black))));
    }
    Navigator.of(context).pop(true);
  }
}
