class WarehouseJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  WarehouseJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  WarehouseJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => Records.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class Records {
  final int? id;
  final String? uid;
  final String? name;
  final CLocationID? cLocationID;
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? value;
  final String? separator;
  final bool? isInTransit;
  final bool? isDisallowNegativeInv;
  final MReserveLocatorID? mReserveLocatorID;
  final LITMReserveLocatorProdMID? lITMReserveLocatorProdMID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.name,
    this.cLocationID,
    this.aDOrgID,
    this.aDClientID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.value,
    this.separator,
    this.isInTransit,
    this.isDisallowNegativeInv,
    this.mReserveLocatorID,
    this.lITMReserveLocatorProdMID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        name = json['Name'] as String?,
        cLocationID = (json['C_Location_ID'] as Map<String, dynamic>?) != null
            ? CLocationID.fromJson(
                json['C_Location_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        value = json['Value'] as String?,
        separator = json['Separator'] as String?,
        isInTransit = json['IsInTransit'] as bool?,
        isDisallowNegativeInv = json['IsDisallowNegativeInv'] as bool?,
        mReserveLocatorID =
            (json['M_ReserveLocator_ID'] as Map<String, dynamic>?) != null
                ? MReserveLocatorID.fromJson(
                    json['M_ReserveLocator_ID'] as Map<String, dynamic>)
                : null,
        lITMReserveLocatorProdMID = (json['LIT_M_ReserveLocator_ProdM_ID']
                    as Map<String, dynamic>?) !=
                null
            ? LITMReserveLocatorProdMID.fromJson(
                json['LIT_M_ReserveLocator_ProdM_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Name': name,
        'C_Location_ID': cLocationID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Value': value,
        'Separator': separator,
        'IsInTransit': isInTransit,
        'IsDisallowNegativeInv': isDisallowNegativeInv,
        'M_ReserveLocator_ID': mReserveLocatorID?.toJson(),
        'LIT_M_ReserveLocator_ProdM_ID': lITMReserveLocatorProdMID?.toJson(),
        'model-name': modelname
      };
}

class CLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CLocationID.fromJson(Map<String, dynamic> json)
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

class MReserveLocatorID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MReserveLocatorID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MReserveLocatorID.fromJson(Map<String, dynamic> json)
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

class LITMReserveLocatorProdMID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITMReserveLocatorProdMID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITMReserveLocatorProdMID.fromJson(Map<String, dynamic> json)
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
