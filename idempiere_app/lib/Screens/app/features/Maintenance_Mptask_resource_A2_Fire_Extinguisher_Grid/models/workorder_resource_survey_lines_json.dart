class WorkOrderResourceSurveyLinesJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  int? rowcount;
  List<Records>? records;

  WorkOrderResourceSurveyLinesJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  WorkOrderResourceSurveyLinesJson.fromJson(Map<String, dynamic> json)
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
  final String? name;
  final String? updated;
  final UpdatedBy? updatedBy;
  final LITSurveySheetsID? lITSurveySheetsID;
  final bool? lITIsField1;
  final bool? lITIsField2;
  final bool? lITIsField3;
  final bool? lITIsField4;
  final bool? lITIsField5;
  final bool? lITIsField6;
  final bool? lITIsField7;
  final bool? lITIsField8;
  final bool? lITIsField9;
  final bool? lITIsField10;
  final bool? lITIsField11;
  final bool? lITIsField12;
  final bool? lITIsField13;
  final bool? lITIsField14;
  final bool? lITIsField15;
  final bool? lITIsField16;
  final bool? lITIsField17;
  final bool? lITIsField18;
  final bool? lITIsField19;
  final bool? lITIsField20;
  final int? lineNo;
  final bool? isValid;
  final String? group1;
  final MPMaintainResourceID? mPMaintainResourceID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.isActive,
    this.name,
    this.updated,
    this.updatedBy,
    this.lITSurveySheetsID,
    this.lITIsField1,
    this.lITIsField2,
    this.lITIsField3,
    this.lITIsField4,
    this.lITIsField5,
    this.lITIsField6,
    this.lITIsField7,
    this.lITIsField8,
    this.lITIsField9,
    this.lITIsField10,
    this.lITIsField11,
    this.lITIsField12,
    this.lITIsField13,
    this.lITIsField14,
    this.lITIsField15,
    this.lITIsField16,
    this.lITIsField17,
    this.lITIsField18,
    this.lITIsField19,
    this.lITIsField20,
    this.lineNo,
    this.isValid,
    this.group1,
    this.mPMaintainResourceID,
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
        name = json['Name'] as String?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        lITSurveySheetsID =
            (json['LIT_SurveySheets_ID'] as Map<String, dynamic>?) != null
                ? LITSurveySheetsID.fromJson(
                    json['LIT_SurveySheets_ID'] as Map<String, dynamic>)
                : null,
        lITIsField1 = json['LIT_IsField1'] as bool?,
        lITIsField2 = json['LIT_IsField2'] as bool?,
        lITIsField3 = json['LIT_IsField3'] as bool?,
        lITIsField4 = json['LIT_IsField4'] as bool?,
        lITIsField5 = json['LIT_IsField5'] as bool?,
        lITIsField6 = json['LIT_IsField6'] as bool?,
        lITIsField7 = json['LIT_IsField7'] as bool?,
        lITIsField8 = json['LIT_IsField8'] as bool?,
        lITIsField9 = json['LIT_IsField9'] as bool?,
        lITIsField10 = json['LIT_IsField10'] as bool?,
        lITIsField11 = json['LIT_IsField11'] as bool?,
        lITIsField12 = json['LIT_IsField12'] as bool?,
        lITIsField13 = json['LIT_IsField13'] as bool?,
        lITIsField14 = json['LIT_IsField14'] as bool?,
        lITIsField15 = json['LIT_IsField15'] as bool?,
        lITIsField16 = json['LIT_IsField16'] as bool?,
        lITIsField17 = json['LIT_IsField17'] as bool?,
        lITIsField18 = json['LIT_IsField18'] as bool?,
        lITIsField19 = json['LIT_IsField19'] as bool?,
        lITIsField20 = json['LIT_IsField20'] as bool?,
        lineNo = json['LineNo'] as int?,
        isValid = json['IsValid'] as bool?,
        group1 = json['Group1'] as String?,
        mPMaintainResourceID =
            (json['MP_Maintain_Resource_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainResourceID.fromJson(
                    json['MP_Maintain_Resource_ID'] as Map<String, dynamic>)
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
        'Name': name,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'LIT_SurveySheets_ID': lITSurveySheetsID?.toJson(),
        'LIT_IsField1': lITIsField1,
        'LIT_IsField2': lITIsField2,
        'LIT_IsField3': lITIsField3,
        'LIT_IsField4': lITIsField4,
        'LIT_IsField5': lITIsField5,
        'LIT_IsField6': lITIsField6,
        'LIT_IsField7': lITIsField7,
        'LIT_IsField8': lITIsField8,
        'LIT_IsField9': lITIsField9,
        'LIT_IsField10': lITIsField10,
        'LIT_IsField11': lITIsField11,
        'LIT_IsField12': lITIsField12,
        'LIT_IsField13': lITIsField13,
        'LIT_IsField14': lITIsField14,
        'LIT_IsField15': lITIsField15,
        'LIT_IsField16': lITIsField16,
        'LIT_IsField17': lITIsField17,
        'LIT_IsField18': lITIsField18,
        'LIT_IsField19': lITIsField19,
        'LIT_IsField20': lITIsField20,
        'LineNo': lineNo,
        'IsValid': isValid,
        'Group1': group1,
        'MP_Maintain_Resource_ID': mPMaintainResourceID?.toJson(),
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

class LITSurveySheetsID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITSurveySheetsID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITSurveySheetsID.fromJson(Map<String, dynamic> json)
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

class LITIsField1 {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITIsField1({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITIsField1.fromJson(Map<String, dynamic> json)
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
