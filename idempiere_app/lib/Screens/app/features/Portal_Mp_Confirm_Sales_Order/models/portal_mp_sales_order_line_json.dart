class PortalMPSalesOrderLineJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  PortalMPSalesOrderLineJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  PortalMPSalesOrderLineJson.fromJson(Map<String, dynamic> json)
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
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? documentNo;
  final DocStatus? docStatus;
  final CDocTypeID? cDocTypeID;
  final CDocTypeTargetID? cDocTypeTargetID;
  final bool? isApproved;
  final bool? isCreditApproved;
  final bool? isDelivered;
  final bool? isInvoiced;
  final bool? isPrinted;
  final bool? isTransferred;
  final String? dateOrdered;
  final String? datePromised;
  final String? dateAcct;
  final SalesRepID? salesRepID;
  final CPaymentTermID? cPaymentTermID;
  final CCurrencyID? cCurrencyID;
  final InvoiceRule? invoiceRule;
  final num? freightAmt;
  final DeliveryViaRule? deliveryViaRule;
  final PriorityRule? priorityRule;
  final num? totalLines;
  final num? grandTotal;
  final MWarehouseID? mWarehouseID;
  final MPriceListID? mPriceListID;
  final CBPartnerID? cBPartnerID;
  final num? chargeAmt;
  final bool? processed;
  final CBPartnerLocationID? cBPartnerLocationID;
  final bool? isSOTrx;
  final DeliveryRule? deliveryRule;
  final FreightCostRule? freightCostRule;
  final PaymentRule? paymentRule;
  final bool? isDiscountPrinted;
  final bool? isTaxIncluded;
  final bool? isSelected;
  final bool? sendEMail;
  final BillBPartnerID? billBPartnerID;
  final BillLocationID? billLocationID;
  final bool? isSelfService;
  final CConversionTypeID? cConversionTypeID;
  final bool? isDropShip;
  final num? volume;
  final num? weight;
  final num? amountTendered;
  final num? amountRefunded;
  final num? processedOn;
  final bool? isPayScheduleValid;
  final bool? isPriviledgedRate;
  final LITTermsAndConditionsID? lITTermsAndConditionsID;
  final String? lITRevisionDate;
  final String? revision;
  final String? note;
  final bool? lITIsNoCheckPaymentTerm;
  final bool? isOrderTemplate;
  final Status? status;
  final num? noPackages;
  final String? lITFEPAIPA;
  final LITLastOrderID? lITLastOrderID;
  final String? lITLastDateOrdered;
  final bool? lITIsDisplaySuppProduct;
  final bool? lITIsWriteCalendarNow;
  final String? modelname;
  final MProductID? mProductID;
  final int? line;
  final String? name;
  final num? lineNetAmt;
  final String? description;
  final num? priceEntered;
  final num? priceList;
  final CTaxID? cTaxID;

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
    this.docStatus,
    this.cDocTypeID,
    this.cDocTypeTargetID,
    this.isApproved,
    this.isCreditApproved,
    this.isDelivered,
    this.isInvoiced,
    this.isPrinted,
    this.isTransferred,
    this.dateOrdered,
    this.datePromised,
    this.dateAcct,
    this.salesRepID,
    this.cPaymentTermID,
    this.cCurrencyID,
    this.invoiceRule,
    this.freightAmt,
    this.deliveryViaRule,
    this.priorityRule,
    this.totalLines,
    this.grandTotal,
    this.mWarehouseID,
    this.mPriceListID,
    this.cBPartnerID,
    this.chargeAmt,
    this.processed,
    this.cBPartnerLocationID,
    this.isSOTrx,
    this.deliveryRule,
    this.freightCostRule,
    this.paymentRule,
    this.isDiscountPrinted,
    this.isTaxIncluded,
    this.isSelected,
    this.sendEMail,
    this.billBPartnerID,
    this.billLocationID,
    this.isSelfService,
    this.cConversionTypeID,
    this.isDropShip,
    this.volume,
    this.weight,
    this.amountTendered,
    this.amountRefunded,
    this.processedOn,
    this.isPayScheduleValid,
    this.isPriviledgedRate,
    this.lITTermsAndConditionsID,
    this.lITRevisionDate,
    this.revision,
    this.note,
    this.lITIsNoCheckPaymentTerm,
    this.isOrderTemplate,
    this.status,
    this.noPackages,
    this.lITFEPAIPA,
    this.lITLastOrderID,
    this.lITLastDateOrdered,
    this.lITIsDisplaySuppProduct,
    this.lITIsWriteCalendarNow,
    this.modelname,
    this.mProductID,
    this.line,
    this.name,
    this.lineNetAmt,
    this.description,
    this.priceEntered,
    this.priceList,
    this.cTaxID,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      updated = json['Updated'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      documentNo = json['DocumentNo'] as String?,
      docStatus = (json['DocStatus'] as Map<String,dynamic>?) != null ? DocStatus.fromJson(json['DocStatus'] as Map<String,dynamic>) : null,
      cDocTypeID = (json['C_DocType_ID'] as Map<String,dynamic>?) != null ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String,dynamic>) : null,
      cDocTypeTargetID = (json['C_DocTypeTarget_ID'] as Map<String,dynamic>?) != null ? CDocTypeTargetID.fromJson(json['C_DocTypeTarget_ID'] as Map<String,dynamic>) : null,
      isApproved = json['IsApproved'] as bool?,
      isCreditApproved = json['IsCreditApproved'] as bool?,
      isDelivered = json['IsDelivered'] as bool?,
      isInvoiced = json['IsInvoiced'] as bool?,
      isPrinted = json['IsPrinted'] as bool?,
      isTransferred = json['IsTransferred'] as bool?,
      dateOrdered = json['DateOrdered'] as String?,
      datePromised = json['DatePromised'] as String?,
      dateAcct = json['DateAcct'] as String?,
      salesRepID = (json['SalesRep_ID'] as Map<String,dynamic>?) != null ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String,dynamic>) : null,
      cPaymentTermID = (json['C_PaymentTerm_ID'] as Map<String,dynamic>?) != null ? CPaymentTermID.fromJson(json['C_PaymentTerm_ID'] as Map<String,dynamic>) : null,
      cCurrencyID = (json['C_Currency_ID'] as Map<String,dynamic>?) != null ? CCurrencyID.fromJson(json['C_Currency_ID'] as Map<String,dynamic>) : null,
      invoiceRule = (json['InvoiceRule'] as Map<String,dynamic>?) != null ? InvoiceRule.fromJson(json['InvoiceRule'] as Map<String,dynamic>) : null,
      freightAmt = json['FreightAmt'] as num?,
      deliveryViaRule = (json['DeliveryViaRule'] as Map<String,dynamic>?) != null ? DeliveryViaRule.fromJson(json['DeliveryViaRule'] as Map<String,dynamic>) : null,
      priorityRule = (json['PriorityRule'] as Map<String,dynamic>?) != null ? PriorityRule.fromJson(json['PriorityRule'] as Map<String,dynamic>) : null,
      totalLines = json['TotalLines'] as num?,
      grandTotal = json['GrandTotal'] as num?,
      mWarehouseID = (json['M_Warehouse_ID'] as Map<String,dynamic>?) != null ? MWarehouseID.fromJson(json['M_Warehouse_ID'] as Map<String,dynamic>) : null,
      mPriceListID = (json['M_PriceList_ID'] as Map<String,dynamic>?) != null ? MPriceListID.fromJson(json['M_PriceList_ID'] as Map<String,dynamic>) : null,
      cBPartnerID = (json['C_BPartner_ID'] as Map<String,dynamic>?) != null ? CBPartnerID.fromJson(json['C_BPartner_ID'] as Map<String,dynamic>) : null,
      chargeAmt = json['ChargeAmt'] as num?,
      processed = json['Processed'] as bool?,
      cBPartnerLocationID = (json['C_BPartner_Location_ID'] as Map<String,dynamic>?) != null ? CBPartnerLocationID.fromJson(json['C_BPartner_Location_ID'] as Map<String,dynamic>) : null,
      isSOTrx = json['IsSOTrx'] as bool?,
      deliveryRule = (json['DeliveryRule'] as Map<String,dynamic>?) != null ? DeliveryRule.fromJson(json['DeliveryRule'] as Map<String,dynamic>) : null,
      freightCostRule = (json['FreightCostRule'] as Map<String,dynamic>?) != null ? FreightCostRule.fromJson(json['FreightCostRule'] as Map<String,dynamic>) : null,
      paymentRule = (json['PaymentRule'] as Map<String,dynamic>?) != null ? PaymentRule.fromJson(json['PaymentRule'] as Map<String,dynamic>) : null,
      isDiscountPrinted = json['IsDiscountPrinted'] as bool?,
      isTaxIncluded = json['IsTaxIncluded'] as bool?,
      isSelected = json['IsSelected'] as bool?,
      sendEMail = json['SendEMail'] as bool?,
      billBPartnerID = (json['Bill_BPartner_ID'] as Map<String,dynamic>?) != null ? BillBPartnerID.fromJson(json['Bill_BPartner_ID'] as Map<String,dynamic>) : null,
      billLocationID = (json['Bill_Location_ID'] as Map<String,dynamic>?) != null ? BillLocationID.fromJson(json['Bill_Location_ID'] as Map<String,dynamic>) : null,
      isSelfService = json['IsSelfService'] as bool?,
      cConversionTypeID = (json['C_ConversionType_ID'] as Map<String,dynamic>?) != null ? CConversionTypeID.fromJson(json['C_ConversionType_ID'] as Map<String,dynamic>) : null,
      isDropShip = json['IsDropShip'] as bool?,
      volume = json['Volume'] as num?,
      weight = json['Weight'] as num?,
      amountTendered = json['AmountTendered'] as num?,
      amountRefunded = json['AmountRefunded'] as num?,
      processedOn = json['ProcessedOn'] as num?,
      isPayScheduleValid = json['IsPayScheduleValid'] as bool?,
      isPriviledgedRate = json['IsPriviledgedRate'] as bool?,
      lITTermsAndConditionsID = (json['LIT_TermsAndConditions_ID'] as Map<String,dynamic>?) != null ? LITTermsAndConditionsID.fromJson(json['LIT_TermsAndConditions_ID'] as Map<String,dynamic>) : null,
      lITRevisionDate = json['LIT_Revision_Date'] as String?,
      revision = json['Revision'] as String?,
      note = json['Note'] as String?,
      lITIsNoCheckPaymentTerm = json['LIT_isNoCheckPaymentTerm'] as bool?,
      isOrderTemplate = json['isOrderTemplate'] as bool?,
      status = (json['Status'] as Map<String,dynamic>?) != null ? Status.fromJson(json['Status'] as Map<String,dynamic>) : null,
      noPackages = json['NoPackages'] as num?,
      lITFEPAIPA = json['LIT_FEPA_IPA'] as String?,
      lITLastOrderID = (json['LIT_LastOrder_ID'] as Map<String,dynamic>?) != null ? LITLastOrderID.fromJson(json['LIT_LastOrder_ID'] as Map<String,dynamic>) : null,
      lITLastDateOrdered = json['LIT_LastDateOrdered'] as String?,
      lITIsDisplaySuppProduct = json['LIT_IsDisplaySuppProduct'] as bool?,
      lITIsWriteCalendarNow = json['LIT_isWriteCalendarNow'] as bool?,
      modelname = json['model-name'] as String?,
      mProductID = (json['M_Product_ID'] as Map<String,dynamic>?) != null ? MProductID.fromJson(json['M_Product_ID'] as Map<String,dynamic>) : null,
      line = json['Line'] as int?,
      name = json['Name'] as String?,
      lineNetAmt = json['LineNetAmt'] as num?,
      description = json['Description'] as String?,
      priceEntered = json['PriceEntered'] as num?,
      priceList = json['PriceList'] as num?,
      cTaxID = (json['C_Tax_ID'] as Map<String,dynamic>?) != null ? CTaxID.fromJson(json['C_Tax_ID'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'AD_Client_ID' : aDClientID?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'IsActive' : isActive,
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'Updated' : updated,
    'UpdatedBy' : updatedBy?.toJson(),
    'DocumentNo' : documentNo,
    'DocStatus' : docStatus?.toJson(),
    'C_DocType_ID' : cDocTypeID?.toJson(),
    'C_DocTypeTarget_ID' : cDocTypeTargetID?.toJson(),
    'IsApproved' : isApproved,
    'IsCreditApproved' : isCreditApproved,
    'IsDelivered' : isDelivered,
    'IsInvoiced' : isInvoiced,
    'IsPrinted' : isPrinted,
    'IsTransferred' : isTransferred,
    'DateOrdered' : dateOrdered,
    'DatePromised' : datePromised,
    'DateAcct' : dateAcct,
    'SalesRep_ID' : salesRepID?.toJson(),
    'C_PaymentTerm_ID' : cPaymentTermID?.toJson(),
    'C_Currency_ID' : cCurrencyID?.toJson(),
    'InvoiceRule' : invoiceRule?.toJson(),
    'FreightAmt' : freightAmt,
    'DeliveryViaRule' : deliveryViaRule?.toJson(),
    'PriorityRule' : priorityRule?.toJson(),
    'TotalLines' : totalLines,
    'GrandTotal' : grandTotal,
    'M_Warehouse_ID' : mWarehouseID?.toJson(),
    'M_PriceList_ID' : mPriceListID?.toJson(),
    'C_BPartner_ID' : cBPartnerID?.toJson(),
    'ChargeAmt' : chargeAmt,
    'Processed' : processed,
    'C_BPartner_Location_ID' : cBPartnerLocationID?.toJson(),
    'IsSOTrx' : isSOTrx,
    'DeliveryRule' : deliveryRule?.toJson(),
    'FreightCostRule' : freightCostRule?.toJson(),
    'PaymentRule' : paymentRule?.toJson(),
    'IsDiscountPrinted' : isDiscountPrinted,
    'IsTaxIncluded' : isTaxIncluded,
    'IsSelected' : isSelected,
    'SendEMail' : sendEMail,
    'Bill_BPartner_ID' : billBPartnerID?.toJson(),
    'Bill_Location_ID' : billLocationID?.toJson(),
    'IsSelfService' : isSelfService,
    'C_ConversionType_ID' : cConversionTypeID?.toJson(),
    'IsDropShip' : isDropShip,
    'Volume' : volume,
    'Weight' : weight,
    'AmountTendered' : amountTendered,
    'AmountRefunded' : amountRefunded,
    'ProcessedOn' : processedOn,
    'IsPayScheduleValid' : isPayScheduleValid,
    'IsPriviledgedRate' : isPriviledgedRate,
    'LIT_TermsAndConditions_ID' : lITTermsAndConditionsID?.toJson(),
    'LIT_Revision_Date' : lITRevisionDate,
    'Revision' : revision,
    'Note' : note,
    'LIT_isNoCheckPaymentTerm' : lITIsNoCheckPaymentTerm,
    'isOrderTemplate' : isOrderTemplate,
    'Status' : status?.toJson(),
    'NoPackages' : noPackages,
    'LIT_FEPA_IPA' : lITFEPAIPA,
    'LIT_LastOrder_ID' : lITLastOrderID?.toJson(),
    'LIT_LastDateOrdered' : lITLastDateOrdered,
    'LIT_IsDisplaySuppProduct' : lITIsDisplaySuppProduct,
    'LIT_isWriteCalendarNow' : lITIsWriteCalendarNow,
    'model-name' : modelname,
    'Line': line,
    'M_Product_ID': mProductID?.toJson(),
    'Name': name,
    'LineNetAmt': lineNetAmt,
    'Description': description,
    'PriceEntered': priceEntered,
    'PriceList': priceList,
    'C_Tax_ID': cTaxID,
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class DeliveryViaRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DeliveryViaRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DeliveryViaRule.fromJson(Map<String, dynamic> json)
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

class PriorityRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  PriorityRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PriorityRule.fromJson(Map<String, dynamic> json)
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

class MWarehouseID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MWarehouseID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MWarehouseID.fromJson(Map<String, dynamic> json)
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class FreightCostRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  FreightCostRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  FreightCostRule.fromJson(Map<String, dynamic> json)
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

class BillBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BillBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BillBPartnerID.fromJson(Map<String, dynamic> json)
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

class BillLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BillLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BillLocationID.fromJson(Map<String, dynamic> json)
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class LITTermsAndConditionsID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITTermsAndConditionsID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITTermsAndConditionsID.fromJson(Map<String, dynamic> json)
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class LITLastOrderID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITLastOrderID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITLastOrderID.fromJson(Map<String, dynamic> json)
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

class MProductID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MProductID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MProductID.fromJson(Map<String, dynamic> json)
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

class CTaxID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CTaxID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CTaxID.fromJson(Map<String, dynamic> json)
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