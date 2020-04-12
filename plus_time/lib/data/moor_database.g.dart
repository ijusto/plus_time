// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class LoginOperation extends DataClass implements Insertable<LoginOperation> {
  final int id;
  final int type;
  final String pass;
  LoginOperation({@required this.id, @required this.type, @required this.pass});
  factory LoginOperation.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return LoginOperation(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      type: intType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      pass: stringType.mapFromDatabaseResponse(data['${effectivePrefix}pass']),
    );
  }
  factory LoginOperation.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return LoginOperation(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<int>(json['type']),
      pass: serializer.fromJson<String>(json['pass']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(type),
      'pass': serializer.toJson<String>(pass),
    };
  }

  @override
  LoginOperationsCompanion createCompanion(bool nullToAbsent) {
    return LoginOperationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      pass: pass == null && nullToAbsent ? const Value.absent() : Value(pass),
    );
  }

  LoginOperation copyWith({int id, int type, String pass}) => LoginOperation(
        id: id ?? this.id,
        type: type ?? this.type,
        pass: pass ?? this.pass,
      );
  @override
  String toString() {
    return (StringBuffer('LoginOperation(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('pass: $pass')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(type.hashCode, pass.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is LoginOperation &&
          other.id == this.id &&
          other.type == this.type &&
          other.pass == this.pass);
}

class LoginOperationsCompanion extends UpdateCompanion<LoginOperation> {
  final Value<int> id;
  final Value<int> type;
  final Value<String> pass;
  const LoginOperationsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.pass = const Value.absent(),
  });
  LoginOperationsCompanion.insert({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    @required String pass,
  }) : pass = Value(pass);
  LoginOperationsCompanion copyWith(
      {Value<int> id, Value<int> type, Value<String> pass}) {
    return LoginOperationsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      pass: pass ?? this.pass,
    );
  }
}

class $LoginOperationsTable extends LoginOperations
    with TableInfo<$LoginOperationsTable, LoginOperation> {
  final GeneratedDatabase _db;
  final String _alias;
  $LoginOperationsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedIntColumn _type;
  @override
  GeneratedIntColumn get type => _type ??= _constructType();
  GeneratedIntColumn _constructType() {
    return GeneratedIntColumn('type', $tableName, false,
        defaultValue: Constant(-1));
  }

  final VerificationMeta _passMeta = const VerificationMeta('pass');
  GeneratedTextColumn _pass;
  @override
  GeneratedTextColumn get pass => _pass ??= _constructPass();
  GeneratedTextColumn _constructPass() {
    return GeneratedTextColumn('pass', $tableName, false,
        minTextLength: 6, maxTextLength: 6);
  }

  @override
  List<GeneratedColumn> get $columns => [id, type, pass];
  @override
  $LoginOperationsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'login_operations';
  @override
  final String actualTableName = 'login_operations';
  @override
  VerificationContext validateIntegrity(LoginOperationsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    }
    if (d.pass.present) {
      context.handle(
          _passMeta, pass.isAcceptableValue(d.pass.value, _passMeta));
    } else if (isInserting) {
      context.missing(_passMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoginOperation map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return LoginOperation.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(LoginOperationsCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.type.present) {
      map['type'] = Variable<int, IntType>(d.type.value);
    }
    if (d.pass.present) {
      map['pass'] = Variable<String, StringType>(d.pass.value);
    }
    return map;
  }

  @override
  $LoginOperationsTable createAlias(String alias) {
    return $LoginOperationsTable(_db, alias);
  }
}

class AccessGivenEntry extends DataClass
    implements Insertable<AccessGivenEntry> {
  final int id;
  final String typeOfAccess;
  final bool granted;
  AccessGivenEntry(
      {@required this.id, @required this.typeOfAccess, @required this.granted});
  factory AccessGivenEntry.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return AccessGivenEntry(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      typeOfAccess: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}type_of_access']),
      granted:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}granted']),
    );
  }
  factory AccessGivenEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AccessGivenEntry(
      id: serializer.fromJson<int>(json['id']),
      typeOfAccess: serializer.fromJson<String>(json['typeOfAccess']),
      granted: serializer.fromJson<bool>(json['granted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'typeOfAccess': serializer.toJson<String>(typeOfAccess),
      'granted': serializer.toJson<bool>(granted),
    };
  }

  @override
  AccessesGivenCompanion createCompanion(bool nullToAbsent) {
    return AccessesGivenCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      typeOfAccess: typeOfAccess == null && nullToAbsent
          ? const Value.absent()
          : Value(typeOfAccess),
      granted: granted == null && nullToAbsent
          ? const Value.absent()
          : Value(granted),
    );
  }

  AccessGivenEntry copyWith({int id, String typeOfAccess, bool granted}) =>
      AccessGivenEntry(
        id: id ?? this.id,
        typeOfAccess: typeOfAccess ?? this.typeOfAccess,
        granted: granted ?? this.granted,
      );
  @override
  String toString() {
    return (StringBuffer('AccessGivenEntry(')
          ..write('id: $id, ')
          ..write('typeOfAccess: $typeOfAccess, ')
          ..write('granted: $granted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(typeOfAccess.hashCode, granted.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is AccessGivenEntry &&
          other.id == this.id &&
          other.typeOfAccess == this.typeOfAccess &&
          other.granted == this.granted);
}

class AccessesGivenCompanion extends UpdateCompanion<AccessGivenEntry> {
  final Value<int> id;
  final Value<String> typeOfAccess;
  final Value<bool> granted;
  const AccessesGivenCompanion({
    this.id = const Value.absent(),
    this.typeOfAccess = const Value.absent(),
    this.granted = const Value.absent(),
  });
  AccessesGivenCompanion.insert({
    this.id = const Value.absent(),
    @required String typeOfAccess,
    this.granted = const Value.absent(),
  }) : typeOfAccess = Value(typeOfAccess);
  AccessesGivenCompanion copyWith(
      {Value<int> id, Value<String> typeOfAccess, Value<bool> granted}) {
    return AccessesGivenCompanion(
      id: id ?? this.id,
      typeOfAccess: typeOfAccess ?? this.typeOfAccess,
      granted: granted ?? this.granted,
    );
  }
}

class $AccessesGivenTable extends AccessesGiven
    with TableInfo<$AccessesGivenTable, AccessGivenEntry> {
  final GeneratedDatabase _db;
  final String _alias;
  $AccessesGivenTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _typeOfAccessMeta =
      const VerificationMeta('typeOfAccess');
  GeneratedTextColumn _typeOfAccess;
  @override
  GeneratedTextColumn get typeOfAccess =>
      _typeOfAccess ??= _constructTypeOfAccess();
  GeneratedTextColumn _constructTypeOfAccess() {
    return GeneratedTextColumn('type_of_access', $tableName, false,
        minTextLength: 1, maxTextLength: 50);
  }

  final VerificationMeta _grantedMeta = const VerificationMeta('granted');
  GeneratedBoolColumn _granted;
  @override
  GeneratedBoolColumn get granted => _granted ??= _constructGranted();
  GeneratedBoolColumn _constructGranted() {
    return GeneratedBoolColumn('granted', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, typeOfAccess, granted];
  @override
  $AccessesGivenTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'accesses_given';
  @override
  final String actualTableName = 'accesses_given';
  @override
  VerificationContext validateIntegrity(AccessesGivenCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    }
    if (d.typeOfAccess.present) {
      context.handle(
          _typeOfAccessMeta,
          typeOfAccess.isAcceptableValue(
              d.typeOfAccess.value, _typeOfAccessMeta));
    } else if (isInserting) {
      context.missing(_typeOfAccessMeta);
    }
    if (d.granted.present) {
      context.handle(_grantedMeta,
          granted.isAcceptableValue(d.granted.value, _grantedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccessGivenEntry map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return AccessGivenEntry.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(AccessesGivenCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.typeOfAccess.present) {
      map['type_of_access'] =
          Variable<String, StringType>(d.typeOfAccess.value);
    }
    if (d.granted.present) {
      map['granted'] = Variable<bool, BoolType>(d.granted.value);
    }
    return map;
  }

  @override
  $AccessesGivenTable createAlias(String alias) {
    return $AccessesGivenTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $LoginOperationsTable _loginOperations;
  $LoginOperationsTable get loginOperations =>
      _loginOperations ??= $LoginOperationsTable(this);
  $AccessesGivenTable _accessesGiven;
  $AccessesGivenTable get accessesGiven =>
      _accessesGiven ??= $AccessesGivenTable(this);
  LoginOperationDao _loginOperationDao;
  LoginOperationDao get loginOperationDao =>
      _loginOperationDao ??= LoginOperationDao(this as AppDatabase);
  AccessesGivenDao _accessesGivenDao;
  AccessesGivenDao get accessesGivenDao =>
      _accessesGivenDao ??= AccessesGivenDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [loginOperations, accessesGiven];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$LoginOperationDaoMixin on DatabaseAccessor<AppDatabase> {
  $LoginOperationsTable get loginOperations => db.loginOperations;
}
mixin _$AccessesGivenDaoMixin on DatabaseAccessor<AppDatabase> {
  $AccessesGivenTable get accessesGiven => db.accessesGiven;
}
