// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyRecordCollection on Isar {
  IsarCollection<DailyRecord> get dailyRecords => this.collection();
}

const DailyRecordSchema = CollectionSchema(
  name: r'DailyRecord',
  id: -1016922496390167466,
  properties: {
    r'actOfKindness': PropertySchema(
      id: 0,
      name: r'actOfKindness',
      type: IsarType.bool,
    ),
    r'coldShower': PropertySchema(
      id: 1,
      name: r'coldShower',
      type: IsarType.bool,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dayNumber': PropertySchema(
      id: 3,
      name: r'dayNumber',
      type: IsarType.long,
    ),
    r'imagePath': PropertySchema(
      id: 4,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'phase': PropertySchema(
      id: 6,
      name: r'phase',
      type: IsarType.byte,
      enumMap: _DailyRecordphaseEnumValueMap,
    ),
    r'powerListTask1': PropertySchema(
      id: 7,
      name: r'powerListTask1',
      type: IsarType.bool,
    ),
    r'powerListTask2': PropertySchema(
      id: 8,
      name: r'powerListTask2',
      type: IsarType.bool,
    ),
    r'powerListTask3': PropertySchema(
      id: 9,
      name: r'powerListTask3',
      type: IsarType.bool,
    ),
    r'progressPhoto': PropertySchema(
      id: 10,
      name: r'progressPhoto',
      type: IsarType.bool,
    ),
    r'reading10Pages': PropertySchema(
      id: 11,
      name: r'reading10Pages',
      type: IsarType.bool,
    ),
    r'strictDiet': PropertySchema(
      id: 12,
      name: r'strictDiet',
      type: IsarType.bool,
    ),
    r'talkToStranger': PropertySchema(
      id: 13,
      name: r'talkToStranger',
      type: IsarType.bool,
    ),
    r'visualization': PropertySchema(
      id: 14,
      name: r'visualization',
      type: IsarType.bool,
    ),
    r'waterGallon': PropertySchema(
      id: 15,
      name: r'waterGallon',
      type: IsarType.bool,
    ),
    r'workout1': PropertySchema(
      id: 16,
      name: r'workout1',
      type: IsarType.bool,
    ),
    r'workout2': PropertySchema(
      id: 17,
      name: r'workout2',
      type: IsarType.bool,
    ),
    r'workoutOutside': PropertySchema(
      id: 18,
      name: r'workoutOutside',
      type: IsarType.bool,
    )
  },
  estimateSize: _dailyRecordEstimateSize,
  serialize: _dailyRecordSerialize,
  deserialize: _dailyRecordDeserialize,
  deserializeProp: _dailyRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyRecordGetId,
  getLinks: _dailyRecordGetLinks,
  attach: _dailyRecordAttach,
  version: '3.1.0+1',
);

int _dailyRecordEstimateSize(
  DailyRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.notes.length * 3;
  return bytesCount;
}

void _dailyRecordSerialize(
  DailyRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.actOfKindness);
  writer.writeBool(offsets[1], object.coldShower);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.dayNumber);
  writer.writeString(offsets[4], object.imagePath);
  writer.writeString(offsets[5], object.notes);
  writer.writeByte(offsets[6], object.phase.index);
  writer.writeBool(offsets[7], object.powerListTask1);
  writer.writeBool(offsets[8], object.powerListTask2);
  writer.writeBool(offsets[9], object.powerListTask3);
  writer.writeBool(offsets[10], object.progressPhoto);
  writer.writeBool(offsets[11], object.reading10Pages);
  writer.writeBool(offsets[12], object.strictDiet);
  writer.writeBool(offsets[13], object.talkToStranger);
  writer.writeBool(offsets[14], object.visualization);
  writer.writeBool(offsets[15], object.waterGallon);
  writer.writeBool(offsets[16], object.workout1);
  writer.writeBool(offsets[17], object.workout2);
  writer.writeBool(offsets[18], object.workoutOutside);
}

DailyRecord _dailyRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyRecord();
  object.actOfKindness = reader.readBool(offsets[0]);
  object.coldShower = reader.readBool(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.dayNumber = reader.readLong(offsets[3]);
  object.id = id;
  object.imagePath = reader.readStringOrNull(offsets[4]);
  object.notes = reader.readString(offsets[5]);
  object.phase =
      _DailyRecordphaseValueEnumMap[reader.readByteOrNull(offsets[6])] ??
          ProgramPhase.hard75;
  object.powerListTask1 = reader.readBool(offsets[7]);
  object.powerListTask2 = reader.readBool(offsets[8]);
  object.powerListTask3 = reader.readBool(offsets[9]);
  object.progressPhoto = reader.readBool(offsets[10]);
  object.reading10Pages = reader.readBool(offsets[11]);
  object.strictDiet = reader.readBool(offsets[12]);
  object.talkToStranger = reader.readBool(offsets[13]);
  object.visualization = reader.readBool(offsets[14]);
  object.waterGallon = reader.readBool(offsets[15]);
  object.workout1 = reader.readBool(offsets[16]);
  object.workout2 = reader.readBool(offsets[17]);
  object.workoutOutside = reader.readBool(offsets[18]);
  return object;
}

P _dailyRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_DailyRecordphaseValueEnumMap[reader.readByteOrNull(offset)] ??
          ProgramPhase.hard75) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DailyRecordphaseEnumValueMap = {
  'hard75': 0,
  'phase1': 1,
  'phase2': 2,
  'phase3': 3,
};
const _DailyRecordphaseValueEnumMap = {
  0: ProgramPhase.hard75,
  1: ProgramPhase.phase1,
  2: ProgramPhase.phase2,
  3: ProgramPhase.phase3,
};

Id _dailyRecordGetId(DailyRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyRecordGetLinks(DailyRecord object) {
  return [];
}

void _dailyRecordAttach(
    IsarCollection<dynamic> col, Id id, DailyRecord object) {
  object.id = id;
}

extension DailyRecordByIndex on IsarCollection<DailyRecord> {
  Future<DailyRecord?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyRecord? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyRecord?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyRecord?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyRecord object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyRecord> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyRecordQueryWhereSort
    on QueryBuilder<DailyRecord, DailyRecord, QWhere> {
  QueryBuilder<DailyRecord, DailyRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyRecordQueryWhere
    on QueryBuilder<DailyRecord, DailyRecord, QWhereClause> {
  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyRecordQueryFilter
    on QueryBuilder<DailyRecord, DailyRecord, QFilterCondition> {
  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      actOfKindnessEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actOfKindness',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      coldShowerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coldShower',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      dayNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      dayNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      dayNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      dayNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> phaseEqualTo(
      ProgramPhase value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phase',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      phaseGreaterThan(
    ProgramPhase value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phase',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> phaseLessThan(
    ProgramPhase value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phase',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> phaseBetween(
    ProgramPhase lower,
    ProgramPhase upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      powerListTask1EqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'powerListTask1',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      powerListTask2EqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'powerListTask2',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      powerListTask3EqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'powerListTask3',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      progressPhotoEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progressPhoto',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      reading10PagesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reading10Pages',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      strictDietEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strictDiet',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      talkToStrangerEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'talkToStranger',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      visualizationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visualization',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      waterGallonEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'waterGallon',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> workout1EqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workout1',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition> workout2EqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workout2',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterFilterCondition>
      workoutOutsideEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workoutOutside',
        value: value,
      ));
    });
  }
}

extension DailyRecordQueryObject
    on QueryBuilder<DailyRecord, DailyRecord, QFilterCondition> {}

extension DailyRecordQueryLinks
    on QueryBuilder<DailyRecord, DailyRecord, QFilterCondition> {}

extension DailyRecordQuerySortBy
    on QueryBuilder<DailyRecord, DailyRecord, QSortBy> {
  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByActOfKindness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actOfKindness', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByActOfKindnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actOfKindness', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByColdShower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coldShower', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByColdShowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coldShower', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByPowerListTask1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask1', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByPowerListTask1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask1', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByPowerListTask2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask2', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByPowerListTask2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask2', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByPowerListTask3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask3', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByPowerListTask3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask3', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByProgressPhoto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPhoto', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByProgressPhotoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPhoto', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByReading10Pages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reading10Pages', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByReading10PagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reading10Pages', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByStrictDiet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strictDiet', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByStrictDietDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strictDiet', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByTalkToStranger() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'talkToStranger', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByTalkToStrangerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'talkToStranger', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByVisualization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualization', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByVisualizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualization', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWaterGallon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterGallon', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWaterGallonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterGallon', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWorkout1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout1', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWorkout1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout1', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWorkout2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout2', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWorkout2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout2', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> sortByWorkoutOutside() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutOutside', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      sortByWorkoutOutsideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutOutside', Sort.desc);
    });
  }
}

extension DailyRecordQuerySortThenBy
    on QueryBuilder<DailyRecord, DailyRecord, QSortThenBy> {
  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByActOfKindness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actOfKindness', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByActOfKindnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actOfKindness', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByColdShower() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coldShower', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByColdShowerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coldShower', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByPowerListTask1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask1', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByPowerListTask1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask1', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByPowerListTask2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask2', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByPowerListTask2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask2', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByPowerListTask3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask3', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByPowerListTask3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerListTask3', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByProgressPhoto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPhoto', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByProgressPhotoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPhoto', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByReading10Pages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reading10Pages', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByReading10PagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reading10Pages', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByStrictDiet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strictDiet', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByStrictDietDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strictDiet', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByTalkToStranger() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'talkToStranger', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByTalkToStrangerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'talkToStranger', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByVisualization() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualization', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByVisualizationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visualization', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWaterGallon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterGallon', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWaterGallonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterGallon', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWorkout1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout1', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWorkout1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout1', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWorkout2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout2', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWorkout2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workout2', Sort.desc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy> thenByWorkoutOutside() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutOutside', Sort.asc);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QAfterSortBy>
      thenByWorkoutOutsideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutOutside', Sort.desc);
    });
  }
}

extension DailyRecordQueryWhereDistinct
    on QueryBuilder<DailyRecord, DailyRecord, QDistinct> {
  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByActOfKindness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actOfKindness');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByColdShower() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coldShower');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayNumber');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phase');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByPowerListTask1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'powerListTask1');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByPowerListTask2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'powerListTask2');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByPowerListTask3() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'powerListTask3');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByProgressPhoto() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressPhoto');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByReading10Pages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reading10Pages');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByStrictDiet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strictDiet');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByTalkToStranger() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'talkToStranger');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByVisualization() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visualization');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByWaterGallon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'waterGallon');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByWorkout1() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workout1');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByWorkout2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workout2');
    });
  }

  QueryBuilder<DailyRecord, DailyRecord, QDistinct> distinctByWorkoutOutside() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutOutside');
    });
  }
}

extension DailyRecordQueryProperty
    on QueryBuilder<DailyRecord, DailyRecord, QQueryProperty> {
  QueryBuilder<DailyRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> actOfKindnessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actOfKindness');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> coldShowerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coldShower');
    });
  }

  QueryBuilder<DailyRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyRecord, int, QQueryOperations> dayNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayNumber');
    });
  }

  QueryBuilder<DailyRecord, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<DailyRecord, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<DailyRecord, ProgramPhase, QQueryOperations> phaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phase');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> powerListTask1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'powerListTask1');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> powerListTask2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'powerListTask2');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> powerListTask3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'powerListTask3');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> progressPhotoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressPhoto');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> reading10PagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reading10Pages');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> strictDietProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strictDiet');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> talkToStrangerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'talkToStranger');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> visualizationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visualization');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> waterGallonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterGallon');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> workout1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workout1');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> workout2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workout2');
    });
  }

  QueryBuilder<DailyRecord, bool, QQueryOperations> workoutOutsideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutOutside');
    });
  }
}
