class AnomalyJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<ANRecords>? records;

  AnomalyJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  AnomalyJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => ANRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class ANRecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? created;
  final CreatedBy? createdBy;
  String? description;
  final bool? isActive;
  final String? name;
  final String? updated;
  final UpdatedBy? updatedBy;
  String? dateDoc;
  ADUserID3? aDUserID;
  final MPMaintainTaskID? mPMaintainTaskID;
  LITNCFaultTypeID? lITNCFaultTypeID;
  MPMaintainResourceID? mPMaintainResourceID;
  MPOTID? mpotid;
  CBPartnerID? cbPartnerID;
  bool? isInvoiced;
  bool? lITIsManagedByCustomer;
  AMProductID? mProductID;
  bool? isClosed;
  bool? lITIsReplaced;
  final String? modelname;
  int? offlineId;
  bool? isValid;

  ANRecords(
      {this.id,
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
      this.mpotid,
      this.cbPartnerID,
      this.lITNCFaultTypeID,
      this.mPMaintainResourceID,
      this.isInvoiced,
      this.lITIsManagedByCustomer,
      this.mProductID,
      this.isClosed,
      this.lITIsReplaced,
      this.modelname,
      this.offlineId,
      this.isValid});

  ANRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        description = json['Description'] as String?,
        isActive = json['IsActive'] as bool?,
        name = json['Name'] as String?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        dateDoc = json['DateDoc'] as String?,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID3.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainTaskID =
            (json['MP_Maintain_Task_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainTaskID.fromJson(
                    json['MP_Maintain_Task_ID'] as Map<String, dynamic>)
                : null,
        mpotid = (json['MP_OT_ID'] as Map<String, dynamic>?) != null
            ? MPOTID.fromJson(json['MP_OT_ID'] as Map<String, dynamic>)
            : null,
        cbPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        lITNCFaultTypeID =
            (json['LIT_NCFaultType_ID'] as Map<String, dynamic>?) != null
                ? LITNCFaultTypeID.fromJson(
                    json['LIT_NCFaultType_ID'] as Map<String, dynamic>)
                : null,
        mPMaintainResourceID =
            (json['MP_Maintain_Resource_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainResourceID.fromJson(
                    json['MP_Maintain_Resource_ID'] as Map<String, dynamic>)
                : null,
        isInvoiced = json['IsInvoiced'] as bool?,
        lITIsManagedByCustomer = json['LIT_IsManagedByCustomer'] as bool?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? AMProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        isClosed = json['IsClosed'] as bool?,
        lITIsReplaced = json['LIT_IsReplaced'] as bool?,
        isValid = json['IsValid'] as bool?,
        offlineId = json["offlineId"] as int?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Description': description,
        'IsActive': isActive,
        'Name': name,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'DateDoc': dateDoc,
        'AD_User_ID': aDUserID?.toJson(),
        'MP_Maintain_Task_ID': mPMaintainTaskID?.toJson(),
        'LIT_NCFaultType_ID': lITNCFaultTypeID?.toJson(),
        'MP_Maintain_Resource_ID': mPMaintainResourceID?.toJson(),
        'IsInvoiced': isInvoiced,
        'LIT_IsManagedByCustomer': lITIsManagedByCustomer,
        'M_Product_ID': mProductID?.toJson(),
        'IsClosed': isClosed,
        'LIT_IsReplaced': lITIsReplaced,
        'IsValid': isValid,
        'model-name': modelname,
        'offlineId': offlineId,
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

class ADUserID3 {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserID3({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserID3.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class AMProductID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  AMProductID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  AMProductID.fromJson(Map<String, dynamic> json)
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
