class PaymentJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  PaymentJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  PaymentJson.fromJson(Map<String, dynamic> json)
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
  final String? description;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final CreditCardType? creditCardType;
  final int? creditCardExpMM;
  final int? creditCardExpYY;
  final bool? isApproved;
  final bool? processed;
  final bool? isReconciled;
  final CBankAccountID? cBankAccountID;
  final num? taxAmt;
  final RAvsAddr? rAvsAddr;
  final RAvsZip? rAvsZip;
  final TrxType? trxType;
  final TenderType? tenderType;
  final CCurrencyID? cCurrencyID;
  final num? discountAmt;
  final CDocTypeID? cDocTypeID;
  final num? payAmt;
  final CBPartnerID? cBPartnerID;
  final String? dateTrx;
  final bool? isAllocated;
  final String? documentNo;
  final bool? isOnline;
  final DocStatus? docStatus;
  final bool? isReceipt;
  final num? writeOffAmt;
  final num? overUnderAmt;
  final bool? isOverUnderPayment;
  final bool? isSelfService;
  final bool? isDelayedCapture;
  final int? chargeAmt;
  final bool? rCVV2Match;
  final CConversionTypeID? cConversionTypeID;
  final String? dateAcct;
  final bool? isPrepayment;
  final num? processedOn;
  final bool? isVoided;
  final bool? isOverrideCurrencyRate;
  final String? modelname;
  final CInvoiceID? cInvoiceID;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.description,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.creditCardType,
    this.creditCardExpMM,
    this.creditCardExpYY,
    this.isApproved,
    this.processed,
    this.isReconciled,
    this.cBankAccountID,
    this.taxAmt,
    this.rAvsAddr,
    this.rAvsZip,
    this.trxType,
    this.tenderType,
    this.cCurrencyID,
    this.discountAmt,
    this.cDocTypeID,
    this.payAmt,
    this.cBPartnerID,
    this.dateTrx,
    this.isAllocated,
    this.documentNo,
    this.cInvoiceID,
    this.isOnline,
    this.docStatus,
    this.isReceipt,
    this.writeOffAmt,
    this.overUnderAmt,
    this.isOverUnderPayment,
    this.isSelfService,
    this.isDelayedCapture,
    this.chargeAmt,
    this.rCVV2Match,
    this.cConversionTypeID,
    this.dateAcct,
    this.isPrepayment,
    this.processedOn,
    this.isVoided,
    this.isOverrideCurrencyRate,
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
        description = json['Description'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        creditCardType =
            (json['CreditCardType'] as Map<String, dynamic>?) != null
                ? CreditCardType.fromJson(
                    json['CreditCardType'] as Map<String, dynamic>)
                : null,
        creditCardExpMM = json['CreditCardExpMM'] as int?,
        creditCardExpYY = json['CreditCardExpYY'] as int?,
        isApproved = json['IsApproved'] as bool?,
        processed = json['Processed'] as bool?,
        isReconciled = json['IsReconciled'] as bool?,
        cBankAccountID =
            (json['C_BankAccount_ID'] as Map<String, dynamic>?) != null
                ? CBankAccountID.fromJson(
                    json['C_BankAccount_ID'] as Map<String, dynamic>)
                : null,
        taxAmt = json['TaxAmt'] as num?,
        rAvsAddr = (json['R_AvsAddr'] as Map<String, dynamic>?) != null
            ? RAvsAddr.fromJson(json['R_AvsAddr'] as Map<String, dynamic>)
            : null,
        rAvsZip = (json['R_AvsZip'] as Map<String, dynamic>?) != null
            ? RAvsZip.fromJson(json['R_AvsZip'] as Map<String, dynamic>)
            : null,
        trxType = (json['TrxType'] as Map<String, dynamic>?) != null
            ? TrxType.fromJson(json['TrxType'] as Map<String, dynamic>)
            : null,
        tenderType = (json['TenderType'] as Map<String, dynamic>?) != null
            ? TenderType.fromJson(json['TenderType'] as Map<String, dynamic>)
            : null,
        cCurrencyID = (json['C_Currency_ID'] as Map<String, dynamic>?) != null
            ? CCurrencyID.fromJson(
                json['C_Currency_ID'] as Map<String, dynamic>)
            : null,
        discountAmt = json['DiscountAmt'] as num?,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        payAmt = json['PayAmt'] as num?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        dateTrx = json['DateTrx'] as String?,
        isAllocated = json['IsAllocated'] as bool?,
        documentNo = json['DocumentNo'] as String?,
        cInvoiceID = (json['C_Invoice_ID'] as Map<String, dynamic>?) != null
            ? CInvoiceID.fromJson(json['C_Invoice_ID'] as Map<String, dynamic>)
            : null,
        isOnline = json['IsOnline'] as bool?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        isReceipt = json['IsReceipt'] as bool?,
        writeOffAmt = json['WriteOffAmt'] as num?,
        overUnderAmt = json['OverUnderAmt'] as num?,
        isOverUnderPayment = json['IsOverUnderPayment'] as bool?,
        isSelfService = json['IsSelfService'] as bool?,
        isDelayedCapture = json['IsDelayedCapture'] as bool?,
        chargeAmt = json['ChargeAmt'] as int?,
        rCVV2Match = json['R_CVV2Match'] as bool?,
        cConversionTypeID =
            (json['C_ConversionType_ID'] as Map<String, dynamic>?) != null
                ? CConversionTypeID.fromJson(
                    json['C_ConversionType_ID'] as Map<String, dynamic>)
                : null,
        dateAcct = json['DateAcct'] as String?,
        isPrepayment = json['IsPrepayment'] as bool?,
        processedOn = json['ProcessedOn'] as num?,
        isVoided = json['IsVoided'] as bool?,
        isOverrideCurrencyRate = json['IsOverrideCurrencyRate'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'Description': description,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'CreditCardType': creditCardType?.toJson(),
        'CreditCardExpMM': creditCardExpMM,
        'CreditCardExpYY': creditCardExpYY,
        'IsApproved': isApproved,
        'Processed': processed,
        'IsReconciled': isReconciled,
        'C_BankAccount_ID': cBankAccountID?.toJson(),
        'TaxAmt': taxAmt,
        'R_AvsAddr': rAvsAddr?.toJson(),
        'R_AvsZip': rAvsZip?.toJson(),
        'TrxType': trxType?.toJson(),
        'TenderType': tenderType?.toJson(),
        'C_Currency_ID': cCurrencyID?.toJson(),
        'DiscountAmt': discountAmt,
        'C_DocType_ID': cDocTypeID?.toJson(),
        'PayAmt': payAmt,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'DateTrx': dateTrx,
        'IsAllocated': isAllocated,
        'DocumentNo': documentNo,
        'C_Invoice_ID': cInvoiceID?.toJson(),
        'IsOnline': isOnline,
        'DocStatus': docStatus?.toJson(),
        'IsReceipt': isReceipt,
        'WriteOffAmt': writeOffAmt,
        'OverUnderAmt': overUnderAmt,
        'IsOverUnderPayment': isOverUnderPayment,
        'IsSelfService': isSelfService,
        'IsDelayedCapture': isDelayedCapture,
        'ChargeAmt': chargeAmt,
        'R_CVV2Match': rCVV2Match,
        'C_ConversionType_ID': cConversionTypeID?.toJson(),
        'DateAcct': dateAcct,
        'IsPrepayment': isPrepayment,
        'ProcessedOn': processedOn,
        'IsVoided': isVoided,
        'IsOverrideCurrencyRate': isOverrideCurrencyRate,
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

class CreditCardType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  CreditCardType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CreditCardType.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class RAvsAddr {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  RAvsAddr({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RAvsAddr.fromJson(Map<String, dynamic> json)
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

class RAvsZip {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  RAvsZip({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RAvsZip.fromJson(Map<String, dynamic> json)
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

class TrxType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  TrxType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  TrxType.fromJson(Map<String, dynamic> json)
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

class TenderType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  TenderType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  TenderType.fromJson(Map<String, dynamic> json)
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
