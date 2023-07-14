class EmployeeJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  EmployeeJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  EmployeeJSON.fromJson(Map<String, dynamic> json)
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
  final String? name;
  final String? description;
  final String? badgeEmployee;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? eMail;
  final String? phone;
  final String? comments;
  final NotificationType? notificationType;
  final bool? isFullBPAccess;
  final CJobID? cJobID;
  final String? value;
  final bool? isInPayroll;
  final bool? isSalesLead;
  final LeadStatus? leadStatus;
  final SalesRepID? salesRepID;
  final bool? isLocked;
  final int? failedLoginCount;
  final bool? isNoPasswordReset;
  final bool? isExpired;
  final bool? isAddMailTextAutomatically;
  final bool? isNoExpire;
  final bool? isSupportUser;
  final bool? isShipTo;
  final bool? isBillTo;
  final bool? isVendorLead;
  final bool? isLegalUser;
  final bool? lITIsMailReader;
  final bool? lITIsWebTicket;
  final String? dateNextAction;
  final String? startDate;
  final bool? lITIsPartner;
  final bool? isPublic;
  final bool? isConfirmed;
  final bool? isPartnerLead;
  final bool? isFavourite;
  final bool? isMobileEnabled;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.name,
    this.description,
    this.badgeEmployee,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.eMail,
    this.phone,
    this.comments,
    this.notificationType,
    this.isFullBPAccess,
    this.cJobID,
    this.value,
    this.isInPayroll,
    this.isSalesLead,
    this.leadStatus,
    this.salesRepID,
    this.isLocked,
    this.failedLoginCount,
    this.isNoPasswordReset,
    this.isExpired,
    this.isAddMailTextAutomatically,
    this.isNoExpire,
    this.isSupportUser,
    this.isShipTo,
    this.isBillTo,
    this.isVendorLead,
    this.isLegalUser,
    this.lITIsMailReader,
    this.lITIsWebTicket,
    this.dateNextAction,
    this.startDate,
    this.lITIsPartner,
    this.isPublic,
    this.isConfirmed,
    this.isPartnerLead,
    this.isFavourite,
    this.isMobileEnabled,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        badgeEmployee = json['LIT_BadgeEmployee'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        eMail = json['EMail'] as String?,
        phone = json['Phone'] as String?,
        comments = json['Comments'] as String?,
        notificationType =
            (json['NotificationType'] as Map<String, dynamic>?) != null
                ? NotificationType.fromJson(
                    json['NotificationType'] as Map<String, dynamic>)
                : null,
        isFullBPAccess = json['IsFullBPAccess'] as bool?,
        cJobID = (json['C_Job_ID'] as Map<String, dynamic>?) != null
            ? CJobID.fromJson(json['C_Job_ID'] as Map<String, dynamic>)
            : null,
        value = json['Value'] as String?,
        isInPayroll = json['IsInPayroll'] as bool?,
        isSalesLead = json['IsSalesLead'] as bool?,
        leadStatus = (json['LeadStatus'] as Map<String, dynamic>?) != null
            ? LeadStatus.fromJson(json['LeadStatus'] as Map<String, dynamic>)
            : null,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        isLocked = json['IsLocked'] as bool?,
        failedLoginCount = json['FailedLoginCount'] as int?,
        isNoPasswordReset = json['IsNoPasswordReset'] as bool?,
        isExpired = json['IsExpired'] as bool?,
        isAddMailTextAutomatically =
            json['IsAddMailTextAutomatically'] as bool?,
        isNoExpire = json['IsNoExpire'] as bool?,
        isSupportUser = json['IsSupportUser'] as bool?,
        isShipTo = json['IsShipTo'] as bool?,
        isBillTo = json['IsBillTo'] as bool?,
        isVendorLead = json['IsVendorLead'] as bool?,
        isLegalUser = json['isLegalUser'] as bool?,
        lITIsMailReader = json['LIT_isMailReader'] as bool?,
        lITIsWebTicket = json['LIT_isWebTicket'] as bool?,
        dateNextAction = json['DateNextAction'] as String?,
        startDate = json['StartDate'] as String?,
        lITIsPartner = json['LIT_IsPartner'] as bool?,
        isPublic = json['IsPublic'] as bool?,
        isConfirmed = json['IsConfirmed'] as bool?,
        isPartnerLead = json['isPartnerLead'] as bool?,
        isFavourite = json['IsFavourite'] as bool?,
        isMobileEnabled = json['IsMobileEnabled'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Name': name,
        'Description': description,
        'LIT_BadgeEmployee': badgeEmployee,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'EMail': eMail,
        'Phone': phone,
        'Comments': comments,
        'NotificationType': notificationType?.toJson(),
        'IsFullBPAccess': isFullBPAccess,
        'C_Job_ID': cJobID?.toJson(),
        'Value': value,
        'IsInPayroll': isInPayroll,
        'IsSalesLead': isSalesLead,
        'LeadStatus': leadStatus?.toJson(),
        'SalesRep_ID': salesRepID?.toJson(),
        'IsLocked': isLocked,
        'FailedLoginCount': failedLoginCount,
        'IsNoPasswordReset': isNoPasswordReset,
        'IsExpired': isExpired,
        'IsAddMailTextAutomatically': isAddMailTextAutomatically,
        'IsNoExpire': isNoExpire,
        'IsSupportUser': isSupportUser,
        'IsShipTo': isShipTo,
        'IsBillTo': isBillTo,
        'IsVendorLead': isVendorLead,
        'isLegalUser': isLegalUser,
        'LIT_isMailReader': lITIsMailReader,
        'LIT_isWebTicket': lITIsWebTicket,
        'DateNextAction': dateNextAction,
        'StartDate': startDate,
        'LIT_IsPartner': lITIsPartner,
        'IsPublic': isPublic,
        'IsConfirmed': isConfirmed,
        'isPartnerLead': isPartnerLead,
        'IsFavourite': isFavourite,
        'IsMobileEnabled': isMobileEnabled,
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

class NotificationType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  NotificationType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  NotificationType.fromJson(Map<String, dynamic> json)
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

class CJobID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CJobID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CJobID.fromJson(Map<String, dynamic> json)
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

class LeadStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LeadStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LeadStatus.fromJson(Map<String, dynamic> json)
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

class SalesRepID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SalesRepID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SalesRepID.fromJson(Map<String, dynamic> json)
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
