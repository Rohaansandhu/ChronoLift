// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Workouts extends Table with TableInfo<Workouts, WorkoutsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Workouts(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression(
          'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)'));
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression(
          'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, name, date, startTime, endTime, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  Workouts createAlias(String alias) {
    return Workouts(attachedDatabase, alias);
  }
}

class WorkoutsData extends DataClass implements Insertable<WorkoutsData> {
  final int id;
  final String uuid;
  final String? name;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WorkoutsData(
      {required this.id,
      required this.uuid,
      this.name,
      required this.date,
      this.startTime,
      this.endTime,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      date: Value(date),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WorkoutsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutsData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String?>(json['name']),
      date: serializer.fromJson<DateTime>(json['date']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String?>(name),
      'date': serializer.toJson<DateTime>(date),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WorkoutsData copyWith(
          {int? id,
          String? uuid,
          Value<String?> name = const Value.absent(),
          DateTime? date,
          Value<DateTime?> startTime = const Value.absent(),
          Value<DateTime?> endTime = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WorkoutsData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name.present ? name.value : this.name,
        date: date ?? this.date,
        startTime: startTime.present ? startTime.value : this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WorkoutsData copyWithCompanion(WorkoutsCompanion data) {
    return WorkoutsData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      date: data.date.present ? data.date.value : this.date,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, uuid, name, date, startTime, endTime, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutsData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.date == this.date &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutsCompanion extends UpdateCompanion<WorkoutsData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String?> name;
  final Value<DateTime> date;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.date = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.name = const Value.absent(),
    required DateTime date,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : uuid = Value(uuid),
        date = Value(date);
  static Insertable<WorkoutsData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<DateTime>? date,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String?>? name,
      Value<DateTime>? date,
      Value<DateTime?>? startTime,
      Value<DateTime?>? endTime,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('date: $date, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class Categories extends Table with TableInfo<Categories, CategoriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression(
          'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {uuid, name},
      ];
  @override
  CategoriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }
}

class CategoriesData extends DataClass implements Insertable<CategoriesData> {
  final int id;
  final String uuid;
  final String name;
  final String? description;
  final DateTime createdAt;
  const CategoriesData(
      {required this.id,
      required this.uuid,
      required this.name,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory CategoriesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoriesData copyWith(
          {int? id,
          String? uuid,
          String? name,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      CategoriesData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  CategoriesData copyWithCompanion(CategoriesCompanion data) {
    return CategoriesData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoriesData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String name,
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : uuid = Value(uuid),
        name = Value(name);
  static Insertable<CategoriesData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime>? createdAt}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class Exercises extends Table with TableInfo<Exercises, ExercisesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Exercises(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression(
          'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, name, categoryId, instructions, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {uuid, name},
      ];
  @override
  ExercisesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExercisesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  Exercises createAlias(String alias) {
    return Exercises(attachedDatabase, alias);
  }
}

class ExercisesData extends DataClass implements Insertable<ExercisesData> {
  final int id;
  final String uuid;
  final String name;
  final int categoryId;
  final String? instructions;
  final DateTime createdAt;
  const ExercisesData(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.categoryId,
      this.instructions,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      categoryId: Value(categoryId),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      createdAt: Value(createdAt),
    );
  }

  factory ExercisesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExercisesData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
      'instructions': serializer.toJson<String?>(instructions),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExercisesData copyWith(
          {int? id,
          String? uuid,
          String? name,
          int? categoryId,
          Value<String?> instructions = const Value.absent(),
          DateTime? createdAt}) =>
      ExercisesData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        instructions:
            instructions.present ? instructions.value : this.instructions,
        createdAt: createdAt ?? this.createdAt,
      );
  ExercisesData copyWithCompanion(ExercisesCompanion data) {
    return ExercisesData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('instructions: $instructions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, name, categoryId, instructions, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExercisesData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.instructions == this.instructions &&
          other.createdAt == this.createdAt);
}

class ExercisesCompanion extends UpdateCompanion<ExercisesData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<int> categoryId;
  final Value<String?> instructions;
  final Value<DateTime> createdAt;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.instructions = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String name,
    required int categoryId,
    this.instructions = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : uuid = Value(uuid),
        name = Value(name),
        categoryId = Value(categoryId);
  static Insertable<ExercisesData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<int>? categoryId,
    Expression<String>? instructions,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (instructions != null) 'instructions': instructions,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExercisesCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<int>? categoryId,
      Value<String?>? instructions,
      Value<DateTime>? createdAt}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('instructions: $instructions, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class WorkoutExercises extends Table
    with TableInfo<WorkoutExercises, WorkoutExercisesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WorkoutExercises(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE CASCADE'));
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES exercises (id)'));
  late final GeneratedColumn<int> orderInWorkout = GeneratedColumn<int>(
      'order_in_workout', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, uuid, workoutId, exerciseId, orderInWorkout, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercisesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercisesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}workout_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}exercise_id'])!,
      orderInWorkout: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_in_workout'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  WorkoutExercises createAlias(String alias) {
    return WorkoutExercises(attachedDatabase, alias);
  }
}

class WorkoutExercisesData extends DataClass
    implements Insertable<WorkoutExercisesData> {
  final int id;
  final String uuid;
  final int workoutId;
  final int exerciseId;
  final int orderInWorkout;
  final String? notes;
  const WorkoutExercisesData(
      {required this.id,
      required this.uuid,
      required this.workoutId,
      required this.exerciseId,
      required this.orderInWorkout,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['workout_id'] = Variable<int>(workoutId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['order_in_workout'] = Variable<int>(orderInWorkout);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      uuid: Value(uuid),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      orderInWorkout: Value(orderInWorkout),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WorkoutExercisesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercisesData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      orderInWorkout: serializer.fromJson<int>(json['orderInWorkout']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'workoutId': serializer.toJson<int>(workoutId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'orderInWorkout': serializer.toJson<int>(orderInWorkout),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutExercisesData copyWith(
          {int? id,
          String? uuid,
          int? workoutId,
          int? exerciseId,
          int? orderInWorkout,
          Value<String?> notes = const Value.absent()}) =>
      WorkoutExercisesData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        workoutId: workoutId ?? this.workoutId,
        exerciseId: exerciseId ?? this.exerciseId,
        orderInWorkout: orderInWorkout ?? this.orderInWorkout,
        notes: notes.present ? notes.value : this.notes,
      );
  WorkoutExercisesData copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercisesData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      orderInWorkout: data.orderInWorkout.present
          ? data.orderInWorkout.value
          : this.orderInWorkout,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderInWorkout: $orderInWorkout, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uuid, workoutId, exerciseId, orderInWorkout, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercisesData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.orderInWorkout == this.orderInWorkout &&
          other.notes == this.notes);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercisesData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> workoutId;
  final Value<int> exerciseId;
  final Value<int> orderInWorkout;
  final Value<String?> notes;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderInWorkout = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int workoutId,
    required int exerciseId,
    required int orderInWorkout,
    this.notes = const Value.absent(),
  })  : uuid = Value(uuid),
        workoutId = Value(workoutId),
        exerciseId = Value(exerciseId),
        orderInWorkout = Value(orderInWorkout);
  static Insertable<WorkoutExercisesData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? workoutId,
    Expression<int>? exerciseId,
    Expression<int>? orderInWorkout,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderInWorkout != null) 'order_in_workout': orderInWorkout,
      if (notes != null) 'notes': notes,
    });
  }

  WorkoutExercisesCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? workoutId,
      Value<int>? exerciseId,
      Value<int>? orderInWorkout,
      Value<String?>? notes}) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderInWorkout: orderInWorkout ?? this.orderInWorkout,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (orderInWorkout.present) {
      map['order_in_workout'] = Variable<int>(orderInWorkout.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderInWorkout: $orderInWorkout, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class Sets extends Table with TableInfo<Sets, SetsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Sets(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> workoutExerciseId = GeneratedColumn<int>(
      'workout_exercise_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_exercises (id) ON DELETE CASCADE'));
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
      'set_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> rpe = GeneratedColumn<int>(
      'rpe', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
      'is_warmup', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_warmup" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        workoutExerciseId,
        setNumber,
        weight,
        reps,
        duration,
        rpe,
        notes,
        isWarmup
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sets';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}workout_exercise_id'])!,
      setNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_number'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight']),
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration']),
      rpe: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rpe']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isWarmup: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_warmup'])!,
    );
  }

  @override
  Sets createAlias(String alias) {
    return Sets(attachedDatabase, alias);
  }
}

class SetsData extends DataClass implements Insertable<SetsData> {
  final int id;
  final String uuid;
  final int workoutExerciseId;
  final int setNumber;
  final double? weight;
  final int? reps;
  final int? duration;
  final int? rpe;
  final String? notes;
  final bool isWarmup;
  const SetsData(
      {required this.id,
      required this.uuid,
      required this.workoutExerciseId,
      required this.setNumber,
      this.weight,
      this.reps,
      this.duration,
      this.rpe,
      this.notes,
      required this.isWarmup});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['workout_exercise_id'] = Variable<int>(workoutExerciseId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<int>(rpe);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    return map;
  }

  SetsCompanion toCompanion(bool nullToAbsent) {
    return SetsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      workoutExerciseId: Value(workoutExerciseId),
      setNumber: Value(setNumber),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isWarmup: Value(isWarmup),
    );
  }

  factory SetsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetsData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      workoutExerciseId: serializer.fromJson<int>(json['workoutExerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double?>(json['weight']),
      reps: serializer.fromJson<int?>(json['reps']),
      duration: serializer.fromJson<int?>(json['duration']),
      rpe: serializer.fromJson<int?>(json['rpe']),
      notes: serializer.fromJson<String?>(json['notes']),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'workoutExerciseId': serializer.toJson<int>(workoutExerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double?>(weight),
      'reps': serializer.toJson<int?>(reps),
      'duration': serializer.toJson<int?>(duration),
      'rpe': serializer.toJson<int?>(rpe),
      'notes': serializer.toJson<String?>(notes),
      'isWarmup': serializer.toJson<bool>(isWarmup),
    };
  }

  SetsData copyWith(
          {int? id,
          String? uuid,
          int? workoutExerciseId,
          int? setNumber,
          Value<double?> weight = const Value.absent(),
          Value<int?> reps = const Value.absent(),
          Value<int?> duration = const Value.absent(),
          Value<int?> rpe = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isWarmup}) =>
      SetsData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
        setNumber: setNumber ?? this.setNumber,
        weight: weight.present ? weight.value : this.weight,
        reps: reps.present ? reps.value : this.reps,
        duration: duration.present ? duration.value : this.duration,
        rpe: rpe.present ? rpe.value : this.rpe,
        notes: notes.present ? notes.value : this.notes,
        isWarmup: isWarmup ?? this.isWarmup,
      );
  SetsData copyWithCompanion(SetsCompanion data) {
    return SetsData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      duration: data.duration.present ? data.duration.value : this.duration,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      notes: data.notes.present ? data.notes.value : this.notes,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetsData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('duration: $duration, ')
          ..write('rpe: $rpe, ')
          ..write('notes: $notes, ')
          ..write('isWarmup: $isWarmup')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, workoutExerciseId, setNumber,
      weight, reps, duration, rpe, notes, isWarmup);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetsData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.duration == this.duration &&
          other.rpe == this.rpe &&
          other.notes == this.notes &&
          other.isWarmup == this.isWarmup);
}

class SetsCompanion extends UpdateCompanion<SetsData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> workoutExerciseId;
  final Value<int> setNumber;
  final Value<double?> weight;
  final Value<int?> reps;
  final Value<int?> duration;
  final Value<int?> rpe;
  final Value<String?> notes;
  final Value<bool> isWarmup;
  const SetsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.duration = const Value.absent(),
    this.rpe = const Value.absent(),
    this.notes = const Value.absent(),
    this.isWarmup = const Value.absent(),
  });
  SetsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required int workoutExerciseId,
    required int setNumber,
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.duration = const Value.absent(),
    this.rpe = const Value.absent(),
    this.notes = const Value.absent(),
    this.isWarmup = const Value.absent(),
  })  : uuid = Value(uuid),
        workoutExerciseId = Value(workoutExerciseId),
        setNumber = Value(setNumber);
  static Insertable<SetsData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? workoutExerciseId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<int>? duration,
    Expression<int>? rpe,
    Expression<String>? notes,
    Expression<bool>? isWarmup,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (duration != null) 'duration': duration,
      if (rpe != null) 'rpe': rpe,
      if (notes != null) 'notes': notes,
      if (isWarmup != null) 'is_warmup': isWarmup,
    });
  }

  SetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? workoutExerciseId,
      Value<int>? setNumber,
      Value<double?>? weight,
      Value<int?>? reps,
      Value<int?>? duration,
      Value<int?>? rpe,
      Value<String?>? notes,
      Value<bool>? isWarmup}) {
    return SetsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      rpe: rpe ?? this.rpe,
      notes: notes ?? this.notes,
      isWarmup: isWarmup ?? this.isWarmup,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<int>(workoutExerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<int>(rpe.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('duration: $duration, ')
          ..write('rpe: $rpe, ')
          ..write('notes: $notes, ')
          ..write('isWarmup: $isWarmup')
          ..write(')'))
        .toString();
  }
}

class Users extends Table with TableInfo<Users, UsersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Users(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression(
          'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)'));
  late final GeneratedColumn<bool> isCurrent = GeneratedColumn<bool>(
      'is_current', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_current" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns => [id, uuid, email, createdAt, isCurrent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsersData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isCurrent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_current'])!,
    );
  }

  @override
  Users createAlias(String alias) {
    return Users(attachedDatabase, alias);
  }
}

class UsersData extends DataClass implements Insertable<UsersData> {
  final int id;
  final String uuid;
  final String email;
  final DateTime createdAt;
  final bool isCurrent;
  const UsersData(
      {required this.id,
      required this.uuid,
      required this.email,
      required this.createdAt,
      required this.isCurrent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['email'] = Variable<String>(email);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_current'] = Variable<bool>(isCurrent);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      uuid: Value(uuid),
      email: Value(email),
      createdAt: Value(createdAt),
      isCurrent: Value(isCurrent),
    );
  }

  factory UsersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsersData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      email: serializer.fromJson<String>(json['email']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isCurrent: serializer.fromJson<bool>(json['isCurrent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'email': serializer.toJson<String>(email),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isCurrent': serializer.toJson<bool>(isCurrent),
    };
  }

  UsersData copyWith(
          {int? id,
          String? uuid,
          String? email,
          DateTime? createdAt,
          bool? isCurrent}) =>
      UsersData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        isCurrent: isCurrent ?? this.isCurrent,
      );
  UsersData copyWithCompanion(UsersCompanion data) {
    return UsersData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      email: data.email.present ? data.email.value : this.email,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isCurrent: data.isCurrent.present ? data.isCurrent.value : this.isCurrent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsersData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('isCurrent: $isCurrent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, email, createdAt, isCurrent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsersData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.email == this.email &&
          other.createdAt == this.createdAt &&
          other.isCurrent == this.isCurrent);
}

class UsersCompanion extends UpdateCompanion<UsersData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> email;
  final Value<DateTime> createdAt;
  final Value<bool> isCurrent;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.email = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isCurrent = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String email,
    this.createdAt = const Value.absent(),
    this.isCurrent = const Value.absent(),
  })  : uuid = Value(uuid),
        email = Value(email);
  static Insertable<UsersData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? email,
    Expression<DateTime>? createdAt,
    Expression<bool>? isCurrent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (email != null) 'email': email,
      if (createdAt != null) 'created_at': createdAt,
      if (isCurrent != null) 'is_current': isCurrent,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? email,
      Value<DateTime>? createdAt,
      Value<bool>? isCurrent}) {
    return UsersCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isCurrent.present) {
      map['is_current'] = Variable<bool>(isCurrent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('isCurrent: $isCurrent')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV2 extends GeneratedDatabase {
  DatabaseAtV2(QueryExecutor e) : super(e);
  late final Workouts workouts = Workouts(this);
  late final Categories categories = Categories(this);
  late final Exercises exercises = Exercises(this);
  late final WorkoutExercises workoutExercises = WorkoutExercises(this);
  late final Sets sets = Sets(this);
  late final Users users = Users(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [workouts, categories, exercises, workoutExercises, sets, users];
  @override
  int get schemaVersion => 2;
}
