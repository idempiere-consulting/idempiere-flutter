class CourseStudentJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  CourseStudentJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  CourseStudentJson.fromJson(Map<String, dynamic> json)
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
  final UpdatedBy? updatedBy;
  final ADOrgID? aDOrgID;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final String? updated;
  final ADClientID? aDClientID;
  final String? value;
  final bool? lITIsField1;
  final bool? lITIsField2;
  final bool? isValid;
  final MPMaintainID? mPMaintainID;
  final bool? isConfirmed;
  final ADUserID? aDUserID;
  final String? modelname;
  final String? name;
  final String? surname;
  final String? birthcity;
  final String? birthday;
  final String? email;
  final String? position;
  final String? taxcode;

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
    this.lITIsField1,
    this.lITIsField2,
    this.isValid,
    this.mPMaintainID,
    this.isConfirmed,
    this.aDUserID,
    this.modelname,
    this.name,
    this.surname,
    this.birthcity,
    this.birthday,
    this.email,
    this.position,
    this.taxcode,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      updated = json['Updated'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      value = json['Value'] as String?,
      lITIsField1 = json['LIT_IsField1'] as bool?,
      lITIsField2 = json['LIT_IsField2'] as bool?,
      isValid = json['IsValid'] as bool?,
      mPMaintainID = (json['MP_Maintain_ID'] as Map<String,dynamic>?) != null ? MPMaintainID.fromJson(json['MP_Maintain_ID'] as Map<String,dynamic>) : null,
      isConfirmed = json['IsConfirmed'] as bool?,
      aDUserID = (json['AD_User_ID'] as Map<String,dynamic>?) != null ? ADUserID.fromJson(json['AD_User_ID'] as Map<String,dynamic>) : null,
      modelname = json['model-name'] as String?,
      name = json['Name'] as String?,
      surname = json['SurName'] as String?,
      birthcity = json['BirthCity'] as String?,
      birthday = json['Birthday'] as String?,
      email = json['EMailUser'] as String?,
      position = json['Description'] as String?,
      taxcode = json['Note'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'UpdatedBy' : updatedBy?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'IsActive' : isActive,
    'Updated' : updated,
    'AD_Client_ID' : aDClientID?.toJson(),
    'Value' : value,
    'LIT_IsField1' : lITIsField1,
    'LIT_IsField2' : lITIsField2,
    'IsValid' : isValid,
    'MP_Maintain_ID' : mPMaintainID?.toJson(),
    'IsConfirmed' : isConfirmed,
    'AD_User_ID' : aDUserID?.toJson(),
    'model-name' : modelname,
    'Name': name,
    'SurName': surname,
    'BirthCity': birthcity,
    'Birthday': birthday,
    'EMailUser': email,
    'Description': position,
    'Note': taxcode,
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