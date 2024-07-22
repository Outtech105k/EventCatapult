// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminds.dart';

// ignore_for_file: type=lint
class $RemindsTable extends Reminds with TableInfo<$RemindsTable, Remind> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 0, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminds';
  @override
  VerificationContext validateIntegrity(Insertable<Remind> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Remind map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Remind(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $RemindsTable createAlias(String alias) {
    return $RemindsTable(attachedDatabase, alias);
  }
}

class Remind extends DataClass implements Insertable<Remind> {
  final int id;
  final String title;
  final String content;
  const Remind({required this.id, required this.title, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    return map;
  }

  RemindsCompanion toCompanion(bool nullToAbsent) {
    return RemindsCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
    );
  }

  factory Remind.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Remind(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
    };
  }

  Remind copyWith({int? id, String? title, String? content}) => Remind(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
      );
  Remind copyWithCompanion(RemindsCompanion data) {
    return Remind(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Remind(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Remind &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content);
}

class RemindsCompanion extends UpdateCompanion<Remind> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> content;
  const RemindsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
  });
  RemindsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String content,
  })  : title = Value(title),
        content = Value(content);
  static Insertable<Remind> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
    });
  }

  RemindsCompanion copyWith(
      {Value<int>? id, Value<String>? title, Value<String>? content}) {
    return RemindsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RemindsTable reminds = $RemindsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [reminds];
}

typedef $$RemindsTableCreateCompanionBuilder = RemindsCompanion Function({
  Value<int> id,
  required String title,
  required String content,
});
typedef $$RemindsTableUpdateCompanionBuilder = RemindsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> content,
});

class $$RemindsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindsTable,
    Remind,
    $$RemindsTableFilterComposer,
    $$RemindsTableOrderingComposer,
    $$RemindsTableCreateCompanionBuilder,
    $$RemindsTableUpdateCompanionBuilder> {
  $$RemindsTableTableManager(_$AppDatabase db, $RemindsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RemindsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RemindsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
          }) =>
              RemindsCompanion(
            id: id,
            title: title,
            content: content,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String content,
          }) =>
              RemindsCompanion.insert(
            id: id,
            title: title,
            content: content,
          ),
        ));
}

class $$RemindsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $RemindsTable> {
  $$RemindsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$RemindsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $RemindsTable> {
  $$RemindsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get content => $state.composableBuilder(
      column: $state.table.content,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RemindsTableTableManager get reminds =>
      $$RemindsTableTableManager(_db, _db.reminds);
}
