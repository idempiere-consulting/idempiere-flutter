class PortalMPAdUserJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  PortalMPAdUserJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  PortalMPAdUserJson.fromJson(Map<String, dynamic> json)
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
  final String? name;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final CBPartnerID? cBPartnerID;
  final String? phone;
  final String? lastResult;
  final String? lastContact;
  final NotificationType? notificationType;
  final bool? isFullBPAccess;
  final String? value;
  final bool? isInPayroll;
  final bool? isSalesLead;
  final bool? isLocked;
  final int? failedLoginCount;
  final String? datePasswordChanged;
  final String? dateLastLogin;
  final bool? isNoPasswordReset;
  final bool? isExpired;
  final bool? isAddMailTextAutomatically;
  final bool? isNoExpire;
  final bool? isSupportUser;
  final bool? isShipTo;
  final bool? isBillTo;
  final bool? isVendorLead;
  final bool? isLegalUser;
  final bool? lITIsWebTicket;
  final String? litMobilerole;
  final String? documentNo;
  final bool? isMobileEnabled;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.name,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.cBPartnerID,
    this.phone,
    this.lastResult,
    this.lastContact,
    this.notificationType,
    this.isFullBPAccess,
    this.value,
    this.isInPayroll,
    this.isSalesLead,
    this.isLocked,
    this.failedLoginCount,
    this.datePasswordChanged,
    this.dateLastLogin,
    this.isNoPasswordReset,
    this.isExpired,
    this.isAddMailTextAutomatically,
    this.isNoExpire,
    this.isSupportUser,
    this.isShipTo,
    this.isBillTo,
    this.isVendorLead,
    this.isLegalUser,
    this.lITIsWebTicket,
    this.litMobilerole,
    this.documentNo,
    this.isMobileEnabled,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      name = json['Name'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      updated = json['Updated'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null,
      phone = json['Phone'] as String?,
      lastResult = json['LastResult'] as String?,
      lastContact = json['LastContact'] as String?,
      notificationType = (json['NotificationType'] as Map<String,dynamic>?) != null ? NotificationType.fromJson(json['NotificationType'] as Map<String,dynamic>) : null,
      isFullBPAccess = json['IsFullBPAccess'] as bool?,
      value = json['Value'] as String?,
      isInPayroll = json['IsInPayroll'] as bool?,
      isSalesLead = json['IsSalesLead'] as bool?,
      isLocked = json['IsLocked'] as bool?,
      failedLoginCount = json['FailedLoginCount'] as int?,
      datePasswordChanged = json['DatePasswordChanged'] as String?,
      dateLastLogin = json['DateLastLogin'] as String?,
      isNoPasswordReset = json['IsNoPasswordReset'] as bool?,
      isExpired = json['IsExpired'] as bool?,
      isAddMailTextAutomatically = json['IsAddMailTextAutomatically'] as bool?,
      isNoExpire = json['IsNoExpire'] as bool?,
      isSupportUser = json['IsSupportUser'] as bool?,
      isShipTo = json['IsShipTo'] as bool?,
      isBillTo = json['IsBillTo'] as bool?,
      isVendorLead = json['IsVendorLead'] as bool?,
      isLegalUser = json['isLegalUser'] as bool?,
      lITIsWebTicket = json['LIT_isWebTicket'] as bool?,
      litMobilerole = json['lit_mobilerole'] as String?,
      documentNo = json['DocumentNo'] as String?,
      isMobileEnabled = json['IsMobileEnabled'] as bool?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'Name' : name,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'IsActive' : isActive,
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'Updated' : updated,
    'UpdatedBy' : updatedBy?.toJson(),
    'C_BPartner_ID' : cBPartnerID?.toJson(),
    'Phone' : phone,
    'LastResult' : lastResult,
    'LastContact' : lastContact,
    'NotificationType' : notificationType?.toJson(),
    'IsFullBPAccess' : isFullBPAccess,
    'Value' : value,
    'IsInPayroll' : isInPayroll,
    'IsSalesLead' : isSalesLead,
    'IsLocked' : isLocked,
    'FailedLoginCount' : failedLoginCount,
    'DatePasswordChanged' : datePasswordChanged,
    'DateLastLogin' : dateLastLogin,
    'IsNoPasswordReset' : isNoPasswordReset,
    'IsExpired' : isExpired,
    'IsAddMailTextAutomatically' : isAddMailTextAutomatically,
    'IsNoExpire' : isNoExpire,
    'IsSupportUser' : isSupportUser,
    'IsShipTo' : isShipTo,
    'IsBillTo' : isBillTo,
    'IsVendorLead' : isVendorLead,
    'isLegalUser' : isLegalUser,
    'LIT_isWebTicket' : lITIsWebTicket,
    'lit_mobilerole' : litMobilerole,
    'DocumentNo' : documentNo,
    'IsMobileEnabled' : isMobileEnabled,
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}