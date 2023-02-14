class B2BProductCategoryJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  B2BProductCategoryJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  B2BProductCategoryJson.fromJson(Map<String, dynamic> json)
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
  final MProductCategoryID? mProductCategoryID;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? value;
  final String? name;
  final bool? isDefault;
  final int? plannedMargin;
  final bool? isSelfService;
  final ADPrintColorID? aDPrintColorID;
  final MMPolicy? mMPolicy;
  final String? mProductCategoryUU;
  final bool? lITIsPerishable;
  final bool? isSummary;
  final int? useLifeMonths;
  final int? lITControl1Months;
  final int? lITControl2Months;
  final int? lITControl3Months;
  final String? image64;
  final String? modelname;

  Records({
    this.id,
    this.mProductCategoryID,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.value,
    this.name,
    this.isDefault,
    this.plannedMargin,
    this.isSelfService,
    this.aDPrintColorID,
    this.mMPolicy,
    this.mProductCategoryUU,
    this.lITIsPerishable,
    this.isSummary,
    this.useLifeMonths,
    this.lITControl1Months,
    this.lITControl2Months,
    this.lITControl3Months,
    this.image64,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mProductCategoryID =
            (json['M_Product_Category_ID'] as Map<String, dynamic>?) != null
                ? MProductCategoryID.fromJson(
                    json['M_Product_Category_ID'] as Map<String, dynamic>)
                : null,
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
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        isDefault = json['IsDefault'] as bool?,
        plannedMargin = json['PlannedMargin'] as int?,
        isSelfService = json['IsSelfService'] as bool?,
        aDPrintColorID =
            (json['AD_PrintColor_ID'] as Map<String, dynamic>?) != null
                ? ADPrintColorID.fromJson(
                    json['AD_PrintColor_ID'] as Map<String, dynamic>)
                : null,
        mMPolicy = (json['MMPolicy'] as Map<String, dynamic>?) != null
            ? MMPolicy.fromJson(json['MMPolicy'] as Map<String, dynamic>)
            : null,
        mProductCategoryUU = json['M_Product_Category_UU'] as String?,
        lITIsPerishable = json['LIT_IsPerishable'] as bool?,
        isSummary = json['IsSummary'] as bool?,
        useLifeMonths = json['UseLifeMonths'] as int?,
        lITControl1Months = json['LIT_Control1Months'] as int?,
        lITControl2Months = json['LIT_Control2Months'] as int?,
        lITControl3Months = json['LIT_Control3Months'] as int?,
        image64 = json['imagebase64'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'M_Product_Category_ID': mProductCategoryID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Value': value,
        'Name': name,
        'IsDefault': isDefault,
        'PlannedMargin': plannedMargin,
        'IsSelfService': isSelfService,
        'AD_PrintColor_ID': aDPrintColorID?.toJson(),
        'MMPolicy': mMPolicy?.toJson(),
        'M_Product_Category_UU': mProductCategoryUU,
        'LIT_IsPerishable': lITIsPerishable,
        'IsSummary': isSummary,
        'UseLifeMonths': useLifeMonths,
        'LIT_Control1Months': lITControl1Months,
        'LIT_Control2Months': lITControl2Months,
        'LIT_Control3Months': lITControl3Months,
        'imagebase64': image64,
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

class ADPrintColorID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADPrintColorID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADPrintColorID.fromJson(Map<String, dynamic> json)
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

class MMPolicy {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  MMPolicy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MMPolicy.fromJson(Map<String, dynamic> json)
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
