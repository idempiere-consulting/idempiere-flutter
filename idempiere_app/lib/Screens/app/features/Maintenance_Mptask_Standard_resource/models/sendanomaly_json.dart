class SendAnomalyJSON {
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final MPOTID? mPOTID;
  final MPMaintainResourceID2? mPMaintainResourceID;
  final LITNCFaultTypeID2? lITNCFaultTypeID;
  final ADUserID2? aDUserID;
  final String? name;
  final String? description;
  final bool? isInvoiced;
  final bool? lITIsReplaced;
  final MProductID? mProductID;
  final String? dateDoc;
  final bool? lITIsManagedByCustomer;
  final bool? isClosed;

  SendAnomalyJSON({
    this.aDOrgID,
    this.aDClientID,
    this.mPOTID,
    this.mPMaintainResourceID,
    this.lITNCFaultTypeID,
    this.aDUserID,
    this.name,
    this.description,
    this.isInvoiced,
    this.lITIsReplaced,
    this.mProductID,
    this.dateDoc,
    this.lITIsManagedByCustomer,
    this.isClosed,
  });

  SendAnomalyJSON.fromJson(Map<String, dynamic> json)
      : aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        mPOTID = (json['MP_OT_ID'] as Map<String, dynamic>?) != null
            ? MPOTID.fromJson(json['MP_OT_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainResourceID =
            (json['MP_Maintain_Resource_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainResourceID2.fromJson(
                    json['MP_Maintain_Resource_ID'] as Map<String, dynamic>)
                : null,
        lITNCFaultTypeID =
            (json['LIT_NCFaultType_ID'] as Map<String, dynamic>?) != null
                ? LITNCFaultTypeID2.fromJson(
                    json['LIT_NCFaultType_ID'] as Map<String, dynamic>)
                : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID2.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        isInvoiced = json['IsInvoiced'] as bool?,
        lITIsReplaced = json['LIT_IsReplaced'] as bool?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        dateDoc = json['DateDoc'] as String?,
        lITIsManagedByCustomer = json['LIT_IsManagedByCustomer'] as bool?,
        isClosed = json['IsClosed'] as bool?;

  Map<String, dynamic> toJson() => {
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'MP_OT_ID': mPOTID?.toJson(),
        'MP_Maintain_Resource_ID': mPMaintainResourceID?.toJson(),
        'LIT_NCFaultType_ID': lITNCFaultTypeID?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
        'Name': name,
        'Description': description,
        'IsInvoiced': isInvoiced,
        'LIT_IsReplaced': lITIsReplaced,
        'M_Product_ID': mProductID?.toJson(),
        'DateDoc': dateDoc,
        'LIT_IsManagedByCustomer': lITIsManagedByCustomer,
        'IsClosed': isClosed
      };
}

class ADOrgID {
  final String? id;

  ADOrgID({
    this.id,
  });

  ADOrgID.fromJson(Map<String, dynamic> json) : id = json['id'] as String?;

  Map<String, dynamic> toJson() => {'id': id};
}

class ADClientID {
  final String? id;

  ADClientID({
    this.id,
  });

  ADClientID.fromJson(Map<String, dynamic> json) : id = json['id'] as String?;

  Map<String, dynamic> toJson() => {'id': id};
}

class MPOTID {
  final int? id;

  MPOTID({
    this.id,
  });

  MPOTID.fromJson(Map<String, dynamic> json) : id = json['id'] as int?;

  Map<String, dynamic> toJson() => {'id': id};
}

class MPMaintainResourceID2 {
  final int? id;

  MPMaintainResourceID2({
    this.id,
  });

  MPMaintainResourceID2.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?;

  Map<String, dynamic> toJson() => {'id': id};
}

class LITNCFaultTypeID2 {
  final int? id;

  LITNCFaultTypeID2({
    this.id,
  });

  LITNCFaultTypeID2.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?;

  Map<String, dynamic> toJson() => {'id': id};
}

class ADUserID2 {
  final int? id;

  ADUserID2({
    this.id,
  });

  ADUserID2.fromJson(Map<String, dynamic> json) : id = json['id'] as int?;

  Map<String, dynamic> toJson() => {'id': id};
}

class MProductID {
  final int? id;

  MProductID({
    this.id,
  });

  MProductID.fromJson(Map<String, dynamic> json) : id = json['id'] as int?;

  Map<String, dynamic> toJson() => {'id': id};
}
