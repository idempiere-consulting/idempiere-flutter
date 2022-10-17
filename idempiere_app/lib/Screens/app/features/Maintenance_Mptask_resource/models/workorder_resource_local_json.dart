class WorkOrderResourceLocalJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  int? rowcount;
  List<RRecords>? records;

  WorkOrderResourceLocalJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  WorkOrderResourceLocalJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => RRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class RRecords {
  final int? id;
  final String? mpOtDocumentno;
  final String? mpDateworkstart;
  final ADClientID? aDClientID;
  final UpdatedBy? updatedBy;
  final int? costAmt;
  final String? created;
  final CreatedBy? createdBy;
  final bool? isActive;
  bool? isValid;
  final int? resourceQty;
  final ResourceType? resourceType;
  final String? updated;
  final ADOrgID? aDOrgID;
  MProductID? mProductID;
  final int? discount;
  String? value;
  String? name;
  String? description;
  String? serNo;
  String? lITControl3DateFrom;
  String? lITControl3DateNext;
  String? lITControl2DateFrom;
  String? lITControl2DateNext;
  String? lITControl1DateFrom;
  String? lITControl1DateNext;
  final LITSurveySheetsID? lITSurveySheetsID;
  EDIType? eDIType;
  String? lot;
  String? locationComment;
  int? manufacturedYear;
  String? userName;
  String? serviceDate;
  String? endDate;
  String? manufacturer;
  int? useLifeYears;
  String? lITProductModel;
  String? dateOrdered;
  LITResourceType? lITResourceType;
  final String? modelname;
  String? prodCode;
  String? textDetails;
  int? offlineId;
  bool? filtered;
  bool? checked;
  MPMaintainID? mpMaintainID;
  String? number;
  int? lineNo;
  String? team;

  RRecords(
      {this.id,
      this.mpOtDocumentno,
      this.mpDateworkstart,
      this.aDClientID,
      this.updatedBy,
      this.costAmt,
      this.created,
      this.createdBy,
      this.isActive,
      this.isValid,
      this.resourceQty,
      this.resourceType,
      this.updated,
      this.aDOrgID,
      this.mProductID,
      this.discount,
      this.value,
      this.name,
      this.description,
      this.serNo,
      this.lITControl3DateFrom,
      this.lITControl3DateNext,
      this.lITControl2DateFrom,
      this.lITControl2DateNext,
      this.lITControl1DateFrom,
      this.lITControl1DateNext,
      this.lITSurveySheetsID,
      this.eDIType,
      this.lot,
      this.locationComment,
      this.manufacturedYear,
      this.userName,
      this.serviceDate,
      this.endDate,
      this.manufacturer,
      this.useLifeYears,
      this.lITProductModel,
      this.dateOrdered,
      this.lITResourceType,
      this.modelname,
      this.prodCode,
      this.textDetails,
      this.offlineId,
      this.checked,
      this.mpMaintainID,
      this.number,
      this.lineNo,
      this.team});

  RRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        mpOtDocumentno = json['mp_ot_documentno'] as String?,
        mpDateworkstart = json['mp_dateworkstart'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        costAmt = json['CostAmt'] as int?,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        isValid = json['IsValid'] as bool?,
        resourceQty = json['ResourceQty'] as int?,
        resourceType = (json['ResourceType'] as Map<String, dynamic>?) != null
            ? ResourceType.fromJson(
                json['ResourceType'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        mProductID = (json['M_Product_ID'] as Map<String, dynamic>?) != null
            ? MProductID.fromJson(json['M_Product_ID'] as Map<String, dynamic>)
            : null,
        discount = json['Discount'] as int?,
        value = json['Value'] as String?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        serNo = json['SerNo'] as String?,
        lITControl3DateFrom = json['LIT_Control3DateFrom'] as String?,
        lITControl3DateNext = json['LIT_Control3DateNext'] as String?,
        lITControl2DateFrom = json['LIT_Control2DateFrom'] as String?,
        lITControl2DateNext = json['LIT_Control2DateNext'] as String?,
        lITControl1DateFrom = json['LIT_Control1DateFrom'] as String?,
        lITControl1DateNext = json['LIT_Control1DateNext'] as String?,
        lITSurveySheetsID =
            (json['LIT_SurveySheets_ID'] as Map<String, dynamic>?) != null
                ? LITSurveySheetsID.fromJson(
                    json['LIT_SurveySheets_ID'] as Map<String, dynamic>)
                : null,
        eDIType = (json['EDIType'] as Map<String, dynamic>?) != null
            ? EDIType.fromJson(json['EDIType'] as Map<String, dynamic>)
            : null,
        lot = json['Lot'] as String?,
        locationComment = json['LocationComment'] as String?,
        manufacturedYear = json['ManufacturedYear'] as int?,
        userName = json['UserName'] as String?,
        serviceDate = json['ServiceDate'] as String?,
        endDate = json['EndDate'] as String?,
        manufacturer = json['Manufacturer'] as String?,
        useLifeYears = json['UseLifeYears'] as int?,
        lITProductModel = json['LIT_ProductModel'] as String?,
        dateOrdered = json['DateOrdered'] as String?,
        lITResourceType =
            (json['LIT_ResourceType'] as Map<String, dynamic>?) != null
                ? LITResourceType.fromJson(
                    json['LIT_ResourceType'] as Map<String, dynamic>)
                : null,
        modelname = json['model-name'] as String?,
        prodCode = json['ProdCode'] as String?,
        textDetails = json['TextDetails'] as String?,
        offlineId = json['offlineId'] as int?,
        checked = false,
        filtered = false,
        mpMaintainID = (json['MP_Maintain_ID'] as Map<String, dynamic>?) != null
            ? MPMaintainID.fromJson(
                json['MP_Maintain_ID'] as Map<String, dynamic>)
            : null,
        number = json['V_Number'] as String?,
        lineNo = json['LineNo'] as int?,
        team = json['team'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mp_ot_documentno': mpOtDocumentno,
        'mp_dateworkstart': mpDateworkstart,
        'AD_Client_ID': aDClientID?.toJson(),
        'UpdatedBy': updatedBy?.toJson(),
        'CostAmt': costAmt,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'IsActive': isActive,
        'IsValid': isValid,
        'ResourceQty': resourceQty,
        'ResourceType': resourceType?.toJson(),
        'Updated': updated,
        'AD_Org_ID': aDOrgID?.toJson(),
        'M_Product_ID': mProductID?.toJson(),
        'Discount': discount,
        'Value': value,
        'Name': name,
        'Description': description,
        'SerNo': serNo,
        'LIT_Control3DateFrom': lITControl3DateFrom,
        'LIT_Control3DateNext': lITControl3DateNext,
        'LIT_Control2DateFrom': lITControl2DateFrom,
        'LIT_Control2DateNext': lITControl2DateNext,
        'LIT_Control1DateFrom': lITControl1DateFrom,
        'LIT_Control1DateNext': lITControl1DateNext,
        'model-name': modelname,
        'LIT_SurveySheets_ID': lITSurveySheetsID?.toJson(),
        'EDIType': eDIType?.toJson(),
        'Lot': lot,
        'LocationComment': locationComment,
        'ManufacturedYear': manufacturedYear,
        'UserName': userName,
        'ServiceDate': serviceDate,
        'EndDate': endDate,
        'Manufacturer': manufacturer,
        'UseLifeYears': useLifeYears,
        'LIT_ProductModel': lITProductModel,
        'DateOrdered': dateOrdered,
        'LIT_ResourceType': lITResourceType?.toJson(),
        'offlineId': offlineId,
        'ProdCode': prodCode,
        'TextDetails': textDetails,
        'Checked': checked,
        'Filtered': filtered,
        'MP_Maintain_ID': mpMaintainID?.toJson(),
        'LineNo': lineNo,
        'V_Number': number,
        'team': team,
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

class ResourceType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ResourceType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ResourceType.fromJson(Map<String, dynamic> json)
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

class MProductID {
  final String? propertyLabel;
  int? id;
  String? identifier;
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

class LITSurveySheetsID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITSurveySheetsID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITSurveySheetsID.fromJson(Map<String, dynamic> json)
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

class EDIType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  EDIType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  EDIType.fromJson(Map<String, dynamic> json)
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

class LITResourceType {
  final String? propertyLabel;
  String? id;
  final String? identifier;
  final String? modelname;

  LITResourceType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITResourceType.fromJson(Map<String, dynamic> json)
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

class MPMaintainID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  MPMaintainID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MPMaintainID.fromJson(Map<String, dynamic> json)
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
