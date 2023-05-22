class MaterialReceiptPurchaseOrderJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  MaterialReceiptPurchaseOrderJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  MaterialReceiptPurchaseOrderJSON.fromJson(Map<String, dynamic> json)
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
  final ADUserID? aDUserID;
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
  final BillUserID? billUserID;
  final BillBPartnerID? billBPartnerID;
  final BillLocationID? billLocationID;
  final bool? isSelfService;
  final bool? isDropShip;
  final num? volume;
  final num? weight;
  final double? processedOn;
  final bool? isPayScheduleValid;
  final bool? isPriviledgedRate;
  final bool? isOrderTemplate;
  final bool? lITIsNoCheckPaymentTerm;
  final num? qtyReserved;
  final Status? status;
  final String? privateNote;
  final LITLastOrderID? lITLastOrderID;
  final String? lITLastDateOrdered;
  final bool? lITIsDisplaySuppProduct;
  final String? dateDoc;
  final num? qtyToInvoice;
  final bool? isAchieved;
  final bool? lITIsWriteCalendarNow;
  final String? modelname;
  final List<COrderLine>? cOrderLine;

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
    this.aDUserID,
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
    this.billUserID,
    this.billBPartnerID,
    this.billLocationID,
    this.isSelfService,
    this.isDropShip,
    this.volume,
    this.weight,
    this.processedOn,
    this.isPayScheduleValid,
    this.isPriviledgedRate,
    this.isOrderTemplate,
    this.lITIsNoCheckPaymentTerm,
    this.qtyReserved,
    this.status,
    this.privateNote,
    this.lITLastOrderID,
    this.lITLastDateOrdered,
    this.lITIsDisplaySuppProduct,
    this.dateDoc,
    this.qtyToInvoice,
    this.isAchieved,
    this.lITIsWriteCalendarNow,
    this.modelname,
    this.cOrderLine,
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
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        cDocTypeTargetID =
            (json['C_DocTypeTarget_ID'] as Map<String, dynamic>?) != null
                ? CDocTypeTargetID.fromJson(
                    json['C_DocTypeTarget_ID'] as Map<String, dynamic>)
                : null,
        isApproved = json['IsApproved'] as bool?,
        isCreditApproved = json['IsCreditApproved'] as bool?,
        isDelivered = json['IsDelivered'] as bool?,
        isInvoiced = json['IsInvoiced'] as bool?,
        isPrinted = json['IsPrinted'] as bool?,
        isTransferred = json['IsTransferred'] as bool?,
        dateOrdered = json['DateOrdered'] as String?,
        datePromised = json['DatePromised'] as String?,
        dateAcct = json['DateAcct'] as String?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        cPaymentTermID =
            (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
                ? CPaymentTermID.fromJson(
                    json['C_PaymentTerm_ID'] as Map<String, dynamic>)
                : null,
        cCurrencyID = (json['C_Currency_ID'] as Map<String, dynamic>?) != null
            ? CCurrencyID.fromJson(
                json['C_Currency_ID'] as Map<String, dynamic>)
            : null,
        invoiceRule = (json['InvoiceRule'] as Map<String, dynamic>?) != null
            ? InvoiceRule.fromJson(json['InvoiceRule'] as Map<String, dynamic>)
            : null,
        freightAmt = json['FreightAmt'] as num?,
        deliveryViaRule =
            (json['DeliveryViaRule'] as Map<String, dynamic>?) != null
                ? DeliveryViaRule.fromJson(
                    json['DeliveryViaRule'] as Map<String, dynamic>)
                : null,
        priorityRule = (json['PriorityRule'] as Map<String, dynamic>?) != null
            ? PriorityRule.fromJson(
                json['PriorityRule'] as Map<String, dynamic>)
            : null,
        totalLines = json['TotalLines'] as num?,
        grandTotal = json['GrandTotal'] as num?,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
            ? MPriceListID.fromJson(
                json['M_PriceList_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        chargeAmt = json['ChargeAmt'] as num?,
        processed = json['Processed'] as bool?,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        isSOTrx = json['IsSOTrx'] as bool?,
        deliveryRule = (json['DeliveryRule'] as Map<String, dynamic>?) != null
            ? DeliveryRule.fromJson(
                json['DeliveryRule'] as Map<String, dynamic>)
            : null,
        freightCostRule =
            (json['FreightCostRule'] as Map<String, dynamic>?) != null
                ? FreightCostRule.fromJson(
                    json['FreightCostRule'] as Map<String, dynamic>)
                : null,
        paymentRule = (json['PaymentRule'] as Map<String, dynamic>?) != null
            ? PaymentRule.fromJson(json['PaymentRule'] as Map<String, dynamic>)
            : null,
        isDiscountPrinted = json['IsDiscountPrinted'] as bool?,
        isTaxIncluded = json['IsTaxIncluded'] as bool?,
        isSelected = json['IsSelected'] as bool?,
        sendEMail = json['SendEMail'] as bool?,
        billUserID = (json['Bill_User_ID'] as Map<String, dynamic>?) != null
            ? BillUserID.fromJson(json['Bill_User_ID'] as Map<String, dynamic>)
            : null,
        billBPartnerID =
            (json['Bill_BPartner_ID'] as Map<String, dynamic>?) != null
                ? BillBPartnerID.fromJson(
                    json['Bill_BPartner_ID'] as Map<String, dynamic>)
                : null,
        billLocationID =
            (json['Bill_Location_ID'] as Map<String, dynamic>?) != null
                ? BillLocationID.fromJson(
                    json['Bill_Location_ID'] as Map<String, dynamic>)
                : null,
        isSelfService = json['IsSelfService'] as bool?,
        isDropShip = json['IsDropShip'] as bool?,
        volume = json['Volume'] as num?,
        weight = json['Weight'] as num?,
        processedOn = json['ProcessedOn'] as double?,
        isPayScheduleValid = json['IsPayScheduleValid'] as bool?,
        isPriviledgedRate = json['IsPriviledgedRate'] as bool?,
        isOrderTemplate = json['isOrderTemplate'] as bool?,
        lITIsNoCheckPaymentTerm = json['LIT_isNoCheckPaymentTerm'] as bool?,
        qtyReserved = json['QtyReserved'] as num?,
        status = (json['Status'] as Map<String, dynamic>?) != null
            ? Status.fromJson(json['Status'] as Map<String, dynamic>)
            : null,
        privateNote = json['PrivateNote'] as String?,
        lITLastOrderID =
            (json['LIT_LastOrder_ID'] as Map<String, dynamic>?) != null
                ? LITLastOrderID.fromJson(
                    json['LIT_LastOrder_ID'] as Map<String, dynamic>)
                : null,
        lITLastDateOrdered = json['LIT_LastDateOrdered'] as String?,
        lITIsDisplaySuppProduct = json['LIT_IsDisplaySuppProduct'] as bool?,
        dateDoc = json['DateDoc'] as String?,
        qtyToInvoice = json['QtyToInvoice'] as num?,
        isAchieved = json['IsAchieved'] as bool?,
        lITIsWriteCalendarNow = json['LIT_isWriteCalendarNow'] as bool?,
        modelname = json['model-name'] as String?,
        cOrderLine = (json['c_orderLine'] as List?)
            ?.map((dynamic e) => COrderLine.fromJson(e as Map<String, dynamic>))
            .toList();

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
        'DocStatus': docStatus?.toJson(),
        'C_DocType_ID': cDocTypeID?.toJson(),
        'C_DocTypeTarget_ID': cDocTypeTargetID?.toJson(),
        'IsApproved': isApproved,
        'IsCreditApproved': isCreditApproved,
        'IsDelivered': isDelivered,
        'IsInvoiced': isInvoiced,
        'IsPrinted': isPrinted,
        'IsTransferred': isTransferred,
        'DateOrdered': dateOrdered,
        'DatePromised': datePromised,
        'DateAcct': dateAcct,
        'SalesRep_ID': salesRepID?.toJson(),
        'C_PaymentTerm_ID': cPaymentTermID?.toJson(),
        'C_Currency_ID': cCurrencyID?.toJson(),
        'InvoiceRule': invoiceRule?.toJson(),
        'FreightAmt': freightAmt,
        'DeliveryViaRule': deliveryViaRule?.toJson(),
        'PriorityRule': priorityRule?.toJson(),
        'TotalLines': totalLines,
        'GrandTotal': grandTotal,
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'M_PriceList_ID': mPriceListID?.toJson(),
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
        'ChargeAmt': chargeAmt,
        'Processed': processed,
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'IsSOTrx': isSOTrx,
        'DeliveryRule': deliveryRule?.toJson(),
        'FreightCostRule': freightCostRule?.toJson(),
        'PaymentRule': paymentRule?.toJson(),
        'IsDiscountPrinted': isDiscountPrinted,
        'IsTaxIncluded': isTaxIncluded,
        'IsSelected': isSelected,
        'SendEMail': sendEMail,
        'Bill_User_ID': billUserID?.toJson(),
        'Bill_BPartner_ID': billBPartnerID?.toJson(),
        'Bill_Location_ID': billLocationID?.toJson(),
        'IsSelfService': isSelfService,
        'IsDropShip': isDropShip,
        'Volume': volume,
        'Weight': weight,
        'ProcessedOn': processedOn,
        'IsPayScheduleValid': isPayScheduleValid,
        'IsPriviledgedRate': isPriviledgedRate,
        'isOrderTemplate': isOrderTemplate,
        'LIT_isNoCheckPaymentTerm': lITIsNoCheckPaymentTerm,
        'QtyReserved': qtyReserved,
        'Status': status?.toJson(),
        'PrivateNote': privateNote,
        'LIT_LastOrder_ID': lITLastOrderID?.toJson(),
        'LIT_LastDateOrdered': lITLastDateOrdered,
        'LIT_IsDisplaySuppProduct': lITIsDisplaySuppProduct,
        'DateDoc': dateDoc,
        'QtyToInvoice': qtyToInvoice,
        'IsAchieved': isAchieved,
        'LIT_isWriteCalendarNow': lITIsWriteCalendarNow,
        'model-name': modelname,
        'c_orderLine': cOrderLine?.map((e) => e.toJson()).toList()
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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

class BillUserID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BillUserID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BillUserID.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class COrderLine {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final int? line;
  final String? dateOrdered;
  final String? datePromised;
  final String? dateDelivered;
  final String? description;
  final MProductID? mProductID;
  final CUOMID? cUOMID;
  final MWarehouseID? mWarehouseID;
  final num? qtyOrdered;
  final num? qtyReserved;
  final num? qtyDelivered;
  final num? qtyInvoiced;
  final CCurrencyID? cCurrencyID;
  final num? priceList;
  final num? priceActual;
  final CTaxID? cTaxID;
  final CBPartnerID? cBPartnerID;
  final num? freightAmt;
  final CBPartnerLocationID? cBPartnerLocationID;
  final num? lineNetAmt;
  final num? priceLimit;
  final num? discount;
  final MAttributeSetInstanceID? mAttributeSetInstanceID;
  final bool? isDescription;
  final bool? processed;
  final num? priceEntered;
  final num? qtyEntered;
  final num? qtyLostSales;
  final String? name;
  final String? vendorProductNo;
  final CContractID? cContractID;
  final num? lITGeneralPriceLimit;
  final ADImageID? aDImageID;

  COrderLine({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.line,
    this.dateOrdered,
    this.datePromised,
    this.dateDelivered,
    this.description,
    this.mProductID,
    this.cUOMID,
    this.mWarehouseID,
    this.qtyOrdered,
    this.qtyReserved,
    this.qtyDelivered,
    this.qtyInvoiced,
    this.cCurrencyID,
    this.priceList,
    this.priceActual,
    this.cTaxID,
    this.cBPartnerID,
    this.freightAmt,
    this.cBPartnerLocationID,
    this.lineNetAmt,
    this.priceLimit,
    this.discount,
    this.mAttributeSetInstanceID,
    this.isDescription,
    this.processed,
    this.priceEntered,
    this.qtyEntered,
    this.qtyLostSales,
    this.name,
    this.vendorProductNo,
    this.cContractID,
    this.lITGeneralPriceLimit,
    this.aDImageID,
  });

  COrderLine.fromJson(Map<String, dynamic> json)
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
        line = json['Line'] as int?,
        dateOrdered = json['DateOrdered'] as String?,
        datePromised = json['DatePromised'] as String?,
        dateDelivered = json['DateDelivered'] as String?,
        description = json['Description'] as String?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        cUOMID = (json['C_UOM_ID'] as Map<String, dynamic>?) != null
            ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String, dynamic>)
            : null,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        qtyOrdered = json['QtyOrdered'] as num?,
        qtyReserved = json['QtyReserved'] as num?,
        qtyDelivered = json['QtyDelivered'] as num?,
        qtyInvoiced = json['QtyInvoiced'] as num?,
        cCurrencyID = (json['C_Currency_ID'] as Map<String, dynamic>?) != null
            ? CCurrencyID.fromJson(
                json['C_Currency_ID'] as Map<String, dynamic>)
            : null,
        priceList = json['PriceList'] as num?,
        priceActual = json['PriceActual'] as num?,
        cTaxID = (json['C_Tax_ID'] as Map<String, dynamic>?) != null
            ? CTaxID.fromJson(json['C_Tax_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        freightAmt = json['FreightAmt'] as num?,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        lineNetAmt = json['LineNetAmt'] as num?,
        priceLimit = json['PriceLimit'] as num?,
        discount = json['Discount'] as num?,
        mAttributeSetInstanceID =
            (json['M_AttributeSetInstance_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetInstanceID.fromJson(
                    json['M_AttributeSetInstance_ID'] as Map<String, dynamic>)
                : null,
        isDescription = json['IsDescription'] as bool?,
        processed = json['Processed'] as bool?,
        priceEntered = json['PriceEntered'] as num?,
        qtyEntered = json['QtyEntered'] as num?,
        qtyLostSales = json['QtyLostSales'] as num?,
        name = json['Name'] as String?,
        vendorProductNo = json['VendorProductNo'] as String?,
        cContractID = (json['C_Contract_ID'] as Map<String, dynamic>?) != null
            ? CContractID.fromJson(
                json['C_Contract_ID'] as Map<String, dynamic>)
            : null,
        lITGeneralPriceLimit = json['LIT_GeneralPriceLimit'] as num?,
        aDImageID = (json['AD_Image_ID'] as Map<String, dynamic>?) != null
            ? ADImageID.fromJson(json['AD_Image_ID'] as Map<String, dynamic>)
            : null;

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
        'Line': line,
        'DateOrdered': dateOrdered,
        'DatePromised': datePromised,
        'DateDelivered': dateDelivered,
        'Description': description,
        'M_Product_ID': mProductID?.toJson(),
        'C_UOM_ID': cUOMID?.toJson(),
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'QtyOrdered': qtyOrdered,
        'QtyReserved': qtyReserved,
        'QtyDelivered': qtyDelivered,
        'QtyInvoiced': qtyInvoiced,
        'C_Currency_ID': cCurrencyID?.toJson(),
        'PriceList': priceList,
        'PriceActual': priceActual,
        'C_Tax_ID': cTaxID?.toJson(),
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'FreightAmt': freightAmt,
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'LineNetAmt': lineNetAmt,
        'PriceLimit': priceLimit,
        'Discount': discount,
        'M_AttributeSetInstance_ID': mAttributeSetInstanceID?.toJson(),
        'IsDescription': isDescription,
        'Processed': processed,
        'PriceEntered': priceEntered,
        'QtyEntered': qtyEntered,
        'QtyLostSales': qtyLostSales,
        'Name': name,
        'VendorProductNo': vendorProductNo,
        'C_Contract_ID': cContractID?.toJson(),
        'LIT_GeneralPriceLimit': lITGeneralPriceLimit,
        'AD_Image_ID': aDImageID?.toJson()
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class CUOMID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CUOMID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CUOMID.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}

class MAttributeSetInstanceID {
  final String? propertyLabel;
  final int? id;
  final String? modelname;

  MAttributeSetInstanceID({
    this.propertyLabel,
    this.id,
    this.modelname,
  });

  MAttributeSetInstanceID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() =>
      {'propertyLabel': propertyLabel, 'id': id, 'model-name': modelname};
}

class CContractID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CContractID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CContractID.fromJson(Map<String, dynamic> json)
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

class ADImageID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADImageID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADImageID.fromJson(Map<String, dynamic> json)
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
