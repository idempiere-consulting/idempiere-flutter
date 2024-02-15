class ProductBOMJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<PBRecords>? records;

  ProductBOMJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ProductBOMJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => PBRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class PBRecords {
  final int? id;
  final String? uid;
  final String? value;
  final String? name;
  final String? description;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final ADClientID? aDClientID;
  final MProductID? mProductID;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? validFrom;
  final ADOrgID? aDOrgID;
  final BOMType? bOMType;
  final BOMUse? bOMUse;
  final CUOMID? cUOMID;
  final String? modelname;

  PBRecords({
    this.id,
    this.uid,
    this.value,
    this.name,
    this.description,
    this.created,
    this.createdBy,
    this.isActive,
    this.aDClientID,
    this.mProductID,
    this.updated,
    this.updatedBy,
    this.validFrom,
    this.aDOrgID,
    this.bOMType,
    this.bOMUse,
    this.cUOMID,
    this.modelname,
  });

  PBRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        validFrom = json['ValidFrom'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        bOMType = (json['BOMType'] as Map<String, dynamic>?) != null
            ? BOMType.fromJson(json['BOMType'] as Map<String, dynamic>)
            : null,
        bOMUse = (json['BOMUse'] as Map<String, dynamic>?) != null
            ? BOMUse.fromJson(json['BOMUse'] as Map<String, dynamic>)
            : null,
        cUOMID = (json['C_UOM_ID'] as Map<String, dynamic>?) != null
            ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Value': value,
        'Name': name,
        'Description': description,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'AD_Client_ID': aDClientID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'ValidFrom': validFrom,
        'AD_Org_ID': aDOrgID?.toJson(),
        'BOMType': bOMType?.toJson(),
        'BOMUse': bOMUse?.toJson(),
        'C_UOM_ID': cUOMID?.toJson(),
        'model-name': modelname
      };
}

class CreatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CreatedBy.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class ADClientID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADClientID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADClientID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class MProductID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MProductID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MProductID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class UpdatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  UpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  UpdatedBy.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class ADOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADOrgID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class BOMType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  BOMType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BOMType.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as String?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class BOMUse {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  BOMUse({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BOMUse.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as String?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class CUOMID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CUOMID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CUOMID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}
