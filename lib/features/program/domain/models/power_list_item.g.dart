// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_list_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPowerListItemCollection on Isar {
  IsarCollection<PowerListItem> get powerListItems => this.collection();
}

const PowerListItemSchema = CollectionSchema(
  name: r'PowerListItem',
  id: 1503591527872610881,
  properties: {
    r'active': PropertySchema(
      id: 0,
      name: r'active',
      type: IsarType.bool,
    ),
    r'retiredDay': PropertySchema(
      id: 1,
      name: r'retiredDay',
      type: IsarType.dateTime,
    ),
    r'slot': PropertySchema(
      id: 2,
      name: r'slot',
      type: IsarType.long,
    ),
    r'startDay': PropertySchema(
      id: 3,
      name: r'startDay',
      type: IsarType.dateTime,
    ),
    r'text': PropertySchema(
      id: 4,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _powerListItemEstimateSize,
  serialize: _powerListItemSerialize,
  deserialize: _powerListItemDeserialize,
  deserializeProp: _powerListItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'slot': IndexSchema(
      id: 686993539073000551,
      name: r'slot',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slot',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'active': IndexSchema(
      id: -7515327150349743717,
      name: r'active',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'active',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _powerListItemGetId,
  getLinks: _powerListItemGetLinks,
  attach: _powerListItemAttach,
  version: '3.1.0+1',
);

int _powerListItemEstimateSize(
  PowerListItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _powerListItemSerialize(
  PowerListItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeDateTime(offsets[1], object.retiredDay);
  writer.writeLong(offsets[2], object.slot);
  writer.writeDateTime(offsets[3], object.startDay);
  writer.writeString(offsets[4], object.text);
}

PowerListItem _powerListItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PowerListItem();
  object.active = reader.readBool(offsets[0]);
  object.id = id;
  object.retiredDay = reader.readDateTimeOrNull(offsets[1]);
  object.slot = reader.readLong(offsets[2]);
  object.startDay = reader.readDateTime(offsets[3]);
  object.text = reader.readString(offsets[4]);
  return object;
}

P _powerListItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _powerListItemGetId(PowerListItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _powerListItemGetLinks(PowerListItem object) {
  return [];
}

void _powerListItemAttach(
    IsarCollection<dynamic> col, Id id, PowerListItem object) {
  object.id = id;
}

extension PowerListItemQueryWhereSort
    on QueryBuilder<PowerListItem, PowerListItem, QWhere> {
  QueryBuilder<PowerListItem, PowerListItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhere> anySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'slot'),
      );
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhere> anyActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'active'),
      );
    });
  }
}

extension PowerListItemQueryWhere
    on QueryBuilder<PowerListItem, PowerListItem, QWhereClause> {
  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> slotEqualTo(
      int slot) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slot',
        value: [slot],
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> slotNotEqualTo(
      int slot) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slot',
              lower: [],
              upper: [slot],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slot',
              lower: [slot],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slot',
              lower: [slot],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slot',
              lower: [],
              upper: [slot],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> slotGreaterThan(
    int slot, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'slot',
        lower: [slot],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> slotLessThan(
    int slot, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'slot',
        lower: [],
        upper: [slot],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> slotBetween(
    int lowerSlot,
    int upperSlot, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'slot',
        lower: [lowerSlot],
        includeLower: includeLower,
        upper: [upperSlot],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause> activeEqualTo(
      bool active) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'active',
        value: [active],
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterWhereClause>
      activeNotEqualTo(bool active) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'active',
              lower: [],
              upper: [active],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'active',
              lower: [active],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'active',
              lower: [active],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'active',
              lower: [],
              upper: [active],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PowerListItemQueryFilter
    on QueryBuilder<PowerListItem, PowerListItem, QFilterCondition> {
  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      activeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      retiredDayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'retiredDay',
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      retiredDayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'retiredDay',
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      retiredDayEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retiredDay',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      retiredDayGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retiredDay',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      retiredDayLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retiredDay',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      retiredDayBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retiredDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> slotEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      slotGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      slotLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> slotBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      startDayEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDay',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      startDayGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDay',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      startDayLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDay',
        value: value,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      startDayBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension PowerListItemQueryObject
    on QueryBuilder<PowerListItem, PowerListItem, QFilterCondition> {}

extension PowerListItemQueryLinks
    on QueryBuilder<PowerListItem, PowerListItem, QFilterCondition> {}

extension PowerListItemQuerySortBy
    on QueryBuilder<PowerListItem, PowerListItem, QSortBy> {
  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortByRetiredDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiredDay', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy>
      sortByRetiredDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiredDay', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortBySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortBySlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortByStartDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDay', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy>
      sortByStartDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDay', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension PowerListItemQuerySortThenBy
    on QueryBuilder<PowerListItem, PowerListItem, QSortThenBy> {
  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByRetiredDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiredDay', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy>
      thenByRetiredDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retiredDay', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenBySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenBySlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByStartDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDay', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy>
      thenByStartDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDay', Sort.desc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension PowerListItemQueryWhereDistinct
    on QueryBuilder<PowerListItem, PowerListItem, QDistinct> {
  QueryBuilder<PowerListItem, PowerListItem, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QDistinct> distinctByRetiredDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retiredDay');
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QDistinct> distinctBySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot');
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QDistinct> distinctByStartDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDay');
    });
  }

  QueryBuilder<PowerListItem, PowerListItem, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension PowerListItemQueryProperty
    on QueryBuilder<PowerListItem, PowerListItem, QQueryProperty> {
  QueryBuilder<PowerListItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PowerListItem, bool, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<PowerListItem, DateTime?, QQueryOperations>
      retiredDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retiredDay');
    });
  }

  QueryBuilder<PowerListItem, int, QQueryOperations> slotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot');
    });
  }

  QueryBuilder<PowerListItem, DateTime, QQueryOperations> startDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDay');
    });
  }

  QueryBuilder<PowerListItem, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}
