class LitMaintainJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  LitMaintainJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  LitMaintainJson.fromJson(Map<String, dynamic> json)
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
  final ADUserID? aDUserID;
  final String? name;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final ADClientID? aDClientID;
  final String? created;
  final String? updated;
  final CreatedBy? createdBy;
  final UpdatedBy? updatedBy;
  final String? documentNo;
  final CBPartnerID? cBPartnerID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final String? dateNextRun;
  final String? address1;
  final String? city;
  final String? modelname;
  final BillBPartnerID? billBPartnerID;
  final CContractID? cContractID;
  final String? dateLastRun;
  final String? postalAdd;

  Records({
    this.id,
    this.aDUserID,
    this.name,
    this.aDOrgID,
    this.isActive,
    this.aDClientID,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.documentNo,
    this.cBPartnerID,
    this.cBPartnerLocationID,
    this.dateNextRun,
    this.address1,
    this.city,
    this.modelname,
    this.billBPartnerID,
    this.cContractID,
    this.dateLastRun,
    this.postalAdd,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      aDUserID = (json['AD_User_ID'] as Map<String,dynamic>?) != null ? ADUserID.fromJson(json['AD_User_ID'] as Map<String,dynamic>) : null,
      name = json['Name'] as String?,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      updated = json['Updated'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      documentNo = json['DocumentNo'] as String?,
      cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null,
      cBPartnerLocationID = (json['C_BPartner_Location_ID'] as Map<String,dynamic>?) != null ? CBPartnerLocationID.fromJson(json['C_BPartner_Location_ID'] as Map<String,dynamic>) : null,
      dateNextRun = json['DateNextRun'] as String?,
      address1 = json['Address1'] as String?,
      city = json['City'] as String?,
      modelname = json['model-name'] as String?,
      billBPartnerID = (json['Bill_BPartner_ID'] as Map<String,dynamic>?) != null ? BillBPartnerID.fromJson(json['Bill_BPartner_ID'] as Map <String,dynamic>) : null,
      cContractID = (json['C_Contract_ID'] as Map<String,dynamic>?) != null ? CContractID.fromJson(json['C_Contract_ID'] as Map<String,dynamic>) : null,
      dateLastRun = json['dateLastRun'] as String?,
      postalAdd = json['Postal_Add'] as String?;


  Map<String, dynamic> toJson() => {
    'id' : id,
    'AD_User_ID' : aDUserID?.toJson(),
    'Name' : name,
    'AD_Org_ID' : aDOrgID?.toJson(),
    'IsActive' : isActive,
    'AD_Client_ID' : aDClientID?.toJson(),
    'Created' : created,
    'Updated' : updated,
    'CreatedBy' : createdBy?.toJson(),
    'UpdatedBy' : updatedBy?.toJson(),
    'DocumentNo' : documentNo,
    'C_BPartner_ID' : cBPartnerID?.toJson(),
    'C_BPartner_Location_ID' : cBPartnerLocationID?.toJson(),
    'DateNextRun' : dateNextRun,
    'Address1' : address1,
    'City' : city,
    'model-name' : modelname
  };
}

class ADUserID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserID.fromJson(Map<String, dynamic> json)
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

class BillBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BillBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BillBPartnerID.fromJson(Map<String, dynamic> json)
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