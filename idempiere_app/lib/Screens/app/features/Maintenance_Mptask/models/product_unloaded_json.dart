class ProductUnloadedJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  ProductUnloadedJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  ProductUnloadedJSON.fromJson(Map<String, dynamic> json)
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
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final LITDraftJournalID? lITDraftJournalID;
  final String? lITDraftJournalUU;
  final MPMaintainResourceID? mPMaintainResourceID;
  final MProductID? mProductID;
  final String? name;
  final String? updated;
  final UpdatedBy? updatedBy;
  final int? qty;
  final MWarehouseID? mWarehouseID;
  final MPMaintainID? mPMaintainID;
  final String? modelname;

  Records({
    this.id,
    this.aDClientID,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.isActive,
    this.lITDraftJournalID,
    this.lITDraftJournalUU,
    this.mPMaintainResourceID,
    this.mProductID,
    this.name,
    this.updated,
    this.updatedBy,
    this.qty,
    this.mWarehouseID,
    this.mPMaintainID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        lITDraftJournalID =
            (json['LIT_DraftJournal_ID'] as Map<String, dynamic>?) != null
                ? LITDraftJournalID.fromJson(
                    json['LIT_DraftJournal_ID'] as Map<String, dynamic>)
                : null,
        lITDraftJournalUU = json['LIT_DraftJournal_UU'] as String?,
        mPMaintainResourceID =
            (json['MP_Maintain_Resource_ID'] as Map<String, dynamic>?) != null
                ? MPMaintainResourceID.fromJson(
                    json['MP_Maintain_Resource_ID'] as Map<String, dynamic>)
                : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        name = json['Name'] as String?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        qty = json['Qty'] as int?,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        mPMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'LIT_DraftJournal_ID': lITDraftJournalID?.toJson(),
        'LIT_DraftJournal_UU': lITDraftJournalUU,
        'MP_Maintain_Resource_ID': mPMaintainResourceID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'Name': name,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Qty': qty,
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'MP_Maintain_ID': mPMaintainID?.toJson(),
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

class LITDraftJournalID {
  final String? propertyLabel;
  final int? id;
  final String? modelname;

  LITDraftJournalID({
    this.propertyLabel,
    this.id,
    this.modelname,
  });

  LITDraftJournalID.fromJson(Map<String, dynamic> json)
      : propertyLabel = json['propertyLabel'] as String?,
        id = json['id'] as int?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() =>
      {'propertyLabel': propertyLabel, 'id': id, 'model-name': modelname};
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
