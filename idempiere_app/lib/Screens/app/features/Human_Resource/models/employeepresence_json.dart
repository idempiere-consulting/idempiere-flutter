class EmployeePresenceJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<EPRecords>? records;

  EmployeePresenceJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  EmployeePresenceJSON.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        arraycount = json['array-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => EPRecords.fromJson(e as Map<String, dynamic>))
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

class EPRecords {
  final int? id;
  final ADOrgID? aDOrgID;
  final ADClientID? aDClientID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? day;
  final ADUser2ID? aDUser2ID;
  final String? datePart;
  final bool? onSaturday;
  final String? dayofpresence;
  final ADUserID? aDUserID;
  final num? qty;
  final String? presente;
  final num? dailyCapacity;
  final String? modelname;

  EPRecords({
    this.id,
    this.aDOrgID,
    this.aDClientID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.day,
    this.aDUser2ID,
    this.datePart,
    this.onSaturday,
    this.dayofpresence,
    this.aDUserID,
    this.qty,
    this.presente,
    this.dailyCapacity,
    this.modelname,
  });

  EPRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
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
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        day = json['day'] as String?,
        aDUser2ID = (json['AD_User2_ID'] as Map<String, dynamic>?) != null
            ? ADUser2ID.fromJson(json['AD_User2_ID'] as Map<String, dynamic>)
            : null,
        datePart = json['date_part'] as String?,
        onSaturday = json['OnSaturday'] as bool?,
        dayofpresence = json['dayofpresence'] as String?,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        qty = json['Qty'] as num?,
        presente = json['presente'] as String?,
        dailyCapacity = json['DailyCapacity'] as num?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'AD_Org_ID': aDOrgID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'day': day,
        'AD_User2_ID': aDUser2ID?.toJson(),
        'date_part': datePart,
        'OnSaturday': onSaturday,
        'dayofpresence': dayofpresence,
        'AD_User_ID': aDUserID?.toJson(),
        'Qty': qty,
        'presente': presente,
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
