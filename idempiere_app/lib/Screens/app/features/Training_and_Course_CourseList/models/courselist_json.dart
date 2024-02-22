class CourseListJson {
  int? pagecount;
  int? recordssize;
  int? skiprecords;
  int? rowcount;
  List<Records>? records;

  CourseListJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  CourseListJson.fromJson(Map<String, dynamic> json) {
    pagecount = json['page-count'] as int?;
    recordssize = json['records-size'] as int?;
    skiprecords = json['skip-records'] as int?;
    rowcount = json['row-count'] as int?;
    records = (json['records'] as List?)
        ?.map((dynamic e) => Records.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['page-count'] = pagecount;
    json['records-size'] = recordssize;
    json['skip-records'] = skiprecords;
    json['row-count'] = rowcount;
    json['records'] = records?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Records {
  int? id;
  String? uid;
  String? documentNo;
  bool? isChild;
  UpdatedBy? updatedBy;
  int? currentmp;
  String? created;
  CreatedBy? createdBy;
  String? dateNextRun;
  String? dateStart;
  String? description;
  DocStatus? docStatus;
  int? interval;
  bool? isActive;
  int? lastmp;
  int? lastread;
  int? nextmp;
  ProgrammingType? programmingType;
  int? promuse;
  int? range;
  String? updated;
  ADClientID? aDClientID;
  MProductID? mProductID;
  ADOrgID? aDOrgID;
  WindowType? windowType;
  String? name;
  String? help;
  ADUserID? aDUserID;
  ADUserID? aDUser2ID;
  int? mPMaintainID2;
  String? litText1;
  String? teacherName;
  String? modelname;
  CBPartnerID? cBPartnerID;
  MPMaintainParentID? mpMaintainParentID;

  Records({
    this.id,
    this.uid,
    this.documentNo,
    this.isChild,
    this.updatedBy,
    this.currentmp,
    this.created,
    this.createdBy,
    this.dateNextRun,
    this.dateStart,
    this.description,
    this.docStatus,
    this.interval,
    this.isActive,
    this.lastmp,
    this.lastread,
    this.nextmp,
    this.programmingType,
    this.promuse,
    this.range,
    this.updated,
    this.aDClientID,
    this.mProductID,
    this.aDOrgID,
    this.windowType,
    this.name,
    this.help,
    this.aDUserID,
    this.aDUser2ID,
    this.mPMaintainID2,
    this.teacherName,
    this.litText1,
    this.modelname,
    this.cBPartnerID,
    this.mpMaintainParentID,
  });

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    uid = json['uid'] as String?;
    documentNo = json['DocumentNo'] as String?;
    isChild = json['IsChild'] as bool?;
    updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
        ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
        : null;
    currentmp = json['currentmp'] as int?;
    created = json['Created'] as String?;
    createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
        ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
        : null;
    dateNextRun = json['DateNextRun'] as String?;
    dateStart = json['DateStart'] as String?;
    description = json['Description'] as String?;
    docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
        ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
        : null;
    interval = json['Interval'] as int?;
    isActive = json['IsActive'] as bool?;
    lastmp = json['lastmp'] as int?;
    lastread = json['lastread'] as int?;
    nextmp = json['nextmp'] as int?;
    programmingType = (json['ProgrammingType'] as Map<String, dynamic>?) != null
        ? ProgrammingType.fromJson(
            json['ProgrammingType'] as Map<String, dynamic>)
        : null;
    promuse = json['promuse'] as int?;
    range = json['Range'] as int?;
    updated = json['Updated'] as String?;
    aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
        ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
        : null;
    mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
        ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
        : null;
    aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
        ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
        : null;
    windowType = (json['WindowType'] as Map<String, dynamic>?) != null
        ? WindowType.fromJson(json['WindowType'] as Map<String, dynamic>)
        : null;
    name = json['Name'] as String?;
    help = json['Help'] as String?;
    aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
        ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
        : null;
    aDUser2ID = (json['AD_User2_ID'] as Map<String, dynamic>?) != null
        ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
        : null;
    mPMaintainID2 = json['MP_Maintain_ID2'] as int?;
    teacherName = json['teacher_name'] as String?;
    litText1 = json['LIT_Text1'] as String?;
    modelname = json['model-name'] as String?;
    mpMaintainParentID =
        (json['MP_MaintainParent_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainParentID.fromJson(
                json['MP_MaintainParent_ID'] as Map<String, dynamic>)
            : null;
    cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
        ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['uid'] = uid;
    json['DocumentNo'] = documentNo;
    json['IsChild'] = isChild;
    json['UpdatedBy'] = updatedBy?.toJson();
    json['currentmp'] = currentmp;
    json['Created'] = created;
    json['CreatedBy'] = createdBy?.toJson();
    json['DateNextRun'] = dateNextRun;
    json['DateStart'] = dateStart;
    json['Description'] = description;
    json['DocStatus'] = docStatus?.toJson();
    json['Interval'] = interval;
    json['IsActive'] = isActive;
    json['lastmp'] = lastmp;
    json['lastread'] = lastread;
    json['nextmp'] = nextmp;
    json['ProgrammingType'] = programmingType?.toJson();
    json['promuse'] = promuse;
    json['Range'] = range;
    json['Updated'] = updated;
    json['AD_Client_ID'] = aDClientID?.toJson();
    json['M_Product_ID'] = mProductID?.toJson();
    json['AD_Org_ID'] = aDOrgID?.toJson();
    json['WindowType'] = windowType?.toJson();
    json['Name'] = name;
    json['Help'] = help;
    json['AD_User_ID'] = aDUserID?.toJson();
    json['MP_Maintain_ID2'] = mPMaintainID2;
    json['teacher_name'] = teacherName;
    json['LIT_Text1'] = litText1;
    json['model-name'] = modelname;
    json['C_BPartner_ID'] = cBPartnerID?.toJson();
    json['MP_MaintainParent_ID'] = mpMaintainParentID?.toJson();
    return json;
  }
}

class UpdatedBy {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  UpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  UpdatedBy.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class CreatedBy {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CreatedBy.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class DocStatus {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  DocStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocStatus.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as String?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class ProgrammingType {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  ProgrammingType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProgrammingType.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as String?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class ADClientID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADClientID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADClientID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class CBPartnerID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class MPMaintainParentID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  MPMaintainParentID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainParentID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class MProductID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  MProductID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MProductID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class ADOrgID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADOrgID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class WindowType {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  WindowType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  WindowType.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as String?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class ADUserID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADUserID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}
