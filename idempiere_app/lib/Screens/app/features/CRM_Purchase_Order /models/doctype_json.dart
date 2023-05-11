class DocTypeJson {
  int? pagecount;
  int? recordssize;
  int? skiprecords;
  int? rowcount;
  List<DTRecords>? records;

  DocTypeJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  DocTypeJson.fromJson(Map<String, dynamic> json) {
    pagecount = json['page-count'] as int?;
    recordssize = json['records-size'] as int?;
    skiprecords = json['skip-records'] as int?;
    rowcount = json['row-count'] as int?;
    records = (json['records'] as List?)?.map((dynamic e) => DTRecords.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['page-count'] = pagecount;
    json['records-size'] = recordssize;
    json['skip-records'] = skiprecords;
    json['row-count'] = rowcount;
    json['records'] = records?.map((e) => e.toJson()).toList();
    return json;
  }
}

class DTRecords {
  int? id;
  String? uid;
  ADClientID? aDClientID;
  ADOrgID? aDOrgID;
  bool? isActive;
  String? created;
  CreatedBy? createdBy;
  String? updated;
  UpdatedBy? updatedBy;
  String? name;
  bool? isDocNoControlled;
  DocNoSequenceID? docNoSequenceID;
  GLCategoryID? gLCategoryID;
  String? printName;
  DocBaseType? docBaseType;
  String? documentNote;
  DocSubTypeSO? docSubTypeSO;
  bool? hasCharges;
  bool? hasProforma;
  bool? isDefault;
  int? documentCopies;
  bool? isSOTrx;
  bool? isDefaultCounterDoc;
  bool? isPickQAConfirm;
  bool? isShipConfirm;
  bool? isInTransit;
  bool? isSplitWhenDifference;
  bool? isCreateCounter;
  bool? isIndexed;
  bool? isOverwriteSeqOnComplete;
  bool? isOverwriteDateOnComplete;
  bool? isPrepareSplitDocument;
  bool? isChargeOrProductMandatory;
  bool? isNoPriceListCheck;
  GenerateWithholding? generateWithholding;
  bool? lITIsCreateNegativeMovement;
  bool? lITIsUseVATSequence;
  bool? lITIsPos;
  bool? lITIsNotPosting;
  bool? isDoNotInvoice;
  String? modelname;

  DTRecords({
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
    this.documentNote,
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
    this.lITIsPos,
    this.lITIsNotPosting,
    this.isDoNotInvoice,
    this.modelname,
  });

  DTRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    uid = json['uid'] as String?;
    aDClientID = (json['AD_Client_ID'] as Map<String,dynamic>?) != null ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String,dynamic>) : null;
    aDOrgID = (json['AD_Org_ID'] as Map<String,dynamic>?) != null ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String,dynamic>) : null;
    isActive = json['IsActive'] as bool?;
    created = json['Created'] as String?;
    createdBy = (json['CreatedBy'] as Map<String,dynamic>?) != null ? CreatedBy.fromJson(json['CreatedBy'] as Map<String,dynamic>) : null;
    updated = json['Updated'] as String?;
    updatedBy = (json['UpdatedBy'] as Map<String,dynamic>?) != null ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String,dynamic>) : null;
    name = json['Name'] as String?;
    isDocNoControlled = json['IsDocNoControlled'] as bool?;
    docNoSequenceID = (json['DocNoSequence_ID'] as Map<String,dynamic>?) != null ? DocNoSequenceID.fromJson(json['DocNoSequence_ID'] as Map<String,dynamic>) : null;
    gLCategoryID = (json['GL_Category_ID'] as Map<String,dynamic>?) != null ? GLCategoryID.fromJson(json['GL_Category_ID'] as Map<String,dynamic>) : null;
    printName = json['PrintName'] as String?;
    docBaseType = (json['DocBaseType'] as Map<String,dynamic>?) != null ? DocBaseType.fromJson(json['DocBaseType'] as Map<String,dynamic>) : null;
    documentNote = json['DocumentNote'] as String?;
    docSubTypeSO = (json['DocSubTypeSO'] as Map<String,dynamic>?) != null ? DocSubTypeSO.fromJson(json['DocSubTypeSO'] as Map<String,dynamic>) : null;
    hasCharges = json['HasCharges'] as bool?;
    hasProforma = json['HasProforma'] as bool?;
    isDefault = json['IsDefault'] as bool?;
    documentCopies = json['DocumentCopies'] as int?;
    isSOTrx = json['IsSOTrx'] as bool?;
    isDefaultCounterDoc = json['IsDefaultCounterDoc'] as bool?;
    isPickQAConfirm = json['IsPickQAConfirm'] as bool?;
    isShipConfirm = json['IsShipConfirm'] as bool?;
    isInTransit = json['IsInTransit'] as bool?;
    isSplitWhenDifference = json['IsSplitWhenDifference'] as bool?;
    isCreateCounter = json['IsCreateCounter'] as bool?;
    isIndexed = json['IsIndexed'] as bool?;
    isOverwriteSeqOnComplete = json['IsOverwriteSeqOnComplete'] as bool?;
    isOverwriteDateOnComplete = json['IsOverwriteDateOnComplete'] as bool?;
    isPrepareSplitDocument = json['IsPrepareSplitDocument'] as bool?;
    isChargeOrProductMandatory = json['IsChargeOrProductMandatory'] as bool?;
    isNoPriceListCheck = json['IsNoPriceListCheck'] as bool?;
    generateWithholding = (json['GenerateWithholding'] as Map<String,dynamic>?) != null ? GenerateWithholding.fromJson(json['GenerateWithholding'] as Map<String,dynamic>) : null;
    lITIsCreateNegativeMovement = json['LIT_isCreateNegativeMovement'] as bool?;
    lITIsUseVATSequence = json['LIT_IsUseVATSequence'] as bool?;
    lITIsPos = json['LIT_isPos'] as bool?;
    lITIsNotPosting = json['LIT_IsNotPosting'] as bool?;
    isDoNotInvoice = json['isDoNotInvoice'] as bool?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['uid'] = uid;
    json['AD_Client_ID'] = aDClientID?.toJson();
    json['AD_Org_ID'] = aDOrgID?.toJson();
    json['IsActive'] = isActive;
    json['Created'] = created;
    json['CreatedBy'] = createdBy?.toJson();
    json['Updated'] = updated;
    json['UpdatedBy'] = updatedBy?.toJson();
    json['Name'] = name;
    json['IsDocNoControlled'] = isDocNoControlled;
    json['DocNoSequence_ID'] = docNoSequenceID?.toJson();
    json['GL_Category_ID'] = gLCategoryID?.toJson();
    json['PrintName'] = printName;
    json['DocBaseType'] = docBaseType?.toJson();
    json['DocumentNote'] = documentNote;
    json['DocSubTypeSO'] = docSubTypeSO?.toJson();
    json['HasCharges'] = hasCharges;
    json['HasProforma'] = hasProforma;
    json['IsDefault'] = isDefault;
    json['DocumentCopies'] = documentCopies;
    json['IsSOTrx'] = isSOTrx;
    json['IsDefaultCounterDoc'] = isDefaultCounterDoc;
    json['IsPickQAConfirm'] = isPickQAConfirm;
    json['IsShipConfirm'] = isShipConfirm;
    json['IsInTransit'] = isInTransit;
    json['IsSplitWhenDifference'] = isSplitWhenDifference;
    json['IsCreateCounter'] = isCreateCounter;
    json['IsIndexed'] = isIndexed;
    json['IsOverwriteSeqOnComplete'] = isOverwriteSeqOnComplete;
    json['IsOverwriteDateOnComplete'] = isOverwriteDateOnComplete;
    json['IsPrepareSplitDocument'] = isPrepareSplitDocument;
    json['IsChargeOrProductMandatory'] = isChargeOrProductMandatory;
    json['IsNoPriceListCheck'] = isNoPriceListCheck;
    json['GenerateWithholding'] = generateWithholding?.toJson();
    json['LIT_isCreateNegativeMovement'] = lITIsCreateNegativeMovement;
    json['LIT_IsUseVATSequence'] = lITIsUseVATSequence;
    json['LIT_isPos'] = lITIsPos;
    json['LIT_IsNotPosting'] = lITIsNotPosting;
    json['isDoNotInvoice'] = isDoNotInvoice;
    json['model-name'] = modelname;
    return json;
  }
}

class ADClientID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADClientID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADClientID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class ADOrgID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  ADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADOrgID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class CreatedBy {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  CreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CreatedBy.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class UpdatedBy {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  UpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  UpdatedBy.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class DocNoSequenceID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  DocNoSequenceID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocNoSequenceID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class GLCategoryID {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelname;

  GLCategoryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  GLCategoryID.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as int?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class DocBaseType {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  DocBaseType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocBaseType.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as String?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class DocSubTypeSO {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  DocSubTypeSO({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocSubTypeSO.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as String?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}

class GenerateWithholding {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelname;

  GenerateWithholding({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  GenerateWithholding.fromJson(Map<String, dynamic> json) {
    propertyLabel = json['propertyLabel'] as String?;
    id = json['id'] as String?;
    identifier = json['identifier'] as String?;
    modelname = json['model-name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['propertyLabel'] = propertyLabel;
    json['id'] = id;
    json['identifier'] = identifier;
    json['model-name'] = modelname;
    return json;
  }
}