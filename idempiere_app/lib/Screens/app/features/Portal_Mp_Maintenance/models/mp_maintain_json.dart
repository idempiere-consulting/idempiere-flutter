class MPMaintainJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  MPMaintainJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  MPMaintainJson.fromJson(Map<String, dynamic> json)
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
  final String? documentNo;
  final UpdatedBy? updatedBy;
  final String? created;
  final CreatedBy? createdBy;
  final String? dateNextRun;
  final String? dateLastRun;
  final DocStatus? docStatus;
  final bool? isActive;
  final ProgrammingType? programmingType;
  final String? updated;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final CBPartnerID? cBPartnerID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final String? modelname;
  final CContractID? cContractID;

  Records({
    this.id,
    this.uid,
    this.documentNo,
    this.updatedBy,
    this.created,
    this.createdBy,
    this.dateNextRun,
    this.dateLastRun,
    this.docStatus,
    this.isActive,
    this.programmingType,
    this.updated,
    this.aDClientID,
    this.aDOrgID,
    this.cBPartnerID,
    this.cBPartnerLocationID,
    this.modelname,
    this.cContractID,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      documentNo = json['DocumentNo'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      dateNextRun = json['DateNextRun'] as String?,
      dateLastRun = json['dateLastRun'] as String?,
      docStatus = (json['DocStatus'] as Map<String,dynamic>?) != null ? DocStatus.fromJson(json['DocStatus'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      programmingType = (json['ProgrammingType'] as Map<String,dynamic>?) != null ? ProgrammingType.fromJson(json['ProgrammingType'] as Map<String,dynamic>) : null,
      updated = json['Updated'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null,
      cBPartnerLocationID = (json['C_BPartner_Location_ID'] as Map<String,dynamic>?) != null ? CBPartnerLocationID.fromJson(json['C_BPartner_Location_ID'] as Map<String,dynamic>) : null,
      modelname = json['model-name'] as String?,
      cContractID = (json['C_Contract_ID'] as Map<String,dynamic>?) != null ? CContractID.fromJson(json['C_Contract_ID'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'DocumentNo' : documentNo,
    'UpdatedBy' : updatedBy?.toJson(),
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'DateNextRun' : dateNextRun,
    'DocStatus' : docStatus?.toJson(),
    'IsActive' : isActive,
    'ProgrammingType' : programmingType?.toJson(),
    'Updated' : updated,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'C_BPartner_ID' : cBPartnerID?.toJson(),
    'C_BPartner_Location_ID' : cBPartnerLocationID?.toJson(),
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

class DocStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocStatus.fromJson(Map<String, dynamic> json)
    : propertyLabel = json['propertyLabel'] as String?,
      id = json['id'] as String?,
      identifier = json['identifier'] as String?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class ProgrammingType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ProgrammingType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProgrammingType.fromJson(Map<String, dynamic> json)
    : propertyLabel = json['propertyLabel'] as String?,
      id = json['id'] as String?,
      identifier = json['identifier'] as String?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
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

class CBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerID.fromJson(Map<String, dynamic> json)
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

class CBPartnerLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerLocationID.fromJson(Map<String, dynamic> json)
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

class CContractID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CContractID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CContractID.fromJson(Map<String, dynamic> json)
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