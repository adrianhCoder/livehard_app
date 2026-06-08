// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_state.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProgramStateCollection on Isar {
  IsarCollection<ProgramState> get programStates => this.collection();
}

const ProgramStateSchema = CollectionSchema(
  name: r'ProgramState',
  id: -7812142987325068096,
  properties: {
    r'currentPhase': PropertySchema(
      id: 0,
      name: r'currentPhase',
      type: IsarType.byte,
      enumMap: _ProgramStatecurrentPhaseEnumValueMap,
    ),
    r'currentPhaseStartDate': PropertySchema(
      id: 1,
      name: r'currentPhaseStartDate',
      type: IsarType.dateTime,
    ),
    r'failedAttempts': PropertySchema(
      id: 2,
      name: r'failedAttempts',
      type: IsarType.objectList,
      target: r'FailedAttempt',
    ),
    r'onboardingComplete': PropertySchema(
      id: 3,
      name: r'onboardingComplete',
      type: IsarType.bool,
    ),
    r'phase1CompletedDate': PropertySchema(
      id: 4,
      name: r'phase1CompletedDate',
      type: IsarType.dateTime,
    ),
    r'phase1StartDate': PropertySchema(
      id: 5,
      name: r'phase1StartDate',
      type: IsarType.dateTime,
    ),
    r'phase2StartDate': PropertySchema(
      id: 6,
      name: r'phase2StartDate',
      type: IsarType.dateTime,
    ),
    r'programStartDate': PropertySchema(
      id: 7,
      name: r'programStartDate',
      type: IsarType.dateTime,
    ),
    r'yearFailed': PropertySchema(
      id: 8,
      name: r'yearFailed',
      type: IsarType.bool,
    )
  },
  estimateSize: _programStateEstimateSize,
  serialize: _programStateSerialize,
  deserialize: _programStateDeserialize,
  deserializeProp: _programStateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'FailedAttempt': FailedAttemptSchema},
  getId: _programStateGetId,
  getLinks: _programStateGetLinks,
  attach: _programStateAttach,
  version: '3.1.0+1',
);

int _programStateEstimateSize(
  ProgramState object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.failedAttempts.length * 3;
  {
    final offsets = allOffsets[FailedAttempt]!;
    for (var i = 0; i < object.failedAttempts.length; i++) {
      final value = object.failedAttempts[i];
      bytesCount +=
          FailedAttemptSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _programStateSerialize(
  ProgramState object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.currentPhase.index);
  writer.writeDateTime(offsets[1], object.currentPhaseStartDate);
  writer.writeObjectList<FailedAttempt>(
    offsets[2],
    allOffsets,
    FailedAttemptSchema.serialize,
    object.failedAttempts,
  );
  writer.writeBool(offsets[3], object.onboardingComplete);
  writer.writeDateTime(offsets[4], object.phase1CompletedDate);
  writer.writeDateTime(offsets[5], object.phase1StartDate);
  writer.writeDateTime(offsets[6], object.phase2StartDate);
  writer.writeDateTime(offsets[7], object.programStartDate);
  writer.writeBool(offsets[8], object.yearFailed);
}

ProgramState _programStateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProgramState();
  object.currentPhase = _ProgramStatecurrentPhaseValueEnumMap[
          reader.readByteOrNull(offsets[0])] ??
      ProgramPhase.hard75;
  object.currentPhaseStartDate = reader.readDateTime(offsets[1]);
  object.failedAttempts = reader.readObjectList<FailedAttempt>(
        offsets[2],
        FailedAttemptSchema.deserialize,
        allOffsets,
        FailedAttempt(),
      ) ??
      [];
  object.id = id;
  object.onboardingComplete = reader.readBool(offsets[3]);
  object.phase1CompletedDate = reader.readDateTimeOrNull(offsets[4]);
  object.phase1StartDate = reader.readDateTimeOrNull(offsets[5]);
  object.phase2StartDate = reader.readDateTimeOrNull(offsets[6]);
  object.programStartDate = reader.readDateTime(offsets[7]);
  object.yearFailed = reader.readBool(offsets[8]);
  return object;
}

P _programStateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_ProgramStatecurrentPhaseValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ProgramPhase.hard75) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readObjectList<FailedAttempt>(
            offset,
            FailedAttemptSchema.deserialize,
            allOffsets,
            FailedAttempt(),
          ) ??
          []) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ProgramStatecurrentPhaseEnumValueMap = {
  'hard75': 0,
  'phase1': 1,
  'phase2': 2,
  'phase3': 3,
};
const _ProgramStatecurrentPhaseValueEnumMap = {
  0: ProgramPhase.hard75,
  1: ProgramPhase.phase1,
  2: ProgramPhase.phase2,
  3: ProgramPhase.phase3,
};

Id _programStateGetId(ProgramState object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _programStateGetLinks(ProgramState object) {
  return [];
}

void _programStateAttach(
    IsarCollection<dynamic> col, Id id, ProgramState object) {
  object.id = id;
}

extension ProgramStateQueryWhereSort
    on QueryBuilder<ProgramState, ProgramState, QWhere> {
  QueryBuilder<ProgramState, ProgramState, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProgramStateQueryWhere
    on QueryBuilder<ProgramState, ProgramState, QWhereClause> {
  QueryBuilder<ProgramState, ProgramState, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProgramState, ProgramState, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterWhereClause> idBetween(
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
}

extension ProgramStateQueryFilter
    on QueryBuilder<ProgramState, ProgramState, QFilterCondition> {
  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseEqualTo(ProgramPhase value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPhase',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseGreaterThan(
    ProgramPhase value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPhase',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseLessThan(
    ProgramPhase value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPhase',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseBetween(
    ProgramPhase lower,
    ProgramPhase upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPhase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPhaseStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseStartDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPhaseStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseStartDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPhaseStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      currentPhaseStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPhaseStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'failedAttempts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'failedAttempts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'failedAttempts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'failedAttempts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'failedAttempts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'failedAttempts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      onboardingCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1CompletedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phase1CompletedDate',
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1CompletedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phase1CompletedDate',
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1CompletedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phase1CompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1CompletedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phase1CompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1CompletedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phase1CompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1CompletedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phase1CompletedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1StartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phase1StartDate',
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1StartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phase1StartDate',
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1StartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phase1StartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1StartDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phase1StartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1StartDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phase1StartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase1StartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phase1StartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase2StartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phase2StartDate',
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase2StartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phase2StartDate',
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase2StartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phase2StartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase2StartDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phase2StartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase2StartDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phase2StartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      phase2StartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phase2StartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      programStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'programStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      programStartDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'programStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      programStartDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'programStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      programStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'programStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      yearFailedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'yearFailed',
        value: value,
      ));
    });
  }
}

extension ProgramStateQueryObject
    on QueryBuilder<ProgramState, ProgramState, QFilterCondition> {
  QueryBuilder<ProgramState, ProgramState, QAfterFilterCondition>
      failedAttemptsElement(FilterQuery<FailedAttempt> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'failedAttempts');
    });
  }
}

extension ProgramStateQueryLinks
    on QueryBuilder<ProgramState, ProgramState, QFilterCondition> {}

extension ProgramStateQuerySortBy
    on QueryBuilder<ProgramState, ProgramState, QSortBy> {
  QueryBuilder<ProgramState, ProgramState, QAfterSortBy> sortByCurrentPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhase', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByCurrentPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhase', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByCurrentPhaseStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByCurrentPhaseStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByPhase1CompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1CompletedDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByPhase1CompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1CompletedDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByPhase1StartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1StartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByPhase1StartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1StartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByPhase2StartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase2StartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByPhase2StartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase2StartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByProgramStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'programStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByProgramStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'programStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy> sortByYearFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearFailed', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      sortByYearFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearFailed', Sort.desc);
    });
  }
}

extension ProgramStateQuerySortThenBy
    on QueryBuilder<ProgramState, ProgramState, QSortThenBy> {
  QueryBuilder<ProgramState, ProgramState, QAfterSortBy> thenByCurrentPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhase', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByCurrentPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhase', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByCurrentPhaseStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByCurrentPhaseStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByPhase1CompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1CompletedDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByPhase1CompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1CompletedDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByPhase1StartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1StartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByPhase1StartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase1StartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByPhase2StartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase2StartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByPhase2StartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phase2StartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByProgramStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'programStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByProgramStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'programStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy> thenByYearFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearFailed', Sort.asc);
    });
  }

  QueryBuilder<ProgramState, ProgramState, QAfterSortBy>
      thenByYearFailedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'yearFailed', Sort.desc);
    });
  }
}

extension ProgramStateQueryWhereDistinct
    on QueryBuilder<ProgramState, ProgramState, QDistinct> {
  QueryBuilder<ProgramState, ProgramState, QDistinct> distinctByCurrentPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPhase');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct>
      distinctByCurrentPhaseStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPhaseStartDate');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct>
      distinctByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingComplete');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct>
      distinctByPhase1CompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phase1CompletedDate');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct>
      distinctByPhase1StartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phase1StartDate');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct>
      distinctByPhase2StartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phase2StartDate');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct>
      distinctByProgramStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'programStartDate');
    });
  }

  QueryBuilder<ProgramState, ProgramState, QDistinct> distinctByYearFailed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'yearFailed');
    });
  }
}

extension ProgramStateQueryProperty
    on QueryBuilder<ProgramState, ProgramState, QQueryProperty> {
  QueryBuilder<ProgramState, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProgramState, ProgramPhase, QQueryOperations>
      currentPhaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPhase');
    });
  }

  QueryBuilder<ProgramState, DateTime, QQueryOperations>
      currentPhaseStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPhaseStartDate');
    });
  }

  QueryBuilder<ProgramState, List<FailedAttempt>, QQueryOperations>
      failedAttemptsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedAttempts');
    });
  }

  QueryBuilder<ProgramState, bool, QQueryOperations>
      onboardingCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingComplete');
    });
  }

  QueryBuilder<ProgramState, DateTime?, QQueryOperations>
      phase1CompletedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phase1CompletedDate');
    });
  }

  QueryBuilder<ProgramState, DateTime?, QQueryOperations>
      phase1StartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phase1StartDate');
    });
  }

  QueryBuilder<ProgramState, DateTime?, QQueryOperations>
      phase2StartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phase2StartDate');
    });
  }

  QueryBuilder<ProgramState, DateTime, QQueryOperations>
      programStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'programStartDate');
    });
  }

  QueryBuilder<ProgramState, bool, QQueryOperations> yearFailedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'yearFailed');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const FailedAttemptSchema = Schema(
  name: r'FailedAttempt',
  id: -3919840840809417357,
  properties: {
    r'dayReached': PropertySchema(
      id: 0,
      name: r'dayReached',
      type: IsarType.long,
    ),
    r'failedAt': PropertySchema(
      id: 1,
      name: r'failedAt',
      type: IsarType.dateTime,
    ),
    r'phase': PropertySchema(
      id: 2,
      name: r'phase',
      type: IsarType.byte,
      enumMap: _FailedAttemptphaseEnumValueMap,
    ),
    r'reason': PropertySchema(
      id: 3,
      name: r'reason',
      type: IsarType.string,
    )
  },
  estimateSize: _failedAttemptEstimateSize,
  serialize: _failedAttemptSerialize,
  deserialize: _failedAttemptDeserialize,
  deserializeProp: _failedAttemptDeserializeProp,
);

int _failedAttemptEstimateSize(
  FailedAttempt object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.reason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _failedAttemptSerialize(
  FailedAttempt object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayReached);
  writer.writeDateTime(offsets[1], object.failedAt);
  writer.writeByte(offsets[2], object.phase.index);
  writer.writeString(offsets[3], object.reason);
}

FailedAttempt _failedAttemptDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FailedAttempt();
  object.dayReached = reader.readLong(offsets[0]);
  object.failedAt = reader.readDateTime(offsets[1]);
  object.phase =
      _FailedAttemptphaseValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          ProgramPhase.hard75;
  object.reason = reader.readStringOrNull(offsets[3]);
  return object;
}

P _failedAttemptDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (_FailedAttemptphaseValueEnumMap[reader.readByteOrNull(offset)] ??
          ProgramPhase.hard75) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FailedAttemptphaseEnumValueMap = {
  'hard75': 0,
  'phase1': 1,
  'phase2': 2,
  'phase3': 3,
};
const _FailedAttemptphaseValueEnumMap = {
  0: ProgramPhase.hard75,
  1: ProgramPhase.phase1,
  2: ProgramPhase.phase2,
  3: ProgramPhase.phase3,
};

extension FailedAttemptQueryFilter
    on QueryBuilder<FailedAttempt, FailedAttempt, QFilterCondition> {
  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      dayReachedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayReached',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      dayReachedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayReached',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      dayReachedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayReached',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      dayReachedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayReached',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      failedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      failedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      failedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      failedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      phaseEqualTo(ProgramPhase value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phase',
        value: value,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
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

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      phaseLessThan(
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

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      phaseBetween(
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

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reason',
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reason',
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<FailedAttempt, FailedAttempt, QAfterFilterCondition>
      reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reason',
        value: '',
      ));
    });
  }
}

extension FailedAttemptQueryObject
    on QueryBuilder<FailedAttempt, FailedAttempt, QFilterCondition> {}
