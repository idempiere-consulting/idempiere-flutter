class ProjectJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  ProjectJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ProjectJson.fromJson(Map<String, dynamic> json)
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
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final String? name;
  final UpdatedBy? updatedBy;
  final bool? isSummary;
  final String? value;
  final CCurrencyID? cCurrencyID;
  final bool? isCommitment;
  final num? committedAmt;
  final bool? processed;
  final num? plannedAmt;
  final num? plannedQty;
  final num? plannedMarginAmt;
  final num? invoicedAmt;
  final num? invoicedQty;
  final num? projectBalanceAmt;
  final num? committedQty;
  final bool? isCommitCeiling;
  final ProjectCategory? projectCategory;
  final ProjInvoiceRule? projInvoiceRule;
  final ProjectLineLevel? projectLineLevel;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDOrgID,
    this.aDClientID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.name,
    this.updatedBy,
    this.isSummary,
    this.value,
    this.cCurrencyID,
    this.isCommitment,
    this.committedAmt,
    this.processed,
    this.plannedAmt,
    this.plannedQty,
    this.plannedMarginAmt,
    this.invoicedAmt,
    this.invoicedQty,
    this.projectBalanceAmt,
    this.committedQty,
    this.isCommitCeiling,
    this.projectCategory,
    this.projInvoiceRule,
    this.projectLineLevel,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        name = json['Name'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        isSummary = json['IsSummary'] as bool?,
        value = json['Value'] as String?,
        cCurrencyID = (json['C_Currency_ID'] as Map<String, dynamic>?) != null
            ? CCurrencyID.fromJson(
                json['C_Currency_ID'] as Map<String, dynamic>)
            : null,
        isCommitment = json['IsCommitment'] as bool?,
        committedAmt = json['CommittedAmt'] as num?,
        processed = json['Processed'] as bool?,
        plannedAmt = json['PlannedAmt'] as num?,
        plannedQty = json['PlannedQty'] as num?,
        plannedMarginAmt = json['PlannedMarginAmt'] as num?,
        invoicedAmt = json['InvoicedAmt'] as num?,
        invoicedQty = json['InvoicedQty'] as num?,
        projectBalanceAmt = json['ProjectBalanceAmt'] as num?,
        committedQty = json['CommittedQty'] as num?,
        isCommitCeiling = json['IsCommitCeiling'] as bool?,
        projectCategory =
            (json['ProjectCategory'] as Map<String, dynamic>?) != null
                ? ProjectCategory.fromJson(
                    json['ProjectCategory'] as Map<String, dynamic>)
                : null,
        projInvoiceRule =
            (json['ProjInvoiceRule'] as Map<String, dynamic>?) != null
                ? ProjInvoiceRule.fromJson(
                    json['ProjInvoiceRule'] as Map<String, dynamic>)
                : null,
        projectLineLevel =
            (json['ProjectLineLevel'] as Map<String, dynamic>?) != null
                ? ProjectLineLevel.fromJson(
                    json['ProjectLineLevel'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'Name': name,
        'UpdatedBy': updatedBy?.toJson(),
        'IsSummary': isSummary,
        'Value': value,
        'C_Currency_ID': cCurrencyID?.toJson(),
        'IsCommitment': isCommitment,
        'CommittedAmt': committedAmt,
        'Processed': processed,
        'PlannedAmt': plannedAmt,
        'PlannedQty': plannedQty,
        'PlannedMarginAmt': plannedMarginAmt,
        'InvoicedAmt': invoicedAmt,
        'InvoicedQty': invoicedQty,
        'ProjectBalanceAmt': projectBalanceAmt,
        'CommittedQty': committedQty,
        'IsCommitCeiling': isCommitCeiling,
        'ProjectCategory': projectCategory?.toJson(),
        'ProjInvoiceRule': projInvoiceRule?.toJson(),
        'ProjectLineLevel': projectLineLevel?.toJson(),
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

class CCurrencyID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CCurrencyID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CCurrencyID.fromJson(Map<String, dynamic> json)
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

class ProjectCategory {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ProjectCategory({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProjectCategory.fromJson(Map<String, dynamic> json)
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

class ProjInvoiceRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ProjInvoiceRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProjInvoiceRule.fromJson(Map<String, dynamic> json)
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

class ProjectLineLevel {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ProjectLineLevel({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ProjectLineLevel.fromJson(Map<String, dynamic> json)
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
