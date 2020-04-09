import 'package:moor_flutter/moor_flutter.dart';

part 'moor_database.g.dart';

// Based on https://www.youtube.com/watch?v=zpWsedYMczM
// tutorial not finished

class Events extends Table {
  // @override
  // Set<Column> get primaryKey => {id, name};

  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

@DataClassName('FirstLogin')
class LoginOperation extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get completed => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [Events, LoginOperation])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<Event>> getAllEvents() => select(events).get();
  Stream<List<Event>> watchAllEvents() => select(events).watch();

  // returns the key of the newly added event
  // remove <int> if the return is not usable
  Future<int> insertEvent(Event event) => into(events).insert(event);

  Future updateEvent(Event event) => update(events).replace(event);

  Future deleteEvent(Event event) => delete(events).delete(event);
}
