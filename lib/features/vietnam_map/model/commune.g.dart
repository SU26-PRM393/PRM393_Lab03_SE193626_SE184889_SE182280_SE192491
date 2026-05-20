// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commune.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommuneCollection on Isar {
  IsarCollection<Commune> get communes => this.collection();
}

const CommuneSchema = CollectionSchema(
  name: r'Commune',
  id: 8257384470769380832,
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
  estimateSize: _communeEstimateSize,
  serialize: _communeSerialize,
  deserialize: _communeDeserialize,
  deserializeProp: _communeDeserializeProp,
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
  getId: _communeGetId,
  getLinks: _communeGetLinks,
  attach: _communeAttach,
  version: '3.1.0+1',
);

int _communeEstimateSize(
  Commune object,
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

void _communeSerialize(
  Commune object,
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

Commune _communeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Commune();
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

P _communeDeserializeProp<P>(
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

Id _communeGetId(Commune object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _communeGetLinks(Commune object) {
  return [];
}

void _communeAttach(IsarCollection<dynamic> col, Id id, Commune object) {
  object.id = id;
}

extension CommuneByIndex on IsarCollection<Commune> {
  Future<Commune?> getByDataId(String dataId) {
    return getByIndex(r'dataId', [dataId]);
  }

  Commune? getByDataIdSync(String dataId) {
    return getByIndexSync(r'dataId', [dataId]);
  }

  Future<bool> deleteByDataId(String dataId) {
    return deleteByIndex(r'dataId', [dataId]);
  }

  bool deleteByDataIdSync(String dataId) {
    return deleteByIndexSync(r'dataId', [dataId]);
  }

  Future<List<Commune?>> getAllByDataId(List<String> dataIdValues) {
    final values = dataIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'dataId', values);
  }

  List<Commune?> getAllByDataIdSync(List<String> dataIdValues) {
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

  Future<Id> putByDataId(Commune object) {
    return putByIndex(r'dataId', object);
  }

  Id putByDataIdSync(Commune object, {bool saveLinks = true}) {
    return putByIndexSync(r'dataId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDataId(List<Commune> objects) {
    return putAllByIndex(r'dataId', objects);
  }

  List<Id> putAllByDataIdSync(List<Commune> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'dataId', objects, saveLinks: saveLinks);
  }
}

extension CommuneQueryWhereSort on QueryBuilder<Commune, Commune, QWhere> {
  QueryBuilder<Commune, Commune, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommuneQueryWhere on QueryBuilder<Commune, Commune, QWhereClause> {
  QueryBuilder<Commune, Commune, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Commune, Commune, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> idBetween(
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

  QueryBuilder<Commune, Commune, QAfterWhereClause> dataIdEqualTo(
      String dataId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dataId',
        value: [dataId],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> dataIdNotEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterWhereClause> maEqualTo(String ma) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ma',
        value: [ma],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> maNotEqualTo(String ma) {
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

  QueryBuilder<Commune, Commune, QAfterWhereClause> tenEqualTo(String ten) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ten',
        value: [ten],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> tenNotEqualTo(String ten) {
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

  QueryBuilder<Commune, Commune, QAfterWhereClause> parentMaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentMa',
        value: [null],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> parentMaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'parentMa',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> parentMaEqualTo(
      String? parentMa) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'parentMa',
        value: [parentMa],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> parentMaNotEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterWhereClause> macroRegionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'macroRegion',
        value: [null],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> macroRegionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'macroRegion',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> macroRegionEqualTo(
      String? macroRegion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'macroRegion',
        value: [macroRegion],
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterWhereClause> macroRegionNotEqualTo(
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

extension CommuneQueryFilter
    on QueryBuilder<Commune, Commune, QFilterCondition> {
  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> areaKm2IsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'areaKm2',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> areaKm2IsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'areaKm2',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> areaKm2EqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> areaKm2GreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> areaKm2LessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> areaKm2Between(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bbox',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bbox',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxElementEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxElementGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxElementLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxElementBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxLengthEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxIsEmpty() {
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxIsNotEmpty() {
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxLengthLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxLengthGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> bboxLengthBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'capital',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'capital',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'capital',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> capitalIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'capital',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centroidLat',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centroidLat',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLatEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLatGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLatLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLatBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'centroidLon',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'centroidLon',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLonEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLonGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLonLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> centroidLonBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataId',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> dataIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataId',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decree',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decree',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decree',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decree',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'decreeUrl',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'decreeUrl',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'decreeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> decreeUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'decreeUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> densityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'density',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> densityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'density',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> densityEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> densityGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> densityLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> densityBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'embedText',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'embedText',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'embedText',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> embedTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'embedText',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'geomType',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'geomType',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geomType',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> geomTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geomType',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'keywords',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'keywords',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsElementEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsElementLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsElementBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsElementEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'keywords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'keywords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      keywordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'keywords',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      keywordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'keywords',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsLengthEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsIsEmpty() {
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsIsNotEmpty() {
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsLengthLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> keywordsLengthBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ma',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> maIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ma',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'macroRegion',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'macroRegion',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> macroRegionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'macroRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      macroRegionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'macroRegion',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nPredecessorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nPredecessors',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      nPredecessorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nPredecessors',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nPredecessorsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nPredecessors',
        value: value,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nPredecessorsLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nPredecessorsBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nVerticesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nVertices',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nVerticesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nVertices',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nVerticesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nVertices',
        value: value,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nVerticesGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nVerticesLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> nVerticesBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentMa',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentMa',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentMa',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentMaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentMa',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTen',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTen',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTen',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTen',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentTenXa',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentTenXa',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> parentTenXaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentTenXa',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      parentTenXaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentTenXa',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> populationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'population',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> populationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'population',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> populationEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'population',
        value: value,
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> populationGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> populationLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> populationBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predecessors',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      predecessorsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predecessors',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> predecessorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessors',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      predecessorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predecessors',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      predecessorsListIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'predecessorsList',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      predecessorsListIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'predecessorsList',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      predecessorsListElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predecessorsList',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
      predecessorsListElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'predecessorsList',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition>
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ten',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ten',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tenShort',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tenShort',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenShort',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> tenShortIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenShort',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeContains(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeMatches(
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

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Commune, Commune, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension CommuneQueryObject
    on QueryBuilder<Commune, Commune, QFilterCondition> {}

extension CommuneQueryLinks
    on QueryBuilder<Commune, Commune, QFilterCondition> {}

extension CommuneQuerySortBy on QueryBuilder<Commune, Commune, QSortBy> {
  QueryBuilder<Commune, Commune, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByAreaKm2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByCapital() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByCapitalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByCentroidLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByCentroidLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDataId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDataIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDecree() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDecreeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDecreeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDecreeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByEmbedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByEmbedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByGeomType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByGeomTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByMacroRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByMacroRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByNPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByNPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByNVerticesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByParentMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByParentMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByParentTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByParentTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByParentTenXa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByParentTenXaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByPopulationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByTenShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByTenShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CommuneQuerySortThenBy
    on QueryBuilder<Commune, Commune, QSortThenBy> {
  QueryBuilder<Commune, Commune, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByAreaKm2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaKm2', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByCapital() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByCapitalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'capital', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByCentroidLatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLat', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByCentroidLonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'centroidLon', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDataId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDataIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataId', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDecree() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDecreeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decree', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDecreeUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDecreeUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'decreeUrl', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByDensityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'density', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByEmbedText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByEmbedTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'embedText', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByGeomType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByGeomTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geomType', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ma', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByMacroRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByMacroRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'macroRegion', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByNPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByNPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nPredecessors', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByNVerticesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nVertices', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByParentMa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByParentMaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentMa', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByParentTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByParentTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTen', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByParentTenXa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByParentTenXaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentTenXa', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByPopulationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'population', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByPredecessorsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predecessors', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByTen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByTenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ten', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByTenShort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByTenShortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenShort', Sort.desc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Commune, Commune, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension CommuneQueryWhereDistinct
    on QueryBuilder<Commune, Commune, QDistinct> {
  QueryBuilder<Commune, Commune, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByAreaKm2() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaKm2');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByBbox() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bbox');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByCapital(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'capital', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByCentroidLat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidLat');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByCentroidLon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'centroidLon');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByDataId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByDecree(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decree', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByDecreeUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'decreeUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByDensity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'density');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByEmbedText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'embedText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByGeomType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geomType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByKeywords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'keywords');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByMa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ma', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByMacroRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'macroRegion', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByNPredecessors() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nPredecessors');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByNVertices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nVertices');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByParentMa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentMa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByParentTen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTen', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByParentTenXa(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentTenXa', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByPopulation() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'population');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByPredecessors(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predecessors', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByPredecessorsList() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predecessorsList');
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByTen(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ten', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByTenShort(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenShort', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commune, Commune, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension CommuneQueryProperty
    on QueryBuilder<Commune, Commune, QQueryProperty> {
  QueryBuilder<Commune, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Commune, double?, QQueryOperations> areaKm2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaKm2');
    });
  }

  QueryBuilder<Commune, List<double>?, QQueryOperations> bboxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bbox');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> capitalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'capital');
    });
  }

  QueryBuilder<Commune, double?, QQueryOperations> centroidLatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidLat');
    });
  }

  QueryBuilder<Commune, double?, QQueryOperations> centroidLonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'centroidLon');
    });
  }

  QueryBuilder<Commune, String, QQueryOperations> dataIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataId');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> decreeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decree');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> decreeUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'decreeUrl');
    });
  }

  QueryBuilder<Commune, double?, QQueryOperations> densityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'density');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> embedTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'embedText');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> geomTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geomType');
    });
  }

  QueryBuilder<Commune, List<String>?, QQueryOperations> keywordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'keywords');
    });
  }

  QueryBuilder<Commune, String, QQueryOperations> maProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ma');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> macroRegionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'macroRegion');
    });
  }

  QueryBuilder<Commune, int?, QQueryOperations> nPredecessorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nPredecessors');
    });
  }

  QueryBuilder<Commune, int?, QQueryOperations> nVerticesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nVertices');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> parentMaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentMa');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> parentTenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTen');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> parentTenXaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentTenXa');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<Commune, int?, QQueryOperations> populationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'population');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> predecessorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predecessors');
    });
  }

  QueryBuilder<Commune, List<String>?, QQueryOperations>
      predecessorsListProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predecessorsList');
    });
  }

  QueryBuilder<Commune, String, QQueryOperations> tenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ten');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> tenShortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenShort');
    });
  }

  QueryBuilder<Commune, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
