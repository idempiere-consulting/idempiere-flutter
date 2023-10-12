class BusinessPartnerJson {
  int? pagecount;
  int? recordssize;
  int? skiprecords;
  int? rowcount;
  List<BPRecords>? records;

  BusinessPartnerJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  BusinessPartnerJson.fromJson(Map<String, dynamic> json) {
    pagecount = json['page-count'] as int?;
    recordssize = json['records-size'] as int?;
    skiprecords = json['skip-records'] as int?;
    rowcount = json['row-count'] as int?;
    records = (json['records'] as List?)
        ?.map((dynamic e) => BPRecords.fromJson(e as Map<String, dynamic>))
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

class BPRecords {
  int? id;
  String? uid;
  ADClientID? aDClientID;
  ADOrgID? aDOrgID;
  bool? isActive;
  String? created;
  CreatedBy? createdBy;
  String? updated;
  UpdatedBy? updatedBy;
  String? value;
  String? name;
  int? salesVolume;
  int? numberEmployees;
  String? taxID;
  bool? isSummary;
  ADLanguage? aDLanguage;
  bool? isVendor;
  bool? isCustomer;
  bool? isProspect;
  String? firstSale;
  num? sOCreditLimit;
  num? sOCreditUsed;
  num? acqusitionCost;
  num? potentialLifeTimeValue;
  CPaymentTermID? cPaymentTermID;
  PaymentRule? paymentRule;
  SalesRepID? salesRepID;
  num? actualLifeTimeValue;
  int? shareOfCustomer;
  bool? isEmployee;
  bool? isSalesRep;
  MPriceListID? mPriceListID;
  bool? isOneTime;
  bool? isTaxExempt;
  int? documentCopies;
  bool? isDiscountPrinted;
  InvoiceRule? invoiceRule;
  DeliveryRule? deliveryRule;
  CBPGroupID? cBPGroupID;
  bool? sendEMail;
  SOCreditStatus? sOCreditStatus;
  int? shelfLifeMinPct;
  int? flatDiscount;
  num? totalOpenBalance;
  bool? isPOTaxExempt;
  bool? isManufacturer;
  bool? is1099Vendor;
  LITTaxTypeBPPartnerID? lITTaxTypeBPPartnerID;
  String? lITTaxID;
  bool? lITIsPriceListUpdatable;
  String? lITNationalIdNumberID;
  bool? lITCardavSync;
  int? lITKm;
  bool? lITNoInvoiceXMLVendor;
  bool? isValid;
  RStatusID? rStatusID;
  String? modelname;

  BPRecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.value,
    this.name,
    this.salesVolume,
    this.numberEmployees,
    this.taxID,
    this.isSummary,
    this.aDLanguage,
    this.isVendor,
    this.isCustomer,
    this.isProspect,
    this.firstSale,
    this.sOCreditLimit,
    this.sOCreditUsed,
    this.acqusitionCost,
    this.potentialLifeTimeValue,
    this.cPaymentTermID,
    this.paymentRule,
    this.salesRepID,
    this.actualLifeTimeValue,
    this.shareOfCustomer,
    this.isEmployee,
    this.isSalesRep,
    this.mPriceListID,
    this.isOneTime,
    this.isTaxExempt,
    this.documentCopies,
    this.isDiscountPrinted,
    this.invoiceRule,
    this.deliveryRule,
    this.cBPGroupID,
    this.sendEMail,
    this.sOCreditStatus,
    this.shelfLifeMinPct,
    this.flatDiscount,
    this.totalOpenBalance,
    this.isPOTaxExempt,
    this.isManufacturer,
    this.is1099Vendor,
    this.lITTaxTypeBPPartnerID,
    this.lITTaxID,
    this.lITIsPriceListUpdatable,
    this.lITNationalIdNumberID,
    this.lITCardavSync,
    this.lITKm,
    this.lITNoInvoiceXMLVendor,
    this.isValid,
    this.rStatusID,
    this.modelname,
  });

  BPRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    uid = json['uid'] as String?;
    aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
        ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
        : null;
    aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
        ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
        : null;
    isActive = json['IsActive'] as bool?;
    created = json['Created'] as String?;
    createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
        ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
        : null;
    updated = json['Updated'] as String?;
    updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
        ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
        : null;
    value = json['Value'] as String?;
    name = json['Name'] as String?;
    salesVolume = json['SalesVolume'] as int?;
    numberEmployees = json['NumberEmployees'] as int?;
    taxID = json['TaxID'] as String?;
    isSummary = json['IsSummary'] as bool?;
    aDLanguage = (json['AD_Language'] as Map<String, dynamic>?) != null
        ? ADLanguage.fromJson(json['AD_Language'] as Map<String, dynamic>)
        : null;
    isVendor = json['IsVendor'] as bool?;
    isCustomer = json['IsCustomer'] as bool?;
    isProspect = json['IsProspect'] as bool?;
    firstSale = json['FirstSale'] as String?;
    sOCreditLimit = json['SO_CreditLimit'] as num?;
    sOCreditUsed = json['SO_CreditUsed'] as num?;
    acqusitionCost = json['AcqusitionCost'] as num?;
    potentialLifeTimeValue = json['PotentialLifeTimeValue'] as num?;
    cPaymentTermID = (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
        ? CPaymentTermID.fromJson(
            json['C_PaymentTerm_ID'] as Map<String, dynamic>)
        : null;
    paymentRule = (json['PaymentRule'] as Map<String, dynamic>?) != null
        ? PaymentRule.fromJson(json['PaymentRule'] as Map<String, dynamic>)
        : null;
    salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
        ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
        : null;
    actualLifeTimeValue = json['ActualLifeTimeValue'] as num?;
    shareOfCustomer = json['ShareOfCustomer'] as int?;
    isEmployee = json['IsEmployee'] as bool?;
    isSalesRep = json['IsSalesRep'] as bool?;
    mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
        ? MPriceListID.fromJson(json['M_PriceList_ID'] as Map<String, dynamic>)
        : null;
    isOneTime = json['IsOneTime'] as bool?;
    isTaxExempt = json['IsTaxExempt'] as bool?;
    documentCopies = json['DocumentCopies'] as int?;
    isDiscountPrinted = json['IsDiscountPrinted'] as bool?;
    invoiceRule = (json['InvoiceRule'] as Map<String, dynamic>?) != null
        ? InvoiceRule.fromJson(json['InvoiceRule'] as Map<String, dynamic>)
        : null;
    deliveryRule = (json['DeliveryRule'] as Map<String, dynamic>?) != null
        ? DeliveryRule.fromJson(json['DeliveryRule'] as Map<String, dynamic>)
        : null;
    cBPGroupID = (json['C_BP_Group_ID'] as Map<String, dynamic>?) != null
        ? CBPGroupID.fromJson(json['C_BP_Group_ID'] as Map<String, dynamic>)
        : null;
    sendEMail = json['SendEMail'] as bool?;
    sOCreditStatus = (json['SOCreditStatus'] as Map<String, dynamic>?) != null
        ? SOCreditStatus.fromJson(
            json['SOCreditStatus'] as Map<String, dynamic>)
        : null;
    shelfLifeMinPct = json['ShelfLifeMinPct'] as int?;
    flatDiscount = json['FlatDiscount'] as int?;
    totalOpenBalance = json['TotalOpenBalance'] as num?;
    isPOTaxExempt = json['IsPOTaxExempt'] as bool?;
    isManufacturer = json['IsManufacturer'] as bool?;
    is1099Vendor = json['Is1099Vendor'] as bool?;
    lITTaxTypeBPPartnerID =
        (json['LIT_TaxTypeBPPartner_ID'] as Map<String, dynamic>?) != null
            ? LITTaxTypeBPPartnerID.fromJson(
                json['LIT_TaxTypeBPPartner_ID'] as Map<String, dynamic>)
            : null;
    lITTaxID = json['LIT_TaxID'] as String?;
    lITIsPriceListUpdatable = json['LIT_isPriceListUpdatable'] as bool?;
    lITNationalIdNumberID = json['LIT_NationalIdNumber_ID'] as String?;
    lITCardavSync = json['LIT_CardavSync'] as bool?;
    lITKm = json['LIT_Km'] as int?;
    lITNoInvoiceXMLVendor = json['LIT_NoInvoiceXMLVendor'] as bool?;
    isValid = json['IsValid'] as bool?;
    rStatusID = (json['R_Status_ID'] as Map<String, dynamic>?) != null
        ? RStatusID.fromJson(json['R_Status_ID'] as Map<String, dynamic>)
        : null;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['uid'] = uid;
    json['AD_Client_ID'] = aDClientID?.toJson();
    json['AD_Org_ID'] = aDOrgID?.toJson();
    json['IsActive'] = isActive;
    json['Created'] = created;
    json['CreatedBy'] = createdBy?.toJson();
    json['Updated'] = updated;
    json['UpdatedBy'] = updatedBy?.toJson();
    json['Value'] = value;
    json['Name'] = name;
    json['SalesVolume'] = salesVolume;
    json['NumberEmployees'] = numberEmployees;
    json['TaxID'] = taxID;
    json['IsSummary'] = isSummary;
    json['AD_Language'] = aDLanguage?.toJson();
    json['IsVendor'] = isVendor;
    json['IsCustomer'] = isCustomer;
    json['IsProspect'] = isProspect;
    json['FirstSale'] = firstSale;
    json['SO_CreditLimit'] = sOCreditLimit;
    json['SO_CreditUsed'] = sOCreditUsed;
    json['AcqusitionCost'] = acqusitionCost;
    json['PotentialLifeTimeValue'] = potentialLifeTimeValue;
    json['C_PaymentTerm_ID'] = cPaymentTermID?.toJson();
    json['SalesRep_ID'] = salesRepID?.toJson();
    json['ActualLifeTimeValue'] = actualLifeTimeValue;
    json['ShareOfCustomer'] = shareOfCustomer;
    json['IsEmployee'] = isEmployee;
    json['IsSalesRep'] = isSalesRep;
    json['M_PriceList_ID'] = mPriceListID?.toJson();
    json['IsOneTime'] = isOneTime;
    json['IsTaxExempt'] = isTaxExempt;
    json['DocumentCopies'] = documentCopies;
    json['IsDiscountPrinted'] = isDiscountPrinted;
    json['InvoiceRule'] = invoiceRule?.toJson();
    json['DeliveryRule'] = deliveryRule?.toJson();
    json['C_BP_Group_ID'] = cBPGroupID?.toJson();
    json['SendEMail'] = sendEMail;
    json['SOCreditStatus'] = sOCreditStatus?.toJson();
    json['ShelfLifeMinPct'] = shelfLifeMinPct;
    json['FlatDiscount'] = flatDiscount;
    json['TotalOpenBalance'] = totalOpenBalance;
    json['IsPOTaxExempt'] = isPOTaxExempt;
    json['IsManufacturer'] = isManufacturer;
    json['Is1099Vendor'] = is1099Vendor;
    json['LIT_TaxTypeBPPartner_ID'] = lITTaxTypeBPPartnerID?.toJson();
    json['LIT_TaxID'] = lITTaxID;
    json['LIT_isPriceListUpdatable'] = lITIsPriceListUpdatable;
    json['LIT_NationalIdNumber_ID'] = lITNationalIdNumberID;
    json['LIT_CardavSync'] = lITCardavSync;
    json['LIT_Km'] = lITKm;
    json['LIT_NoInvoiceXMLVendor'] = lITNoInvoiceXMLVendor;
    json['IsValid'] = isValid;
    json['R_Status_ID'] = rStatusID?.toJson();
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

class ADLanguage {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  ADLanguage({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADLanguage.fromJson(Map<String, dynamic> json) {
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

class SalesRepID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  SalesRepID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SalesRepID.fromJson(Map<String, dynamic> json) {
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

class CPaymentTermID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CPaymentTermID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPaymentTermID.fromJson(Map<String, dynamic> json) {
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

class PaymentRule {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  PaymentRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PaymentRule.fromJson(Map<String, dynamic> json) {
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

class MPriceListID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  MPriceListID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPriceListID.fromJson(Map<String, dynamic> json) {
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

class InvoiceRule {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  InvoiceRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  InvoiceRule.fromJson(Map<String, dynamic> json) {
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

class DeliveryRule {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  DeliveryRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DeliveryRule.fromJson(Map<String, dynamic> json) {
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

class CBPGroupID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CBPGroupID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPGroupID.fromJson(Map<String, dynamic> json) {
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

class SOCreditStatus {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  SOCreditStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SOCreditStatus.fromJson(Map<String, dynamic> json) {
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

class LITTaxTypeBPPartnerID {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  LITTaxTypeBPPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITTaxTypeBPPartnerID.fromJson(Map<String, dynamic> json) {
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

class RStatusID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  RStatusID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RStatusID.fromJson(Map<String, dynamic> json) {
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
