class ResourceAssignmentJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  ResourceAssignmentJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ResourceAssignmentJson.fromJson(Map<String, dynamic> json)
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
  final num? id;
  final String? uid;
  final bool? isConfirmed;
  final num? qty;
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
  final ADUserID? aDUserID;
  final num? amountAttendance;
  final String? assignDateToOriginal;
  final num? expenseAmt;
  final bool? isApproved;
  final bool? isDoNotInvoice;
  final bool? isInvoiced;
  final num? lITAmtAttDiscounted;
  final num? lITKm;
  final num? lITTransferAmtDiscounted;
  final bool? onFriday;
  final bool? onMonday;
  final bool? onSaturday;
  final bool? onSunday;
  final bool? onThursday;
  final bool? onTuesday;
  final bool? onWednesday;
  final num? transferAmount;
  final num? plannedQty;
  final num? percent;
  final bool? isPublic;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.isConfirmed,
    this.qty,
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
    this.aDUserID,
    this.amountAttendance,
    this.assignDateToOriginal,
    this.expenseAmt,
    this.isApproved,
    this.isDoNotInvoice,
    this.isInvoiced,
    this.lITAmtAttDiscounted,
    this.lITKm,
    this.lITTransferAmtDiscounted,
    this.onFriday,
    this.onMonday,
    this.onSaturday,
    this.onSunday,
    this.onThursday,
    this.onTuesday,
    this.onWednesday,
    this.transferAmount,
    this.plannedQty,
    this.percent,
    this.isPublic,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as num?,
        uid = json['uid'] as String?,
        isConfirmed = json['IsConfirmed'] as bool?,
        qty = json['Qty'] as num?,
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
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        amountAttendance = json['Amount_attendance'] as num?,
        assignDateToOriginal = json['AssignDateToOriginal'] as String?,
        expenseAmt = json['ExpenseAmt'] as num?,
        isApproved = json['IsApproved'] as bool?,
        isDoNotInvoice = json['isDoNotInvoice'] as bool?,
        isInvoiced = json['IsInvoiced'] as bool?,
        lITAmtAttDiscounted = json['LIT_Amt_attDiscounted'] as num?,
        lITKm = json['LIT_Km'] as num?,
        lITTransferAmtDiscounted = json['LIT_TransferAmtDiscounted'] as num?,
        onFriday = json['OnFriday'] as bool?,
        onMonday = json['OnMonday'] as bool?,
        onSaturday = json['OnSaturday'] as bool?,
        onSunday = json['OnSunday'] as bool?,
        onThursday = json['OnThursday'] as bool?,
        onTuesday = json['OnTuesday'] as bool?,
        onWednesday = json['OnWednesday'] as bool?,
        transferAmount = json['TransferAmount'] as num?,
        plannedQty = json['PlannedQty'] as num?,
        percent = json['Percent'] as num?,
        isPublic = json['IsPublic'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'IsConfirmed': isConfirmed,
        'Qty': qty,
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
        'AD_User_ID': aDUserID?.toJson(),
        'Amount_attendance': amountAttendance,
        'AssignDateToOriginal': assignDateToOriginal,
        'ExpenseAmt': expenseAmt,
        'IsApproved': isApproved,
        'isDoNotInvoice': isDoNotInvoice,
        'IsInvoiced': isInvoiced,
        'LIT_Amt_attDiscounted': lITAmtAttDiscounted,
        'LIT_Km': lITKm,
        'LIT_TransferAmtDiscounted': lITTransferAmtDiscounted,
        'OnFriday': onFriday,
        'OnMonday': onMonday,
        'OnSaturday': onSaturday,
        'OnSunday': onSunday,
        'OnThursday': onThursday,
        'OnTuesday': onTuesday,
        'OnWednesday': onWednesday,
        'TransferAmount': transferAmount,
        'PlannedQty': plannedQty,
        'Percent': percent,
        'IsPublic': isPublic,
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
