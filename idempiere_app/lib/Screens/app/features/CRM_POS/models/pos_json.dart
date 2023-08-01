class PosJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final int? arraycount;
  final List<Records>? records;

  PosJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.arraycount,
    this.records,
  });

  PosJSON.fromJson(Map<String, dynamic> json)
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
  final String? created;
  final UpdatedBy? updatedBy;
  final ADOrgID? aDOrgID;
  final CreatedBy? createdBy;
  final String? updated;
  final ADClientID? aDClientID;
  final SalesRepID? salesRepID;
  final String? name;
  final MWarehouseID? mWarehouseID;
  final MPriceListID? mPriceListID;
  final bool? isActive;
  final bool? isModifyPrice;
  final CBankAccountID? cBankAccountID;
  final int? autoLogoutDelay;
  final LITPOSType? lITPOSType;
  final CPOSKeyLayoutID? cposKeyLayoutID;
  final ADWindowID? aDWindowID;
  final ADTabID? aDTabID;
  final ADUserID? aDUserID;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.created,
    this.updatedBy,
    this.aDOrgID,
    this.createdBy,
    this.updated,
    this.aDClientID,
    this.salesRepID,
    this.name,
    this.mWarehouseID,
    this.mPriceListID,
    this.isActive,
    this.isModifyPrice,
    this.cBankAccountID,
    this.autoLogoutDelay,
    this.lITPOSType,
    this.cposKeyLayoutID,
    this.aDWindowID,
    this.aDTabID,
    this.aDUserID,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        created = json['Created'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        name = json['Name'] as String?,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
            ? MPriceListID.fromJson(
                json['M_PriceList_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        isModifyPrice = json['IsModifyPrice'] as bool?,
        cBankAccountID =
            (json['C_BankAccount_ID'] as Map<String, dynamic>?) != null
                ? CBankAccountID.fromJson(
                    json['C_BankAccount_ID'] as Map<String, dynamic>)
                : null,
        autoLogoutDelay = json['AutoLogoutDelay'] as int?,
        lITPOSType = (json['LIT_POSType'] as Map<String, dynamic>?) != null
            ? LITPOSType.fromJson(json['LIT_POSType'] as Map<String, dynamic>)
            : null,
        cposKeyLayoutID =
            (json['C_POSKeyLayout_ID'] as Map<String, dynamic>?) != null
                ? CPOSKeyLayoutID.fromJson(
                    json['C_POSKeyLayout_ID'] as Map<String, dynamic>)
                : null,
        aDWindowID = (json['AD_Window_ID'] as Map<String, dynamic>?) != null
            ? ADWindowID.fromJson(json['AD_Window_ID'] as Map<String, dynamic>)
            : null,
        aDTabID = (json['AD_Tab_ID'] as Map<String, dynamic>?) != null
            ? ADTabID.fromJson(json['AD_Tab_ID'] as Map<String, dynamic>)
            : null,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'Created': created,
        'UpdatedBy': updatedBy?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'AD_Client_ID': aDClientID?.toJson(),
        'SalesRep_ID': salesRepID?.toJson(),
        'Name': name,
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'M_PriceList_ID': mPriceListID?.toJson(),
        'IsActive': isActive,
        'IsModifyPrice': isModifyPrice,
        'C_BankAccount_ID': cBankAccountID?.toJson(),
        'AutoLogoutDelay': autoLogoutDelay,
        'LIT_POSType': lITPOSType?.toJson(),
        'C_POSKeyLayout_ID': cposKeyLayoutID?.toJson(),
        'AD_Window_ID': aDWindowID?.toJson(),
        'AD_Tab_ID': aDTabID?.toJson(),
        'AD_User_ID': aDUserID?.toJson(),
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

class MPriceListID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPriceListID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPriceListID.fromJson(Map<String, dynamic> json)
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

class CPOSKeyLayoutID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CPOSKeyLayoutID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPOSKeyLayoutID.fromJson(Map<String, dynamic> json)
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

class CBankAccountID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBankAccountID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBankAccountID.fromJson(Map<String, dynamic> json)
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

class LITPOSType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITPOSType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITPOSType.fromJson(Map<String, dynamic> json)
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

class ADWindowID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADWindowID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADWindowID.fromJson(Map<String, dynamic> json)
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

class ADTabID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADTabID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADTabID.fromJson(Map<String, dynamic> json)
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
