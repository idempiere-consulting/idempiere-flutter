class MPMaintainResourceJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<MPRRecords>? records;

  MPMaintainResourceJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  MPMaintainResourceJSON.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => MPRRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class MPRRecords {
  final int? id;
  final String? uid;
  final UpdatedBy? updatedBy;
  final ADOrgID? aDOrgID;
  final int? costAmt;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final int? resourceQty;
  final String? updated;
  final ADClientID? aDClientID;
  final MProductID? mProductID;
  final int? discount;
  final int? lITControl3Months;
  final int? lITControl2Months;
  final int? lITControl1Months;
  final String? lITControl1DateNext;
  final String? lITControl2DateNext;
  final String? lITControl3DateNext;
  final String? lITControl2DateFrom;
  final String? lITControl1DateFrom;
  final String? lITControl3DateFrom;
  final String? serNo;
  final String? value;
  final String? locationComment;
  final bool? lITIsField1;
  final int? manufacturedYear;
  final bool? lITIsField2;
  final bool? isValid;
  final String? manufacturer;
  final int? useLifeYears;
  final String? prodCode;
  final MPMaintainID? mPMaintainID;
  final String? dateStart;
  final String? modelname;

  MPRRecords({
    this.id,
    this.uid,
    this.updatedBy,
    this.aDOrgID,
    this.costAmt,
    this.created,
    this.createdBy,
    this.isActive,
    this.resourceQty,
    this.updated,
    this.aDClientID,
    this.mProductID,
    this.discount,
    this.lITControl3Months,
    this.lITControl2Months,
    this.lITControl1Months,
    this.lITControl1DateNext,
    this.lITControl2DateNext,
    this.lITControl3DateNext,
    this.lITControl2DateFrom,
    this.lITControl1DateFrom,
    this.lITControl3DateFrom,
    this.serNo,
    this.value,
    this.locationComment,
    this.lITIsField1,
    this.manufacturedYear,
    this.lITIsField2,
    this.isValid,
    this.manufacturer,
    this.useLifeYears,
    this.prodCode,
    this.mPMaintainID,
    this.dateStart,
    this.modelname,
  });

  MPRRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        costAmt = json['CostAmt'] as int?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        resourceQty = json['ResourceQty'] as int?,
        updated = json['Updated'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        discount = json['Discount'] as int?,
        lITControl3Months = json['LIT_Control3Months'] as int?,
        lITControl2Months = json['LIT_Control2Months'] as int?,
        lITControl1Months = json['LIT_Control1Months'] as int?,
        lITControl1DateNext = json['LIT_Control1DateNext'] as String?,
        lITControl2DateNext = json['LIT_Control2DateNext'] as String?,
        lITControl3DateNext = json['LIT_Control3DateNext'] as String?,
        lITControl2DateFrom = json['LIT_Control2DateFrom'] as String?,
        lITControl1DateFrom = json['LIT_Control1DateFrom'] as String?,
        lITControl3DateFrom = json['LIT_Control3DateFrom'] as String?,
        serNo = json['SerNo'] as String?,
        value = json['Value'] as String?,
        locationComment = json['LocationComment'] as String?,
        lITIsField1 = json['LIT_IsField1'] as bool?,
        manufacturedYear = json['ManufacturedYear'] as int?,
        lITIsField2 = json['LIT_IsField2'] as bool?,
        isValid = json['IsValid'] as bool?,
        manufacturer = json['Manufacturer'] as String?,
        useLifeYears = json['UseLifeYears'] as int?,
        prodCode = json['ProdCode'] as String?,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        dateStart = json['DateStart'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'UpdatedBy': updatedBy?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'CostAmt': costAmt,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'ResourceQty': resourceQty,
        'Updated': updated,
        'AD_Client_ID': aDClientID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'Discount': discount,
        'LIT_Control3Months': lITControl3Months,
        'LIT_Control2Months': lITControl2Months,
        'LIT_Control1Months': lITControl1Months,
        'LIT_Control1DateNext': lITControl1DateNext,
        'LIT_Control2DateNext': lITControl2DateNext,
        'LIT_Control3DateNext': lITControl3DateNext,
        'LIT_Control2DateFrom': lITControl2DateFrom,
        'LIT_Control1DateFrom': lITControl1DateFrom,
        'LIT_Control3DateFrom': lITControl3DateFrom,
        'SerNo': serNo,
        'Value': value,
        'LocationComment': locationComment,
        'LIT_IsField1': lITIsField1,
        'ManufacturedYear': manufacturedYear,
        'LIT_IsField2': lITIsField2,
        'IsValid': isValid,
        'Manufacturer': manufacturer,
        'UseLifeYears': useLifeYears,
        'ProdCode': prodCode,
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'DateStart': dateStart,
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

class MPMaintainID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainID.fromJson(Map<String, dynamic> json)
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
