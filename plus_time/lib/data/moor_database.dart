import 'package:moor_flutter/moor_flutter.dart';

//part 'moor_database.g.dart';

// Based on https://www.youtube.com/watch?v=zpWsedYMczM
// tutorial not finished

class Events extends Table {
  // autoIncrement automatically sets this to be the primary key
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();
}
