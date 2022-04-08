class LoadUnloadLineJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  LoadUnloadLineJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  LoadUnloadLineJson.fromJson(Map<String, dynamic> json)
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
  final MInventoryID? mInventoryID;
  final MLocatorID? mLocatorID;
  final MProductID? mProductID;
  final num? qtyBook;
  final num? qtyCount;
  final String? description;
  final int? line;
  final MAttributeSetInstanceID? mAttributeSetInstanceID;
  final CChargeID? cChargeID;
  final InventoryType? inventoryType;
  final bool? processed;
  final num? qtyInternalUse;
  final String? value;
  final int? qtyCsv;
  final int? currentCostPrice;
  final int? newCostPrice;
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
    this.mInventoryID,
    this.mLocatorID,
    this.mProductID,
    this.qtyBook,
    this.qtyCount,
    this.description,
    this.line,
    this.mAttributeSetInstanceID,
    this.cChargeID,
    this.inventoryType,
    this.processed,
    this.qtyInternalUse,
    this.value,
    this.qtyCsv,
    this.currentCostPrice,
    this.newCostPrice,
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
        mInventoryID = (json['M_Inventory_ID'] as Map<String, dynamic>?) != null
            ? MInventoryID.fromJson(
                json['M_Inventory_ID'] as Map<String, dynamic>)
            : null,
        mLocatorID = (json['M_Locator_ID'] as Map<String, dynamic>?) != null
            ? MLocatorID.fromJson(json['M_Locator_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        qtyBook = json['QtyBook'] as num?,
        qtyCount = json['QtyCount'] as num?,
        description = json['Description'] as String?,
        line = json['Line'] as int?,
        mAttributeSetInstanceID =
            (json['M_AttributeSetInstance_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetInstanceID.fromJson(
                    json['M_AttributeSetInstance_ID'] as Map<String, dynamic>)
                : null,
        cChargeID = (json['C_Charge_ID'] as Map<String, dynamic>?) != null
            ? CChargeID.fromJson(json['C_Charge_ID'] as Map<String, dynamic>)
            : null,
        inventoryType = (json['InventoryType'] as Map<String, dynamic>?) != null
            ? InventoryType.fromJson(
                json['InventoryType'] as Map<String, dynamic>)
            : null,
        processed = json['Processed'] as bool?,
        qtyInternalUse = json['QtyInternalUse'] as num?,
        value = json['Value'] as String?,
        qtyCsv = json['QtyCsv'] as int?,
        currentCostPrice = json['CurrentCostPrice'] as int?,
        newCostPrice = json['NewCostPrice'] as int?,
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
        'M_Inventory_ID': mInventoryID?.toJson(),
        'M_Locator_ID': mLocatorID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'QtyBook': qtyBook,
        'QtyCount': qtyCount,
        'Description': description,
        'Line': line,
        'M_AttributeSetInstance_ID': mAttributeSetInstanceID?.toJson(),
        'C_Charge_ID': cChargeID?.toJson(),
        'InventoryType': inventoryType?.toJson(),
        'Processed': processed,
        'QtyInternalUse': qtyInternalUse,
        'Value': value,
        'QtyCsv': qtyCsv,
        'CurrentCostPrice': currentCostPrice,
        'NewCostPrice': newCostPrice,
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

class MInventoryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MInventoryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MInventoryID.fromJson(Map<String, dynamic> json)
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

class MLocatorID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MLocatorID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MLocatorID.fromJson(Map<String, dynamic> json)
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

class CChargeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CChargeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CChargeID.fromJson(Map<String, dynamic> json)
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

class InventoryType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  InventoryType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  InventoryType.fromJson(Map<String, dynamic> json)
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
