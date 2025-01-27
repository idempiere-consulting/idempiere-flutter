class TicketsJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  TicketsJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  TicketsJson.fromJson(Map<String, dynamic> json)
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
  final String? documentNo;
  final num? requestAmt;
  final Priority? priority;
  final DueType? dueType;
  final String? summary;
  final bool? isEscalated;
  final String? dateLastAction;
  final SalesRepID? salesRepID;
  final CBPartnerID? cBPartnerID;
  final MProductID? mProductID;
  final COrderID? cOrderID;
  final NextAction? nextAction;
  final String? dateNextAction;
  final bool? processed;
  final RRequestTypeID? rRequestTypeID;
  final bool? isSelfService;
  final String? dateLastAlert;
  final RStatusID? rStatusID;
  final PriorityUser? priorityUser;
  final ConfidentialType? confidentialType;
  final ADRoleID? aDRoleID;
  final bool? isInvoiced;
  final ConfidentialTypeEntry? confidentialTypeEntry;
  final num? qtySpent;
  final num? qtyInvoiced;
  final CActivityID? cActivityID;
  final String? startDate;
  final String? closeDate;
  final TaskStatus? taskStatus;
  final String? dateCompletePlan;
  final num? qtyPlan;
  final String? dateStartPlan;
  final String? name;
  final String? description;
  final String? help;
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
    this.documentNo,
    this.requestAmt,
    this.priority,
    this.dueType,
    this.summary,
    this.isEscalated,
    this.dateLastAction,
    this.salesRepID,
    this.cBPartnerID,
    this.cOrderID,
    this.mProductID,
    this.nextAction,
    this.dateNextAction,
    this.processed,
    this.rRequestTypeID,
    this.isSelfService,
    this.dateLastAlert,
    this.rStatusID,
    this.priorityUser,
    this.confidentialType,
    this.aDRoleID,
    this.isInvoiced,
    this.confidentialTypeEntry,
    this.qtySpent,
    this.qtyInvoiced,
    this.cActivityID,
    this.startDate,
    this.closeDate,
    this.taskStatus,
    this.dateCompletePlan,
    this.qtyPlan,
    this.dateStartPlan,
    this.name,
    this.description,
    this.help,
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
        documentNo = json['DocumentNo'] as String?,
        requestAmt = json['RequestAmt'] as num?,
        priority = (json['Priority'] as Map<String, dynamic>?) != null
            ? Priority.fromJson(json['Priority'] as Map<String, dynamic>)
            : null,
        dueType = (json['DueType'] as Map<String, dynamic>?) != null
            ? DueType.fromJson(json['DueType'] as Map<String, dynamic>)
            : null,
        summary = json['Summary'] as String?,
        isEscalated = json['IsEscalated'] as bool?,
        dateLastAction = json['DateLastAction'] as String?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        cOrderID = (json['C_Order_ID'] as Map<String, dynamic>?) != null
            ? COrderID.fromJson(json['C_Order_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        nextAction = (json['NextAction'] as Map<String, dynamic>?) != null
            ? NextAction.fromJson(json['NextAction'] as Map<String, dynamic>)
            : null,
        dateNextAction = json['DateNextAction'] as String?,
        help = json['Help'] as String?,
        processed = json['Processed'] as bool?,
        rRequestTypeID =
            (json['R_RequestType_ID'] as Map<String, dynamic>?) != null
                ? RRequestTypeID.fromJson(
                    json['R_RequestType_ID'] as Map<String, dynamic>)
                : null,
        isSelfService = json['IsSelfService'] as bool?,
        dateLastAlert = json['DateLastAlert'] as String?,
        rStatusID = (json['R_Status_ID'] as Map<String, dynamic>?) != null
            ? RStatusID.fromJson(json['R_Status_ID'] as Map<String, dynamic>)
            : null,
        priorityUser = (json['PriorityUser'] as Map<String, dynamic>?) != null
            ? PriorityUser.fromJson(
                json['PriorityUser'] as Map<String, dynamic>)
            : null,
        confidentialType =
            (json['ConfidentialType'] as Map<String, dynamic>?) != null
                ? ConfidentialType.fromJson(
                    json['ConfidentialType'] as Map<String, dynamic>)
                : null,
        aDRoleID = (json['AD_Role_ID'] as Map<String, dynamic>?) != null
            ? ADRoleID.fromJson(json['AD_Role_ID'] as Map<String, dynamic>)
            : null,
        isInvoiced = json['IsInvoiced'] as bool?,
        confidentialTypeEntry =
            (json['ConfidentialTypeEntry'] as Map<String, dynamic>?) != null
                ? ConfidentialTypeEntry.fromJson(
                    json['ConfidentialTypeEntry'] as Map<String, dynamic>)
                : null,
        qtySpent = json['QtySpent'] as num?,
        qtyInvoiced = json['QtyInvoiced'] as num?,
        cActivityID = (json['C_Activity_ID'] as Map<String, dynamic>?) != null
            ? CActivityID.fromJson(
                json['C_Activity_ID'] as Map<String, dynamic>)
            : null,
        startDate = json['StartDate'] as String?,
        closeDate = json['CloseDate'] as String?,
        taskStatus = (json['TaskStatus'] as Map<String, dynamic>?) != null
            ? TaskStatus.fromJson(json['TaskStatus'] as Map<String, dynamic>)
            : null,
        dateCompletePlan = json['DateCompletePlan'] as String?,
        qtyPlan = json['QtyPlan'] as num?,
        dateStartPlan = json['DateStartPlan'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
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
        'DocumentNo': documentNo,
        'RequestAmt': requestAmt,
        'Priority': priority?.toJson(),
        'DueType': dueType?.toJson(),
        'Summary': summary,
        'IsEscalated': isEscalated,
        'DateLastAction': dateLastAction,
        'SalesRep_ID': salesRepID?.toJson(),
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'NextAction': nextAction?.toJson(),
        'DateNextAction': dateNextAction,
        'Processed': processed,
        'R_RequestType_ID': rRequestTypeID?.toJson(),
        'IsSelfService': isSelfService,
        'DateLastAlert': dateLastAlert,
        'R_Status_ID': rStatusID?.toJson(),
        'PriorityUser': priorityUser?.toJson(),
        'ConfidentialType': confidentialType?.toJson(),
        'AD_Role_ID': aDRoleID?.toJson(),
        'IsInvoiced': isInvoiced,
        'ConfidentialTypeEntry': confidentialTypeEntry?.toJson(),
        'QtySpent': qtySpent,
        'QtyInvoiced': qtyInvoiced,
        'C_Activity_ID': cActivityID?.toJson(),
        'StartDate': startDate,
        'CloseDate': closeDate,
        'TaskStatus': taskStatus?.toJson(),
        'DateCompletePlan': dateCompletePlan,
        'QtyPlan': qtyPlan,
        'DateStartPlan': dateStartPlan,
        'Name': name,
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

class Priority {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  Priority({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  Priority.fromJson(Map<String, dynamic> json)
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

class COrderID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  COrderID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  COrderID.fromJson(Map<String, dynamic> json)
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

class DueType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DueType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DueType.fromJson(Map<String, dynamic> json)
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

class NextAction {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  NextAction({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  NextAction.fromJson(Map<String, dynamic> json)
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

class RRequestTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  RRequestTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  RRequestTypeID.fromJson(Map<String, dynamic> json)
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

class PriorityUser {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  PriorityUser({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PriorityUser.fromJson(Map<String, dynamic> json)
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

class ADRoleID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADRoleID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADRoleID.fromJson(Map<String, dynamic> json)
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

class ConfidentialTypeEntry {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ConfidentialTypeEntry({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ConfidentialTypeEntry.fromJson(Map<String, dynamic> json)
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

class CActivityID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CActivityID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CActivityID.fromJson(Map<String, dynamic> json)
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

class TaskStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  TaskStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  TaskStatus.fromJson(Map<String, dynamic> json)
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
