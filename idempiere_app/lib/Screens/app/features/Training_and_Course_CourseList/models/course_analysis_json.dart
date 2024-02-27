class CourseAnalysisJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  CourseAnalysisJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  CourseAnalysisJSON.fromJson(Map<String, dynamic> json)
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
  final MPMaintainResourceID? mPMaintainResourceID;
  final UpdatedBy? updatedBy;
  final ADOrgID? aDOrgID;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final String? updated;
  final ADClientID? aDClientID;
  final String? mPMaintainResourceUU;
  final String? value;
  final String? name;
  final String? description;
  final bool? lITIsField2;
  final bool? isValid;
  final String? surName;
  final bool? isConfirmed;
  final ADUserID? aDUserID;
  final MPMaintainID? mPMaintainID;
  final String? birthday;
  final String? birthCity;
  final String? eMailUser;
  final CBPartnerID? cBPartnerID;
  final LITResourceStatus? lITResourceStatus;
  final bool? lITIsField1;
  final bool? lITIsDoNotUpdate;
  final String? lITBackupData;
  final int? length;
  final int? width;
  final int? weightedAmt;
  final int? height;
  final bool? isSold;
  final String? password;
  final String? lITCorrectAnswerValue;
  final String? valueNumber;
  final LITSurveyType? lITSurveyType;
  final int? lineNo;
  final String? modelname;

  Records({
    this.id,
    this.mPMaintainResourceID,
    this.updatedBy,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.isActive,
    this.updated,
    this.aDClientID,
    this.mPMaintainResourceUU,
    this.value,
    this.name,
    this.description,
    this.lITIsField2,
    this.isValid,
    this.surName,
    this.isConfirmed,
    this.aDUserID,
    this.mPMaintainID,
    this.birthday,
    this.birthCity,
    this.eMailUser,
    this.cBPartnerID,
    this.lITResourceStatus,
    this.lITIsField1,
    this.lITIsDoNotUpdate,
    this.lITBackupData,
    this.length,
    this.width,
    this.weightedAmt,
    this.height,
    this.isSold,
    this.password,
    this.lITCorrectAnswerValue,
    this.valueNumber,
    this.lITSurveyType,
    this.lineNo,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mPMaintainResourceID =
            (json['MP_Maintain_Resource_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainResourceID.fromJson(
                    json['MP_Maintain_Resource_ID'] as Map<String, dynamic>)
                : null,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
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
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainResourceUU = json['MP_Maintain_Resource_UU'] as String?,
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        lITIsField2 = json['LIT_IsField2'] as bool?,
        isValid = json['IsValid'] as bool?,
        surName = json['SurName'] as String?,
        isConfirmed = json['IsConfirmed'] as bool?,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        birthday = json['Birthday'] as String?,
        birthCity = json['BirthCity'] as String?,
        eMailUser = json['EMailUser'] as String?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        lITResourceStatus =
            (json['LIT_ResourceStatus'] as Map<String, dynamic>?) != null
                ? LITResourceStatus.fromJson(
                    json['LIT_ResourceStatus'] as Map<String, dynamic>)
                : null,
        lITIsField1 = json['LIT_IsField1'] as bool?,
        lITIsDoNotUpdate = json['LIT_IsDoNotUpdate'] as bool?,
        lITBackupData = json['LIT_BackupData'] as String?,
        length = json['Length'] as int?,
        width = json['Width'] as int?,
        weightedAmt = json['WeightedAmt'] as int?,
        height = json['Height'] as int?,
        isSold = json['IsSold'] as bool?,
        password = json['Password'] as String?,
        lITCorrectAnswerValue = json['LIT_CorrectAnswerValue'] as String?,
        valueNumber = json['ValueNumber'] as String?,
        lITSurveyType =
            (json['LIT_SurveyType'] as Map<String, dynamic>?) != null
                ? LITSurveyType.fromJson(
                    json['LIT_SurveyType'] as Map<String, dynamic>)
                : null,
        lineNo = json['LineNo'] as int?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'MP_Maintain_Resource_ID': mPMaintainResourceID?.toJson(),
        'UpdatedBy': updatedBy?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'Updated': updated,
        'AD_Client_ID': aDClientID?.toJson(),
        'MP_Maintain_Resource_UU': mPMaintainResourceUU,
        'Value': value,
        'Name': name,
        'Description': description,
        'LIT_IsField2': lITIsField2,
        'IsValid': isValid,
        'SurName': surName,
        'IsConfirmed': isConfirmed,
        'AD_User_ID': aDUserID?.toJson(),
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'Birthday': birthday,
        'BirthCity': birthCity,
        'EMailUser': eMailUser,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'LIT_ResourceStatus': lITResourceStatus?.toJson(),
        'LIT_IsField1': lITIsField1,
        'LIT_IsDoNotUpdate': lITIsDoNotUpdate,
        'LIT_BackupData': lITBackupData,
        'Length': length,
        'Width': width,
        'WeightedAmt': weightedAmt,
        'Height': height,
        'IsSold': isSold,
        'Password': password,
        'LIT_CorrectAnswerValue': lITCorrectAnswerValue,
        'ValueNumber': valueNumber,
        'LIT_SurveyType': lITSurveyType?.toJson(),
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

class MPMaintainID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainID.fromJson(Map<String, dynamic> json)
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

class LITResourceStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITResourceStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITResourceStatus.fromJson(Map<String, dynamic> json)
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
