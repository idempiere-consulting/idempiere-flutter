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
  final int? lineNo;
  final bool? isValid;
  final String? group1;
  final String? dateValue;
  final String? valueNumber;
  final String? lITText1;
  final String? lITText2;
  final String? lITText3;
  final String? lITText4;
  final String? lITText5;
  final String? lITCorrectAnswerValue;
  final MPMaintainResourceID? mPMaintainResourceID;
  final LITSurveyType? lITSurveyType;
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
    this.lineNo,
    this.isValid,
    this.group1,
    this.dateValue,
    this.valueNumber,
    this.lITText1,
    this.lITText2,
    this.lITText3,
    this.lITText4,
    this.lITText5,
    this.lITCorrectAnswerValue,
    this.mPMaintainResourceID,
    this.lITSurveyType,
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
        lineNo = json['LineNo'] as int?,
        isValid = json['IsValid'] as bool?,
        group1 = json['Group1'] as String?,
        dateValue = json['DateValue'] as String?,
        valueNumber = json['ValueNumber'] as String?,
        lITText1 = json['LIT_Text1'] as String?,
        lITText2 = json['LIT_Text2'] as String?,
        lITText3 = json['LIT_Text3'] as String?,
        lITText4 = json['LIT_Text4'] as String?,
        lITText5 = json['LIT_Text5'] as String?,
        lITCorrectAnswerValue = json['LIT_CorrectAnswerValue'] as String?,
        mPMaintainResourceID =
            (json['MP_Maintain_Resource_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainResourceID.fromJson(
                    json['MP_Maintain_Resource_ID'] as Map<String, dynamic>)
                : null,
        lITSurveyType =
            (json['LIT_SurveyType'] as Map<String, dynamic>?) != null
                ? LITSurveyType.fromJson(
                    json['LIT_SurveyType'] as Map<String, dynamic>)
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
        'LineNo': lineNo,
        'IsValid': isValid,
        'Group1': group1,
        'DateValue': dateValue,
        'ValueNumber': valueNumber,
        'LIT_Text1': lITText1,
        'LIT_Text2': lITText2,
        'LIT_Text3': lITText3,
        'LIT_Text4': lITText4,
        'LIT_Text5': lITText5,
        'MP_Maintain_Resource_ID': mPMaintainResourceID?.toJson(),
        'LIT_SurveyType': lITSurveyType?.toJson(),
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

class LITSurveyType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITSurveyType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITSurveyType.fromJson(Map<String, dynamic> json)
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
