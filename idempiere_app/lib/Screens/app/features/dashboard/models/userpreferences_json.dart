class UserPreferencesJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  UserPreferencesJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  UserPreferencesJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => Records.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class Records {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final String? updated;
  final UpdatedBy? updatedBy;
  final ADUserID? aDUserID;
  final bool? autoCommit;
  final bool? autoNew;
  final int? automaticDecimalPlacesForAmoun;
  final bool? toggleOnDoubleClick;
  final bool? isDetailedZoomAcross;
  final bool? isUseSimilarTo;
  final ViewFindResult? viewFindResult;
  final MInventoryLineCChargeID? mInventoryLineCChargeID;
  final LITDocTypeProdDeclarationID? lITDocTypeProdDeclarationID;
  final LITDocTypeProdPickingID? lITDocTypeProdPickingID;
  final LITDocTypeProdPickDeclID? lITDocTypeProdPickDeclID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.isActive,
    this.updated,
    this.updatedBy,
    this.aDUserID,
    this.autoCommit,
    this.autoNew,
    this.automaticDecimalPlacesForAmoun,
    this.toggleOnDoubleClick,
    this.isDetailedZoomAcross,
    this.isUseSimilarTo,
    this.viewFindResult,
    this.mInventoryLineCChargeID,
    this.lITDocTypeProdDeclarationID,
    this.lITDocTypeProdPickingID,
    this.lITDocTypeProdPickDeclID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
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
        isActive = json['IsActive'] as bool?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        autoCommit = json['AutoCommit'] as bool?,
        autoNew = json['AutoNew'] as bool?,
        automaticDecimalPlacesForAmoun =
            json['AutomaticDecimalPlacesForAmoun'] as int?,
        toggleOnDoubleClick = json['ToggleOnDoubleClick'] as bool?,
        isDetailedZoomAcross = json['IsDetailedZoomAcross'] as bool?,
        isUseSimilarTo = json['IsUseSimilarTo'] as bool?,
        viewFindResult =
            (json['ViewFindResult'] as Map<String, dynamic>?) != null
                ? ViewFindResult.fromJson(
                    json['ViewFindResult'] as Map<String, dynamic>)
                : null,
        mInventoryLineCChargeID =
            (json['M_InventoryLine_C_Charge_ID'] as Map<String, dynamic>?) !=
                    null
                ? MInventoryLineCChargeID.fromJson(
                    json['M_InventoryLine_C_Charge_ID'] as Map<String, dynamic>)
                : null,
        lITDocTypeProdDeclarationID = (json['LIT_DocTypeProdDeclaration_ID']
                    as Map<String, dynamic>?) !=
                null
            ? LITDocTypeProdDeclarationID.fromJson(
                json['LIT_DocTypeProdDeclaration_ID'] as Map<String, dynamic>)
            : null,
        lITDocTypeProdPickingID =
            (json['LIT_DocTypeProdPicking_ID'] as Map<String, dynamic>?) != null
                ? LITDocTypeProdPickingID.fromJson(
                    json['LIT_DocTypeProdPicking_ID'] as Map<String, dynamic>)
                : null,
        lITDocTypeProdPickDeclID =
            (json['LIT_DocTypeProdPickDecl_ID'] as Map<String, dynamic>?) !=
                    null
                ? LITDocTypeProdPickDeclID.fromJson(
                    json['LIT_DocTypeProdPickDecl_ID'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
        'AutoCommit': autoCommit,
        'AutoNew': autoNew,
        'AutomaticDecimalPlacesForAmoun': automaticDecimalPlacesForAmoun,
        'ToggleOnDoubleClick': toggleOnDoubleClick,
        'IsDetailedZoomAcross': isDetailedZoomAcross,
        'IsUseSimilarTo': isUseSimilarTo,
        'ViewFindResult': viewFindResult?.toJson(),
        'M_InventoryLine_C_Charge_ID': mInventoryLineCChargeID?.toJson(),
        'LIT_DocTypeProdDeclaration_ID': lITDocTypeProdDeclarationID?.toJson(),
        'LIT_DocTypeProdPicking_ID': lITDocTypeProdPickingID?.toJson(),
        'LIT_DocTypeProdPickDecl_ID': lITDocTypeProdPickDeclID?.toJson(),
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

class ViewFindResult {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ViewFindResult({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ViewFindResult.fromJson(Map<String, dynamic> json)
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

class MInventoryLineCChargeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MInventoryLineCChargeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MInventoryLineCChargeID.fromJson(Map<String, dynamic> json)
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

class LITDocTypeProdDeclarationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITDocTypeProdDeclarationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITDocTypeProdDeclarationID.fromJson(Map<String, dynamic> json)
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

class LITDocTypeProdPickingID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITDocTypeProdPickingID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITDocTypeProdPickingID.fromJson(Map<String, dynamic> json)
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

class LITDocTypeProdPickDeclID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITDocTypeProdPickDeclID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITDocTypeProdPickDeclID.fromJson(Map<String, dynamic> json)
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
