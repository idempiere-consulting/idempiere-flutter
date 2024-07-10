class ProductionLineJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<PLRecords>? records;

  ProductionLineJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  ProductionLineJSON.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        arraycount = json['array-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => PLRecords.fromJson(e as Map<String, dynamic>))
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

class PLRecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final MLocatorID? mLocatorID;
  final MProductID? mProductID;
  final num? movementQty;
  final int? line;
  final MAttributeSetInstanceID? mAttributeSetInstanceID;
  final bool? processed;
  final MProductionID? mProductionID;
  final MInventoryLineID? mInventoryLineID;
  final num? plannedQty;
  final num? qtyUsed;
  final bool? isEndProduct;
  final LITMLocatorFromID? lITMLocatorFromID;
  final int? bOMQty;
  final int? width;
  final int? height;
  final int? length;
  final String? name;
  final String? productValue;
  final String? modelname;

  PLRecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.mLocatorID,
    this.mProductID,
    this.movementQty,
    this.line,
    this.mAttributeSetInstanceID,
    this.processed,
    this.mProductionID,
    this.mInventoryLineID,
    this.plannedQty,
    this.qtyUsed,
    this.isEndProduct,
    this.lITMLocatorFromID,
    this.bOMQty,
    this.width,
    this.height,
    this.length,
    this.name,
    this.productValue,
    this.modelname,
  });

  PLRecords.fromJson(Map<String, dynamic> json)
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
        mLocatorID = (json['M_Locator_ID'] as Map<String, dynamic>?) != null
            ? MLocatorID.fromJson(json['M_Locator_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        movementQty = json['MovementQty'] as num?,
        line = json['Line'] as int?,
        mAttributeSetInstanceID =
            (json['M_AttributeSetInstance_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetInstanceID.fromJson(
                    json['M_AttributeSetInstance_ID'] as Map<String, dynamic>)
                : null,
        processed = json['Processed'] as bool?,
        mProductionID =
            (json['M_Production_ID'] as Map<String, dynamic>?) != null
                ? MProductionID.fromJson(
                    json['M_Production_ID'] as Map<String, dynamic>)
                : null,
        mInventoryLineID =
            (json['M_InventoryLine_ID'] as Map<String, dynamic>?) != null
                ? MInventoryLineID.fromJson(
                    json['M_InventoryLine_ID'] as Map<String, dynamic>)
                : null,
        plannedQty = json['PlannedQty'] as num?,
        qtyUsed = json['QtyUsed'] as num?,
        isEndProduct = json['IsEndProduct'] as bool?,
        lITMLocatorFromID =
            (json['LIT_M_LocatorFrom_ID'] as Map<String, dynamic>?) != null
                ? LITMLocatorFromID.fromJson(
                    json['LIT_M_LocatorFrom_ID'] as Map<String, dynamic>)
                : null,
        bOMQty = json['BOMQty'] as int?,
        width = json['Width'] as int?,
        height = json['Height'] as int?,
        length = json['Length'] as int?,
        name = json['Name'] as String?,
        productValue = json['ProductValue'] as String?,
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
        'M_Locator_ID': mLocatorID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'MovementQty': movementQty,
        'Line': line,
        'M_AttributeSetInstance_ID': mAttributeSetInstanceID?.toJson(),
        'Processed': processed,
        'M_Production_ID': mProductionID?.toJson(),
        'M_InventoryLine_ID': mInventoryLineID?.toJson(),
        'PlannedQty': plannedQty,
        'QtyUsed': qtyUsed,
        'IsEndProduct': isEndProduct,
        'LIT_M_LocatorFrom_ID': lITMLocatorFromID?.toJson(),
        'BOMQty': bOMQty,
        'Name': name,
        'ProductValue': productValue,
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

class MInventoryLineID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MInventoryLineID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MInventoryLineID.fromJson(Map<String, dynamic> json)
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

class MProductionID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MProductionID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MProductionID.fromJson(Map<String, dynamic> json)
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

class LITMLocatorFromID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITMLocatorFromID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITMLocatorFromID.fromJson(Map<String, dynamic> json)
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
