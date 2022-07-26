class DocTypeJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  DocTypeJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  DocTypeJson.fromJson(Map<String, dynamic> json)
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
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? name;
  final bool? isDocNoControlled;
  final DocNoSequenceID? docNoSequenceID;
  final GLCategoryID? gLCategoryID;
  final String? printName;
  final DocBaseType? docBaseType;
  final DocSubTypeSO? docSubTypeSO;
  final bool? hasCharges;
  final bool? hasProforma;
  final bool? isDefault;
  final int? documentCopies;
  final bool? isSOTrx;
  final bool? isDefaultCounterDoc;
  final bool? isPickQAConfirm;
  final bool? isShipConfirm;
  final bool? isInTransit;
  final bool? isSplitWhenDifference;
  final bool? isCreateCounter;
  final bool? isIndexed;
  final bool? isOverwriteSeqOnComplete;
  final bool? isOverwriteDateOnComplete;
  final bool? isPrepareSplitDocument;
  final bool? isChargeOrProductMandatory;
  final bool? isNoPriceListCheck;
  final GenerateWithholding? generateWithholding;
  final bool? lITIsCreateNegativeMovement;
  final bool? lITIsUseVATSequence;
  final bool? lITIsNotPosting;
  final bool? isDoNotInvoice;
  final String? modelname;

  Records({
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
    this.isDocNoControlled,
    this.docNoSequenceID,
    this.gLCategoryID,
    this.printName,
    this.docBaseType,
    this.docSubTypeSO,
    this.hasCharges,
    this.hasProforma,
    this.isDefault,
    this.documentCopies,
    this.isSOTrx,
    this.isDefaultCounterDoc,
    this.isPickQAConfirm,
    this.isShipConfirm,
    this.isInTransit,
    this.isSplitWhenDifference,
    this.isCreateCounter,
    this.isIndexed,
    this.isOverwriteSeqOnComplete,
    this.isOverwriteDateOnComplete,
    this.isPrepareSplitDocument,
    this.isChargeOrProductMandatory,
    this.isNoPriceListCheck,
    this.generateWithholding,
    this.lITIsCreateNegativeMovement,
    this.lITIsUseVATSequence,
    this.lITIsNotPosting,
    this.isDoNotInvoice,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
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
        isDocNoControlled = json['IsDocNoControlled'] as bool?,
        docNoSequenceID =
            (json['DocNoSequence_ID'] as Map<String, dynamic>?) != null
                ? DocNoSequenceID.fromJson(
                    json['DocNoSequence_ID'] as Map<String, dynamic>)
                : null,
        gLCategoryID = (json['GL_Category_ID'] as Map<String, dynamic>?) != null
            ? GLCategoryID.fromJson(
                json['GL_Category_ID'] as Map<String, dynamic>)
            : null,
        printName = json['PrintName'] as String?,
        docBaseType = (json['DocBaseType'] as Map<String, dynamic>?) != null
            ? DocBaseType.fromJson(json['DocBaseType'] as Map<String, dynamic>)
            : null,
        docSubTypeSO = (json['DocSubTypeSO'] as Map<String, dynamic>?) != null
            ? DocSubTypeSO.fromJson(
                json['DocSubTypeSO'] as Map<String, dynamic>)
            : null,
        hasCharges = json['HasCharges'] as bool?,
        hasProforma = json['HasProforma'] as bool?,
        isDefault = json['IsDefault'] as bool?,
        documentCopies = json['DocumentCopies'] as int?,
        isSOTrx = json['IsSOTrx'] as bool?,
        isDefaultCounterDoc = json['IsDefaultCounterDoc'] as bool?,
        isPickQAConfirm = json['IsPickQAConfirm'] as bool?,
        isShipConfirm = json['IsShipConfirm'] as bool?,
        isInTransit = json['IsInTransit'] as bool?,
        isSplitWhenDifference = json['IsSplitWhenDifference'] as bool?,
        isCreateCounter = json['IsCreateCounter'] as bool?,
        isIndexed = json['IsIndexed'] as bool?,
        isOverwriteSeqOnComplete = json['IsOverwriteSeqOnComplete'] as bool?,
        isOverwriteDateOnComplete = json['IsOverwriteDateOnComplete'] as bool?,
        isPrepareSplitDocument = json['IsPrepareSplitDocument'] as bool?,
        isChargeOrProductMandatory =
            json['IsChargeOrProductMandatory'] as bool?,
        isNoPriceListCheck = json['IsNoPriceListCheck'] as bool?,
        generateWithholding =
            (json['GenerateWithholding'] as Map<String, dynamic>?) != null
                ? GenerateWithholding.fromJson(
                    json['GenerateWithholding'] as Map<String, dynamic>)
                : null,
        lITIsCreateNegativeMovement =
            json['LIT_isCreateNegativeMovement'] as bool?,
        lITIsUseVATSequence = json['LIT_IsUseVATSequence'] as bool?,
        lITIsNotPosting = json['LIT_IsNotPosting'] as bool?,
        isDoNotInvoice = json['isDoNotInvoice'] as bool?,
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
        'IsDocNoControlled': isDocNoControlled,
        'DocNoSequence_ID': docNoSequenceID?.toJson(),
        'GL_Category_ID': gLCategoryID?.toJson(),
        'PrintName': printName,
        'DocBaseType': docBaseType?.toJson(),
        'DocSubTypeSO': docSubTypeSO?.toJson(),
        'HasCharges': hasCharges,
        'HasProforma': hasProforma,
        'IsDefault': isDefault,
        'DocumentCopies': documentCopies,
        'IsSOTrx': isSOTrx,
        'IsDefaultCounterDoc': isDefaultCounterDoc,
        'IsPickQAConfirm': isPickQAConfirm,
        'IsShipConfirm': isShipConfirm,
        'IsInTransit': isInTransit,
        'IsSplitWhenDifference': isSplitWhenDifference,
        'IsCreateCounter': isCreateCounter,
        'IsIndexed': isIndexed,
        'IsOverwriteSeqOnComplete': isOverwriteSeqOnComplete,
        'IsOverwriteDateOnComplete': isOverwriteDateOnComplete,
        'IsPrepareSplitDocument': isPrepareSplitDocument,
        'IsChargeOrProductMandatory': isChargeOrProductMandatory,
        'IsNoPriceListCheck': isNoPriceListCheck,
        'GenerateWithholding': generateWithholding?.toJson(),
        'LIT_isCreateNegativeMovement': lITIsCreateNegativeMovement,
        'LIT_IsUseVATSequence': lITIsUseVATSequence,
        'LIT_IsNotPosting': lITIsNotPosting,
        'isDoNotInvoice': isDoNotInvoice,
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

class DocNoSequenceID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  DocNoSequenceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocNoSequenceID.fromJson(Map<String, dynamic> json)
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

class GLCategoryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  GLCategoryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  GLCategoryID.fromJson(Map<String, dynamic> json)
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

class DocBaseType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocBaseType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocBaseType.fromJson(Map<String, dynamic> json)
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

class DocSubTypeSO {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocSubTypeSO({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocSubTypeSO.fromJson(Map<String, dynamic> json)
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

class GenerateWithholding {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  GenerateWithholding({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  GenerateWithholding.fromJson(Map<String, dynamic> json)
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
