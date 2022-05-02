import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const dbName = 'notes.db';
const noteTable = 'notes';
const userTable = 'users';
const idColumn = 'id';
const emailcolumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

class NotesService {
  Database? _db;

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // create user table
      const createUserTable = ''' CREATE TABLE IF NOT EXISTS "users"  (
        "id"	INTEGER NOT NULL,
        "email"	INTEGER NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';
      await db.execute(createUserTable);

      // create notes table
      const createNotesTable = ''' CREATE TABLE IF NOT EXISTS "notes" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "users"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      ); ''';
      await db.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> close() async {
    var db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      await _db!.close();
      _db = null;
    }
  }

  Database _getDatabaseOrThrow() {
    var db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    final userId =
        await db.insert(userTable, {emailcolumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email= ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw UserNotExistsException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw UserNotExistsException();
    }
    const text = '';
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id= ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id= ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return DatabaseNote.fromRow(notes.first);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      return await getNote(id: note.id);
    }
  }
}

class DatabaseUser {
  final int id;
  final String email;

  DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailcolumn] as String;

  @override
  String toString() => 'Person, ID=$id, email= $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Notes, ID=$id, Text= $text , UserId=$userId, isSyncedWithCloud=$isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
