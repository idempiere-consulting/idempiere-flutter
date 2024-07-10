class PPCostCollectorJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  PPCostCollectorJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  PPCostCollectorJSON.fromJson(Map<String, dynamic> json)
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
  final MProductID? mProductID;
  final ADOrgID? aDOrgID;
  final CDocTypeTargetID? cDocTypeTargetID;
  final CDocTypeID? cDocTypeID;
  final CUOMID? cUOMID;
  final String? created;
  final CreatedBy? createdBy;
  final String? dateAcct;
  final DocStatus? docStatus;
  final num? durationReal;
  final bool? isActive;
  final bool? isBatchTime;
  final MLocatorID? mLocatorID;
  final MWarehouseID? mWarehouseID;
  final String? movementDate;
  final int? movementQty;
  final CostCollectorType? costCollectorType;
  final bool? processed;
  final int? qtyReject;
  final SResourceID? sResourceID;
  final int? scrappedQty;
  final int? setupTimeReal;
  final String? updated;
  final UpdatedBy? updatedBy;
  final ADClientID? aDClientID;
  final bool? isSubcontracting;
  final String? documentNo;
  final double? processedOn;
  final MProductionID? mProductionID;
  final MProductionNodeID? mProductionNodeID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.mProductID,
    this.aDOrgID,
    this.cDocTypeTargetID,
    this.cDocTypeID,
    this.cUOMID,
    this.created,
    this.createdBy,
    this.dateAcct,
    this.docStatus,
    this.durationReal,
    this.isActive,
    this.isBatchTime,
    this.mLocatorID,
    this.mWarehouseID,
    this.movementDate,
    this.movementQty,
    this.costCollectorType,
    this.processed,
    this.qtyReject,
    this.sResourceID,
    this.scrappedQty,
    this.setupTimeReal,
    this.updated,
    this.updatedBy,
    this.aDClientID,
    this.isSubcontracting,
    this.documentNo,
    this.processedOn,
    this.mProductionID,
    this.mProductionNodeID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        cDocTypeTargetID =
            (json['C_DocTypeTarget_ID'] as Map<String, dynamic>?) != null
                ? CDocTypeTargetID.fromJson(
                    json['C_DocTypeTarget_ID'] as Map<String, dynamic>)
                : null,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        cUOMID = (json['C_UOM_ID'] as Map<String, dynamic>?) != null
            ? CUOMID.fromJson(json['C_UOM_ID'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        dateAcct = json['DateAcct'] as String?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        durationReal = json['DurationReal'] as num?,
        isActive = json['IsActive'] as bool?,
        isBatchTime = json['IsBatchTime'] as bool?,
        mLocatorID = (json['M_Locator_ID'] as Map<String, dynamic>?) != null
            ? MLocatorID.fromJson(json['M_Locator_ID'] as Map<String, dynamic>)
            : null,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        movementDate = json['MovementDate'] as String?,
        movementQty = json['MovementQty'] as int?,
        costCollectorType =
            (json['CostCollectorType'] as Map<String, dynamic>?) != null
                ? CostCollectorType.fromJson(
                    json['CostCollectorType'] as Map<String, dynamic>)
                : null,
        processed = json['Processed'] as bool?,
        qtyReject = json['QtyReject'] as int?,
        sResourceID = (json['S_Resource_ID'] as Map<String, dynamic>?) != null
            ? SResourceID.fromJson(
                json['S_Resource_ID'] as Map<String, dynamic>)
            : null,
        scrappedQty = json['ScrappedQty'] as int?,
        setupTimeReal = json['SetupTimeReal'] as int?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        isSubcontracting = json['IsSubcontracting'] as bool?,
        documentNo = json['DocumentNo'] as String?,
        processedOn = json['ProcessedOn'] as double?,
        mProductionID =
            (json['M_Production_ID'] as Map<String, dynamic>?) != null
                ? MProductionID.fromJson(
                    json['M_Production_ID'] as Map<String, dynamic>)
                : null,
        mProductionNodeID =
            (json['M_Production_Node_ID'] as Map<String, dynamic>?) != null
                ? MProductionNodeID.fromJson(
                    json['M_Production_Node_ID'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'M_Product_ID': mProductID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'C_DocTypeTarget_ID': cDocTypeTargetID?.toJson(),
        'C_DocType_ID': cDocTypeID?.toJson(),
        'C_UOM_ID': cUOMID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'DateAcct': dateAcct,
        'DocStatus': docStatus?.toJson(),
        'DurationReal': durationReal,
        'IsActive': isActive,
        'IsBatchTime': isBatchTime,
        'M_Locator_ID': mLocatorID?.toJson(),
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'MovementDate': movementDate,
        'MovementQty': movementQty,
        'CostCollectorType': costCollectorType?.toJson(),
        'Processed': processed,
        'QtyReject': qtyReject,
        'S_Resource_ID': sResourceID?.toJson(),
        'ScrappedQty': scrappedQty,
        'SetupTimeReal': setupTimeReal,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'IsSubcontracting': isSubcontracting,
        'DocumentNo': documentNo,
        'ProcessedOn': processedOn,
        'M_Production_ID': mProductionID?.toJson(),
        'M_Production_Node_ID': mProductionNodeID?.toJson(),
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

class CostCollectorType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  CostCollectorType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CostCollectorType.fromJson(Map<String, dynamic> json)
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

class SResourceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SResourceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SResourceID.fromJson(Map<String, dynamic> json)
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

class MProductionNodeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MProductionNodeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MProductionNodeID.fromJson(Map<String, dynamic> json)
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
