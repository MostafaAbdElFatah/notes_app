import 'package:floor/floor.dart';

@entity
class Note {
  @primaryKey
  int id;
  String note;
  String date;

  Note(this.note, this.date);

  Note.withID(this.id, this.note, this.date);

  Note.fromMapObject(Map<String, dynamic> map) {
    this.id = map["id"];
    this.note = map["note"];
    this.date = map["date"];
  }

  factory Note.fromMap(Map<String, dynamic> map) => Note.withID(map["id"], map["note"], map["date"]);


  Map<String, dynamic> toMap() => {
    "id"   : this.id ,
    "note" : this.note,
    "date" : this.date,
  };


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          note == other.note &&
          date == other.date;

  @override
  int get hashCode => this.id.hashCode ^ this.note.hashCode;

  @override
  String toString() {
    return 'Note{id: $id, note: $note, date: $date}';
  }
}
