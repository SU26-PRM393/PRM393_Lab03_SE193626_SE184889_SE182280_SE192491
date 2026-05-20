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
    r'nPredecessors': PropertySchema(
      id: 15,
      name: r'nPredecessors',
      type: IsarType.long,
    ),
    r'nVertices': PropertySchema(
      id: 16,
      name: r'nVertices',
      type: IsarType.long,
    ),
    r'parentMa': PropertySchema(
      id: 17,
      name: r'parentMa',
      type: IsarType.string,
    ),
    r'parentTen': PropertySchema(
      id: 18,
      name: r'parentTen',
      type: IsarType.string,
    ),
    r'parentTenXa': PropertySchema(
      id: 19,
      name: r'parentTenXa',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 20,
      name: r'phone',
      type: IsarType.string,
    ),
    r'population': PropertySchema(
      id: 21,
      name: r'population',
      type: IsarType.long,
    ),
    r'predecessors': PropertySchema(
      id: 22,
      name: r'predecessors',
      type: IsarType.string,
    ),
    r'predecessorsList': PropertySchema(
      id: 23,
      name: r'predecessorsList',
      type: IsarType.stringList,
    ),
    r'ten': PropertySchema(
      id: 24,
      name: r'ten',
      type: IsarType.string,
    ),
    r'tenShort': PropertySchema(
      id: 25,
      name: r'tenShort',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 26,
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
  {
    final value = object.ma;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
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

void _committeeSerialize(
  Committee object,
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
  writer.writeLong(offsets[15], object.nPredecessors);
  writer.writeLong(offsets[16], object.nVertices);
  writer.writeString(offsets[17], object.parentMa);
  writer.writeString(offsets[18], object.parentTen);
  writer.writeString(offsets[19], object.parentTenXa);
  writer.writeString(offsets[20], object.phone);
  writer.writeLong(offsets[21], object.population);
  writer.writeString(offsets[22], object.predecessors);
  writer.writeStringList(offsets[23], object.predecessorsList);
  writer.writeString(offsets[24], object.ten);
  writer.writeString(offsets[25], object.tenShort);
  writer.writeString(offsets[26], object.type);
}

Committee _committeeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Committee();
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
  object.ma = reader.readStringOrNull(offsets[13]);
  object.macroRegion = reader.readStringOrNull(offsets[14]);
  object.nPredecessors = reader.readLongOrNull(offsets[15]);
  object.nVertices = reader.readLongOrNull(offsets[16]);
  object.parentMa = reader.readStringOrNull(offsets[17]);
  object.parentTen = reader.readStringOrNull(offsets[18]);
  object.parentTenXa = reader.readStringOrNull(offsets[19]);
  object.phone = reader.readStringOrNull(offsets[20]);
  object.population = reader.readLongOrNull(offsets[21]);
  object.predecessors = reader.readStringOrNull(offsets[22]);
  object.predecessorsList = reader.readStringList(offsets[23]);
  object.ten = reader.readString(offsets[24]);
  object.tenShort = reader.readStringOrNull(offsets[25]);
  object.type = reader.readStringOrNull(offsets[26]);
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
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readLongOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringList(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
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

  QueryBuilder<Committee, Committee, QAfterWhereClause> maIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ma',
        value: [null],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> maIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ma',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> maEqualTo(String? ma) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ma',
        value: [ma],
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterWhereClause> maNotEqualTo(
      String? ma) {
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
  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> areaKm2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaKm2',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> areaKm2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaKm2',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> areaKm2EqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> areaKm2GreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> areaKm2LessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> areaKm2Between(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bbox',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bbox',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxElementEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxElementLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxElementBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxLengthEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxIsEmpty() {
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxIsNotEmpty() {
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxLengthLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      bboxLengthGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> bboxLengthBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'capital',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'capital',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> capitalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capital',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      capitalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capital',
        value: '',
      ));
    });
  }

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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decree',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decree',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decree',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decree',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decreeUrl',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      decreeUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decreeUrl',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      decreeUrlGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> decreeUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decreeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      decreeUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decreeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> densityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'density',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> densityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'density',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> densityEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> densityGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> densityLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> densityBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ma',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ma',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maEqualTo(
    String? value, {
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maGreaterThan(
    String? value, {
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maLessThan(
    String? value, {
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ma',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> maIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ma',
        value: '',
      ));
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nPredecessorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nPredecessors',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nPredecessorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nPredecessors',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nPredecessorsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nPredecessors',
        value: value,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nPredecessorsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nPredecessors',
        value: value,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nPredecessorsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nPredecessors',
        value: value,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nPredecessorsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nPredecessors',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> nVerticesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nVertices',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nVerticesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nVertices',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> nVerticesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nVertices',
        value: value,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      nVerticesGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> nVerticesLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> nVerticesBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenXaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTenXa',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenXaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTenXa',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenXaEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenXaLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenXaBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenXaStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenXaEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenXaContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> parentTenXaMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenXaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTenXa',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      parentTenXaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTenXa',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneStartsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneContains(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> populationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'population',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      populationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'population',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> populationEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'population',
        value: value,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      populationGreaterThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> populationLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> populationBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predecessors',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predecessors',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> predecessorsEqualTo(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsLessThan(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition> predecessorsBetween(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsEndsWith(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'predecessors',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition> predecessorsMatches(
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessors',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predecessors',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predecessorsList',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predecessorsList',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessorsList',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
      predecessorsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predecessorsList',
        value: '',
      ));
    });
  }

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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

  QueryBuilder<Committee, Committee, QAfterFilterCondition>
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
  QueryBuilder<Committee, Committee, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByAreaKm2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByCapital() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByCapitalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.desc);
    });
  }

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

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDecree() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDecreeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDecreeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDecreeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
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

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.desc);
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

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByNPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByNPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByNVerticesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.desc);
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

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByParentTenXa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByParentTenXaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByPopulationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> sortByPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.desc);
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
  QueryBuilder<Committee, Committee, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByAreaKm2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByCapital() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByCapitalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.desc);
    });
  }

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

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDecree() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDecreeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDecreeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDecreeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
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

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.desc);
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

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByNPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByNPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByNVerticesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.desc);
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

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByParentTenXa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByParentTenXaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByPopulationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.desc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.asc);
    });
  }

  QueryBuilder<Committee, Committee, QAfterSortBy> thenByPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.desc);
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
  QueryBuilder<Committee, Committee, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaKm2');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByBbox() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bbox');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByCapital(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capital', caseSensitive: caseSensitive);
    });
  }

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

  QueryBuilder<Committee, Committee, QDistinct> distinctByDecree(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decree', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByDecreeUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decreeUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'density');
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

  QueryBuilder<Committee, Committee, QDistinct> distinctByMa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ma', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByMacroRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macroRegion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByNPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nPredecessors');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nVertices');
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

  QueryBuilder<Committee, Committee, QDistinct> distinctByParentTenXa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTenXa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'population');
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByPredecessors(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predecessors', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Committee, Committee, QDistinct> distinctByPredecessorsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predecessorsList');
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

  QueryBuilder<Committee, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Committee, double?, QQueryOperations> areaKm2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaKm2');
    });
  }

  QueryBuilder<Committee, List<double>?, QQueryOperations> bboxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bbox');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> capitalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capital');
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

  QueryBuilder<Committee, String?, QQueryOperations> decreeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decree');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> decreeUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decreeUrl');
    });
  }

  QueryBuilder<Committee, double?, QQueryOperations> densityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'density');
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

  QueryBuilder<Committee, String?, QQueryOperations> maProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ma');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> macroRegionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macroRegion');
    });
  }

  QueryBuilder<Committee, int?, QQueryOperations> nPredecessorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nPredecessors');
    });
  }

  QueryBuilder<Committee, int?, QQueryOperations> nVerticesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nVertices');
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

  QueryBuilder<Committee, String?, QQueryOperations> parentTenXaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTenXa');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<Committee, int?, QQueryOperations> populationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'population');
    });
  }

  QueryBuilder<Committee, String?, QQueryOperations> predecessorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predecessors');
    });
  }

  QueryBuilder<Committee, List<String>?, QQueryOperations>
      predecessorsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predecessorsList');
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
