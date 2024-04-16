class ProjectJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  ProjectJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  ProjectJSON.fromJson(Map<String, dynamic> json)
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
  final CBPartnerID? cBPartnerID;
  final bool? isCommitment;
  final num? committedAmt;
  final String? dateContract;
  final String? dateFinish;
  final bool? processed;
  final SalesRepID? salesRepID;
  final num? plannedAmt;
  final int? plannedQty;
  final num? plannedMarginAmt;
  final CPaymentTermID? cPaymentTermID;
  final num? invoicedAmt;
  final int? invoicedQty;
  final int? cProjectTypeID;
  final int? projectBalanceAmt;
  final int? committedQty;
  final bool? isCommitCeiling;
  final MWarehouseID? mWarehouseID;
  final ProjectCategory? projectCategory;
  final ProjInvoiceRule? projInvoiceRule;
  final ProjectLineLevel? projectLineLevel;
  final RStatusID? rStatusID;
  final String? startDate;
  final String? endDate;
  final bool? lITIsVisible;
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
    this.cBPartnerID,
    this.isCommitment,
    this.committedAmt,
    this.dateContract,
    this.dateFinish,
    this.processed,
    this.salesRepID,
    this.plannedAmt,
    this.plannedQty,
    this.plannedMarginAmt,
    this.cPaymentTermID,
    this.invoicedAmt,
    this.invoicedQty,
    this.cProjectTypeID,
    this.projectBalanceAmt,
    this.committedQty,
    this.isCommitCeiling,
    this.mWarehouseID,
    this.projectCategory,
    this.projInvoiceRule,
    this.projectLineLevel,
    this.rStatusID,
    this.startDate,
    this.endDate,
    this.lITIsVisible,
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
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        isCommitment = json['IsCommitment'] as bool?,
        committedAmt = json['CommittedAmt'] as num?,
        dateContract = json['DateContract'] as String?,
        dateFinish = json['DateFinish'] as String?,
        processed = json['Processed'] as bool?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        plannedAmt = json['PlannedAmt'] as num?,
        plannedQty = json['PlannedQty'] as int?,
        plannedMarginAmt = json['PlannedMarginAmt'] as num?,
        cPaymentTermID =
            (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
                ? CPaymentTermID.fromJson(
                    json['C_PaymentTerm_ID'] as Map<String, dynamic>)
                : null,
        invoicedAmt = json['InvoicedAmt'] as num?,
        invoicedQty = json['InvoicedQty'] as int?,
        cProjectTypeID = json['C_ProjectType_ID'] as int?,
        projectBalanceAmt = json['ProjectBalanceAmt'] as int?,
        committedQty = json['CommittedQty'] as int?,
        isCommitCeiling = json['IsCommitCeiling'] as bool?,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
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
        rStatusID = (json['R_Status_ID'] as Map<String, dynamic>?) != null
            ? RStatusID.fromJson(json['R_Status_ID'] as Map<String, dynamic>)
            : null,
        startDate = json['StartDate'] as String?,
        endDate = json['EndDate'] as String?,
        lITIsVisible = json['LIT_IsVisible'] as bool?,
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
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'IsCommitment': isCommitment,
        'CommittedAmt': committedAmt,
        'DateContract': dateContract,
        'DateFinish': dateFinish,
        'Processed': processed,
        'SalesRep_ID': salesRepID?.toJson(),
        'PlannedAmt': plannedAmt,
        'PlannedQty': plannedQty,
        'PlannedMarginAmt': plannedMarginAmt,
        'C_PaymentTerm_ID': cPaymentTermID?.toJson(),
        'InvoicedAmt': invoicedAmt,
        'InvoicedQty': invoicedQty,
        'C_ProjectType_ID': cProjectTypeID,
        'ProjectBalanceAmt': projectBalanceAmt,
        'CommittedQty': committedQty,
        'IsCommitCeiling': isCommitCeiling,
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'ProjectCategory': projectCategory?.toJson(),
        'ProjInvoiceRule': projInvoiceRule?.toJson(),
        'ProjectLineLevel': projectLineLevel?.toJson(),
        'R_Status_ID': rStatusID?.toJson(),
        'StartDate': startDate,
        'EndDate': endDate,
        'LIT_IsVisible': lITIsVisible,
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

class CBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerID.fromJson(Map<String, dynamic> json)
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

class SalesRepID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  SalesRepID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SalesRepID.fromJson(Map<String, dynamic> json)
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

class CPaymentTermID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CPaymentTermID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPaymentTermID.fromJson(Map<String, dynamic> json)
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

class RStatusID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  RStatusID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RStatusID.fromJson(Map<String, dynamic> json)
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
