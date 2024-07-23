class ProductionOrderJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<POJRecords>? records;

  ProductionOrderJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ProductionOrderJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => POJRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class POJRecords {
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
  final String? movementDate;
  final bool? processed;
  final IsCreated? isCreated;
  final num? processedOn;
  final String? documentNo;
  final MProductID? mProductID;
  final CBPartnerID? cbPartnerID;
  final MLocatorID? mLocatorID;
  final num? productionQty;
  final num? actualQty;
  final num? qtyPost;
  final String? datePromised;
  final bool? isUseProductionPlan;
  final DocStatus? docStatus;
  final CBPartnerVendorID? cBPartnerVendorID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final COrderID? cOrderID;
  final CDocTypeID? cDocTypeID;
  final ADWorkflowID? aDWorkflowID;
  final String? modelname;

  POJRecords({
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
    this.movementDate,
    this.processed,
    this.isCreated,
    this.processedOn,
    this.documentNo,
    this.mProductID,
    this.cbPartnerID,
    this.mLocatorID,
    this.productionQty,
    this.actualQty,
    this.qtyPost,
    this.datePromised,
    this.isUseProductionPlan,
    this.docStatus,
    this.cBPartnerVendorID,
    this.cBPartnerLocationID,
    this.cOrderID,
    this.cDocTypeID,
    this.aDWorkflowID,
    this.modelname,
  });

  POJRecords.fromJson(Map<String, dynamic> json)
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
        movementDate = json['MovementDate'] as String?,
        processed = json['Processed'] as bool?,
        isCreated = (json['IsCreated'] as Map<String, dynamic>?) != null
            ? IsCreated.fromJson(json['IsCreated'] as Map<String, dynamic>)
            : null,
        processedOn = json['ProcessedOn'] as num?,
        documentNo = json['DocumentNo'] as String?,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        cbPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        mLocatorID = (json['M_Locator_ID'] as Map<String, dynamic>?) != null
            ? MLocatorID.fromJson(json['M_Locator_ID'] as Map<String, dynamic>)
            : null,
        productionQty = json['ProductionQty'] as num?,
        actualQty = json['ActualQty'] as num?,
        qtyPost = json['QtyPost'] as num?,
        datePromised = json['DatePromised'] as String?,
        isUseProductionPlan = json['IsUseProductionPlan'] as bool?,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        cBPartnerVendorID =
            (json['C_BPartner_Vendor_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerVendorID.fromJson(
                    json['C_BPartner_Vendor_ID'] as Map<String, dynamic>)
                : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        cOrderID = (json['C_Order_ID'] as Map<String, dynamic>?) != null
            ? COrderID.fromJson(json['C_Order_ID'] as Map<String, dynamic>)
            : null,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        aDWorkflowID = (json['AD_Workflow_ID'] as Map<String, dynamic>?) != null
            ? ADWorkflowID.fromJson(
                json['AD_Workflow_ID'] as Map<String, dynamic>)
            : null,
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
        'Name': name,
        'Description': description,
        'MovementDate': movementDate,
        'Processed': processed,
        'IsCreated': isCreated?.toJson(),
        'ProcessedOn': processedOn,
        'DocumentNo': documentNo,
        'M_Product_ID': mProductID?.toJson(),
        'M_Locator_ID': mLocatorID?.toJson(),
        'ProductionQty': productionQty,
        'ActualQty': actualQty,
        'QtyPost': qtyPost,
        'DatePromised': datePromised,
        'IsUseProductionPlan': isUseProductionPlan,
        'DocStatus': docStatus?.toJson(),
        'C_BPartner_Vendor_ID': cBPartnerVendorID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'C_Order_ID': cOrderID?.toJson(),
        'C_DocType_ID': cDocTypeID?.toJson(),
        'AD_Workflow_ID': aDWorkflowID?.toJson(),
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

class IsCreated {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  IsCreated({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  IsCreated.fromJson(Map<String, dynamic> json)
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

class CBPartnerVendorID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerVendorID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerVendorID.fromJson(Map<String, dynamic> json)
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

class ADWorkflowID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADWorkflowID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADWorkflowID.fromJson(Map<String, dynamic> json)
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
