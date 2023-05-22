class SalesOrderLineJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  SalesOrderLineJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  SalesOrderLineJson.fromJson(Map<String, dynamic> json)
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
  final COrderID? cOrderID;
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
  final num? priceCost;
  final num? qtyLostSales;
  final num? rRAmt;
  final CActivityID? cActivityID;
  final String? name;
  final String? vendorProductNo;
  final num? lITStockInTrade;
  final num? lITGeneralPriceLimit;
  final String? modelname;
  num? qtyRegistered;

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
    this.cOrderID,
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
    this.priceCost,
    this.qtyLostSales,
    this.rRAmt,
    this.cActivityID,
    this.name,
    this.vendorProductNo,
    this.lITStockInTrade,
    this.lITGeneralPriceLimit,
    this.modelname,
    this.qtyRegistered,
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
        cOrderID = (json['C_Order_ID'] as Map<String, dynamic>?) != null
            ? COrderID.fromJson(json['C_Order_ID'] as Map<String, dynamic>)
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
        priceCost = json['PriceCost'] as num?,
        qtyLostSales = json['QtyLostSales'] as num?,
        rRAmt = json['RRAmt'] as num?,
        cActivityID = (json['C_Activity_ID'] as Map<String, dynamic>?) != null
            ? CActivityID.fromJson(
                json['C_Activity_ID'] as Map<String, dynamic>)
            : null,
        name = json['Name'] as String?,
        vendorProductNo = json['VendorProductNo'] as String?,
        lITStockInTrade = json['LIT_StockInTrade'] as num?,
        lITGeneralPriceLimit = json['LIT_GeneralPriceLimit'] as num?,
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
        'C_Order_ID': cOrderID?.toJson(),
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
        'PriceCost': priceCost,
        'QtyLostSales': qtyLostSales,
        'RRAmt': rRAmt,
        'C_Activity_ID': cActivityID?.toJson(),
        'Name': name,
        'VendorProductNo': vendorProductNo,
        'LIT_StockInTrade': lITStockInTrade,
        'LIT_GeneralPriceLimit': lITGeneralPriceLimit,
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

class MAttributeSetInstanceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MAttributeSetInstanceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MAttributeSetInstanceID.fromJson(Map<String, dynamic> json)
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
