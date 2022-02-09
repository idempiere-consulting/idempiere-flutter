class ResAssignmentJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  ResAssignmentJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ResAssignmentJson.fromJson(Map<String, dynamic> json)
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
  final bool? isConfirmed;
  final int? qty;
  final String? assignDateTo;
  final String? assignDateFrom;
  final SResourceID? sResourceID;
  final UpdatedBy? updatedBy;
  final String? updated;
  final CreatedBy? createdBy;
  final String? created;
  final bool? isActive;
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final String? name;
  final String? description;
  final int? amountAttendance;
  final CBPartnerID? cBPartnerID;
  final String? documentNo;
  final bool? isApproved;
  final bool? isDoNotInvoice;
  final bool? isInvoiced;
  final int? lITAmtAttDiscounted;
  final int? lITExtraCost;
  final int? lITExtraHour;
  final int? lITHolidayCost;
  final int? lITHolidayHour;
  final int? lITHolidayNightCost;
  final int? lITHolidaynighthour;
  final int? lITNightCost;
  final int? lITNightExtraCost;
  final int? lITNightExtraHour;
  final int? lITNightHour;
  final int? lITStandardCost;
  final int? lITStandardHour;
  final bool? onFriday;
  final bool? onMonday;
  final bool? onSaturday;
  final bool? onSunday;
  final bool? onThursday;
  final bool? onTuesday;
  final bool? onWednesday;
  final String? qtyEffectiveTime;
  final CContactActivityID? cContactActivityID;
  final int? percent;
  final bool? isPublic;
  final Priority? priority;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.isConfirmed,
    this.qty,
    this.assignDateTo,
    this.assignDateFrom,
    this.sResourceID,
    this.updatedBy,
    this.updated,
    this.createdBy,
    this.created,
    this.isActive,
    this.aDOrgID,
    this.aDClientID,
    this.name,
    this.description,
    this.amountAttendance,
    this.cBPartnerID,
    this.documentNo,
    this.isApproved,
    this.isDoNotInvoice,
    this.isInvoiced,
    this.lITAmtAttDiscounted,
    this.lITExtraCost,
    this.lITExtraHour,
    this.lITHolidayCost,
    this.lITHolidayHour,
    this.lITHolidayNightCost,
    this.lITHolidaynighthour,
    this.lITNightCost,
    this.lITNightExtraCost,
    this.lITNightExtraHour,
    this.lITNightHour,
    this.lITStandardCost,
    this.lITStandardHour,
    this.onFriday,
    this.onMonday,
    this.onSaturday,
    this.onSunday,
    this.onThursday,
    this.onTuesday,
    this.onWednesday,
    this.qtyEffectiveTime,
    this.cContactActivityID,
    this.percent,
    this.isPublic,
    this.priority,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        isConfirmed = json['IsConfirmed'] as bool?,
        qty = json['Qty'] as int?,
        assignDateTo = json['AssignDateTo'] as String?,
        assignDateFrom = json['AssignDateFrom'] as String?,
        sResourceID = (json['S_Resource_ID'] as Map<String, dynamic>?) != null
            ? SResourceID.fromJson(
                json['S_Resource_ID'] as Map<String, dynamic>)
            : null,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        isActive = json['IsActive'] as bool?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        amountAttendance = json['Amount_attendance'] as int?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        documentNo = json['DocumentNo'] as String?,
        isApproved = json['IsApproved'] as bool?,
        isDoNotInvoice = json['isDoNotInvoice'] as bool?,
        isInvoiced = json['IsInvoiced'] as bool?,
        lITAmtAttDiscounted = json['LIT_Amt_attDiscounted'] as int?,
        lITExtraCost = json['LIT_ExtraCost'] as int?,
        lITExtraHour = json['LIT_ExtraHour'] as int?,
        lITHolidayCost = json['LIT_HolidayCost'] as int?,
        lITHolidayHour = json['LIT_HolidayHour'] as int?,
        lITHolidayNightCost = json['LIT_HolidayNightCost'] as int?,
        lITHolidaynighthour = json['LIT_Holidaynighthour'] as int?,
        lITNightCost = json['LIT_NightCost'] as int?,
        lITNightExtraCost = json['LIT_NightExtraCost'] as int?,
        lITNightExtraHour = json['LIT_NightExtraHour'] as int?,
        lITNightHour = json['LIT_NightHour'] as int?,
        lITStandardCost = json['LIT_StandardCost'] as int?,
        lITStandardHour = json['LIT_StandardHour'] as int?,
        onFriday = json['OnFriday'] as bool?,
        onMonday = json['OnMonday'] as bool?,
        onSaturday = json['OnSaturday'] as bool?,
        onSunday = json['OnSunday'] as bool?,
        onThursday = json['OnThursday'] as bool?,
        onTuesday = json['OnTuesday'] as bool?,
        onWednesday = json['OnWednesday'] as bool?,
        qtyEffectiveTime = json['QtyEffectiveTime'] as String?,
        cContactActivityID =
            (json['C_ContactActivity_ID'] as Map<String, dynamic>?) != null
                ? CContactActivityID.fromJson(
                    json['C_ContactActivity_ID'] as Map<String, dynamic>)
                : null,
        percent = json['Percent'] as int?,
        isPublic = json['IsPublic'] as bool?,
        priority = (json['Priority'] as Map<String, dynamic>?) != null
            ? Priority.fromJson(json['Priority'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'IsConfirmed': isConfirmed,
        'Qty': qty,
        'AssignDateTo': assignDateTo,
        'AssignDateFrom': assignDateFrom,
        'S_Resource_ID': sResourceID?.toJson(),
        'UpdatedBy': updatedBy?.toJson(),
        'Updated': updated,
        'CreatedBy': createdBy?.toJson(),
        'Created': created,
        'IsActive': isActive,
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'Name': name,
        'Description': description,
        'Amount_attendance': amountAttendance,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'DocumentNo': documentNo,
        'IsApproved': isApproved,
        'isDoNotInvoice': isDoNotInvoice,
        'IsInvoiced': isInvoiced,
        'LIT_Amt_attDiscounted': lITAmtAttDiscounted,
        'LIT_ExtraCost': lITExtraCost,
        'LIT_ExtraHour': lITExtraHour,
        'LIT_HolidayCost': lITHolidayCost,
        'LIT_HolidayHour': lITHolidayHour,
        'LIT_HolidayNightCost': lITHolidayNightCost,
        'LIT_Holidaynighthour': lITHolidaynighthour,
        'LIT_NightCost': lITNightCost,
        'LIT_NightExtraCost': lITNightExtraCost,
        'LIT_NightExtraHour': lITNightExtraHour,
        'LIT_NightHour': lITNightHour,
        'LIT_StandardCost': lITStandardCost,
        'LIT_StandardHour': lITStandardHour,
        'OnFriday': onFriday,
        'OnMonday': onMonday,
        'OnSaturday': onSaturday,
        'OnSunday': onSunday,
        'OnThursday': onThursday,
        'OnTuesday': onTuesday,
        'OnWednesday': onWednesday,
        'QtyEffectiveTime': qtyEffectiveTime,
        'C_ContactActivity_ID': cContactActivityID?.toJson(),
        'Percent': percent,
        'IsPublic': isPublic,
        'Priority': priority?.toJson(),
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

class CContactActivityID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CContactActivityID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CContactActivityID.fromJson(Map<String, dynamic> json)
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

class Priority {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  Priority({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  Priority.fromJson(Map<String, dynamic> json)
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
