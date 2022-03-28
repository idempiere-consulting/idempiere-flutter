class ResourceJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<RRecords>? records;

  ResourceJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ResourceJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => RRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class RRecords {
  final int? id;
  final String? uid;
  final bool? isAvailable;
  final MWarehouseID? mWarehouseID;
  final SResourceTypeID? sResourceTypeID;
  final String? name;
  final String? value;
  final UpdatedBy? updatedBy;
  final String? updated;
  final CreatedBy? createdBy;
  final String? created;
  final bool? isActive;
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final ADUserID? aDUserID;
  final int? chargeableQty;
  final int? percentUtilization;
  final bool? isManufacturingResource;
  final int? planningHorizon;
  final bool? multiActivity;
  final int? costStandard;
  final String? modelname;

  RRecords({
    this.id,
    this.uid,
    this.isAvailable,
    this.mWarehouseID,
    this.sResourceTypeID,
    this.name,
    this.value,
    this.updatedBy,
    this.updated,
    this.createdBy,
    this.created,
    this.isActive,
    this.aDOrgID,
    this.aDClientID,
    this.aDUserID,
    this.chargeableQty,
    this.percentUtilization,
    this.isManufacturingResource,
    this.planningHorizon,
    this.multiActivity,
    this.costStandard,
    this.modelname,
  });

  RRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        isAvailable = json['IsAvailable'] as bool?,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        sResourceTypeID =
            (json['S_ResourceType_ID'] as Map<String, dynamic>?) != null
                ? SResourceTypeID.fromJson(
                    json['S_ResourceType_ID'] as Map<String, dynamic>)
                : null,
        name = json['Name'] as String?,
        value = json['Value'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        isActive = json['IsActive'] as bool?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        chargeableQty = json['ChargeableQty'] as int?,
        percentUtilization = json['PercentUtilization'] as int?,
        isManufacturingResource = json['IsManufacturingResource'] as bool?,
        planningHorizon = json['PlanningHorizon'] as int?,
        multiActivity = json['multiActivity'] as bool?,
        costStandard = json['CostStandard'] as int?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'IsAvailable': isAvailable,
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'S_ResourceType_ID': sResourceTypeID?.toJson(),
        'Name': name,
        'Value': value,
        'UpdatedBy': updatedBy?.toJson(),
        'Updated': updated,
        'CreatedBy': createdBy?.toJson(),
        'Created': created,
        'IsActive': isActive,
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
        'ChargeableQty': chargeableQty,
        'PercentUtilization': percentUtilization,
        'IsManufacturingResource': isManufacturingResource,
        'PlanningHorizon': planningHorizon,
        'multiActivity': multiActivity,
        'CostStandard': costStandard,
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

class SResourceTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SResourceTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SResourceTypeID.fromJson(Map<String, dynamic> json)
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
        'propertyLabel': propertyLabel,
        'id': id,
        'identifier': identifier,
        'model-name': modelname
      };
}
