class OpenItemJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<OARecords>? records;

  OpenItemJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  OpenItemJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => OARecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class OARecords {
  final int? id;
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final String? documentNo;
  final CInvoiceID? cInvoiceID;
  final COrderID? cOrderID;
  final CBPartnerID? cBPartnerID;
  final bool? isSOTrx;
  final String? dateInvoiced;
  final String? dateAcct;
  final int? netDays;
  final String? dueDate;
  final int? daysDue;
  final String? discountDate;
  final num? discountAmt;
  final double? grandTotal;
  final num? paidAmt;
  final double? openAmt;
  final CCurrencyID? cCurrencyID;
  final CPaymentTermID? cPaymentTermID;
  final bool? isPayScheduleValid;
  final CInvoicePayScheduleID? cInvoicePayScheduleID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final CDocTypeID? cDocTypeID;
  final CDocTypeTargetID? cDocTypeTargetID;
  final num? chargeAmt;
  final String? created;
  final CreatedBy? createdBy;
  final String? dateOrdered;
  final DocStatus? docStatus;
  final bool? isActive;
  final bool? isApproved;
  final bool? isDiscountPrinted;
  final bool? isInDispute;
  final bool? isPaid;
  final bool? isPrinted;
  final bool? isSelfService;
  final bool? isTaxIncluded;
  final bool? isTransferred;
  final MPriceListID? mPriceListID;
  final bool? paymentRule;
  final bool? posted;
  final double? processedOn;
  final SalesRepID? salesRepID;
  final bool? sendEMail;
  final double? totalLines;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? modelname;

  OARecords({
    this.id,
    this.aDOrgID,
    this.aDClientID,
    this.documentNo,
    this.cInvoiceID,
    this.cOrderID,
    this.cBPartnerID,
    this.isSOTrx,
    this.dateInvoiced,
    this.dateAcct,
    this.netDays,
    this.dueDate,
    this.daysDue,
    this.discountDate,
    this.discountAmt,
    this.grandTotal,
    this.paidAmt,
    this.openAmt,
    this.cCurrencyID,
    this.cPaymentTermID,
    this.isPayScheduleValid,
    this.cInvoicePayScheduleID,
    this.cBPartnerLocationID,
    this.cDocTypeID,
    this.cDocTypeTargetID,
    this.chargeAmt,
    this.created,
    this.createdBy,
    this.dateOrdered,
    this.docStatus,
    this.isActive,
    this.isApproved,
    this.isDiscountPrinted,
    this.isInDispute,
    this.isPaid,
    this.isPrinted,
    this.isSelfService,
    this.isTaxIncluded,
    this.isTransferred,
    this.mPriceListID,
    this.paymentRule,
    this.posted,
    this.processedOn,
    this.salesRepID,
    this.sendEMail,
    this.totalLines,
    this.updated,
    this.updatedBy,
    this.modelname,
  });

  OARecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        documentNo = json['DocumentNo'] as String?,
        cInvoiceID = (json['C_Invoice_ID'] as Map<String, dynamic>?) != null
            ? CInvoiceID.fromJson(json['C_Invoice_ID'] as Map<String, dynamic>)
            : null,
        cOrderID = (json['C_Order_ID'] as Map<String, dynamic>?) != null
            ? COrderID.fromJson(json['C_Order_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        isSOTrx = json['IsSOTrx'] as bool?,
        dateInvoiced = json['DateInvoiced'] as String?,
        dateAcct = json['DateAcct'] as String?,
        netDays = json['NetDays'] as int?,
        dueDate = json['DueDate'] as String?,
        daysDue = json['DaysDue'] as int?,
        discountDate = json['DiscountDate'] as String?,
        discountAmt = json['DiscountAmt'] as num?,
        grandTotal = json['GrandTotal'] as double?,
        paidAmt = json['PaidAmt'] as num?,
        openAmt = json['OpenAmt'] as double?,
        cCurrencyID = (json['C_Currency_ID'] as Map<String, dynamic>?) != null
            ? CCurrencyID.fromJson(
                json['C_Currency_ID'] as Map<String, dynamic>)
            : null,
        cPaymentTermID =
            (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
                ? CPaymentTermID.fromJson(
                    json['C_PaymentTerm_ID'] as Map<String, dynamic>)
                : null,
        isPayScheduleValid = json['IsPayScheduleValid'] as bool?,
        cInvoicePayScheduleID =
            (json['C_InvoicePaySchedule_ID'] as Map<String, dynamic>?) != null
                ? CInvoicePayScheduleID.fromJson(
                    json['C_InvoicePaySchedule_ID'] as Map<String, dynamic>)
                : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        cDocTypeTargetID =
            (json['C_DocTypeTarget_ID'] as Map<String, dynamic>?) != null
                ? CDocTypeTargetID.fromJson(
                    json['C_DocTypeTarget_ID'] as Map<String, dynamic>)
                : null,
        chargeAmt = json['ChargeAmt'] as num?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        dateOrdered = json['DateOrdered'] as String?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        isApproved = json['IsApproved'] as bool?,
        isDiscountPrinted = json['IsDiscountPrinted'] as bool?,
        isInDispute = json['IsInDispute'] as bool?,
        isPaid = json['IsPaid'] as bool?,
        isPrinted = json['IsPrinted'] as bool?,
        isSelfService = json['IsSelfService'] as bool?,
        isTaxIncluded = json['IsTaxIncluded'] as bool?,
        isTransferred = json['IsTransferred'] as bool?,
        mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
            ? MPriceListID.fromJson(
                json['M_PriceList_ID'] as Map<String, dynamic>)
            : null,
        paymentRule = json['PaymentRule'] as bool?,
        posted = json['Posted'] as bool?,
        processedOn = json['ProcessedOn'] as double?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        sendEMail = json['SendEMail'] as bool?,
        totalLines = json['TotalLines'] as double?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'DocumentNo': documentNo,
        'C_Invoice_ID': cInvoiceID?.toJson(),
        'C_Order_ID': cOrderID?.toJson(),
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'IsSOTrx': isSOTrx,
        'DateInvoiced': dateInvoiced,
        'DateAcct': dateAcct,
        'NetDays': netDays,
        'DueDate': dueDate,
        'DaysDue': daysDue,
        'DiscountDate': discountDate,
        'DiscountAmt': discountAmt,
        'GrandTotal': grandTotal,
        'PaidAmt': paidAmt,
        'OpenAmt': openAmt,
        'C_Currency_ID': cCurrencyID?.toJson(),
        'C_PaymentTerm_ID': cPaymentTermID?.toJson(),
        'IsPayScheduleValid': isPayScheduleValid,
        'C_InvoicePaySchedule_ID': cInvoicePayScheduleID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'C_DocType_ID': cDocTypeID?.toJson(),
        'C_DocTypeTarget_ID': cDocTypeTargetID?.toJson(),
        'ChargeAmt': chargeAmt,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'DateOrdered': dateOrdered,
        'DocStatus': docStatus?.toJson(),
        'IsActive': isActive,
        'IsApproved': isApproved,
        'IsDiscountPrinted': isDiscountPrinted,
        'IsInDispute': isInDispute,
        'IsPaid': isPaid,
        'IsPrinted': isPrinted,
        'IsSelfService': isSelfService,
        'IsTaxIncluded': isTaxIncluded,
        'IsTransferred': isTransferred,
        'M_PriceList_ID': mPriceListID?.toJson(),
        'PaymentRule': paymentRule,
        'Posted': posted,
        'ProcessedOn': processedOn,
        'SalesRep_ID': salesRepID?.toJson(),
        'SendEMail': sendEMail,
        'TotalLines': totalLines,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
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

class CInvoiceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CInvoiceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CInvoiceID.fromJson(Map<String, dynamic> json)
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

class COrderID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  COrderID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  COrderID.fromJson(Map<String, dynamic> json)
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

class CInvoicePayScheduleID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CInvoicePayScheduleID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CInvoicePayScheduleID.fromJson(Map<String, dynamic> json)
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
