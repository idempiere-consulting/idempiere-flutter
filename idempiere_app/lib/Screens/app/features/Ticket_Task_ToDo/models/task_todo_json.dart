class TaskToDoJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  TaskToDoJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  TaskToDoJson.fromJson(Map<String, dynamic> json)
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
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  final String? name;
  final String? updated;
  final UpdatedBy? updatedBy;
  final JPToDoType? jPToDoType;
  final ADUserID? aDUserID;
  final String? jPToDoScheduledStartTime;
  final String? jPToDoScheduledEndTime;
  final JPToDoStatus? jPToDoStatus;
  final bool? processed;
  final bool? isOpenToDoJP;
  final String? jPToDoScheduledStartDate;
  final String? jPToDoScheduledEndDate;
  final bool? isStartDateAllDayJP;
  final bool? isEndDateAllDayJP;
  final int? percent;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.created,
    this.createdBy,
    this.isActive,
    this.name,
    this.updated,
    this.updatedBy,
    this.jPToDoType,
    this.aDUserID,
    this.jPToDoScheduledStartTime,
    this.jPToDoScheduledEndTime,
    this.jPToDoStatus,
    this.processed,
    this.isOpenToDoJP,
    this.jPToDoScheduledStartDate,
    this.jPToDoScheduledEndDate,
    this.isStartDateAllDayJP,
    this.isEndDateAllDayJP,
    this.percent,
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
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        name = json['Name'] as String?,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        jPToDoType = (json['JP_ToDo_Type'] as Map<String, dynamic>?) != null
            ? JPToDoType.fromJson(json['JP_ToDo_Type'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        jPToDoScheduledStartTime =
            json['JP_ToDo_ScheduledStartTime'] as String?,
        jPToDoScheduledEndTime = json['JP_ToDo_ScheduledEndTime'] as String?,
        jPToDoStatus = (json['JP_ToDo_Status'] as Map<String, dynamic>?) != null
            ? JPToDoStatus.fromJson(
                json['JP_ToDo_Status'] as Map<String, dynamic>)
            : null,
        processed = json['Processed'] as bool?,
        isOpenToDoJP = json['IsOpenToDoJP'] as bool?,
        jPToDoScheduledStartDate =
            json['JP_ToDo_ScheduledStartDate'] as String?,
        jPToDoScheduledEndDate = json['JP_ToDo_ScheduledEndDate'] as String?,
        isStartDateAllDayJP = json['IsStartDateAllDayJP'] as bool?,
        isEndDateAllDayJP = json['IsEndDateAllDayJP'] as bool?,
        percent = json['Percent'] as int?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'Name': name,
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'JP_ToDo_Type': jPToDoType?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
        'JP_ToDo_ScheduledStartTime': jPToDoScheduledStartTime,
        'JP_ToDo_ScheduledEndTime': jPToDoScheduledEndTime,
        'JP_ToDo_Status': jPToDoStatus?.toJson(),
        'Processed': processed,
        'IsOpenToDoJP': isOpenToDoJP,
        'JP_ToDo_ScheduledStartDate': jPToDoScheduledStartDate,
        'JP_ToDo_ScheduledEndDate': jPToDoScheduledEndDate,
        'IsStartDateAllDayJP': isStartDateAllDayJP,
        'IsEndDateAllDayJP': isEndDateAllDayJP,
        'Percent': percent,
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

class JPToDoType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  JPToDoType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JPToDoType.fromJson(Map<String, dynamic> json)
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

class JPToDoStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  JPToDoStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  JPToDoStatus.fromJson(Map<String, dynamic> json)
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
