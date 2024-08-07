class ProductJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<PRecords>? records;

  ProductJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ProductJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => PRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class PRecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? name;
  final String? description;
  final bool? isSummary;
  final CUOMID? cUOMID;
  final bool? isStocked;
  final bool? isPurchased;
  final bool? isSold;
  final num? volume;
  final num? weight;
  final String? value;
  final MProductCategoryID? mProductCategoryID;
  final CTaxCategoryID? cTaxCategoryID;
  final String? sKU;
  final int? shelfWidth;
  final int? shelfHeight;
  final int? shelfDepth;
  final int? unitsPerPallet;
  final bool? discontinued;
  final bool? isBOM;
  final bool? isInvoicePrintDetails;
  final bool? isPickListPrintDetails;
  final bool? isVerified;
  final ProductType? productType;
  final int? guaranteeDays;
  final MAttributeSetInstanceID? mAttributeSetInstanceID;
  final MAttributeSetID? mAttributeSetID;
  final int? guaranteeDaysMin;
  final bool? isWebStoreFeatured;
  final bool? isSelfService;
  final bool? isDropShip;
  final bool? isExcludeAutoDelivery;
  final int? unitsPerPack;
  final int? lowLevel;
  final bool? isKanban;
  final bool? isManufactured;
  final bool? isPhantom;
  final bool? isOwnBox;
  final bool? isAutoProduce;
  final bool? lITIsKanbanNoConsume;
  final bool? lITIsAllowCostRecording;
  final bool? lITIsContract;
  final bool? lITIsScheduledPO;
  final bool? lITIsSubcontractingPhase;
  final bool? lITIsProductCard;
  final bool? lITIsProductConfigurable;
  final String? modelname;
  final MLocatorID? mLocatorID;

  PRecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.name,
    this.description,
    this.isSummary,
    this.cUOMID,
    this.isStocked,
    this.isPurchased,
    this.isSold,
    this.volume,
    this.weight,
    this.value,
    this.mProductCategoryID,
    this.cTaxCategoryID,
    this.sKU,
    this.shelfWidth,
    this.shelfHeight,
    this.shelfDepth,
    this.unitsPerPallet,
    this.discontinued,
    this.isBOM,
    this.isInvoicePrintDetails,
    this.isPickListPrintDetails,
    this.isVerified,
    this.productType,
    this.guaranteeDays,
    this.mAttributeSetInstanceID,
    this.mAttributeSetID,
    this.guaranteeDaysMin,
    this.isWebStoreFeatured,
    this.isSelfService,
    this.isDropShip,
    this.isExcludeAutoDelivery,
    this.unitsPerPack,
    this.lowLevel,
    this.isKanban,
    this.isManufactured,
    this.isPhantom,
    this.isOwnBox,
    this.isAutoProduce,
    this.lITIsKanbanNoConsume,
    this.lITIsAllowCostRecording,
    this.lITIsContract,
    this.lITIsScheduledPO,
    this.lITIsSubcontractingPhase,
    this.lITIsProductCard,
    this.lITIsProductConfigurable,
    this.modelname,
    this.mLocatorID,
  });

  PRecords.fromJson(Map<String, dynamic> json)
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
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        isSummary = json['IsSummary'] as bool?,
        cUOMID = (json['C_UOM_ID'] as Map<String, dynamic>?) != null
            ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String, dynamic>)
            : null,
        isStocked = json['IsStocked'] as bool?,
        isPurchased = json['IsPurchased'] as bool?,
        isSold = json['IsSold'] as bool?,
        volume = json['Volume'] as num?,
        weight = json['Weight'] as num?,
        value = json['Value'] as String?,
        mProductCategoryID =
            (json['M_Product_Category_ID'] as Map<String, dynamic>?) != null
                ? MProductCategoryID.fromJson(
                    json['M_Product_Category_ID'] as Map<String, dynamic>)
                : null,
        cTaxCategoryID =
            (json['C_TaxCategory_ID'] as Map<String, dynamic>?) != null
                ? CTaxCategoryID.fromJson(
                    json['C_TaxCategory_ID'] as Map<String, dynamic>)
                : null,
        sKU = json['SKU'] as String?,
        shelfWidth = json['ShelfWidth'] as int?,
        shelfHeight = json['ShelfHeight'] as int?,
        shelfDepth = json['ShelfDepth'] as int?,
        unitsPerPallet = json['UnitsPerPallet'] as int?,
        discontinued = json['Discontinued'] as bool?,
        isBOM = json['IsBOM'] as bool?,
        isInvoicePrintDetails = json['IsInvoicePrintDetails'] as bool?,
        isPickListPrintDetails = json['IsPickListPrintDetails'] as bool?,
        isVerified = json['IsVerified'] as bool?,
        productType = (json['ProductType'] as Map<String, dynamic>?) != null
            ? ProductType.fromJson(json['ProductType'] as Map<String, dynamic>)
            : null,
        guaranteeDays = json['GuaranteeDays'] as int?,
        mAttributeSetInstanceID =
            (json['M_AttributeSetInstance_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetInstanceID.fromJson(
                    json['M_AttributeSetInstance_ID'] as Map<String, dynamic>)
                : null,
        mAttributeSetID =
            (json['M_AttributeSet_ID'] as Map<String, dynamic>?) != null
                ? MAttributeSetID.fromJson(
                    json['M_AttributeSet_ID'] as Map<String, dynamic>)
                : null,
        guaranteeDaysMin = json['GuaranteeDaysMin'] as int?,
        isWebStoreFeatured = json['IsWebStoreFeatured'] as bool?,
        isSelfService = json['IsSelfService'] as bool?,
        isDropShip = json['IsDropShip'] as bool?,
        isExcludeAutoDelivery = json['IsExcludeAutoDelivery'] as bool?,
        unitsPerPack = json['UnitsPerPack'] as int?,
        lowLevel = json['LowLevel'] as int?,
        isKanban = json['IsKanban'] as bool?,
        isManufactured = json['IsManufactured'] as bool?,
        isPhantom = json['IsPhantom'] as bool?,
        isOwnBox = json['IsOwnBox'] as bool?,
        isAutoProduce = json['IsAutoProduce'] as bool?,
        lITIsKanbanNoConsume = json['LIT_isKanbanNoConsume'] as bool?,
        lITIsAllowCostRecording = json['LIT_IsAllowCostRecording'] as bool?,
        lITIsContract = json['LIT_IsContract'] as bool?,
        lITIsScheduledPO = json['LIT_IsScheduledPO'] as bool?,
        lITIsSubcontractingPhase = json['LIT_IsSubcontractingPhase'] as bool?,
        lITIsProductCard = json['LIT_IsProductCard'] as bool?,
        lITIsProductConfigurable = json['LIT_IsProductConfigurable'] as bool?,
        modelname = json['model-name'] as String?,
        mLocatorID = (json['M_Locator_ID'] as Map<String, dynamic>?) != null
            ? MLocatorID.fromJson(json['M_Locator_ID'] as Map<String, dynamic>)
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
        'Name': name,
        'Description': description,
        'IsSummary': isSummary,
        'C_UOM_ID': cUOMID?.toJson(),
        'IsStocked': isStocked,
        'IsPurchased': isPurchased,
        'IsSold': isSold,
        'Volume': volume,
        'Weight': weight,
        'Value': value,
        'M_Product_Category_ID': mProductCategoryID?.toJson(),
        'C_TaxCategory_ID': cTaxCategoryID?.toJson(),
        'SKU': sKU,
        'ShelfWidth': shelfWidth,
        'ShelfHeight': shelfHeight,
        'ShelfDepth': shelfDepth,
        'UnitsPerPallet': unitsPerPallet,
        'Discontinued': discontinued,
        'IsBOM': isBOM,
        'IsInvoicePrintDetails': isInvoicePrintDetails,
        'IsPickListPrintDetails': isPickListPrintDetails,
        'IsVerified': isVerified,
        'ProductType': productType?.toJson(),
        'GuaranteeDays': guaranteeDays,
        'M_AttributeSetInstance_ID': mAttributeSetInstanceID?.toJson(),
        'GuaranteeDaysMin': guaranteeDaysMin,
        'IsWebStoreFeatured': isWebStoreFeatured,
        'IsSelfService': isSelfService,
        'IsDropShip': isDropShip,
        'IsExcludeAutoDelivery': isExcludeAutoDelivery,
        'UnitsPerPack': unitsPerPack,
        'LowLevel': lowLevel,
        'IsKanban': isKanban,
        'IsManufactured': isManufactured,
        'IsPhantom': isPhantom,
        'IsOwnBox': isOwnBox,
        'IsAutoProduce': isAutoProduce,
        'LIT_isKanbanNoConsume': lITIsKanbanNoConsume,
        'LIT_IsAllowCostRecording': lITIsAllowCostRecording,
        'LIT_IsContract': lITIsContract,
        'LIT_IsScheduledPO': lITIsScheduledPO,
        'LIT_IsSubcontractingPhase': lITIsSubcontractingPhase,
        'LIT_IsProductCard': lITIsProductCard,
        'LIT_IsProductConfigurable': lITIsProductConfigurable,
        'model-name': modelname,
        'M_Locator_ID': mLocatorID?.toJson(),
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

class MProductCategoryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MProductCategoryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MProductCategoryID.fromJson(Map<String, dynamic> json)
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

class CTaxCategoryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CTaxCategoryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CTaxCategoryID.fromJson(Map<String, dynamic> json)
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

class ProductType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ProductType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProductType.fromJson(Map<String, dynamic> json)
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

class MAttributeSetID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MAttributeSetID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MAttributeSetID.fromJson(Map<String, dynamic> json)
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
