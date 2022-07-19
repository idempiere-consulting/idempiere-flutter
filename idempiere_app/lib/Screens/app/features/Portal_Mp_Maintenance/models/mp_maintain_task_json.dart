class MPMaintainTaskJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  MPMaintainTaskJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  MPMaintainTaskJson.fromJson(Map<String, dynamic> json)
    : pagecount = json['page-count'] as int?,
      recordssize = json['records-size'] as int?,
      skiprecords = json['skip-records'] as int?,
      rowcount = json['row-count'] as int?,
      records = (json['records'] as List?)?.map((dynamic e) => Records.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'page-count' : pagecount,
    'records-size' : recordssize,
    'skip-records' : skiprecords,
    'row-count' : rowcount,
    'records' : records?.map((e) => e.toJson()).toList()
  };
}

class Records {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final CUOMID? cUOMID;
  final String? created;
  final CreatedBy? createdBy;
  final UpdatedBy? updatedBy;
  final bool? isActive;
  final MPMaintainID? mPMaintainID;
  final String? updated;
  final bool? isConfirmed;
  final int? line;
  final int? qty;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.cUOMID,
    this.created,
    this.createdBy,
    this.updatedBy,
    this.isActive,
    this.mPMaintainID,
    this.updated,
    this.isConfirmed,
    this.line,
    this.qty,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      cUOMID = (json['C_UOM_ID'] as Map<String,dynamic>?) != null ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      mPMaintainID = (json['MP_Maintain_ID'] as Map<String,dynamic>?) != null ? MPMaintainID.fromJson(json['MP_Maintain_ID'] as Map<String,dynamic>) : null,
      updated = json['Updated'] as String?,
      isConfirmed = json['IsConfirmed'] as bool?,
      line = json['Line'] as int?,
      qty = json['Qty'] as int?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'C_UOM_ID' : cUOMID?.toJson(),
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'UpdatedBy' : updatedBy?.toJson(),
    'IsActive' : isActive,
    'MP_Maintain_ID' : mPMaintainID?.toJson(),
    'Updated' : updated,
    'IsConfirmed' : isConfirmed,
    'Line' : line,
    'Qty' : qty,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class MPMaintainID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainID.fromJson(Map<String, dynamic> json)
    : propertyLabel = json['propertyLabel'] as String?,
      id = json['id'] as int?,
      identifier = json['identifier'] as String?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}