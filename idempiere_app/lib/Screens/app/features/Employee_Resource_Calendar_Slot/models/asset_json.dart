class AssetJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  AssetJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  AssetJSON.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        arraycount = json['array-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => Records.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'array-count': arraycount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class Records {
  final int? id;
  final String? uid;
  final bool? isDisposed;
  final bool? isInPosession;
  final bool? isActive;
  final CreatedBy? createdBy;
  final MProductID? mProductID;
  final String? created;
  final AAssetGroupID? aAssetGroupID;
  final ADOrgID? aDOrgID;
  final String? value;
  final bool? isOwned;
  final String? name;
  final String? licensePlate;
  final String? serNo;
  final String? targetFrame;
  final String? description;
  final int? year;
  final ADUserID? adUserID;
  final CBPartnerID? cbPartnerID;
  final bool? isDepreciated;
  final bool? processing;
  final UpdatedBy? updatedBy;
  final ADClientID? aDClientID;
  final String? assetServiceDate;
  final String? updated;
  final bool? isFullyDepreciated;
  final MAttributeSetInstanceID? mAttributeSetInstanceID;
  final String? aAssetCreateDate;
  final AParentAssetID? aParentAssetID;
  final AAssetStatus? aAssetStatus;
  final AAssetAction? aAssetAction;
  final bool? processed;
  final String? assetActivationDate;
  final String? inventoryNo;
  final String? aAssetType;
  final bool? isAvailable;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.isDisposed,
    this.isInPosession,
    this.isActive,
    this.createdBy,
    this.mProductID,
    this.created,
    this.aAssetGroupID,
    this.aDOrgID,
    this.value,
    this.isOwned,
    this.name,
    this.licensePlate,
    this.serNo,
    this.targetFrame,
    this.description,
    this.year,
    this.cbPartnerID,
    this.adUserID,
    this.isDepreciated,
    this.processing,
    this.updatedBy,
    this.aDClientID,
    this.assetServiceDate,
    this.updated,
    this.isFullyDepreciated,
    this.mAttributeSetInstanceID,
    this.aAssetCreateDate,
    this.aParentAssetID,
    this.aAssetStatus,
    this.aAssetAction,
    this.processed,
    this.assetActivationDate,
    this.inventoryNo,
    this.aAssetType,
    this.isAvailable,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        isDisposed = json['IsDisposed'] as bool?,
        isInPosession = json['IsInPosession'] as bool?,
        isActive = json['IsActive'] as bool?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        aAssetGroupID =
            (json['A_Asset_Group_ID'] as Map<String, dynamic>?) != null
                ? AAssetGroupID.fromJson(
                    json['A_Asset_Group_ID'] as Map<String, dynamic>)
                : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        value = json['Value'] as String?,
        isOwned = json['IsOwned'] as bool?,
        name = json['Name'] as String?,
        licensePlate = json['LIT_LicensePlate'] as String?,
        serNo = json['SerNo'] as String?,
        targetFrame = json['Target_Frame'] as String?,
        description = json['Description'] as String?,
        year = json['year'] as int?,
        adUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        cbPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        isDepreciated = json['IsDepreciated'] as bool?,
        processing = json['Processing'] as bool?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        assetServiceDate = json['AssetServiceDate'] as String?,
        updated = json['Updated'] as String?,
        isFullyDepreciated = json['IsFullyDepreciated'] as bool?,
        mAttributeSetInstanceID =
            (json['M_AttributeSetInstance_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetInstanceID.fromJson(
                    json['M_AttributeSetInstance_ID'] as Map<String, dynamic>)
                : null,
        aAssetCreateDate = json['A_Asset_CreateDate'] as String?,
        aParentAssetID =
            (json['A_Parent_Asset_ID'] as Map<String, dynamic>?) != null
                ? AParentAssetID.fromJson(
                    json['A_Parent_Asset_ID'] as Map<String, dynamic>)
                : null,
        aAssetStatus = (json['A_Asset_Status'] as Map<String, dynamic>?) != null
            ? AAssetStatus.fromJson(
                json['A_Asset_Status'] as Map<String, dynamic>)
            : null,
        aAssetAction = (json['A_Asset_Action'] as Map<String, dynamic>?) != null
            ? AAssetAction.fromJson(
                json['A_Asset_Action'] as Map<String, dynamic>)
            : null,
        processed = json['Processed'] as bool?,
        assetActivationDate = json['AssetActivationDate'] as String?,
        inventoryNo = json['InventoryNo'] as String?,
        aAssetType = json['A_AssetType'] as String?,
        isAvailable = json['IsAvailable'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'IsDisposed': isDisposed,
        'IsInPosession': isInPosession,
        'IsActive': isActive,
        'CreatedBy': createdBy?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'Created': created,
        'A_Asset_Group_ID': aAssetGroupID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Value': value,
        'IsOwned': isOwned,
        'Name': name,
        'AD_User_ID': adUserID?.toJson(),
        'C_BPartner_ID': cbPartnerID?.toJson(),
        'LIT_LicensePlate': licensePlate,
        'IsDepreciated': isDepreciated,
        'Processing': processing,
        'UpdatedBy': updatedBy?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'AssetServiceDate': assetServiceDate,
        'Updated': updated,
        'IsFullyDepreciated': isFullyDepreciated,
        'M_AttributeSetInstance_ID': mAttributeSetInstanceID?.toJson(),
        'A_Asset_CreateDate': aAssetCreateDate,
        'A_Parent_Asset_ID': aParentAssetID?.toJson(),
        'A_Asset_Status': aAssetStatus?.toJson(),
        'A_Asset_Action': aAssetAction?.toJson(),
        'Processed': processed,
        'AssetActivationDate': assetActivationDate,
        'InventoryNo': inventoryNo,
        'A_AssetType': aAssetType,
        'IsAvailable': isAvailable,
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class AAssetGroupID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  AAssetGroupID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  AAssetGroupID.fromJson(Map<String, dynamic> json)
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

class MAttributeSetInstanceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MAttributeSetInstanceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MAttributeSetInstanceID.fromJson(Map<String, dynamic> json)
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

class AParentAssetID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  AParentAssetID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  AParentAssetID.fromJson(Map<String, dynamic> json)
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

class AAssetStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  AAssetStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  AAssetStatus.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as String?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class AAssetAction {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  AAssetAction({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  AAssetAction.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as String?,
        identifier = json['identifier'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}
