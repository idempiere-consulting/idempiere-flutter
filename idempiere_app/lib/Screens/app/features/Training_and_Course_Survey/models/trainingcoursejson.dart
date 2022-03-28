class TrainingCourseJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  TrainingCourseJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  TrainingCourseJson.fromJson(Map<String, dynamic> json)
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
  final MPMaintainID? mPMaintainID;
  final String? documentNo;
  final bool? isChild;
  final UpdatedBy? updatedBy;
  final int? currentmp;
  final String? created;
  final CreatedBy? createdBy;
  final String? dateLastOT;
  final String? dateLastRun;
  final String? dateNextRun;
  final String? description;
  final DocStatus? docStatus;
  final int? interval;
  final bool? isActive;
  final int? lastmp;
  final int? lastread;
  final int? nextmp;
  final ProgrammingType? programmingType;
  final int? promuse;
  final PriorityRule? priorityRule;
  final int? range;
  final String? updated;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? mPMaintainUU;
  final SResourceID? sResourceID;
  final CBPartnerID? cBPartnerID;
  final WindowType? windowType;
  final CBPartnerLocationID? cBPartnerLocationID;
  final BillBPartnerID? billBPartnerID;
  final BillLocationID? billLocationID;
  final MProductID? mProductID;
  final ADUserID? aDUserID;
  final String? modelname;

  Records({
    this.id,
    this.mPMaintainID,
    this.documentNo,
    this.isChild,
    this.updatedBy,
    this.currentmp,
    this.created,
    this.createdBy,
    this.dateLastOT,
    this.dateLastRun,
    this.dateNextRun,
    this.description,
    this.docStatus,
    this.interval,
    this.isActive,
    this.lastmp,
    this.lastread,
    this.nextmp,
    this.programmingType,
    this.promuse,
    this.priorityRule,
    this.range,
    this.updated,
    this.aDClientID,
    this.aDOrgID,
    this.mPMaintainUU,
    this.sResourceID,
    this.cBPartnerID,
    this.windowType,
    this.cBPartnerLocationID,
    this.billBPartnerID,
    this.billLocationID,
    this.mProductID,
    this.aDUserID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        documentNo = json['DocumentNo'] as String?,
        isChild = json['IsChild'] as bool?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        currentmp = json['currentmp'] as int?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        dateLastOT = json['DateLastOT'] as String?,
        dateLastRun = json['DateLastRun'] as String?,
        dateNextRun = json['DateNextRun'] as String?,
        description = json['Description'] as String?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        interval = json['Interval'] as int?,
        isActive = json['IsActive'] as bool?,
        lastmp = json['lastmp'] as int?,
        lastread = json['lastread'] as int?,
        nextmp = json['nextmp'] as int?,
        programmingType =
            (json['ProgrammingType'] as Map<String, dynamic>?) != null
                ? ProgrammingType.fromJson(
                    json['ProgrammingType'] as Map<String, dynamic>)
                : null,
        promuse = json['promuse'] as int?,
        priorityRule = (json['PriorityRule'] as Map<String, dynamic>?) != null
            ? PriorityRule.fromJson(
                json['PriorityRule'] as Map<String, dynamic>)
            : null,
        range = json['Range'] as int?,
        updated = json['Updated'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainUU = json['MP_Maintain_UU'] as String?,
        sResourceID = (json['S_Resource_ID'] as Map<String, dynamic>?) != null
            ? SResourceID.fromJson(
                json['S_Resource_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        windowType = (json['WindowType'] as Map<String, dynamic>?) != null
            ? WindowType.fromJson(json['WindowType'] as Map<String, dynamic>)
            : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        billBPartnerID =
            (json['Bill_BPartner_ID'] as Map<String, dynamic>?) != null
                ? BillBPartnerID.fromJson(
                    json['Bill_BPartner_ID'] as Map<String, dynamic>)
                : null,
        billLocationID =
            (json['Bill_Location_ID'] as Map<String, dynamic>?) != null
                ? BillLocationID.fromJson(
                    json['Bill_Location_ID'] as Map<String, dynamic>)
                : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'DocumentNo': documentNo,
        'IsChild': isChild,
        'UpdatedBy': updatedBy?.toJson(),
        'currentmp': currentmp,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'DateLastOT': dateLastOT,
        'DateLastRun': dateLastRun,
        'DateNextRun': dateNextRun,
        'Description': description,
        'DocStatus': docStatus?.toJson(),
        'Interval': interval,
        'IsActive': isActive,
        'lastmp': lastmp,
        'lastread': lastread,
        'nextmp': nextmp,
        'ProgrammingType': programmingType?.toJson(),
        'promuse': promuse,
        'PriorityRule': priorityRule?.toJson(),
        'Range': range,
        'Updated': updated,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'MP_Maintain_UU': mPMaintainUU,
        'S_Resource_ID': sResourceID?.toJson(),
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'WindowType': windowType?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'Bill_BPartner_ID': billBPartnerID?.toJson(),
        'Bill_Location_ID': billLocationID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
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

class DocStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocStatus.fromJson(Map<String, dynamic> json)
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

class ProgrammingType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ProgrammingType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProgrammingType.fromJson(Map<String, dynamic> json)
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

class PriorityRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  PriorityRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PriorityRule.fromJson(Map<String, dynamic> json)
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

class SResourceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SResourceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SResourceID.fromJson(Map<String, dynamic> json)
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

class WindowType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  WindowType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  WindowType.fromJson(Map<String, dynamic> json)
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

class CBPartnerLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerLocationID.fromJson(Map<String, dynamic> json)
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

class BillBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BillBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BillBPartnerID.fromJson(Map<String, dynamic> json)
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

class BillLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BillLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BillLocationID.fromJson(Map<String, dynamic> json)
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
