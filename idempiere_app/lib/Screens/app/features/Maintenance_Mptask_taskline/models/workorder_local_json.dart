class WorkOrderLocalJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  List<Records>? records;

  WorkOrderLocalJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  WorkOrderLocalJson.fromJson(Map<String, dynamic> json)
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
  final MPOTID? mPOTID;
  final ADClientID? aDClientID;
  final String? documentNo;
  final UpdatedBy? updatedBy;
  final String? created;
  final CreatedBy? createdBy;
  final String? dateTrx;
  final String? description;
  final DocStatus? docStatus;
  final bool? isActive;
  final MPMaintainID? mPMaintainID;
  final bool? processed;
  final String? updated;
  final ADOrgID? aDOrgID;
  final CDocTypeID? cDocTypeID;
  final String? mPOTUU;
  final String? dateWorkStart;
  final CBPartnerID? cBPartnerID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final JPTeamID? jPTeamID;
  final String? mpOtAdUserName;
  final int? mpOtTaskQty;
  String? mpOtTaskStatus;
  final String? cBpartnerLocationPhone;
  final String? cBpartnerLocationEmail;
  final String? cBpartnerLocationName;
  final String? cLocationAddress1;
  final String? cLocationCity;
  final String? cLocationPostal;
  final String? cCountryTrlName;
  final MPOTTaskID? mPOTTaskID;
  final MPMaintainTaskID? mPMaintainTaskID;
  final String? modelname;
  final String? phone;
  final String? phone2;
  final String? refname;
  final String? ref2name;
  final String? team;
  final String? jpToDoStartDate;
  final String? jpToDoEndDate;
  final String? jpToDoStartTime;
  final String? jpToDoEndTime;
  final String? litMpMaintainHelp;

  Records(
      {this.id,
      this.mPOTID,
      this.aDClientID,
      this.documentNo,
      this.updatedBy,
      this.created,
      this.createdBy,
      this.dateTrx,
      this.description,
      this.docStatus,
      this.isActive,
      this.mPMaintainID,
      this.processed,
      this.updated,
      this.aDOrgID,
      this.cDocTypeID,
      this.mPOTUU,
      this.dateWorkStart,
      this.cBPartnerID,
      this.cBPartnerLocationID,
      this.jPTeamID,
      this.mpOtAdUserName,
      this.mpOtTaskQty,
      this.mpOtTaskStatus,
      this.cBpartnerLocationPhone,
      this.cBpartnerLocationEmail,
      this.cBpartnerLocationName,
      this.cLocationAddress1,
      this.cLocationCity,
      this.cLocationPostal,
      this.cCountryTrlName,
      this.mPOTTaskID,
      this.mPMaintainTaskID,
      this.modelname,
      this.phone,
      this.phone2,
      this.refname,
      this.ref2name,
      this.team,
      this.jpToDoStartDate,
      this.jpToDoEndDate,
      this.jpToDoStartTime,
      this.jpToDoEndTime,
      this.litMpMaintainHelp});

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mPOTID = (json['MP_OT_ID'] as Map<String, dynamic>?) != null
            ? MPOTID.fromJson(json['MP_OT_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        documentNo = json['DocumentNo'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        dateTrx = json['DateTrx'] as String?,
        description = json['Description'] as String?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        processed = json['Processed'] as bool?,
        updated = json['Updated'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        mPOTUU = json['MP_OT_UU'] as String?,
        dateWorkStart = json['DateWorkStart'] as String?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        jPTeamID = (json['JP_Team_ID'] as Map<String, dynamic>?) != null
            ? JPTeamID.fromJson(json['JP_Team_ID'] as Map<String, dynamic>)
            : null,
        mpOtAdUserName = json['mp_ot_ad_user_name'] as String?,
        mpOtTaskQty = json['mp_ot_task_qty'] as int?,
        mpOtTaskStatus = json['mp_ot_task_status'] as String?,
        cBpartnerLocationPhone = json['c_bpartner_location_phone'] as String?,
        cBpartnerLocationEmail = json['c_bpartner_location_email'] as String?,
        cBpartnerLocationName = json['c_bpartner_location_name'] as String?,
        cLocationAddress1 = json['c_location_address1'] as String?,
        cLocationCity = json['c_location_city'] as String?,
        cLocationPostal = json['c_location_postal'] as String?,
        cCountryTrlName = json['c_country_trl_name'] as String?,
        mPOTTaskID = (json['MP_OT_Task_ID'] as Map<String, dynamic>?) != null
            ? MPOTTaskID.fromJson(json['MP_OT_Task_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainTaskID =
            (json['MP_Maintain_Task_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainTaskID.fromJson(
                    json['MP_Maintain_Task_ID'] as Map<String, dynamic>)
                : null,
        phone = json['Phone'] as String?,
        phone2 = json['Phone2'] as String?,
        refname = json['ref_name'] as String?,
        ref2name = json['ref2_name'] as String?,
        modelname = json['model-name'] as String?,
        team = json['team'] as String?,
        jpToDoStartDate = json['JP_ToDo_ScheduledStartDate'] as String?,
        jpToDoEndDate = json['JP_ToDo_ScheduledEndDate'] as String?,
        jpToDoStartTime = json['JP_ToDo_ScheduledStartTime'] as String?,
        jpToDoEndTime = json['JP_ToDo_ScheduledEndTime'] as String?,
        litMpMaintainHelp = json['mp_maintain_help'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'MP_OT_ID': mPOTID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'DocumentNo': documentNo,
        'UpdatedBy': updatedBy?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'DateTrx': dateTrx,
        'Description': description,
        'DocStatus': docStatus?.toJson(),
        'IsActive': isActive,
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'Processed': processed,
        'Updated': updated,
        'AD_Org_ID': aDOrgID?.toJson(),
        'C_DocType_ID': cDocTypeID?.toJson(),
        'MP_OT_UU': mPOTUU,
        'DateWorkStart': dateWorkStart,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'JP_Team_ID': jPTeamID?.toJson(),
        'mp_ot_ad_user_name': mpOtAdUserName,
        'mp_ot_task_qty': mpOtTaskQty,
        'mp_ot_task_status': mpOtTaskStatus,
        'c_bpartner_location_phone': cBpartnerLocationPhone,
        'c_bpartner_location_email': cBpartnerLocationEmail,
        'c_bpartner_location_name': cBpartnerLocationName,
        'c_location_address1': cLocationAddress1,
        'c_location_city': cLocationCity,
        'c_location_postal': cLocationPostal,
        'c_country_trl_name': cCountryTrlName,
        'MP_OT_Task_ID': mPOTTaskID?.toJson(),
        'MP_Maintain_Task_ID': mPMaintainTaskID?.toJson(),
        'Phone': phone,
        'Phone2': phone2,
        'ref_name': refname,
        'ref2_name': ref2name,
        'model-name': modelname,
        'team': team,
      };
}

class MPOTID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPOTID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPOTID.fromJson(Map<String, dynamic> json)
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

class CDocTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CDocTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CDocTypeID.fromJson(Map<String, dynamic> json)
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

class JPTeamID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  JPTeamID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JPTeamID.fromJson(Map<String, dynamic> json)
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

class MPOTTaskID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPOTTaskID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPOTTaskID.fromJson(Map<String, dynamic> json)
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
