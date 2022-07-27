class PortalMPContractJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  PortalMPContractJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  PortalMPContractJson.fromJson(Map<String, dynamic> json)
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
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final CBPartnerID? cBPartnerID;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final bool? isConfirmed;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? validtodate;
  final String? validfromdate;
  final String? contractsigndate;
  final FrequencyType? frequencyType;
  final String? frequencyNextDate;
  final CDocTypeTargetID? cDocTypeTargetID;
  final bool? isSOTrx;
  final PaymentRule? paymentRule;
  final CPaymentTermID? cPaymentTermID;
  final WindowType? windowType;
  final String? documentNo;
  final CBankAccountID? cBankAccountID;
  final bool? lITIsDateCompetence;
  final String? modelname;
  final String? name;
  final String? description;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.cBPartnerID,
    this.created,
    this.createdBy,
    this.isActive,
    this.isConfirmed,
    this.updated,
    this.updatedBy,
    this.validtodate,
    this.validfromdate,
    this.contractsigndate,
    this.frequencyType,
    this.frequencyNextDate,
    this.cDocTypeTargetID,
    this.isSOTrx,
    this.paymentRule,
    this.cPaymentTermID,
    this.windowType,
    this.documentNo,
    this.cBankAccountID,
    this.lITIsDateCompetence,
    this.modelname,
    this.name,
    this.description,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      isConfirmed = json['IsConfirmed'] as bool?,
      updated = json['Updated'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      validtodate = json['validtodate'] as String?,
      validfromdate = json['validfromdate'] as String?,
      contractsigndate = json['contractsigndate'] as String?,
      frequencyType = (json['FrequencyType'] as Map<String,dynamic>?) != null ? FrequencyType.fromJson(json['FrequencyType'] as Map<String,dynamic>) : null,
      frequencyNextDate = json['FrequencyNextDate'] as String?,
      cDocTypeTargetID = (json['C_DocTypeTarget_ID'] as Map<String,dynamic>?) != null ? CDocTypeTargetID.fromJson(json['C_DocTypeTarget_ID'] as Map<String,dynamic>) : null,
      isSOTrx = json['IsSOTrx'] as bool?,
      paymentRule = (json['PaymentRule'] as Map<String,dynamic>?) != null ? PaymentRule.fromJson(json['PaymentRule'] as Map<String,dynamic>) : null,
      cPaymentTermID = (json['C_PaymentTerm_ID'] as Map<String,dynamic>?) != null ? CPaymentTermID.fromJson(json['C_PaymentTerm_ID'] as Map<String,dynamic>) : null,
      windowType = (json['WindowType'] as Map<String,dynamic>?) != null ? WindowType.fromJson(json['WindowType'] as Map<String,dynamic>) : null,
      documentNo = json['DocumentNo'] as String?,
      cBankAccountID = (json['C_BankAccount_ID'] as Map<String,dynamic>?) != null ? CBankAccountID.fromJson(json['C_BankAccount_ID'] as Map<String,dynamic>) : null,
      lITIsDateCompetence = json['LIT_IsDateCompetence'] as bool?,
      modelname = json['model-name'] as String?,
      name = json['Name'] as String?,
      description = json['Description'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'C_BPartner_ID' : cBPartnerID?.toJson(),
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'IsActive' : isActive,
    'IsConfirmed' : isConfirmed,
    'Updated' : updated,
    'UpdatedBy' : updatedBy?.toJson(),
    'validtodate' : validtodate,
    'validfromdate' : validfromdate,
    'contractsigndate' : contractsigndate,
    'FrequencyType' : frequencyType?.toJson(),
    'FrequencyNextDate' : frequencyNextDate,
    'C_DocTypeTarget_ID' : cDocTypeTargetID?.toJson(),
    'IsSOTrx' : isSOTrx,
    'PaymentRule' : paymentRule?.toJson(),
    'C_PaymentTerm_ID' : cPaymentTermID?.toJson(),
    'WindowType' : windowType?.toJson(),
    'DocumentNo' : documentNo,
    'C_BankAccount_ID' : cBankAccountID?.toJson(),
    'LIT_IsDateCompetence' : lITIsDateCompetence,
    'model-name' : modelname,
    'Name': name,
    'Description': description,
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

class FrequencyType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  FrequencyType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  FrequencyType.fromJson(Map<String, dynamic> json)
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

class CDocTypeTargetID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CDocTypeTargetID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CDocTypeTargetID.fromJson(Map<String, dynamic> json)
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

class PaymentRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  PaymentRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PaymentRule.fromJson(Map<String, dynamic> json)
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

class CPaymentTermID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CPaymentTermID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPaymentTermID.fromJson(Map<String, dynamic> json)
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class CBankAccountID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBankAccountID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBankAccountID.fromJson(Map<String, dynamic> json)
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