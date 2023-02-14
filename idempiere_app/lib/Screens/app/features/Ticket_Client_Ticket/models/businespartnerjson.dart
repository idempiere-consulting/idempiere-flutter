class BusinessPartnerJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<BPRecords>? records;

  BusinessPartnerJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  BusinessPartnerJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => BPRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class BPRecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? value;
  final String? name;
  final int? salesVolume;
  final int? numberEmployees;
  final bool? isSummary;
  final ADLanguage? aDLanguage;
  final bool? isVendor;
  final bool? isCustomer;
  final bool? isProspect;
  final num? sOCreditLimit;
  final num? sOCreditUsed;
  final num? acqusitionCost;
  final num? potentialLifeTimeValue;
  final CPaymentTermID? cPaymentTermID;
  final CPaymentRuleID? cPaymentRuleID;
  final num? actualLifeTimeValue;
  final num? shareOfCustomer;
  final bool? isEmployee;
  final bool? isSalesRep;
  final MPriceListID? mPriceListID;
  final bool? isOneTime;
  final bool? isTaxExempt;
  final int? documentCopies;
  final bool? isDiscountPrinted;
  final InvoiceRule? invoiceRule;
  final DeliveryRule? deliveryRule;
  final CBPGroupID? cBPGroupID;
  final bool? sendEMail;
  final SOCreditStatus? sOCreditStatus;
  final num? shelfLifeMinPct;
  final num? flatDiscount;
  final num? totalOpenBalance;
  final bool? isPOTaxExempt;
  final bool? isManufacturer;
  final bool? is1099Vendor;
  final LITTaxTypeBPPartnerID? lITTaxTypeBPPartnerID;
  final bool? lITIsPriceListUpdatable;
  final bool? lITCardavSync;
  final int? lITKm;
  final bool? lITNoInvoiceXMLVendor;
  final bool? isValid;
  final String? litTaxID;
  final String? modelname;

  BPRecords(
      {this.id,
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
      this.isSummary,
      this.aDLanguage,
      this.isVendor,
      this.isCustomer,
      this.isProspect,
      this.sOCreditLimit,
      this.sOCreditUsed,
      this.acqusitionCost,
      this.potentialLifeTimeValue,
      this.cPaymentTermID,
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
      this.lITIsPriceListUpdatable,
      this.lITCardavSync,
      this.lITKm,
      this.lITNoInvoiceXMLVendor,
      this.isValid,
      this.litTaxID,
      this.modelname,
      this.cPaymentRuleID});

  BPRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
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
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        salesVolume = json['SalesVolume'] as int?,
        numberEmployees = json['NumberEmployees'] as int?,
        isSummary = json['IsSummary'] as bool?,
        aDLanguage = (json['AD_Language'] as Map<String, dynamic>?) != null
            ? ADLanguage.fromJson(json['AD_Language'] as Map<String, dynamic>)
            : null,
        isVendor = json['IsVendor'] as bool?,
        isCustomer = json['IsCustomer'] as bool?,
        isProspect = json['IsProspect'] as bool?,
        sOCreditLimit = json['SO_CreditLimit'] as num?,
        sOCreditUsed = json['SO_CreditUsed'] as num?,
        acqusitionCost = json['AcqusitionCost'] as num?,
        potentialLifeTimeValue = json['PotentialLifeTimeValue'] as num?,
        cPaymentTermID =
            (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
                ? CPaymentTermID.fromJson(
                    json['C_PaymentTerm_ID'] as Map<String, dynamic>)
                : null,
        cPaymentRuleID = (json['PaymentRule'] as Map<String, dynamic>?) != null
            ? CPaymentRuleID.fromJson(
                json['PaymentRule'] as Map<String, dynamic>)
            : null,
        actualLifeTimeValue = json['ActualLifeTimeValue'] as num?,
        shareOfCustomer = json['ShareOfCustomer'] as int?,
        isEmployee = json['IsEmployee'] as bool?,
        isSalesRep = json['IsSalesRep'] as bool?,
        mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
            ? MPriceListID.fromJson(
                json['M_PriceList_ID'] as Map<String, dynamic>)
            : null,
        isOneTime = json['IsOneTime'] as bool?,
        isTaxExempt = json['IsTaxExempt'] as bool?,
        documentCopies = json['DocumentCopies'] as int?,
        isDiscountPrinted = json['IsDiscountPrinted'] as bool?,
        invoiceRule = (json['InvoiceRule'] as Map<String, dynamic>?) != null
            ? InvoiceRule.fromJson(json['InvoiceRule'] as Map<String, dynamic>)
            : null,
        deliveryRule = (json['DeliveryRule'] as Map<String, dynamic>?) != null
            ? DeliveryRule.fromJson(
                json['DeliveryRule'] as Map<String, dynamic>)
            : null,
        cBPGroupID = (json['C_BP_Group_ID'] as Map<String, dynamic>?) != null
            ? CBPGroupID.fromJson(json['C_BP_Group_ID'] as Map<String, dynamic>)
            : null,
        sendEMail = json['SendEMail'] as bool?,
        sOCreditStatus =
            (json['SOCreditStatus'] as Map<String, dynamic>?) != null
                ? SOCreditStatus.fromJson(
                    json['SOCreditStatus'] as Map<String, dynamic>)
                : null,
        shelfLifeMinPct = json['ShelfLifeMinPct'] as num?,
        flatDiscount = json['FlatDiscount'] as num?,
        totalOpenBalance = json['TotalOpenBalance'] as num?,
        isPOTaxExempt = json['IsPOTaxExempt'] as bool?,
        isManufacturer = json['IsManufacturer'] as bool?,
        is1099Vendor = json['Is1099Vendor'] as bool?,
        lITTaxTypeBPPartnerID =
            (json['LIT_TaxTypeBPPartner_ID'] as Map<String, dynamic>?) != null
                ? LITTaxTypeBPPartnerID.fromJson(
                    json['LIT_TaxTypeBPPartner_ID'] as Map<String, dynamic>)
                : null,
        lITIsPriceListUpdatable = json['LIT_isPriceListUpdatable'] as bool?,
        lITCardavSync = json['LIT_CardavSync'] as bool?,
        lITKm = json['LIT_Km'] as int?,
        lITNoInvoiceXMLVendor = json['LIT_NoInvoiceXMLVendor'] as bool?,
        isValid = json['IsValid'] as bool?,
        litTaxID = json['LIT_TaxID'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Value': value,
        'Name': name,
        'SalesVolume': salesVolume,
        'NumberEmployees': numberEmployees,
        'IsSummary': isSummary,
        'AD_Language': aDLanguage?.toJson(),
        'IsVendor': isVendor,
        'IsCustomer': isCustomer,
        'IsProspect': isProspect,
        'SO_CreditLimit': sOCreditLimit,
        'SO_CreditUsed': sOCreditUsed,
        'AcqusitionCost': acqusitionCost,
        'PotentialLifeTimeValue': potentialLifeTimeValue,
        'C_PaymentTerm_ID': cPaymentTermID?.toJson(),
        'ActualLifeTimeValue': actualLifeTimeValue,
        'ShareOfCustomer': shareOfCustomer,
        'IsEmployee': isEmployee,
        'IsSalesRep': isSalesRep,
        'M_PriceList_ID': mPriceListID?.toJson(),
        'IsOneTime': isOneTime,
        'IsTaxExempt': isTaxExempt,
        'DocumentCopies': documentCopies,
        'IsDiscountPrinted': isDiscountPrinted,
        'InvoiceRule': invoiceRule?.toJson(),
        'DeliveryRule': deliveryRule?.toJson(),
        'C_BP_Group_ID': cBPGroupID?.toJson(),
        'SendEMail': sendEMail,
        'SOCreditStatus': sOCreditStatus?.toJson(),
        'ShelfLifeMinPct': shelfLifeMinPct,
        'FlatDiscount': flatDiscount,
        'TotalOpenBalance': totalOpenBalance,
        'IsPOTaxExempt': isPOTaxExempt,
        'IsManufacturer': isManufacturer,
        'Is1099Vendor': is1099Vendor,
        'LIT_TaxTypeBPPartner_ID': lITTaxTypeBPPartnerID?.toJson(),
        'LIT_isPriceListUpdatable': lITIsPriceListUpdatable,
        'LIT_CardavSync': lITCardavSync,
        'LIT_Km': lITKm,
        'LIT_NoInvoiceXMLVendor': lITNoInvoiceXMLVendor,
        'IsValid': isValid,
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

class ADLanguage {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ADLanguage({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADLanguage.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class CPaymentRuleID {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  CPaymentRuleID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPaymentRuleID.fromJson(Map<String, dynamic> json)
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

class MPriceListID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPriceListID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPriceListID.fromJson(Map<String, dynamic> json)
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

class InvoiceRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  InvoiceRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  InvoiceRule.fromJson(Map<String, dynamic> json)
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

class DeliveryRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DeliveryRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DeliveryRule.fromJson(Map<String, dynamic> json)
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

class CBPGroupID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPGroupID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPGroupID.fromJson(Map<String, dynamic> json)
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

class SOCreditStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  SOCreditStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SOCreditStatus.fromJson(Map<String, dynamic> json)
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

class LITTaxTypeBPPartnerID {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITTaxTypeBPPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITTaxTypeBPPartnerID.fromJson(Map<String, dynamic> json)
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

class LITTaxID {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITTaxID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITTaxID.fromJson(Map<String, dynamic> json)
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
