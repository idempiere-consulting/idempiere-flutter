class InvoiceJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  InvoiceJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  InvoiceJson.fromJson(Map<String, dynamic> json)
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
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? documentNo;
  final CDocTypeID? cDocTypeID;
  final DocStatus? docStatus;
  final bool? processed;
  final CBPartnerID? cBPartnerID;
  final CPaymentTermID? cPaymentTermID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final bool? isApproved;
  final bool? isTransferred;
  final CCurrencyID? cCurrencyID;
  final int? totalLines;
  final num? grandTotal;
  final String? dateAcct;
  final SalesRepID? salesRepID;
  final bool? isSOTrx;
  final CDocTypeTargetID? cDocTypeTargetID;
  final String? dateInvoiced;
  final int? chargeAmt;
  final MPriceListID? mPriceListID;
  final PaymentRule? paymentRule;
  final bool? isDiscountPrinted;
  final bool? isPrinted;
  final bool? isTaxIncluded;
  final bool? isPaid;
  final bool? sendEMail;
  final bool? isSelfService;
  final CConversionTypeID? cConversionTypeID;
  final bool? isPayScheduleValid;
  final bool? isInDispute;
  final double? processedOn;
  final bool? isFixedAssetInvoice;
  final bool? isOverrideCurrencyRate;
  final bool? lITIsNoCheckPaymentTerm;
  final int? withholdingAmt;
  final String? vATDocumentNo;
  final LITVATPeriodID? lITVATPeriodID;
  final Status? status;
  final int? taxBaseAmt;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.documentNo,
    this.cDocTypeID,
    this.docStatus,
    this.processed,
    this.cBPartnerID,
    this.cPaymentTermID,
    this.cBPartnerLocationID,
    this.isApproved,
    this.isTransferred,
    this.cCurrencyID,
    this.totalLines,
    this.grandTotal,
    this.dateAcct,
    this.salesRepID,
    this.isSOTrx,
    this.cDocTypeTargetID,
    this.dateInvoiced,
    this.chargeAmt,
    this.mPriceListID,
    this.paymentRule,
    this.isDiscountPrinted,
    this.isPrinted,
    this.isTaxIncluded,
    this.isPaid,
    this.sendEMail,
    this.isSelfService,
    this.cConversionTypeID,
    this.isPayScheduleValid,
    this.isInDispute,
    this.processedOn,
    this.isFixedAssetInvoice,
    this.isOverrideCurrencyRate,
    this.lITIsNoCheckPaymentTerm,
    this.withholdingAmt,
    this.vATDocumentNo,
    this.lITVATPeriodID,
    this.status,
    this.taxBaseAmt,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
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
        documentNo = json['DocumentNo'] as String?,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        processed = json['Processed'] as bool?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        cPaymentTermID =
            (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
                ? CPaymentTermID.fromJson(
                    json['C_PaymentTerm_ID'] as Map<String, dynamic>)
                : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        isApproved = json['IsApproved'] as bool?,
        isTransferred = json['IsTransferred'] as bool?,
        cCurrencyID = (json['C_Currency_ID'] as Map<String, dynamic>?) != null
            ? CCurrencyID.fromJson(
                json['C_Currency_ID'] as Map<String, dynamic>)
            : null,
        totalLines = json['TotalLines'] as int?,
        grandTotal = json['GrandTotal'] as int?,
        dateAcct = json['DateAcct'] as String?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        isSOTrx = json['IsSOTrx'] as bool?,
        cDocTypeTargetID =
            (json['C_DocTypeTarget_ID'] as Map<String, dynamic>?) != null
                ? CDocTypeTargetID.fromJson(
                    json['C_DocTypeTarget_ID'] as Map<String, dynamic>)
                : null,
        dateInvoiced = json['DateInvoiced'] as String?,
        chargeAmt = json['ChargeAmt'] as int?,
        mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
            ? MPriceListID.fromJson(
                json['M_PriceList_ID'] as Map<String, dynamic>)
            : null,
        paymentRule = (json['PaymentRule'] as Map<String, dynamic>?) != null
            ? PaymentRule.fromJson(json['PaymentRule'] as Map<String, dynamic>)
            : null,
        isDiscountPrinted = json['IsDiscountPrinted'] as bool?,
        isPrinted = json['IsPrinted'] as bool?,
        isTaxIncluded = json['IsTaxIncluded'] as bool?,
        isPaid = json['IsPaid'] as bool?,
        sendEMail = json['SendEMail'] as bool?,
        isSelfService = json['IsSelfService'] as bool?,
        cConversionTypeID =
            (json['C_ConversionType_ID'] as Map<String, dynamic>?) != null
                ? CConversionTypeID.fromJson(
                    json['C_ConversionType_ID'] as Map<String, dynamic>)
                : null,
        isPayScheduleValid = json['IsPayScheduleValid'] as bool?,
        isInDispute = json['IsInDispute'] as bool?,
        processedOn = json['ProcessedOn'] as double?,
        isFixedAssetInvoice = json['IsFixedAssetInvoice'] as bool?,
        isOverrideCurrencyRate = json['IsOverrideCurrencyRate'] as bool?,
        lITIsNoCheckPaymentTerm = json['LIT_isNoCheckPaymentTerm'] as bool?,
        withholdingAmt = json['WithholdingAmt'] as int?,
        vATDocumentNo = json['VATDocumentNo'] as String?,
        lITVATPeriodID =
            (json['LIT_VAT_Period_ID'] as Map<String, dynamic>?) != null
                ? LITVATPeriodID.fromJson(
                    json['LIT_VAT_Period_ID'] as Map<String, dynamic>)
                : null,
        status = (json['Status'] as Map<String, dynamic>?) != null
            ? Status.fromJson(json['Status'] as Map<String, dynamic>)
            : null,
        taxBaseAmt = json['TaxBaseAmt'] as int?,
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
        'DocumentNo': documentNo,
        'C_DocType_ID': cDocTypeID?.toJson(),
        'DocStatus': docStatus?.toJson(),
        'Processed': processed,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'C_PaymentTerm_ID': cPaymentTermID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'IsApproved': isApproved,
        'IsTransferred': isTransferred,
        'C_Currency_ID': cCurrencyID?.toJson(),
        'TotalLines': totalLines,
        'GrandTotal': grandTotal,
        'DateAcct': dateAcct,
        'SalesRep_ID': salesRepID?.toJson(),
        'IsSOTrx': isSOTrx,
        'C_DocTypeTarget_ID': cDocTypeTargetID?.toJson(),
        'DateInvoiced': dateInvoiced,
        'ChargeAmt': chargeAmt,
        'M_PriceList_ID': mPriceListID?.toJson(),
        'PaymentRule': paymentRule?.toJson(),
        'IsDiscountPrinted': isDiscountPrinted,
        'IsPrinted': isPrinted,
        'IsTaxIncluded': isTaxIncluded,
        'IsPaid': isPaid,
        'SendEMail': sendEMail,
        'IsSelfService': isSelfService,
        'C_ConversionType_ID': cConversionTypeID?.toJson(),
        'IsPayScheduleValid': isPayScheduleValid,
        'IsInDispute': isInDispute,
        'ProcessedOn': processedOn,
        'IsFixedAssetInvoice': isFixedAssetInvoice,
        'IsOverrideCurrencyRate': isOverrideCurrencyRate,
        'LIT_isNoCheckPaymentTerm': lITIsNoCheckPaymentTerm,
        'WithholdingAmt': withholdingAmt,
        'VATDocumentNo': vATDocumentNo,
        'LIT_VAT_Period_ID': lITVATPeriodID?.toJson(),
        'Status': status?.toJson(),
        'TaxBaseAmt': taxBaseAmt,
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

class CCurrencyID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CCurrencyID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CCurrencyID.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class CConversionTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CConversionTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CConversionTypeID.fromJson(Map<String, dynamic> json)
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

class LITVATPeriodID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITVATPeriodID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITVATPeriodID.fromJson(Map<String, dynamic> json)
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

class Status {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  Status({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  Status.fromJson(Map<String, dynamic> json)
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
