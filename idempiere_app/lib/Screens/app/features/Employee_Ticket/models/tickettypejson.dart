class TicketTypeJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<TTRecords>? records;

  TicketTypeJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  TicketTypeJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => TTRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class TTRecords {
  final int? id;
  final String? uid;
  final CreatedBy? createdBy;
  final ADOrgID? aDOrgID;
  final UpdatedBy? updatedBy;
  final String? created;
  final String? description;
  final String? name;
  final String? updated;
  final bool? isActive;
  final ADClientID? aDClientID;
  final bool? isDefault;
  final bool? isSelfService;
  final int? dueDateTolerance;
  final bool? isEMailWhenOverdue;
  final bool? isEMailWhenDue;
  final bool? isInvoiced;
  final int? autoDueDateDays;
  final ConfidentialType? confidentialType;
  final bool? isAutoChangeRequest;
  final bool? isConfidentialInfo;
  final RStatusCategoryID? rStatusCategoryID;
  final bool? isIndexed;
  final LITRequestSubType? lITRequestSubType;
  final String? modelname;

  TTRecords({
    this.id,
    this.uid,
    this.createdBy,
    this.aDOrgID,
    this.updatedBy,
    this.created,
    this.description,
    this.name,
    this.updated,
    this.isActive,
    this.aDClientID,
    this.isDefault,
    this.isSelfService,
    this.dueDateTolerance,
    this.isEMailWhenOverdue,
    this.isEMailWhenDue,
    this.isInvoiced,
    this.autoDueDateDays,
    this.confidentialType,
    this.isAutoChangeRequest,
    this.isConfidentialInfo,
    this.rStatusCategoryID,
    this.isIndexed,
    this.lITRequestSubType,
    this.modelname,
  });

  TTRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        description = json['Description'] as String?,
        name = json['Name'] as String?,
        updated = json['Updated'] as String?,
        isActive = json['IsActive'] as bool?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        isDefault = json['IsDefault'] as bool?,
        isSelfService = json['IsSelfService'] as bool?,
        dueDateTolerance = json['DueDateTolerance'] as int?,
        isEMailWhenOverdue = json['IsEMailWhenOverdue'] as bool?,
        isEMailWhenDue = json['IsEMailWhenDue'] as bool?,
        isInvoiced = json['IsInvoiced'] as bool?,
        autoDueDateDays = json['AutoDueDateDays'] as int?,
        confidentialType =
            (json['ConfidentialType'] as Map<String, dynamic>?) != null
                ? ConfidentialType.fromJson(
                    json['ConfidentialType'] as Map<String, dynamic>)
                : null,
        isAutoChangeRequest = json['IsAutoChangeRequest'] as bool?,
        isConfidentialInfo = json['IsConfidentialInfo'] as bool?,
        rStatusCategoryID =
            (json['R_StatusCategory_ID'] as Map<String, dynamic>?) != null
                ? RStatusCategoryID.fromJson(
                    json['R_StatusCategory_ID'] as Map<String, dynamic>)
                : null,
        isIndexed = json['IsIndexed'] as bool?,
        lITRequestSubType =
            (json['LIT_RequestSubType'] as Map<String, dynamic>?) != null
                ? LITRequestSubType.fromJson(
                    json['LIT_RequestSubType'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'CreatedBy': createdBy?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'UpdatedBy': updatedBy?.toJson(),
        'Created': created,
        'Description': description,
        'Name': name,
        'Updated': updated,
        'IsActive': isActive,
        'AD_Client_ID': aDClientID?.toJson(),
        'IsDefault': isDefault,
        'IsSelfService': isSelfService,
        'DueDateTolerance': dueDateTolerance,
        'IsEMailWhenOverdue': isEMailWhenOverdue,
        'IsEMailWhenDue': isEMailWhenDue,
        'IsInvoiced': isInvoiced,
        'AutoDueDateDays': autoDueDateDays,
        'ConfidentialType': confidentialType?.toJson(),
        'IsAutoChangeRequest': isAutoChangeRequest,
        'IsConfidentialInfo': isConfidentialInfo,
        'R_StatusCategory_ID': rStatusCategoryID?.toJson(),
        'IsIndexed': isIndexed,
        'LIT_RequestSubType': lITRequestSubType?.toJson(),
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

class ConfidentialType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ConfidentialType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ConfidentialType.fromJson(Map<String, dynamic> json)
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

class RStatusCategoryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  RStatusCategoryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RStatusCategoryID.fromJson(Map<String, dynamic> json)
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

class LITRequestSubType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITRequestSubType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITRequestSubType.fromJson(Map<String, dynamic> json)
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
