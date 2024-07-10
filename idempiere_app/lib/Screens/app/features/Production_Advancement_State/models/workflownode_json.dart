class WorkFlowNodeJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  WorkFlowNodeJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  WorkFlowNodeJSON.fromJson(Map<String, dynamic> json)
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
  final ADWorkflowID? aDWorkflowID;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final Action? action;
  final bool? isCentrallyMaintained;
  final int? yPosition;
  final EntityType? entityType;
  final int? xPosition;
  final int? limit;
  final int? duration;
  final num? cost;
  final int? waitingTime;
  final JoinElement? joinElement;
  final SplitElement? splitElement;
  final DocAction? docAction;
  final String? value;
  final int? dynPriorityChange;
  final bool? isMilestone;
  final bool? isSubcontracting;
  final int? unitsCycles;
  final int? yield;
  final bool? isAttachedDocumentToEmail;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.name,
    this.aDWorkflowID,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.action,
    this.isCentrallyMaintained,
    this.yPosition,
    this.entityType,
    this.xPosition,
    this.limit,
    this.duration,
    this.cost,
    this.waitingTime,
    this.joinElement,
    this.splitElement,
    this.docAction,
    this.value,
    this.dynPriorityChange,
    this.isMilestone,
    this.isSubcontracting,
    this.unitsCycles,
    this.yield,
    this.isAttachedDocumentToEmail,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        name = json['Name'] as String?,
        aDWorkflowID = (json['AD_Workflow_ID'] as Map<String, dynamic>?) != null
            ? ADWorkflowID.fromJson(
                json['AD_Workflow_ID'] as Map<String, dynamic>)
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
        action = (json['Action'] as Map<String, dynamic>?) != null
            ? Action.fromJson(json['Action'] as Map<String, dynamic>)
            : null,
        isCentrallyMaintained = json['IsCentrallyMaintained'] as bool?,
        yPosition = json['YPosition'] as int?,
        entityType = (json['EntityType'] as Map<String, dynamic>?) != null
            ? EntityType.fromJson(json['EntityType'] as Map<String, dynamic>)
            : null,
        xPosition = json['XPosition'] as int?,
        limit = json['Limit'] as int?,
        duration = json['Duration'] as int?,
        cost = json['Cost'] as num?,
        waitingTime = json['WaitingTime'] as int?,
        joinElement = (json['JoinElement'] as Map<String, dynamic>?) != null
            ? JoinElement.fromJson(json['JoinElement'] as Map<String, dynamic>)
            : null,
        splitElement = (json['SplitElement'] as Map<String, dynamic>?) != null
            ? SplitElement.fromJson(
                json['SplitElement'] as Map<String, dynamic>)
            : null,
        docAction = (json['DocAction'] as Map<String, dynamic>?) != null
            ? DocAction.fromJson(json['DocAction'] as Map<String, dynamic>)
            : null,
        value = json['Value'] as String?,
        dynPriorityChange = json['DynPriorityChange'] as int?,
        isMilestone = json['IsMilestone'] as bool?,
        isSubcontracting = json['IsSubcontracting'] as bool?,
        unitsCycles = json['UnitsCycles'] as int?,
        yield = json['Yield'] as int?,
        isAttachedDocumentToEmail = json['IsAttachedDocumentToEmail'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Name': name,
        'AD_Workflow_ID': aDWorkflowID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Action': action?.toJson(),
        'IsCentrallyMaintained': isCentrallyMaintained,
        'YPosition': yPosition,
        'EntityType': entityType?.toJson(),
        'XPosition': xPosition,
        'Limit': limit,
        'Duration': duration,
        'Cost': cost,
        'WaitingTime': waitingTime,
        'JoinElement': joinElement?.toJson(),
        'SplitElement': splitElement?.toJson(),
        'DocAction': docAction?.toJson(),
        'Value': value,
        'DynPriorityChange': dynPriorityChange,
        'IsMilestone': isMilestone,
        'IsSubcontracting': isSubcontracting,
        'UnitsCycles': unitsCycles,
        'Yield': yield,
        'IsAttachedDocumentToEmail': isAttachedDocumentToEmail,
        'model-name': modelname
      };
}

class ADWorkflowID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADWorkflowID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADWorkflowID.fromJson(Map<String, dynamic> json)
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

class Action {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  Action({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  Action.fromJson(Map<String, dynamic> json)
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

class EntityType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  EntityType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  EntityType.fromJson(Map<String, dynamic> json)
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

class JoinElement {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  JoinElement({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JoinElement.fromJson(Map<String, dynamic> json)
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

class SplitElement {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  SplitElement({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  SplitElement.fromJson(Map<String, dynamic> json)
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

class DocAction {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocAction({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocAction.fromJson(Map<String, dynamic> json)
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
