class CommissionJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  CommissionJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  CommissionJson.fromJson(Map<String, dynamic> json)
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
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? name;
  final CBPartnerID? cBPartnerID;
  final CCurrencyID? cCurrencyID;
  final FrequencyType? frequencyType;
  final DocBasisType? docBasisType;
  final String? dateLastRun;
  final bool? listDetails;
  final CChargeID? cChargeID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.name,
    this.cBPartnerID,
    this.cCurrencyID,
    this.frequencyType,
    this.docBasisType,
    this.dateLastRun,
    this.listDetails,
    this.cChargeID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      updated = json['Updated'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      name = json['Name'] as String?,
      cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null,
      cCurrencyID = (json['C_Currency_ID'] as Map<String,dynamic>?) != null ? CCurrencyID.fromJson(json['C_Currency_ID'] as Map<String,dynamic>) : null,
      frequencyType = (json['FrequencyType'] as Map<String,dynamic>?) != null ? FrequencyType.fromJson(json['FrequencyType'] as Map<String,dynamic>) : null,
      docBasisType = (json['DocBasisType'] as Map<String,dynamic>?) != null ? DocBasisType.fromJson(json['DocBasisType'] as Map<String,dynamic>) : null,
      dateLastRun = json['DateLastRun'] as String?,
      listDetails = json['ListDetails'] as bool?,
      cChargeID = (json['C_Charge_ID'] as Map<String,dynamic>?) != null ? CChargeID.fromJson(json['C_Charge_ID'] as Map<String,dynamic>) : null,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'IsActive' : isActive,
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'Updated' : updated,
    'UpdatedBy' : updatedBy?.toJson(),
    'Name' : name,
    'C_BPartner_ID' : cBPartnerID?.toJson(),
    'C_Currency_ID' : cCurrencyID?.toJson(),
    'FrequencyType' : frequencyType?.toJson(),
    'DocBasisType' : docBasisType?.toJson(),
    'DateLastRun' : dateLastRun,
    'ListDetails' : listDetails,
    'C_Charge_ID' : cChargeID?.toJson(),
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

class CCurrencyID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CCurrencyID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CCurrencyID.fromJson(Map<String, dynamic> json)
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

class FrequencyType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  FrequencyType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  FrequencyType.fromJson(Map<String, dynamic> json)
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

class DocBasisType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocBasisType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocBasisType.fromJson(Map<String, dynamic> json)
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

class CChargeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CChargeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CChargeID.fromJson(Map<String, dynamic> json)
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