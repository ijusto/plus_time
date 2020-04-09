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

class LoginOperations extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();
  // 0 - pass, 1 - fingerprint
  IntColumn get type => integer().withDefault(Constant(-1))();
  TextColumn get pass => text().withLength(min: 6, max: 6)();
}

@UseMoor(tables: [Events, LoginOperations])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<List<LoginOperation>> getAllLoginOperations() =>
      select(loginOperations).get();
  Stream<List<LoginOperation>> watchAllLoginOperation() =>
      select(loginOperations).watch();

  // returns the key of the newly added event
  // remove <int> if the return is not usable
  Future<int> insertLoginOperation(LoginOperation loginOperation) =>
      into(loginOperations).insert(loginOperation);

  Future updateLoginOperation(LoginOperation loginOperation) =>
      update(loginOperations).replace(loginOperation);

  Future deleteLoginOperation(LoginOperation loginOperation) =>
      delete(loginOperations).delete(loginOperation);
}
