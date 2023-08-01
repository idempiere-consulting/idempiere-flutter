class PosButtonLayoutJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  PosButtonLayoutJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  PosButtonLayoutJSON.fromJson(Map<String, dynamic> json)
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
  final String? name;
  final String? updated;
  final int? seqNo;
  final CPOSKeyLayoutID? cPOSKeyLayoutID;
  final SubKeyLayoutID? subKeyLayoutID;
  final ADClientID? aDClientID;
  final bool? isActive;
  final UpdatedBy? updatedBy;
  final String? created;
  final CreatedBy? createdBy;
  final ADOrgID? aDOrgID;
  final int? qty;
  final ADPrintColorID? aDPrintColorID;
  final MProductCategoryID? mProductCategoryID;
  final int? spanX;
  final int? spanY;
  final ADPrintFontID? aDPrintFontID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.name,
    this.updated,
    this.seqNo,
    this.cPOSKeyLayoutID,
    this.subKeyLayoutID,
    this.aDClientID,
    this.isActive,
    this.updatedBy,
    this.created,
    this.createdBy,
    this.aDOrgID,
    this.qty,
    this.aDPrintColorID,
    this.mProductCategoryID,
    this.spanX,
    this.spanY,
    this.aDPrintFontID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        name = json['Name'] as String?,
        updated = json['Updated'] as String?,
        seqNo = json['SeqNo'] as int?,
        cPOSKeyLayoutID =
            (json['C_POSKeyLayout_ID'] as Map<String, dynamic>?) != null
                ? CPOSKeyLayoutID.fromJson(
                    json['C_POSKeyLayout_ID'] as Map<String, dynamic>)
                : null,
        subKeyLayoutID =
            (json['SubKeyLayout_ID'] as Map<String, dynamic>?) != null
                ? SubKeyLayoutID.fromJson(
                    json['SubKeyLayout_ID'] as Map<String, dynamic>)
                : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        qty = json['Qty'] as int?,
        aDPrintColorID =
            (json['AD_PrintColor_ID'] as Map<String, dynamic>?) != null
                ? ADPrintColorID.fromJson(
                    json['AD_PrintColor_ID'] as Map<String, dynamic>)
                : null,
        mProductCategoryID =
            (json['M_Product_Category_ID'] as Map<String, dynamic>?) != null
                ? MProductCategoryID.fromJson(
                    json['M_Product_Category_ID'] as Map<String, dynamic>)
                : null,
        spanX = json['SpanX'] as int?,
        spanY = json['SpanY'] as int?,
        aDPrintFontID =
            (json['AD_PrintFont_ID'] as Map<String, dynamic>?) != null
                ? ADPrintFontID.fromJson(
                    json['AD_PrintFont_ID'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Name': name,
        'Updated': updated,
        'SeqNo': seqNo,
        'C_POSKeyLayout_ID': cPOSKeyLayoutID?.toJson(),
        'SubKeyLayout_ID': subKeyLayoutID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'IsActive': isActive,
        'UpdatedBy': updatedBy?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Qty': qty,
        'AD_PrintColor_ID': aDPrintColorID?.toJson(),
        'M_Product_Category_ID': mProductCategoryID?.toJson(),
        'SpanX': spanX,
        'SpanY': spanY,
        'AD_PrintFont_ID': aDPrintFontID?.toJson(),
        'model-name': modelname
      };
}

class CPOSKeyLayoutID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CPOSKeyLayoutID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPOSKeyLayoutID.fromJson(Map<String, dynamic> json)
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

class SubKeyLayoutID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SubKeyLayoutID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SubKeyLayoutID.fromJson(Map<String, dynamic> json)
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

class ADPrintFontID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADPrintFontID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADPrintFontID.fromJson(Map<String, dynamic> json)
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
