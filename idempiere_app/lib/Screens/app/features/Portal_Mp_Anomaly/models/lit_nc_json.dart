class LitNcJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  LitNcJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  LitNcJson.fromJson(Map<String, dynamic> json)
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
  final String? name;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final ADClientID? aDClientID;
  final String? created;
  final String? updated;
  final CreatedBy? createdBy;
  final UpdatedBy? updatedBy;
  final LITNCFaultTypeID? lITNCFaultTypeID;
  final String? ncName;
  final String? ncDescription;
  final String? dateDoc;
  final String? taskName;
  final String? taskDescription;
  final int? taskLine;
  final int? taskQuantity;
  final String? productName;
  final String? maintainLocation;
  final String? maintainValue;
  final String? modelname;
  final MPMaintainTaskID? mPMaintainTaskID;
  final MPMaintainResourceID? mPMaintainResourceID;
  final MProductID? mProductID;
  final ADUserID? aDUserID;
  final String? maintainSerNo;
  final String? litControl1DateFrom;
  final String? litControl1DateNext;
  final String? litControl2DateFrom;
  final String? litControl2DateNext;
  final String? litControl3DateFrom;
  final String? litControl3DateNext;

  Records({
    this.id,
    this.name,
    this.aDOrgID,
    this.isActive,
    this.aDClientID,
    this.created,
    this.updated,
    this.createdBy,
    this.updatedBy,
    this.lITNCFaultTypeID,
    this.ncName,
    this.ncDescription,
    this.dateDoc,
    this.taskName,
    this.taskDescription,
    this.taskLine,
    this.taskQuantity,
    this.productName,
    this.maintainLocation,
    this.maintainValue,
    this.modelname,
    this.mPMaintainResourceID,
    this.mPMaintainTaskID,
    this.mProductID,
    this.aDUserID,
    this.maintainSerNo,
    this.litControl1DateFrom,
    this.litControl1DateNext,
    this.litControl2DateFrom,
    this.litControl2DateNext,
    this.litControl3DateFrom,
    this.litControl3DateNext,
  });

  Records.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      name = json['Name'] as String?,
      aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null,
      isActive = json['IsActive'] as bool?,
      aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null,
      created = json['Created'] as String?,
      updated = json['Updated'] as String?,
      createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null,
      updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null,
      lITNCFaultTypeID = (json['LIT_NCFaultType_ID'] as Map<String,dynamic>?) != null ? LITNCFaultTypeID.fromJson(json['LIT_NCFaultType_ID'] as Map<String,dynamic>) : null,
      ncName = json['nc_name'] as String?,
      ncDescription = json['nc_description'] as String?,
      dateDoc = json['DateDoc'] as String?,
      taskName = json['task_name'] as String?,
      taskDescription = json['task_description'] as String?,
      taskLine = json['task_line'] as int?,
      taskQuantity = json['task_quantity'] as int?,
      productName = json['ProductName'] as String?,
      maintainLocation = json['maintain_location'] as String?,
      maintainValue = json['maintain_value'] as String?,
      modelname = json['model-name'] as String?,
      mPMaintainTaskID = (json['MP_Maintain_Task_ID'] as Map<String,dynamic>?) != null ? MPMaintainTaskID.fromJson(json['MP_Maintain_Task_ID'] as Map<String,dynamic>) : null,
      mPMaintainResourceID = (json['MP_Maintain_Resource_ID'] as Map<String,dynamic>?) != null ? MPMaintainResourceID.fromJson(json['MP_Maintain_Resource_ID'] as Map<String,dynamic>) : null,
      mProductID = (json['M_Product_ID'] as Map<String,dynamic>?) != null ? MProductID.fromJson(json['M_Product_ID'] as Map<String,dynamic>) : null,
      aDUserID = (json['AD_User_ID'] as Map<String,dynamic>?) != null ? ADUserID.fromJson(json['AD_User_ID'] as Map<String,dynamic>) : null,
      maintainSerNo = json['SerNo'] as String?,
      litControl1DateFrom = json['LIT_Control1DateFrom'] as String?,
      litControl1DateNext = json['LIT_Control1DateNext'] as String?,
      litControl2DateFrom = json['LIT_Control2DateFrom'] as String?,
      litControl2DateNext = json['LIT_Control2DateNext'] as String?,
      litControl3DateFrom = json['LIT_Control3DateFrom'] as String?,
      litControl3DateNext = json['LIT_Control3DateNext'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'Name' : name,
    'AD_Org_ID' : aDOrgID?.toJson(),
    'IsActive' : isActive,
    'AD_Client_ID' : aDClientID?.toJson(),
    'Created' : created,
    'Updated' : updated,
    'CreatedBy' : createdBy?.toJson(),
    'UpdatedBy' : updatedBy?.toJson(),
    'LIT_NCFaultType_ID' : lITNCFaultTypeID?.toJson(),
    'nc_name' : ncName,
    'nc_description' : ncDescription,
    'DateDoc' : dateDoc,
    'task_name' : taskName,
    'task_description' : taskDescription,
    'task_line' : taskLine,
    'task_quantity' : taskQuantity,
    'ProductName' : productName,
    'maintain_location' : maintainLocation,
    'maintain_value' : maintainValue,
    'model-name' : modelname,
    'SerNo': maintainSerNo,
    'LIT_Control1DateFrom': litControl1DateFrom,
    'LIT_Control1DateNext' : litControl1DateNext,
    'LIT_Control2DateFrom': litControl2DateFrom,
    'LIT_Control2DateNext' : litControl2DateNext,
    'LIT_Control3DateFrom': litControl3DateFrom,
    'LIT_Control3DateNext' : litControl3DateNext,
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

class LITNCFaultTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITNCFaultTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITNCFaultTypeID.fromJson(Map<String, dynamic> json)
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

class MPMaintainResourceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainResourceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainResourceID.fromJson(Map<String, dynamic> json)
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

class ADUserID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserID.fromJson(Map<String, dynamic> json)
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