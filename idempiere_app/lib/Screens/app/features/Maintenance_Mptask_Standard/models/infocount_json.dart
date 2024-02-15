class InfoCountJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  InfoCountJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  InfoCountJSON.fromJson(Map<String, dynamic> json)
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
  final bool? isActive;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? created;
  final CreatedBy? createdBy;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final MProductCategoryID? mProductCategoryID;
  final String? categoryName;
  final String? revsCount;
  String? pcCount;
  String? prCount;
  String? ptCount;
  String? pxCount;
  final String? todoAction;
  final MPMaintainID? mPMaintainID;
  final String? mpc2CategoryName;
  final String? mpc2CategoryNote;
  final MPOTID? mPOTID;
  final String? modelname;

  Records({
    this.id,
    this.isActive,
    this.updated,
    this.updatedBy,
    this.created,
    this.createdBy,
    this.aDClientID,
    this.aDOrgID,
    this.mProductCategoryID,
    this.categoryName,
    this.revsCount,
    this.pcCount,
    this.prCount,
    this.ptCount,
    this.pxCount,
    this.todoAction,
    this.mPMaintainID,
    this.mpc2CategoryName,
    this.mpc2CategoryNote,
    this.mPOTID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        isActive = json['IsActive'] as bool?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        mProductCategoryID =
            (json['M_Product_Category_ID'] as Map<String, dynamic>?) != null
                ? MProductCategoryID.fromJson(
                    json['M_Product_Category_ID'] as Map<String, dynamic>)
                : null,
        categoryName = json['CategoryName'] as String?,
        revsCount = json['revs_count'] as String?,
        pcCount = json['revs_count'] as String?,
        prCount = json['prnow_count'] as String?,
        ptCount = json['pt_count'] as String?,
        pxCount = json['px_count'] as String?,
        todoAction = json['todo_action'] as String?,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        mpc2CategoryName = json['mpc2_category_name'] as String?,
        mpc2CategoryNote = json['mpc2_category_note'] as String?,
        mPOTID = (json['MP_OT_ID'] as Map<String, dynamic>?) != null
            ? MPOTID.fromJson(json['MP_OT_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'IsActive': isActive,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'M_Product_Category_ID': mProductCategoryID?.toJson(),
        'CategoryName': categoryName,
        'revs_count': revsCount,
        'todo_action': todoAction,
        'MP_Maintain_ID': mPMaintainID?.toJson(),
        'mpc2_category_name': mpc2CategoryName,
        'mpc2_category_note': mpc2CategoryNote,
        'MP_OT_ID': mPOTID?.toJson(),
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

class MPOTID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPOTID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPOTID.fromJson(Map<String, dynamic> json)
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
