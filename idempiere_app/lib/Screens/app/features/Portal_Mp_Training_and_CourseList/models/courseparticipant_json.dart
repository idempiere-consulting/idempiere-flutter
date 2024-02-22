class CourseParticipantJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  CourseParticipantJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  CourseParticipantJSON.fromJson(Map<String, dynamic> json)
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
  final UpdatedBy? updatedBy;
  final ADOrgID? aDOrgID;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final String? updated;
  final ADClientID? aDClientID;
  final String? value;
  final String? name;
  final bool? lITIsField1;
  final bool? lITIsField2;
  final bool? isValid;
  final String? surName;
  final MPMaintainID? mPMaintainID;
  final bool? isConfirmed;
  final ADUserID? aDUserID;
  final String? birthday;
  final String? birthCity;
  final String? eMailUser;
  final LITResourceStatus? lITResourceStatus;
  final bool? lITIsDoNotUpdate;
  final String? lITBackupData;
  final int? length;
  final int? width;
  final int? weightedAmt;
  final int? height;
  final bool? isSold;
  final String? description;
  final String? note;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.updatedBy,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.isActive,
    this.updated,
    this.aDClientID,
    this.value,
    this.name,
    this.lITIsField1,
    this.lITIsField2,
    this.isValid,
    this.surName,
    this.mPMaintainID,
    this.isConfirmed,
    this.aDUserID,
    this.birthday,
    this.birthCity,
    this.eMailUser,
    this.lITResourceStatus,
    this.lITIsDoNotUpdate,
    this.lITBackupData,
    this.length,
    this.width,
    this.weightedAmt,
    this.height,
    this.isSold,
    this.description,
    this.note,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
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
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        lITIsField1 = json['LIT_IsField1'] as bool?,
        lITIsField2 = json['LIT_IsField2'] as bool?,
        isValid = json['IsValid'] as bool?,
        surName = json['SurName'] as String?,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        isConfirmed = json['IsConfirmed'] as bool?,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        birthday = json['Birthday'] as String?,
        birthCity = json['BirthCity'] as String?,
        eMailUser = json['EMailUser'] as String?,
        lITResourceStatus =
            (json['LIT_ResourceStatus'] as Map<String, dynamic>?) != null
                ? LITResourceStatus.fromJson(
                    json['LIT_ResourceStatus'] as Map<String, dynamic>)
                : null,
        lITIsDoNotUpdate = json['LIT_IsDoNotUpdate'] as bool?,
        lITBackupData = json['LIT_BackupData'] as String?,
        length = json['Length'] as int?,
        width = json['Width'] as int?,
        weightedAmt = json['WeightedAmt'] as int?,
        height = json['Height'] as int?,
        isSold = json['IsSold'] as bool?,
        description = json['Description'] as String?,
        note = json['Note'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'UpdatedBy': updatedBy?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'Updated': updated,
        'AD_Client_ID': aDClientID?.toJson(),
        'Value': value,
        'Name': name,
        'LIT_IsField1': lITIsField1,
        'LIT_IsField2': lITIsField2,
        'IsValid': isValid,
        'SurName': surName,
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'IsConfirmed': isConfirmed,
        'AD_User_ID': aDUserID?.toJson(),
        'Birthday': birthday,
        'BirthCity': birthCity,
        'EMailUser': eMailUser,
        'LIT_ResourceStatus': lITResourceStatus?.toJson(),
        'LIT_IsDoNotUpdate': lITIsDoNotUpdate,
        'LIT_BackupData': lITBackupData,
        'Length': length,
        'Width': width,
        'WeightedAmt': weightedAmt,
        'Height': height,
        'IsSold': isSold,
        'Description': description,
        'Note': note,
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
