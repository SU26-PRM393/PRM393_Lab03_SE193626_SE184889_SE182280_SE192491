// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'committee.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommitteeCollection on Isar {
  IsarCollection<Committee> get committees => this.collection();
}

const CommitteeSchema = CollectionSchema(
  name: r'Committee',
  id: 6543261920673967059,
  properties: {
    r'centroidLat': PropertySchema(
      id: 0,
      name: r'centroidLat',
      type: IsarType.double,
    ),
    r'centroidLon': PropertySchema(
      id: 1,
      name: r'centroidLon',
      type: IsarType.double,
    ),
    r'dataId': PropertySchema(
      id: 2,
      name: r'dataId',
      type: IsarType.string,
    ),
    r'embedText': PropertySchema(
      id: 3,
      name: r'embedText',
      type: IsarType.string,
    ),
    r'geomType': PropertySchema(
      id: 4,
      name: r'geomType',
      type: IsarType.string,
    ),
    r'keywords': PropertySchema(
      id: 5,
      name: r'keywords',
      type: IsarType.stringList,
    ),
    r'macroRegion': PropertySchema(
      id: 6,
      name: r'macroRegion',
      type: IsarType.string,
    ),
    r'parentMa': PropertySchema(
      id: 7,
      name: r'parentMa',
      type: IsarType.string,
    ),
    r'parentTen': PropertySchema(
      id: 8,
      name: r'parentTen',
      type: IsarType.string,
    ),
    r'ten': PropertySchema(
      id: 9,
      name: r'ten',
      type: IsarType.string,
    ),
    r'tenShort': PropertySchema(
      id: 10,
      name: r'tenShort',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 11,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _committeeEstimateSize,
  serialize: _committeeSerialize,
  deserialize: _committeeDeserialize,
  deserializeProp: _committeeDeserializeProp,
  idName: r'id',
  indexes: {
    r'dataId': IndexSchema(
      id: -3108753711740298699,
      name: r'dataId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dataId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'ten': IndexSchema(
      id: 7052888800916339221,
      name: r'ten',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ten',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'parentMa': IndexSchema(
      id: -905506884225154041,
      name: r'parentMa',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'parentMa',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'macroRegion': IndexSchema(
      id: 8517184331073014014,
      name: r'macroRegion',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'macroRegion',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _committeeGetId,
  getLinks: _committeeGetLinks,
  attach: _committeeAttach,
  version: '3.1.0+1',
);

int _committeeEstimateSize(
  Committee object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dataId.length * 3;
  {
    final value = object.embedText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.geomType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.keywords;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.macroRegion;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.parentMa;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.parentTen;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ten.length * 3;
  {
    final value = object.tenShort;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _committeeSerialize(
  Committee object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.centroidLat);
  writer.writeDouble(offsets[1], object.centroidLon);
  writer.writeString(offsets[2], object.dataId);
  writer.writeString(offsets[3], object.embedText);
  writer.writeString(offsets[4], object.geomType);
  writer.writeStringList(offsets[5], object.keywords);
  writer.writeString(offsets[6], object.macroRegion);
  writer.writeString(offsets[7], object.parentMa);
  writer.writeString(offsets[8], object.parentTen);
  writer.writeString(offsets[9], object.ten);
  writer.writeString(offsets[10], object.tenShort);
  writer.writeString(offsets[11], object.type);
}

Committee _committeeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Committee();
  object.centroidLat = reader.readDoubleOrNull(offsets[0]);
  object.centroidLon = reader.readDoubleOrNull(offsets[1]);
  object.dataId = reader.readString(offsets[2]);
  object.embedText = reader.readStringOrNull(offsets[3]);
  object.geomType = reader.readStringOrNull(offsets[4]);
  object.id = id;
  object.keywords = reader.readStringList(offsets[5]);
  object.macroRegion = reader.readStringOrNull(offsets[6]);
  object.parentMa = reader.readStringOrNull(offsets[7]);
  object.parentTen = reader.readStringOrNull(offsets[8]);
  object.ten = reader.readString(offsets[9]);
  object.tenShort = reader.readStringOrNull(offsets[10]);
  object.type = reader.readStringOrNull(offsets[11]);
  return object;
}

P _committeeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _committeeGetId(Committee object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _committeeGetLinks(Committee object) {
  return [];
}

void _committeeAttach(IsarCollection<dynamic> col, Id id, Committee object) {
  object.id = id;
}

extension CommitteeByIndex on IsarCollection<Committee> {
  Future<Committee?> getByDataId(String dataId) {
    return getByIndex(r'dataId', [dataId]);
  }

  Committee? getByDataIdSync(String dataId) {
    return getByIndexSync(r'dataId', [dataId]);
  }

  Future<bool> deleteByDataId(String dataId) {
    return deleteByIndex(r'dataId', [dataId]);
  }

  bool deleteByDataIdSync(String dataId) {
    return deleteByIndexSync(r'dataId', [dataId]);
  }

  Future<List<Committee?>> getAllByDataId(List<String> dataIdValues) {
    final values = dataIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'dataId', values);
  }

  List<Committee?> getAllByDataIdSync(List<String> dataIdValues) {
    final values = dataIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dataId', values);
  }

  Future<int> deleteAllByDataId(List<String> dataIdValues) {
    final values = dataIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dataId', values);
  }

  int deleteAllByDataIdSync(List<String> dataIdValues) {
    final values = dataIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dataId', values);
  }

  Future<Id> putByDataId(Committee object) {
    return putByIndex(r'dataId', object);
  }

  Id putByDataIdSync(Committee object, {bool saveLinks = true}) {
    return putByIndexSync(r'dataId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDataId(List<Committee> objects) {
    return putAllByIndex(r'dataId', objects);
  }

  List<Id> putAllByDataIdSync(List<Committee> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'dataId', objects, saveLinks: saveLinks);
  }
}

extension CommitteeQueryWhereSort
    on QueryBuilder<Committee, Committee, QWhere> {
  QueryBuilder<Committee, Committee, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommitteeQueryWhere
    on QueryBuilder<Committee, Committee, QWhereClause> {
  QueryBuilder<Committee, Committee, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Committee, Committee, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> idBetween(
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

  QueryBuilder<Committee, Committee, QAfterWhereClause> dataIdEqualTo(
      String dataId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dataId',
        value: [dataId],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> dataIdNotEqualTo(
      String dataId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataId',
              lower: [],
              upper: [dataId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataId',
              lower: [dataId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataId',
              lower: [dataId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dataId',
              lower: [],
              upper: [dataId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> tenEqualTo(String ten) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ten',
        value: [ten],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> tenNotEqualTo(
      String ten) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ten',
              lower: [],
              upper: [ten],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ten',
              lower: [ten],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ten',
              lower: [ten],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ten',
              lower: [],
              upper: [ten],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> parentMaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentMa',
        value: [null],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> parentMaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentMa',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> parentMaEqualTo(
      String? parentMa) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentMa',
        value: [parentMa],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> parentMaNotEqualTo(
      String? parentMa) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentMa',
              lower: [],
              upper: [parentMa],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentMa',
              lower: [parentMa],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentMa',
              lower: [parentMa],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'parentMa',
              lower: [],
              upper: [parentMa],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> macroRegionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'macroRegion',
        value: [null],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> macroRegionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'macroRegion',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> macroRegionEqualTo(
      String? macroRegion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'macroRegion',
        value: [macroRegion],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> macroRegionNotEqualTo(
      String? macroRegion) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'macroRegion',
              lower: [],
              upper: [macroRegion],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'macroRegion',
              lower: [macroRegion],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'macroRegion',
              lower: [macroRegion],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'macroRegion',
              lower: [],
              upper: [macroRegion],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CommitteeQueryFilter
    on QueryBuilder<Committee, Committee, QFilterCondition> {
  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      centroidLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centroidLat',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      centroidLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centroidLat',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> centroidLatEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centroidLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      centroidLatGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centroidLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> centroidLatLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centroidLat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> centroidLatBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centroidLat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      centroidLonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centroidLon',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      centroidLonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centroidLon',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> centroidLonEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'centroidLon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      centroidLonGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'centroidLon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> centroidLonLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'centroidLon',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> centroidLonBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'centroidLon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataId',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> dataIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataId',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'embedText',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      embedTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'embedText',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'embedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      embedTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'embedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'embedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'embedText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'embedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'embedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'embedText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'embedText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> embedTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'embedText',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      embedTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'embedText',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geomType',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      geomTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geomType',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geomType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'geomType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'geomType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'geomType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'geomType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'geomType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'geomType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'geomType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> geomTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geomType',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      geomTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geomType',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> keywordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'keywords',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'keywords',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'keywords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keywords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keywords',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keywords',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keywords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> keywordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keywords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keywords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keywords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keywords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      keywordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'keywords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      macroRegionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'macroRegion',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      macroRegionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'macroRegion',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> macroRegionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macroRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      macroRegionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'macroRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> macroRegionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'macroRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> macroRegionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'macroRegion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      macroRegionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'macroRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> macroRegionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'macroRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> macroRegionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'macroRegion',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> macroRegionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'macroRegion',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      macroRegionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macroRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      macroRegionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'macroRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentMa',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentMaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentMa',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentMa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentMa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentMa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentMa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentMa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentMa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentMa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentMa',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentMaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentMa',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentMaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentMa',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTen',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTen',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentTen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentTen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentTen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentTen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentTen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentTen',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentTen',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTen',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTen',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ten',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ten',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ten',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ten',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ten',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ten',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ten',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ten',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ten',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ten',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tenShort',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      tenShortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tenShort',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tenShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tenShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tenShort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tenShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tenShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tenShort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tenShort',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> tenShortIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenShort',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      tenShortIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenShort',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension CommitteeQueryObject
    on QueryBuilder<Committee, Committee, QFilterCondition> {}

extension CommitteeQueryLinks
    on QueryBuilder<Committee, Committee, QFilterCondition> {}

extension CommitteeQuerySortBy on QueryBuilder<Committee, Committee, QSortBy> {
  QueryBuilder<Committee, Committee, QAfterSortBy> sortByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByCentroidLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByCentroidLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDataId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDataIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByEmbedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByEmbedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByGeomType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByGeomTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByMacroRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByMacroRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByParentMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByParentMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByParentTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByParentTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByTenShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByTenShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CommitteeQuerySortThenBy
    on QueryBuilder<Committee, Committee, QSortThenBy> {
  QueryBuilder<Committee, Committee, QAfterSortBy> thenByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByCentroidLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByCentroidLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDataId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDataIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByEmbedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByEmbedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByGeomType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByGeomTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByMacroRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByMacroRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByParentMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByParentMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByParentTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByParentTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByTenShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByTenShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CommitteeQueryWhereDistinct
    on QueryBuilder<Committee, Committee, QDistinct> {
  QueryBuilder<Committee, Committee, QDistinct> distinctByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidLat');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidLon');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByDataId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByEmbedText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'embedText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByGeomType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geomType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByKeywords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keywords');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByMacroRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macroRegion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByParentMa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentMa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByParentTen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByTen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ten', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByTenShort(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenShort', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension CommitteeQueryProperty
    on QueryBuilder<Committee, Committee, QQueryProperty> {
  QueryBuilder<Committee, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Committee, double?, QQueryOperations> centroidLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidLat');
    });
  }

  QueryBuilder<Committee, double?, QQueryOperations> centroidLonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidLon');
    });
  }

  QueryBuilder<Committee, String, QQueryOperations> dataIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataId');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> embedTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'embedText');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> geomTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geomType');
    });
  }

  QueryBuilder<Committee, List<String>?, QQueryOperations> keywordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keywords');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> macroRegionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macroRegion');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> parentMaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentMa');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> parentTenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTen');
    });
  }

  QueryBuilder<Committee, String, QQueryOperations> tenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ten');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> tenShortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenShort');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
