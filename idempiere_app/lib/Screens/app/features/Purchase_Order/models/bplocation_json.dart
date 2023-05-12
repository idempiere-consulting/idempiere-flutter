class BPLocationJson {
  int? pagecount;
  int? recordssize;
  int? skiprecords;
  int? rowcount;
  List<BPLRecords>? records;

  BPLocationJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  BPLocationJson.fromJson(Map<String, dynamic> json) {
    pagecount = json['page-count'] as int?;
    recordssize = json['records-size'] as int?;
    skiprecords = json['skip-records'] as int?;
    rowcount = json['row-count'] as int?;
    records = (json['records'] as List?)?.map((dynamic e) => BPLRecords.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['page-count'] = pagecount;
    json['records-size'] = recordssize;
    json['skip-records'] = skiprecords;
    json['row-count'] = rowcount;
    json['records'] = records?.map((e) => e.toJson()).toList();
    return json;
  }
}

class BPLRecords {
  int? id;
  String? uid;
  ADClientID? aDClientID;
  ADOrgID? aDOrgID;
  bool? isActive;
  String? created;
  CreatedBy? createdBy;
  String? updated;
  UpdatedBy? updatedBy;
  CBPartnerID? cBPartnerID;
  CLocationID? cLocationID;
  String? name;
  bool? isBillTo;
  bool? isShipTo;
  bool? isPayFrom;
  bool? isRemitTo;
  bool? isPreserveCustomName;
  String? modelname;

  BPLRecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.cBPartnerID,
    this.cLocationID,
    this.name,
    this.isBillTo,
    this.isShipTo,
    this.isPayFrom,
    this.isRemitTo,
    this.isPreserveCustomName,
    this.modelname,
  });

  BPLRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    uid = json['uid'] as String?;
    aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null;
    aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null;
    isActive = json['IsActive'] as bool?;
    created = json['Created'] as String?;
    createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null;
    updated = json['Updated'] as String?;
    updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null;
    cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null;
    cLocationID = (json['C_Location_ID'] as Map<String,dynamic>?) != null ? CLocationID.fromJson(json['C_Location_ID'] as Map<String,dynamic>) : null;
    name = json['Name'] as String?;
    isBillTo = json['IsBillTo'] as bool?;
    isShipTo = json['IsShipTo'] as bool?;
    isPayFrom = json['IsPayFrom'] as bool?;
    isRemitTo = json['IsRemitTo'] as bool?;
    isPreserveCustomName = json['IsPreserveCustomName'] as bool?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['uid'] = uid;
    json['AD_Client_ID'] = aDClientID?.toJson();
    json['AD_Org_ID'] = aDOrgID?.toJson();
    json['IsActive'] = isActive;
    json['Created'] = created;
    json['CreatedBy'] = createdBy?.toJson();
    json['Updated'] = updated;
    json['UpdatedBy'] = updatedBy?.toJson();
    json['C_BPartner_ID'] = cBPartnerID?.toJson();
    json['C_Location_ID'] = cLocationID?.toJson();
    json['Name'] = name;
    json['IsBillTo'] = isBillTo;
    json['IsShipTo'] = isShipTo;
    json['IsPayFrom'] = isPayFrom;
    json['IsRemitTo'] = isRemitTo;
    json['IsPreserveCustomName'] = isPreserveCustomName;
    json['model-name'] = modelname;
    return json;
  }
}

class ADClientID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADClientID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADClientID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class ADOrgID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADOrgID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class CreatedBy {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CreatedBy.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class UpdatedBy {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  UpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  UpdatedBy.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class CBPartnerID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class CLocationID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CLocationID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}