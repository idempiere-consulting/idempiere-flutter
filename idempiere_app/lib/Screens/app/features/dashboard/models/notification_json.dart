class NotificationJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  NotificationJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  NotificationJson.fromJson(Map<String, dynamic> json)
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
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? recordName;
  final String? docType;
  final bool? isSOTrx;
  final SalesRepID? salesRepID;
  final bool? isActive;
  final String? updated;
  final String? modelname;

  Records({
    this.id,
    this.aDClientID,
    this.aDOrgID,
    this.recordName,
    this.docType,
    this.isSOTrx,
    this.salesRepID,
    this.isActive,
    this.updated,
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
        recordName = json['record_name'] as String?,
        docType = json['DocType'] as String?,
        isSOTrx = json['IsSOTrx'] as bool?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        updated = json['Updated'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'record_name': recordName,
        'DocType': docType,
        'IsSOTrx': isSOTrx,
        'SalesRep_ID': salesRepID?.toJson(),
        'IsActive': isActive,
        'Updated': updated,
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
