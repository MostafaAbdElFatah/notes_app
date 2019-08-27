import 'dart:math';
import 'NotesDetails.dart';
import 'Model/Note.dart';
import 'Database/SqfiteDB.dart';
import 'package:notes_app/Database/FloorDB.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseManager dbManager;
  final Random _random = Random();
  List<Note> _notesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// SQfite DB
//    dbManager = DatabaseHelper();
//    dbManager.getNotes().then((notesList){
//      setState(() {
//        _notesList.clear();
//        _notesList.addAll(notesList);
//      });
//    });

    /// Floor DB
    dbManager = DatabaseManager();
    dbManager.getNotes().then((notesList) {
      setState(() {
        _notesList.clear();
        _notesList.addAll(notesList);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (index) {
              switch (index) {
                case 0:
                  setState(() {
                    _notesList.clear();
                    dbManager.deleteAllNotes();
                  });
                  break;
                case 1:
                  break;
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text("delete all"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Setting"),
              ),
            ],
          ),
        ],
      ),
      body:
          this._notesList.length > 0 ? this._getListContent() : this._emptyList,
      floatingActionButton: FloatingActionButton(
        onPressed: _showNotesDetails,
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showNotesDetails({int index}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return index == null
          ? NotesDetails()
          : NotesDetails(
              note: this._notesList[index],
            );
    }));
  }

  final _emptyList = Center(
    child: Text(
      "No Notes Found",
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 30),
    ),
  );

  Widget _getListContent() {
    return ListView.builder(
      itemCount: this._notesList.length,
      itemBuilder: (BuildContext context, int index) {
        return this._getListViewCell(index);
      },
    );
  }

  void deleteNote(int index) {
    setState(() {
      dbManager.deleteNote(_notesList[index]);
      _notesList.removeAt(index);
    });
  }

  Widget _getListViewCell(int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          foregroundColor: Colors.red,
          iconWidget: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onTap: () => this.deleteNote(index),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          foregroundColor: Colors.red,
          iconWidget: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onTap: () => this.deleteNote(index),
        ),
      ],
      //key: Key(_notesList[index].id.toString()),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color.fromRGBO(
                    _random.nextInt(255),
                    _random.nextInt(255),
                    _random.nextInt(255),
                    1,
                  ),
                  radius: 5,
                ),
                title: Text(
                  this._notesList[index].date,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.subtitle,
                ),
                subtitle: Text(
                  this._notesList[index].note,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.title,
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: () {
                  this._showNotesDetails(index: index);
                },
              )),
        ),
      ),
    );
  }
}
