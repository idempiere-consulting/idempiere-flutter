class InvoiceLineJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  InvoiceLineJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  InvoiceLineJson.fromJson(Map<String, dynamic> json)
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
  final CInvoiceID? cInvoiceID;
  final COrderLineID? cOrderLineID;
  final int? line;
  final String? description;
  final MProductID? mProductID;
  final num? qtyInvoiced;
  final num? priceList;
  final num? priceActual;
  final num? lineNetAmt;
  final CUOMID? cUOMID;
  final CTaxID? cTaxID;
  final MInOutLineID? mInOutLineID;
  final num? priceLimit;
  final num? taxAmt;
  final MAttributeSetInstanceID? mAttributeSetInstanceID;
  final bool? isDescription;
  final num? lineTotalAmt;
  final bool? isPrinted;
  final bool? processed;
  final num? qtyEntered;
  final num? priceEntered;
  final CActivityID? cActivityID;
  final bool? aCreateAsset;
  final bool? aProcessed;
  final bool? isFixedAssetInvoice;
  final String? name;
  final bool? lITIsApplyDiscount;
  final num? discount;
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
    this.cInvoiceID,
    this.cOrderLineID,
    this.line,
    this.description,
    this.mProductID,
    this.qtyInvoiced,
    this.priceList,
    this.priceActual,
    this.lineNetAmt,
    this.cUOMID,
    this.cTaxID,
    this.mInOutLineID,
    this.priceLimit,
    this.taxAmt,
    this.mAttributeSetInstanceID,
    this.isDescription,
    this.lineTotalAmt,
    this.isPrinted,
    this.processed,
    this.qtyEntered,
    this.priceEntered,
    this.cActivityID,
    this.aCreateAsset,
    this.aProcessed,
    this.isFixedAssetInvoice,
    this.name,
    this.lITIsApplyDiscount,
    this.discount,
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
        cInvoiceID = (json['C_Invoice_ID'] as Map<String, dynamic>?) != null
            ? CInvoiceID.fromJson(json['C_Invoice_ID'] as Map<String, dynamic>)
            : null,
        cOrderLineID = (json['C_OrderLine_ID'] as Map<String, dynamic>?) != null
            ? COrderLineID.fromJson(
                json['C_OrderLine_ID'] as Map<String, dynamic>)
            : null,
        line = json['Line'] as int?,
        description = json['Description'] as String?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        qtyInvoiced = json['QtyInvoiced'] as num?,
        priceList = json['PriceList'] as num?,
        priceActual = json['PriceActual'] as num?,
        lineNetAmt = json['LineNetAmt'] as num?,
        cUOMID = (json['C_UOM_ID'] as Map<String, dynamic>?) != null
            ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String, dynamic>)
            : null,
        cTaxID = (json['C_Tax_ID'] as Map<String, dynamic>?) != null
            ? CTaxID.fromJson(json['C_Tax_ID'] as Map<String, dynamic>)
            : null,
        mInOutLineID = (json['M_InOutLine_ID'] as Map<String, dynamic>?) != null
            ? MInOutLineID.fromJson(
                json['M_InOutLine_ID'] as Map<String, dynamic>)
            : null,
        priceLimit = json['PriceLimit'] as num?,
        taxAmt = json['TaxAmt'] as num?,
        mAttributeSetInstanceID =
            (json['M_AttributeSetInstance_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetInstanceID.fromJson(
                    json['M_AttributeSetInstance_ID'] as Map<String, dynamic>)
                : null,
        isDescription = json['IsDescription'] as bool?,
        lineTotalAmt = json['LineTotalAmt'] as num?,
        isPrinted = json['IsPrinted'] as bool?,
        processed = json['Processed'] as bool?,
        qtyEntered = json['QtyEntered'] as num?,
        priceEntered = json['PriceEntered'] as num?,
        cActivityID = (json['C_Activity_ID'] as Map<String, dynamic>?) != null
            ? CActivityID.fromJson(
                json['C_Activity_ID'] as Map<String, dynamic>)
            : null,
        aCreateAsset = json['A_CreateAsset'] as bool?,
        aProcessed = json['A_Processed'] as bool?,
        isFixedAssetInvoice = json['IsFixedAssetInvoice'] as bool?,
        name = json['Name'] as String?,
        lITIsApplyDiscount = json['LIT_IsApplyDiscount'] as bool?,
        discount = json['Discount'] as num?,
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
        'C_Invoice_ID': cInvoiceID?.toJson(),
        'C_OrderLine_ID': cOrderLineID?.toJson(),
        'Line': line,
        'Description': description,
        'M_Product_ID': mProductID?.toJson(),
        'QtyInvoiced': qtyInvoiced,
        'PriceList': priceList,
        'PriceActual': priceActual,
        'LineNetAmt': lineNetAmt,
        'C_UOM_ID': cUOMID?.toJson(),
        'C_Tax_ID': cTaxID?.toJson(),
        'M_InOutLine_ID': mInOutLineID?.toJson(),
        'PriceLimit': priceLimit,
        'TaxAmt': taxAmt,
        'M_AttributeSetInstance_ID': mAttributeSetInstanceID?.toJson(),
        'IsDescription': isDescription,
        'LineTotalAmt': lineTotalAmt,
        'IsPrinted': isPrinted,
        'Processed': processed,
        'QtyEntered': qtyEntered,
        'PriceEntered': priceEntered,
        'C_Activity_ID': cActivityID?.toJson(),
        'A_CreateAsset': aCreateAsset,
        'A_Processed': aProcessed,
        'IsFixedAssetInvoice': isFixedAssetInvoice,
        'Name': name,
        'LIT_IsApplyDiscount': lITIsApplyDiscount,
        'Discount': discount,
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

class COrderLineID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  COrderLineID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  COrderLineID.fromJson(Map<String, dynamic> json)
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

class MInOutLineID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MInOutLineID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MInOutLineID.fromJson(Map<String, dynamic> json)
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

class CActivityID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CActivityID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CActivityID.fromJson(Map<String, dynamic> json)
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
