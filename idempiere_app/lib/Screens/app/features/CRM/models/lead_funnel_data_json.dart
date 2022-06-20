class LeadFunnelDataJson {
  int? pagecount;
  int? recordssize;
  int? skiprecords;
  int? rowcount;
  List<Records>? records;

  LeadFunnelDataJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  LeadFunnelDataJson.fromJson(Map<String, dynamic> json) {
    pagecount = json['page-count'] as int?;
    recordssize = json['records-size'] as int?;
    skiprecords = json['skip-records'] as int?;
    rowcount = json['row-count'] as int?;
    records = (json['records'] as List?)?.map((dynamic e) => Records.fromJson(e as Map<String,dynamic>)).toList();
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

class Records {
  int? id;
  ADClientID? aDClientID;
  ADOrgID? aDOrgID;
  String? created;
  CreatedBy? createdBy;
  String? updated;
  UpdatedBy? updatedBy;
  String? tot;
  String? name;
  bool? isActive;
  String? modelname;

  Records({
    this.id,
    this.aDClientID,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.tot,
    this.name,
    this.isActive,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null;
    aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null;
    created = json['Created'] as String?;
    createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null;
    updated = json['Updated'] as String?;
    updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null;
    tot = json['tot'] as String?;
    name = json['Name'] as String?;
    isActive = json['IsActive'] as bool?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['AD_Client_ID'] = aDClientID?.toJson();
    json['AD_Org_ID'] = aDOrgID?.toJson();
    json['Created'] = created;
    json['CreatedBy'] = createdBy?.toJson();
    json['Updated'] = updated;
    json['UpdatedBy'] = updatedBy?.toJson();
    json['tot'] = tot;
    json['Name'] = name;
    json['IsActive'] = isActive;
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