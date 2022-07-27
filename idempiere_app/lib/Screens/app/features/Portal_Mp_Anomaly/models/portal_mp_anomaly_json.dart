class PortalMPAnomalyJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  PortalMPAnomalyJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  PortalMPAnomalyJson.fromJson(Map<String, dynamic> json)
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
  final String? created;
  final CreatedBy? createdBy;
  final String? description;
  final bool? isActive;
  final String? name;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? dateDoc;
  final ADUserID? aDUserID;
  final MPMaintainTaskID? mPMaintainTaskID;
  final LITNCFaultTypeID? lITNCFaultTypeID;
  final MPMaintainResourceID? mPMaintainResourceID;
  final bool? isBOM;
  final bool? isInvoiced;
  final MPOTID? mPOTID;
  final bool? lITIsManagedByCustomer;
  final MProductID? mProductID;
  final bool? isClosed;
  final bool? lITIsReplaced;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.description,
    this.isActive,
    this.name,
    this.updated,
    this.updatedBy,
    this.dateDoc,
    this.aDUserID,
    this.mPMaintainTaskID,
    this.lITNCFaultTypeID,
    this.mPMaintainResourceID,
    this.isBOM,
    this.isInvoiced,
    this.mPOTID,
    this.lITIsManagedByCustomer,
    this.mProductID,
    this.isClosed,
    this.lITIsReplaced,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      description = json['Description'] as String?,
      isActive = json['IsActive'] as bool?,
      name = json['Name'] as String?,
      updated = json['Updated'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      dateDoc = json['DateDoc'] as String?,
      aDUserID = (json['AD_User_ID'] as Map<String,dynamic>?) != null ? ADUserID.fromJson(json['AD_User_ID'] as Map<String,dynamic>) : null,
      mPMaintainTaskID = (json['MP_Maintain_Task_ID'] as Map<String,dynamic>?) != null ? MPMaintainTaskID.fromJson(json['MP_Maintain_Task_ID'] as Map<String,dynamic>) : null,
      lITNCFaultTypeID = (json['LIT_NCFaultType_ID'] as Map<String,dynamic>?) != null ? LITNCFaultTypeID.fromJson(json['LIT_NCFaultType_ID'] as Map<String,dynamic>) : null,
      mPMaintainResourceID = (json['MP_Maintain_Resource_ID'] as Map<String,dynamic>?) != null ? MPMaintainResourceID.fromJson(json['MP_Maintain_Resource_ID'] as Map<String,dynamic>) : null,
      isBOM = json['IsBOM'] as bool?,
      isInvoiced = json['IsInvoiced'] as bool?,
      mPOTID = (json['MP_OT_ID'] as Map<String,dynamic>?) != null ? MPOTID.fromJson(json['MP_OT_ID'] as Map<String,dynamic>) : null,
      lITIsManagedByCustomer = json['LIT_IsManagedByCustomer'] as bool?,
      mProductID = (json['M_Product_ID'] as Map<String,dynamic>?) != null ? MProductID.fromJson(json['M_Product_ID'] as Map<String,dynamic>) : null,
      isClosed = json['IsClosed'] as bool?,
      lITIsReplaced = json['LIT_IsReplaced'] as bool?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'Description' : description,
    'IsActive' : isActive,
    'Name' : name,
    'Updated' : updated,
    'UpdatedBy' : updatedBy?.toJson(),
    'DateDoc' : dateDoc,
    'AD_User_ID' : aDUserID?.toJson(),
    'MP_Maintain_Task_ID' : mPMaintainTaskID?.toJson(),
    'LIT_NCFaultType_ID' : lITNCFaultTypeID?.toJson(),
    'MP_Maintain_Resource_ID' : mPMaintainResourceID?.toJson(),
    'IsBOM' : isBOM,
    'IsInvoiced' : isInvoiced,
    'MP_OT_ID' : mPOTID?.toJson(),
    'LIT_IsManagedByCustomer' : lITIsManagedByCustomer,
    'M_Product_ID' : mProductID?.toJson(),
    'IsClosed' : isClosed,
    'LIT_IsReplaced' : lITIsReplaced,
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

class MPMaintainTaskID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainTaskID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainTaskID.fromJson(Map<String, dynamic> json)
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

class LITNCFaultTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITNCFaultTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITNCFaultTypeID.fromJson(Map<String, dynamic> json)
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

class MPMaintainResourceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainResourceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainResourceID.fromJson(Map<String, dynamic> json)
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

class MPOTID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPOTID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPOTID.fromJson(Map<String, dynamic> json)
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}