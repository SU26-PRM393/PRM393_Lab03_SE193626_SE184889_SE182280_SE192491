// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'province.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProvinceCollection on Isar {
  IsarCollection<Province> get provinces => this.collection();
}

const ProvinceSchema = CollectionSchema(
  name: r'Province',
  id: -1130278499051240386,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'areaKm2': PropertySchema(
      id: 1,
      name: r'areaKm2',
      type: IsarType.double,
    ),
    r'bbox': PropertySchema(
      id: 2,
      name: r'bbox',
      type: IsarType.doubleList,
    ),
    r'capital': PropertySchema(
      id: 3,
      name: r'capital',
      type: IsarType.string,
    ),
    r'centroidLat': PropertySchema(
      id: 4,
      name: r'centroidLat',
      type: IsarType.double,
    ),
    r'centroidLon': PropertySchema(
      id: 5,
      name: r'centroidLon',
      type: IsarType.double,
    ),
    r'dataId': PropertySchema(
      id: 6,
      name: r'dataId',
      type: IsarType.string,
    ),
    r'decree': PropertySchema(
      id: 7,
      name: r'decree',
      type: IsarType.string,
    ),
    r'decreeUrl': PropertySchema(
      id: 8,
      name: r'decreeUrl',
      type: IsarType.string,
    ),
    r'density': PropertySchema(
      id: 9,
      name: r'density',
      type: IsarType.double,
    ),
    r'embedText': PropertySchema(
      id: 10,
      name: r'embedText',
      type: IsarType.string,
    ),
    r'geomType': PropertySchema(
      id: 11,
      name: r'geomType',
      type: IsarType.string,
    ),
    r'keywords': PropertySchema(
      id: 12,
      name: r'keywords',
      type: IsarType.stringList,
    ),
    r'ma': PropertySchema(
      id: 13,
      name: r'ma',
      type: IsarType.string,
    ),
    r'macroRegion': PropertySchema(
      id: 14,
      name: r'macroRegion',
      type: IsarType.string,
    ),
    r'nVertices': PropertySchema(
      id: 15,
      name: r'nVertices',
      type: IsarType.long,
    ),
    r'parentMa': PropertySchema(
      id: 16,
      name: r'parentMa',
      type: IsarType.string,
    ),
    r'parentTen': PropertySchema(
      id: 17,
      name: r'parentTen',
      type: IsarType.string,
    ),
    r'parentTenXa': PropertySchema(
      id: 18,
      name: r'parentTenXa',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 19,
      name: r'phone',
      type: IsarType.string,
    ),
    r'population': PropertySchema(
      id: 20,
      name: r'population',
      type: IsarType.long,
    ),
    r'predecessors': PropertySchema(
      id: 21,
      name: r'predecessors',
      type: IsarType.string,
    ),
    r'predecessorsList': PropertySchema(
      id: 22,
      name: r'predecessorsList',
      type: IsarType.stringList,
    ),
    r'ten': PropertySchema(
      id: 23,
      name: r'ten',
      type: IsarType.string,
    ),
    r'tenShort': PropertySchema(
      id: 24,
      name: r'tenShort',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 25,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _provinceEstimateSize,
  serialize: _provinceSerialize,
  deserialize: _provinceDeserialize,
  deserializeProp: _provinceDeserializeProp,
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
    r'ma': IndexSchema(
      id: -4596340741078201700,
      name: r'ma',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ma',
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
  getId: _provinceGetId,
  getLinks: _provinceGetLinks,
  attach: _provinceAttach,
  version: '3.1.0+1',
);

int _provinceEstimateSize(
  Province object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.address;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bbox;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.capital;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.dataId.length * 3;
  {
    final value = object.decree;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.decreeUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
  bytesCount += 3 + object.ma.length * 3;
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
  {
    final value = object.parentTenXa;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.predecessors;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.predecessorsList;
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

void _provinceSerialize(
  Province object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeDouble(offsets[1], object.areaKm2);
  writer.writeDoubleList(offsets[2], object.bbox);
  writer.writeString(offsets[3], object.capital);
  writer.writeDouble(offsets[4], object.centroidLat);
  writer.writeDouble(offsets[5], object.centroidLon);
  writer.writeString(offsets[6], object.dataId);
  writer.writeString(offsets[7], object.decree);
  writer.writeString(offsets[8], object.decreeUrl);
  writer.writeDouble(offsets[9], object.density);
  writer.writeString(offsets[10], object.embedText);
  writer.writeString(offsets[11], object.geomType);
  writer.writeStringList(offsets[12], object.keywords);
  writer.writeString(offsets[13], object.ma);
  writer.writeString(offsets[14], object.macroRegion);
  writer.writeLong(offsets[15], object.nVertices);
  writer.writeString(offsets[16], object.parentMa);
  writer.writeString(offsets[17], object.parentTen);
  writer.writeString(offsets[18], object.parentTenXa);
  writer.writeString(offsets[19], object.phone);
  writer.writeLong(offsets[20], object.population);
  writer.writeString(offsets[21], object.predecessors);
  writer.writeStringList(offsets[22], object.predecessorsList);
  writer.writeString(offsets[23], object.ten);
  writer.writeString(offsets[24], object.tenShort);
  writer.writeString(offsets[25], object.type);
}

Province _provinceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Province();
  object.address = reader.readStringOrNull(offsets[0]);
  object.areaKm2 = reader.readDoubleOrNull(offsets[1]);
  object.bbox = reader.readDoubleList(offsets[2]);
  object.capital = reader.readStringOrNull(offsets[3]);
  object.centroidLat = reader.readDoubleOrNull(offsets[4]);
  object.centroidLon = reader.readDoubleOrNull(offsets[5]);
  object.dataId = reader.readString(offsets[6]);
  object.decree = reader.readStringOrNull(offsets[7]);
  object.decreeUrl = reader.readStringOrNull(offsets[8]);
  object.density = reader.readDoubleOrNull(offsets[9]);
  object.embedText = reader.readStringOrNull(offsets[10]);
  object.geomType = reader.readStringOrNull(offsets[11]);
  object.id = id;
  object.keywords = reader.readStringList(offsets[12]);
  object.ma = reader.readString(offsets[13]);
  object.macroRegion = reader.readStringOrNull(offsets[14]);
  object.nVertices = reader.readLongOrNull(offsets[15]);
  object.parentMa = reader.readStringOrNull(offsets[16]);
  object.parentTen = reader.readStringOrNull(offsets[17]);
  object.parentTenXa = reader.readStringOrNull(offsets[18]);
  object.phone = reader.readStringOrNull(offsets[19]);
  object.population = reader.readLongOrNull(offsets[20]);
  object.predecessors = reader.readStringOrNull(offsets[21]);
  object.predecessorsList = reader.readStringList(offsets[22]);
  object.ten = reader.readString(offsets[23]);
  object.tenShort = reader.readStringOrNull(offsets[24]);
  object.type = reader.readStringOrNull(offsets[25]);
  return object;
}

P _provinceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringList(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readLongOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringList(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _provinceGetId(Province object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _provinceGetLinks(Province object) {
  return [];
}

void _provinceAttach(IsarCollection<dynamic> col, Id id, Province object) {
  object.id = id;
}

extension ProvinceByIndex on IsarCollection<Province> {
  Future<Province?> getByDataId(String dataId) {
    return getByIndex(r'dataId', [dataId]);
  }

  Province? getByDataIdSync(String dataId) {
    return getByIndexSync(r'dataId', [dataId]);
  }

  Future<bool> deleteByDataId(String dataId) {
    return deleteByIndex(r'dataId', [dataId]);
  }

  bool deleteByDataIdSync(String dataId) {
    return deleteByIndexSync(r'dataId', [dataId]);
  }

  Future<List<Province?>> getAllByDataId(List<String> dataIdValues) {
    final values = dataIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'dataId', values);
  }

  List<Province?> getAllByDataIdSync(List<String> dataIdValues) {
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

  Future<Id> putByDataId(Province object) {
    return putByIndex(r'dataId', object);
  }

  Id putByDataIdSync(Province object, {bool saveLinks = true}) {
    return putByIndexSync(r'dataId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDataId(List<Province> objects) {
    return putAllByIndex(r'dataId', objects);
  }

  List<Id> putAllByDataIdSync(List<Province> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'dataId', objects, saveLinks: saveLinks);
  }
}

extension ProvinceQueryWhereSort on QueryBuilder<Province, Province, QWhere> {
  QueryBuilder<Province, Province, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProvinceQueryWhere on QueryBuilder<Province, Province, QWhereClause> {
  QueryBuilder<Province, Province, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Province, Province, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> idBetween(
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

  QueryBuilder<Province, Province, QAfterWhereClause> dataIdEqualTo(
      String dataId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dataId',
        value: [dataId],
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> dataIdNotEqualTo(
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

  QueryBuilder<Province, Province, QAfterWhereClause> maEqualTo(String ma) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ma',
        value: [ma],
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> maNotEqualTo(String ma) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ma',
              lower: [],
              upper: [ma],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ma',
              lower: [ma],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ma',
              lower: [ma],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ma',
              lower: [],
              upper: [ma],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> tenEqualTo(String ten) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ten',
        value: [ten],
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> tenNotEqualTo(
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

  QueryBuilder<Province, Province, QAfterWhereClause> macroRegionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'macroRegion',
        value: [null],
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> macroRegionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'macroRegion',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> macroRegionEqualTo(
      String? macroRegion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'macroRegion',
        value: [macroRegion],
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterWhereClause> macroRegionNotEqualTo(
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

extension ProvinceQueryFilter
    on QueryBuilder<Province, Province, QFilterCondition> {
  QueryBuilder<Province, Province, QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> areaKm2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaKm2',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> areaKm2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaKm2',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> areaKm2EqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaKm2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> areaKm2GreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'areaKm2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> areaKm2LessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'areaKm2',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> areaKm2Between(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'areaKm2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bbox',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bbox',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bbox',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      bboxElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bbox',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bbox',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bbox',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bbox',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bbox',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bbox',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bbox',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bbox',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> bboxLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bbox',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'capital',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'capital',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capital',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'capital',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'capital',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'capital',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'capital',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'capital',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'capital',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'capital',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capital',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> capitalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capital',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centroidLat',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      centroidLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centroidLat',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLatEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLatLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLatBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centroidLon',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      centroidLonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centroidLon',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLonEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLonLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> centroidLonBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataId',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> dataIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataId',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decree',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decree',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decree',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decree',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decree',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decree',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decreeUrl',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decreeUrl',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decreeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'decreeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'decreeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'decreeUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'decreeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'decreeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'decreeUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'decreeUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> decreeUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decreeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      decreeUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decreeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> densityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'density',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> densityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'density',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> densityEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'density',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> densityGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'density',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> densityLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'density',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> densityBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'density',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'embedText',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'embedText',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> embedTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'embedText',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      embedTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'embedText',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geomType',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geomType',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geomType',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> geomTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geomType',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> keywordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'keywords',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> keywordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'keywords',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
      keywordsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      keywordsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keywords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      keywordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keywords',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      keywordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keywords',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> keywordsLengthEqualTo(
      int length) {
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

  QueryBuilder<Province, Province, QAfterFilterCondition> keywordsIsEmpty() {
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

  QueryBuilder<Province, Province, QAfterFilterCondition> keywordsIsNotEmpty() {
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition> keywordsLengthBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> maEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ma',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ma',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ma',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> maIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ma',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'macroRegion',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      macroRegionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'macroRegion',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition>
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> macroRegionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macroRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      macroRegionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'macroRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> nVerticesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nVertices',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> nVerticesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nVertices',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> nVerticesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nVertices',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> nVerticesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nVertices',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> nVerticesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nVertices',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> nVerticesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nVertices',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentMa',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentMa',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentMa',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentMaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentMa',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTen',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTen',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTen',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      parentTenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTen',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTenXa',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      parentTenXaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTenXa',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTenXa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      parentTenXaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentTenXa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentTenXa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentTenXa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentTenXa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentTenXa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentTenXa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentTenXa',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> parentTenXaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTenXa',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      parentTenXaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTenXa',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> populationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'population',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      populationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'population',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> populationEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'population',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> populationGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'population',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> populationLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'population',
        value: value,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> populationBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'population',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predecessors',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predecessors',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predecessors',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> predecessorsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'predecessors',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessors',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predecessors',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predecessorsList',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predecessorsList',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessorsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predecessorsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predecessorsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predecessorsList',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'predecessorsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'predecessorsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'predecessorsList',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'predecessorsList',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessorsList',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predecessorsList',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'predecessorsList',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'predecessorsList',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'predecessorsList',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'predecessorsList',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'predecessorsList',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition>
      predecessorsListLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'predecessorsList',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> tenEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ten',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> tenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ten',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tenShort',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tenShort',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenShort',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> tenShortIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenShort',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeContains(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeMatches(
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

  QueryBuilder<Province, Province, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Province, Province, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension ProvinceQueryObject
    on QueryBuilder<Province, Province, QFilterCondition> {}

extension ProvinceQueryLinks
    on QueryBuilder<Province, Province, QFilterCondition> {}

extension ProvinceQuerySortBy on QueryBuilder<Province, Province, QSortBy> {
  QueryBuilder<Province, Province, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByAreaKm2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByCapital() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByCapitalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByCentroidLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByCentroidLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDataId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDataIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDecree() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDecreeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDecreeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDecreeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByEmbedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByEmbedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByGeomType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByGeomTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByMacroRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByMacroRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByNVerticesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByParentMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByParentMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByParentTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByParentTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByParentTenXa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByParentTenXaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByPopulationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByTenShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByTenShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ProvinceQuerySortThenBy
    on QueryBuilder<Province, Province, QSortThenBy> {
  QueryBuilder<Province, Province, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByAreaKm2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByCapital() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByCapitalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByCentroidLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByCentroidLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDataId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDataIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDecree() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDecreeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDecreeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDecreeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByEmbedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByEmbedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByGeomType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByGeomTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByMacroRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByMacroRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByNVerticesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByParentMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByParentMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByParentTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByParentTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByParentTenXa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByParentTenXaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByPopulationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByTenShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByTenShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.desc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Province, Province, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ProvinceQueryWhereDistinct
    on QueryBuilder<Province, Province, QDistinct> {
  QueryBuilder<Province, Province, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaKm2');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByBbox() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bbox');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByCapital(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capital', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidLat');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidLon');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByDataId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByDecree(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decree', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByDecreeUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decreeUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'density');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByEmbedText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'embedText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByGeomType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geomType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByKeywords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keywords');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByMa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ma', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByMacroRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macroRegion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nVertices');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByParentMa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentMa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByParentTen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByParentTenXa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTenXa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'population');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByPredecessors(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predecessors', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByPredecessorsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predecessorsList');
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByTen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ten', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByTenShort(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenShort', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Province, Province, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension ProvinceQueryProperty
    on QueryBuilder<Province, Province, QQueryProperty> {
  QueryBuilder<Province, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Province, double?, QQueryOperations> areaKm2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaKm2');
    });
  }

  QueryBuilder<Province, List<double>?, QQueryOperations> bboxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bbox');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> capitalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capital');
    });
  }

  QueryBuilder<Province, double?, QQueryOperations> centroidLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidLat');
    });
  }

  QueryBuilder<Province, double?, QQueryOperations> centroidLonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidLon');
    });
  }

  QueryBuilder<Province, String, QQueryOperations> dataIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataId');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> decreeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decree');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> decreeUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decreeUrl');
    });
  }

  QueryBuilder<Province, double?, QQueryOperations> densityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'density');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> embedTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'embedText');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> geomTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geomType');
    });
  }

  QueryBuilder<Province, List<String>?, QQueryOperations> keywordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keywords');
    });
  }

  QueryBuilder<Province, String, QQueryOperations> maProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ma');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> macroRegionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macroRegion');
    });
  }

  QueryBuilder<Province, int?, QQueryOperations> nVerticesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nVertices');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> parentMaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentMa');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> parentTenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTen');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> parentTenXaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTenXa');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<Province, int?, QQueryOperations> populationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'population');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> predecessorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predecessors');
    });
  }

  QueryBuilder<Province, List<String>?, QQueryOperations>
      predecessorsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predecessorsList');
    });
  }

  QueryBuilder<Province, String, QQueryOperations> tenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ten');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> tenShortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenShort');
    });
  }

  QueryBuilder<Province, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
