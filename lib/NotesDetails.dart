import 'package:flutter/material.dart';
import 'Model/Note.dart';
import 'package:intl/intl.dart';
import 'Database/SqfiteDB.dart';
import 'package:notes_app/Database/FloorDB.dart';

class NotesDetails extends StatelessWidget {
  final Note note;
  NotesDetails({this.note});

  @override
  Widget build(BuildContext context) {
    return _Notes(note: note,);
  }
}

class _Notes extends StatefulWidget {

  final Note note;
  _Notes({this.note});

  @override
  _NotesState createState() => _NotesState(note:note,);
}

class _NotesState extends State<_Notes> {

  final Note note;
  _NotesState({this.note});
  TextEditingController _noteEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   if(note != null){
     _noteEditingController.text = note.note;
   }
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes App"),
          actions: <Widget>[
            FlatButton(
                onPressed: this._popPage,
                child: Text(note == null ? "Save":"Update", style: TextStyle(color: Colors.white)))
          ],
        ),
        body: new Container(
          margin: EdgeInsets.all(10),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _noteEditingController,
                  keyboardType: TextInputType.multiline,
                  minLines: 100,
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Note",
                      alignLabelWithHint: true,
                      hintText: "Note",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
            ),
          ),
      ),
    );
  }

  void _popPage() {
    //save note database
    DateTime now = new DateTime.now();
    var formatter = new DateFormat.yMd().add_jms();
    String formattedDate = formatter.format(now);
    /// SQfite DB
//    final dbManager = DatabaseHelper();
//    if(this.note == null) {
//      Note note = Note( _noteEditingController.text, formattedDate);
//      dbManager.insertNote(note);
//    }else{
//      this.note.note = _noteEditingController.text;
//      dbManager.updateNote(note);
//    }
    /// Floor DB
    var dbManager = DatabaseManager();
    if(this.note == null) {
      Note note = Note( _noteEditingController.text, formattedDate);
      dbManager.insertNote(note);
    }else{
      this.note.note = _noteEditingController.text;
      dbManager.updateNote(note);
    }
    Navigator.pop(context);
  }
}
