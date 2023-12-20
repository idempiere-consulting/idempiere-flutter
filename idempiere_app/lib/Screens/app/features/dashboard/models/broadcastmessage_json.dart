class BroadcastMessageJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  BroadcastMessageJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  BroadcastMessageJSON.fromJson(Map<String, dynamic> json)
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
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final BroadcastFrequency? broadcastFrequency;
  final String? broadcastMessage;
  final BroadcastType? broadcastType;
  final bool? logAcknowledge;
  final Target? target;
  final ADRoleID? aDRoleID;
  final ADUserID? aDUserID;
  final ADBroadcastMessageID? aDBroadcastMessageID;
  final bool? isPublished;
  final bool? processed;
  final bool? expired;
  final String? aDBroadcastMessageUU;
  final String? title;
  final ADUser2ID? aDUser2ID;
  final ADUser3ID? aDUser3ID;
  final ADNoteID? adNoteID;
  final String? url;
  final String? modelname;

  Records({
    this.id,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.broadcastFrequency,
    this.broadcastMessage,
    this.broadcastType,
    this.logAcknowledge,
    this.target,
    this.aDRoleID,
    this.aDUserID,
    this.aDBroadcastMessageID,
    this.isPublished,
    this.processed,
    this.expired,
    this.aDBroadcastMessageUU,
    this.title,
    this.aDUser2ID,
    this.aDUser3ID,
    this.adNoteID,
    this.url,
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
        isActive = json['IsActive'] as bool?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        broadcastFrequency =
            (json['BroadcastFrequency'] as Map<String, dynamic>?) != null
                ? BroadcastFrequency.fromJson(
                    json['BroadcastFrequency'] as Map<String, dynamic>)
                : null,
        broadcastMessage = json['BroadcastMessage'] as String?,
        broadcastType = (json['BroadcastType'] as Map<String, dynamic>?) != null
            ? BroadcastType.fromJson(
                json['BroadcastType'] as Map<String, dynamic>)
            : null,
        logAcknowledge = json['LogAcknowledge'] as bool?,
        target = (json['Target'] as Map<String, dynamic>?) != null
            ? Target.fromJson(json['Target'] as Map<String, dynamic>)
            : null,
        aDRoleID = (json['AD_Role_ID'] as Map<String, dynamic>?) != null
            ? ADRoleID.fromJson(json['AD_Role_ID'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        aDBroadcastMessageID =
            (json['AD_BroadcastMessage_ID'] as Map<String, dynamic>?) != null
                ? ADBroadcastMessageID.fromJson(
                    json['AD_BroadcastMessage_ID'] as Map<String, dynamic>)
                : null,
        isPublished = json['IsPublished'] as bool?,
        processed = json['Processed'] as bool?,
        expired = json['Expired'] as bool?,
        aDBroadcastMessageUU = json['AD_BroadcastMessage_UU'] as String?,
        title = json['Title'] as String?,
        aDUser2ID = (json['AD_User2_ID'] as Map<String, dynamic>?) != null
            ? ADUser2ID.fromJson(json['AD_User2_ID'] as Map<String, dynamic>)
            : null,
        aDUser3ID = (json['AD_User3_ID'] as Map<String, dynamic>?) != null
            ? ADUser3ID.fromJson(json['AD_User3_ID'] as Map<String, dynamic>)
            : null,
        adNoteID = (json['AD_Note_ID'] as Map<String, dynamic>?) != null
            ? ADNoteID.fromJson(json['AD_Note_ID'] as Map<String, dynamic>)
            : null,
        url = json['URL'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'BroadcastFrequency': broadcastFrequency?.toJson(),
        'BroadcastMessage': broadcastMessage,
        'BroadcastType': broadcastType?.toJson(),
        'LogAcknowledge': logAcknowledge,
        'Target': target?.toJson(),
        'AD_Role_ID': aDRoleID?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
        'AD_BroadcastMessage_ID': aDBroadcastMessageID?.toJson(),
        'IsPublished': isPublished,
        'Processed': processed,
        'Expired': expired,
        'AD_BroadcastMessage_UU': aDBroadcastMessageUU,
        'Title': title,
        'AD_User2_ID': aDUser2ID?.toJson(),
        'model-name': modelname
      };
}

class ADNoteID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADNoteID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADNoteID.fromJson(Map<String, dynamic> json)
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

class BroadcastFrequency {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  BroadcastFrequency({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BroadcastFrequency.fromJson(Map<String, dynamic> json)
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

class BroadcastType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  BroadcastType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BroadcastType.fromJson(Map<String, dynamic> json)
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

class Target {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  Target({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  Target.fromJson(Map<String, dynamic> json)
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

class ADUserID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserID.fromJson(Map<String, dynamic> json)
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

class ADBroadcastMessageID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADBroadcastMessageID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADBroadcastMessageID.fromJson(Map<String, dynamic> json)
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

class ADUser2ID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUser2ID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUser2ID.fromJson(Map<String, dynamic> json)
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

class ADUser3ID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUser3ID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUser3ID.fromJson(Map<String, dynamic> json)
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
