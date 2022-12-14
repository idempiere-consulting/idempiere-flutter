class MPMaintainContractJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  List<Records>? records;

  MPMaintainContractJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  MPMaintainContractJSON.fromJson(Map<String, dynamic> json)
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
  final String? documentNo;
  final bool? isChild;
  final UpdatedBy? updatedBy;
  final int? currentmp;
  final String? created;
  final CreatedBy? createdBy;
  String? dateNextRun;
  final DocStatus? docStatus;
  final int? interval;
  final bool? isActive;
  final int? lastmp;
  final int? lastread;
  final int? nextmp;
  final ProgrammingType? programmingType;
  final int? promuse;
  final String? updated;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  CBPartnerID? cBPartnerID;
  final int? mPMaintainID2;
  final String? modelname;
  final String? phone;
  final String? userNameBp;
  final CBPartnerLocationID? cbPartnerLocationID;
  final MPMaintainTaskID? mPMaintainTaskID;
  ADUserID? adUserID;
  final String? team;
  final String? cLocationAddress1;
  final String? cLocationCity;
  final String? cLocationPostal;
  String? litMpMaintainHelp;
  final CSalesRegionID? cSalesRegionID;
  String? latestWorkOrder;
  int? latestWorkOrderId;
  String? latestWorkOrderDocNo;
  CContractID? cContractID;

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
    this.docStatus,
    this.interval,
    this.isActive,
    this.lastmp,
    this.lastread,
    this.nextmp,
    this.programmingType,
    this.promuse,
    this.updated,
    this.aDClientID,
    this.aDOrgID,
    this.cBPartnerID,
    this.mPMaintainID2,
    this.modelname,
    this.phone,
    this.userNameBp,
    this.cbPartnerLocationID,
    this.mPMaintainTaskID,
    this.adUserID,
    this.team,
    this.cLocationAddress1,
    this.cLocationCity,
    this.cLocationPostal,
    this.litMpMaintainHelp,
    this.cSalesRegionID,
    this.latestWorkOrder,
    this.latestWorkOrderId,
    this.latestWorkOrderDocNo,
    this.cContractID,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
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
        dateNextRun = json['DateNextRun'] as String?,
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
        updated = json['Updated'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainID2 = json['MP_Maintain_ID2'] as int?,
        modelname = json['model-name'] as String?,
        phone = json['Phone'] as String?,
        userNameBp = json['bp_user_name'] as String?,
        cbPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        mPMaintainTaskID =
            (json['MP_Maintain_Task_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainTaskID.fromJson(
                    json['MP_Maintain_Task_ID'] as Map<String, dynamic>)
                : null,
        team = json['team'] as String?,
        cLocationAddress1 = json['c_location_address1'] as String?,
        cLocationCity = json['c_location_city'] as String?,
        cLocationPostal = json['c_location_postal'] as String?,
        litMpMaintainHelp = json['mp_maintain_help'] as String?,
        adUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        cSalesRegionID =
            (json['C_SalesRegion_ID'] as Map<String, dynamic>?) != null
                ? CSalesRegionID.fromJson(
                    json['C_SalesRegion_ID'] as Map<String, dynamic>)
                : null,
        latestWorkOrder = json['latest_workorder'] as String?,
        latestWorkOrderDocNo = json['latest_workorder_documentno'] as String?,
        cContractID = (json['C_Contract_ID'] as Map<String, dynamic>?) != null
            ? CContractID.fromJson(
                json['C_Contract_ID'] as Map<String, dynamic>)
            : null,
        latestWorkOrderId = json['latest_workorder_id'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'DocumentNo': documentNo,
        'IsChild': isChild,
        'UpdatedBy': updatedBy?.toJson(),
        'currentmp': currentmp,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'DateNextRun': dateNextRun,
        'DocStatus': docStatus?.toJson(),
        'Interval': interval,
        'IsActive': isActive,
        'lastmp': lastmp,
        'lastread': lastread,
        'nextmp': nextmp,
        'ProgrammingType': programmingType?.toJson(),
        'promuse': promuse,
        'Updated': updated,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'MP_Maintain_ID2': mPMaintainID2,
        'team': team,
        'c_location_address1': cLocationAddress1,
        'c_location_city': cLocationCity,
        'c_location_postal': cLocationPostal,
        'mp_maintain_help': litMpMaintainHelp,
        'model-name': modelname,
        'C_SalesRegion_ID': cSalesRegionID?.toJson(),
        'latest_workorder': latestWorkOrder,
        'latest_workorder_documentno': latestWorkOrderDocNo,
        'C_Contract_ID': cContractID?.toJson(),
        'latest_workorder_id': latestWorkOrderId,
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

class CContractID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CContractID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CContractID.fromJson(Map<String, dynamic> json)
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

class CSalesRegionID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CSalesRegionID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CSalesRegionID.fromJson(Map<String, dynamic> json)
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
  int? id;
  String? identifier;
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

class MPMaintainTaskID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainTaskID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainTaskID.fromJson(Map<String, dynamic> json)
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
