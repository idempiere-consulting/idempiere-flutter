class BOMLineJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<BMLRecords>? records;

  BOMLineJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  BOMLineJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => BMLRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class BMLRecords {
  final int? id;
  final String? uid;
  final ADOrgID? aDOrgID;
  final int? assay;
  final CUOMID? cUOMID;
  final ComponentType? componentType;
  final String? created;
  final CreatedBy? createdBy;
  final int? forecast;
  final bool? isActive;
  final bool? isCritical;
  final bool? isQtyPercentage;
  final IssueMethod? issueMethod;
  final int? leadTimeOffset;
  final int? line;
  final MProductID? mProductID;
  final PPProductBOMID? pPProductBOMID;
  final int? qtyBOM;
  final int? qtyBatch;
  final int? scrap;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? validFrom;
  final ADClientID? aDClientID;
  final int? costAllocationPerc;
  final MProductCategoryID? mProductCategoryID;
  final String? modelname;

  BMLRecords({
    this.id,
    this.uid,
    this.aDOrgID,
    this.assay,
    this.cUOMID,
    this.componentType,
    this.created,
    this.createdBy,
    this.forecast,
    this.isActive,
    this.isCritical,
    this.isQtyPercentage,
    this.issueMethod,
    this.leadTimeOffset,
    this.line,
    this.mProductID,
    this.pPProductBOMID,
    this.qtyBOM,
    this.qtyBatch,
    this.scrap,
    this.updated,
    this.updatedBy,
    this.validFrom,
    this.aDClientID,
    this.costAllocationPerc,
    this.mProductCategoryID,
    this.modelname,
  });

  BMLRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        assay = json['Assay'] as int?,
        cUOMID = (json['C_UOM_ID'] as Map<String, dynamic>?) != null
            ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String, dynamic>)
            : null,
        componentType = (json['ComponentType'] as Map<String, dynamic>?) != null
            ? ComponentType.fromJson(
                json['ComponentType'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        forecast = json['Forecast'] as int?,
        isActive = json['IsActive'] as bool?,
        isCritical = json['IsCritical'] as bool?,
        isQtyPercentage = json['IsQtyPercentage'] as bool?,
        issueMethod = (json['IssueMethod'] as Map<String, dynamic>?) != null
            ? IssueMethod.fromJson(json['IssueMethod'] as Map<String, dynamic>)
            : null,
        leadTimeOffset = json['LeadTimeOffset'] as int?,
        line = json['Line'] as int?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        pPProductBOMID =
            (json['PP_Product_BOM_ID'] as Map<String, dynamic>?) != null
                ? PPProductBOMID.fromJson(
                    json['PP_Product_BOM_ID'] as Map<String, dynamic>)
                : null,
        qtyBOM = json['QtyBOM'] as int?,
        qtyBatch = json['QtyBatch'] as int?,
        scrap = json['Scrap'] as int?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        validFrom = json['ValidFrom'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        costAllocationPerc = json['CostAllocationPerc'] as int?,
        mProductCategoryID =
            (json['M_Product_Category_ID'] as Map<String, dynamic>?) != null
                ? MProductCategoryID.fromJson(
                    json['M_Product_Category_ID'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Org_ID': aDOrgID?.toJson(),
        'Assay': assay,
        'C_UOM_ID': cUOMID?.toJson(),
        'ComponentType': componentType?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Forecast': forecast,
        'IsActive': isActive,
        'IsCritical': isCritical,
        'IsQtyPercentage': isQtyPercentage,
        'IssueMethod': issueMethod?.toJson(),
        'LeadTimeOffset': leadTimeOffset,
        'Line': line,
        'M_Product_ID': mProductID?.toJson(),
        'PP_Product_BOM_ID': pPProductBOMID?.toJson(),
        'QtyBOM': qtyBOM,
        'QtyBatch': qtyBatch,
        'Scrap': scrap,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'ValidFrom': validFrom,
        'AD_Client_ID': aDClientID?.toJson(),
        'CostAllocationPerc': costAllocationPerc,
        'M_Product_Category_ID': mProductCategoryID?.toJson(),
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

class ComponentType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ComponentType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ComponentType.fromJson(Map<String, dynamic> json)
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

class IssueMethod {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  IssueMethod({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  IssueMethod.fromJson(Map<String, dynamic> json)
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

class PPProductBOMID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  PPProductBOMID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PPProductBOMID.fromJson(Map<String, dynamic> json)
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
