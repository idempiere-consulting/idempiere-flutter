class MPMaintainResourcesJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  MPMaintainResourcesJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  MPMaintainResourcesJson.fromJson(Map<String, dynamic> json)
    : pagecount = json['page-count'] as int?,
      recordssize = json['records-size'] as int?,
      skiprecords = json['skip-records'] as int?,
      rowcount = json['row-count'] as int?,
      records = (json['records'] as List?)?.map((dynamic e) => Records.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'page-count' : pagecount,
    'records-size' : recordssize,
    'skip-records' : skiprecords,
    'row-count' : rowcount,
    'records' : records?.map((e) => e.toJson()).toList()
  };
}

class Records {
  final int? id;
  final String? uid;
  final UpdatedBy? updatedBy;
  final ADOrgID? aDOrgID;
  final int? costAmt;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final MPMaintainTaskID? mPMaintainTaskID;
  final int? resourceQty;
  final String? updated;
  final ADClientID? aDClientID;
  final MProductID? mProductID;
  final int? discount;
  final int? lITControl3Months;
  final int? lITControl2Months;
  final int? lITControl1Months;
  final String? value;
  final bool? lITIsField1;
  final int? manufacturedYear;
  final bool? lITIsField2;
  final bool? isValid;
  final int? useLifeYears;
  final MPMaintainID? mPMaintainID;
  final String? modelname;
  final String? locationComment;
  final String? litControl1DateFrom;
  final String? litControl1DateNext;
  final String? litControl2DateFrom;
  final String? litControl2DateNext;
  final String? litControl3DateFrom;
  final String? litControl3DateNext;
  final String? serNo;

  Records({
    this.id,
    this.uid,
    this.updatedBy,
    this.aDOrgID,
    this.costAmt,
    this.created,
    this.createdBy,
    this.isActive,
    this.mPMaintainTaskID,
    this.resourceQty,
    this.updated,
    this.aDClientID,
    this.mProductID,
    this.discount,
    this.lITControl3Months,
    this.lITControl2Months,
    this.lITControl1Months,
    this.value,
    this.lITIsField1,
    this.manufacturedYear,
    this.lITIsField2,
    this.isValid,
    this.useLifeYears,
    this.mPMaintainID,
    this.modelname,
    this.locationComment,
    this.litControl1DateFrom,
    this.litControl1DateNext,
    this.litControl2DateFrom,
    this.litControl2DateNext,
    this.litControl3DateFrom,
    this.litControl3DateNext,
    this.serNo
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      uid = json['uid'] as String?,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      costAmt = json['CostAmt'] as int?,
      created = json['Created'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      mPMaintainTaskID = (json['MP_Maintain_Task_ID'] as Map<String,dynamic>?) != null ? MPMaintainTaskID.fromJson(json['MP_Maintain_Task_ID'] as Map<String,dynamic>) : null,
      resourceQty = json['ResourceQty'] as int?,
      updated = json['Updated'] as String?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      mProductID = (json['M_Product_ID'] as Map<String,dynamic>?) != null ? MProductID.fromJson(json['M_Product_ID'] as Map<String,dynamic>) : null,
      discount = json['Discount'] as int?,
      lITControl3Months = json['LIT_Control3Months'] as int?,
      lITControl2Months = json['LIT_Control2Months'] as int?,
      lITControl1Months = json['LIT_Control1Months'] as int?,
      value = json['Value'] as String?,
      lITIsField1 = json['LIT_IsField1'] as bool?,
      manufacturedYear = json['ManufacturedYear'] as int?,
      lITIsField2 = json['LIT_IsField2'] as bool?,
      isValid = json['IsValid'] as bool?,
      useLifeYears = json['UseLifeYears'] as int?,
      mPMaintainID = (json['MP_Maintain_ID'] as Map<String,dynamic>?) != null ? MPMaintainID.fromJson(json['MP_Maintain_ID'] as Map<String,dynamic>) : null,
      modelname = json['model-name'] as String?,
      locationComment = json['LocationComment'] as String?,
      litControl1DateFrom = json['LIT_Control1DateFrom'] as String?,
      litControl1DateNext = json['LIT_Control1DateNext'] as String?,
      litControl2DateFrom = json['LIT_Control2DateFrom'] as String?,
      litControl2DateNext = json['LIT_Control2DateNext'] as String?,
      litControl3DateFrom = json['LIT_Control3DateFrom'] as String?,
      litControl3DateNext = json['LIT_Control3DateNext'] as String?,
      serNo = json['SerNo'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'uid' : uid,
    'UpdatedBy' : updatedBy?.toJson(),
    'AD_Org_ID' : aDOrgID?.toJson(),
    'CostAmt' : costAmt,
    'Created' : created,
    'CreatedBy' : createdBy?.toJson(),
    'IsActive' : isActive,
    'MP_Maintain_Task_ID' : mPMaintainTaskID?.toJson(),
    'ResourceQty' : resourceQty,
    'Updated' : updated,
    'AD_Client_ID' : aDClientID?.toJson(),
    'M_Product_ID' : mProductID?.toJson(),
    'Discount' : discount,
    'LIT_Control3Months' : lITControl3Months,
    'LIT_Control2Months' : lITControl2Months,
    'LIT_Control1Months' : lITControl1Months,
    'Value' : value,
    'LIT_IsField1' : lITIsField1,
    'ManufacturedYear' : manufacturedYear,
    'LIT_IsField2' : lITIsField2,
    'IsValid' : isValid,
    'UseLifeYears' : useLifeYears,
    'MP_Maintain_ID' : mPMaintainID?.toJson(),
    'model-name' : modelname,
    'LocationComment' : locationComment,
    'LIT_Control1DateFrom': litControl1DateFrom,
    'LIT_Control1DateNext' : litControl1DateNext,
    'LIT_Control2DateFrom': litControl2DateFrom,
    'LIT_Control2DateNext' : litControl2DateNext,
    'LIT_Control3DateFrom': litControl3DateFrom,
    'LIT_Control3DateNext' : litControl3DateNext,
    'SerNo' : serNo
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}

class MPMaintainTaskID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainTaskID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainTaskID.fromJson(Map<String, dynamic> json)
    : propertyLabel = json['propertyLabel'] as String?,
      id = json['id'] as int?,
      identifier = json['identifier'] as String?,
      modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
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
    'propertyLabel' : propertyLabel,
    'id' : id,
    'identifier' : identifier,
    'model-name' : modelname
  };
}