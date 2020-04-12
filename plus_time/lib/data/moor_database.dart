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

@DataClassName('AccessGivenEntry')
class AccessesGiven extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();

  // calendar, location, storage, camera, biometrics
  TextColumn get typeOfAccess => text().withLength(min: 1, max: 50)();

  BoolColumn get granted => boolean().withDefault(Constant(false))();
}

class LoginOperations extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();
  // 0 - pass, 1 - fingerprint
  IntColumn get type => integer().withDefault(Constant(-1))();
  TextColumn get pass => text().withLength(min: 6, max: 6)();
}

@UseMoor(
    tables: [LoginOperations, AccessesGiven],
    daos: [LoginOperationDao, AccessesGivenDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 2;
}

@UseDao(tables: [LoginOperations])
class LoginOperationDao extends DatabaseAccessor<AppDatabase>
    with _$LoginOperationDaoMixin {
  final AppDatabase db;

  LoginOperationDao(this.db) : super(db);

  Future<List<LoginOperation>> getAllLoginOperations() =>
      select(loginOperations).get();

  Stream<List<LoginOperation>> watchAllLoginOperation() =>
      select(loginOperations).watch();

  // returns the key of the newly added event
  // remove <int> if the return is not usable
  Future<int> insertLoginOperation(Insertable<LoginOperation> loginOperation) =>
      into(loginOperations).insert(loginOperation);

  Future updateLoginOperation(Insertable<LoginOperation> loginOperation) =>
      update(loginOperations).replace(loginOperation);

  Future deleteLoginOperation(Insertable<LoginOperation> loginOperation) =>
      delete(loginOperations).delete(loginOperation);
}

@UseDao(tables: [AccessesGiven])
class AccessesGivenDao extends DatabaseAccessor<AppDatabase>
    with _$AccessesGivenDaoMixin {
  final AppDatabase db;

  AccessesGivenDao(this.db) : super(db);

  Future<List<AccessGivenEntry>> getAllAccessesGivens() =>
      select(accessesGiven).get();
  Stream<List<AccessGivenEntry>> watchAllAccessesGivens() =>
      select(accessesGiven).watch();

  // returns the key of the newly added event
  // remove <int> if the return is not usable
  Future<int> insertAccessesGiven(
          Insertable<AccessGivenEntry> accessGivenEntry) =>
      into(accessesGiven).insert(accessGivenEntry);

  Future updateAccessesGiven(Insertable<AccessGivenEntry> accessGivenEntry) =>
      update(accessesGiven).replace(accessGivenEntry);

  Future deleteAccessesGiven(Insertable<AccessGivenEntry> accessGivenEntry) =>
      delete(accessesGiven).delete(accessGivenEntry);
}
