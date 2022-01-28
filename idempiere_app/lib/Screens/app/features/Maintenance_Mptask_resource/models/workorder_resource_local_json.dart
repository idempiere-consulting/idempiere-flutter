class WorkOrderResourceLocalJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  WorkOrderResourceLocalJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  WorkOrderResourceLocalJson.fromJson(Map<String, dynamic> json)
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
  final String? mpOtDocumentno;
  final String? mpDateworkstart;
  final ADClientID? aDClientID;
  final UpdatedBy? updatedBy;
  final int? costAmt;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final int? resourceQty;
  final ResourceType? resourceType;
  final String? updated;
  final ADOrgID? aDOrgID;
  final MProductID? mProductID;
  final int? discount;
  final String? value;
  final String? name;
  final String? description;
  final String? serNo;
  final String? lITControl3DateFrom;
  final String? lITControl3DateNext;
  final String? lITControl2DateFrom;
  final String? lITControl2DateNext;
  final String? lITControl1DateFrom;
  final String? lITControl1DateNext;
  final String? modelname;

  Records({
    this.id,
    this.mpOtDocumentno,
    this.mpDateworkstart,
    this.aDClientID,
    this.updatedBy,
    this.costAmt,
    this.created,
    this.createdBy,
    this.isActive,
    this.resourceQty,
    this.resourceType,
    this.updated,
    this.aDOrgID,
    this.mProductID,
    this.discount,
    this.value,
    this.name,
    this.description,
    this.serNo,
    this.lITControl3DateFrom,
    this.lITControl3DateNext,
    this.lITControl2DateFrom,
    this.lITControl2DateNext,
    this.lITControl1DateFrom,
    this.lITControl1DateNext,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mpOtDocumentno = json['mp_ot_documentno'] as String?,
        mpDateworkstart = json['mp_dateworkstart'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        costAmt = json['CostAmt'] as int?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        resourceQty = json['ResourceQty'] as int?,
        resourceType = (json['ResourceType'] as Map<String, dynamic>?) != null
            ? ResourceType.fromJson(
                json['ResourceType'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        discount = json['Discount'] as int?,
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        serNo = json['SerNo'] as String?,
        lITControl3DateFrom = json['LIT_Control3DateFrom'] as String?,
        lITControl3DateNext = json['LIT_Control3DateNext'] as String?,
        lITControl2DateFrom = json['LIT_Control2DateFrom'] as String?,
        lITControl2DateNext = json['LIT_Control2DateNext'] as String?,
        lITControl1DateFrom = json['LIT_Control1DateFrom'] as String?,
        lITControl1DateNext = json['LIT_Control1DateNext'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mp_ot_documentno': mpOtDocumentno,
        'mp_dateworkstart': mpDateworkstart,
        'AD_Client_ID': aDClientID?.toJson(),
        'UpdatedBy': updatedBy?.toJson(),
        'CostAmt': costAmt,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'ResourceQty': resourceQty,
        'ResourceType': resourceType?.toJson(),
        'Updated': updated,
        'AD_Org_ID': aDOrgID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'Discount': discount,
        'Value': value,
        'Name': name,
        'Description': description,
        'SerNo': serNo,
        'LIT_Control3DateFrom': lITControl3DateFrom,
        'LIT_Control3DateNext': lITControl3DateNext,
        'LIT_Control2DateFrom': lITControl2DateFrom,
        'LIT_Control2DateNext': lITControl2DateNext,
        'LIT_Control1DateFrom': lITControl1DateFrom,
        'LIT_Control1DateNext': lITControl1DateNext,
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

class ResourceType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ResourceType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ResourceType.fromJson(Map<String, dynamic> json)
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
