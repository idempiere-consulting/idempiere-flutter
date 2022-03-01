class ShipmentJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  ShipmentJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  ShipmentJson.fromJson(Map<String, dynamic> json)
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
  final MovementType? movementType;
  final String? movementDate;
  final String? privateNote;
  final bool? processed;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final bool? isSOTrx;
  final String? documentNo;
  final CDocTypeID? cDocTypeID;
  final bool? isPrinted;
  final String? dateAcct;
  final CBPartnerID? cBPartnerID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final MWarehouseID? mWarehouseID;
  final DeliveryRule? deliveryRule;
  final FreightCostRule? freightCostRule;
  final num? freightAmt;
  final DeliveryViaRule? deliveryViaRule;
  final num? chargeAmt;
  final PriorityRule? priorityRule;
  final DocStatus? docStatus;
  final bool? sendEMail;
  final SalesRepID? salesRepID;
  final num? noPackages;
  final bool? isInTransit;
  final bool? isApproved;
  final bool? isInDispute;
  final num? volume;
  final num? weight;
  final bool? isDropShip;
  final num? processedOn;
  final bool? isAlternateReturnAddress;
  final bool? lITIsChecked;
  final bool? isDelivered;
  final num? lITGrossWeight;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.movementType,
    this.movementDate,
    this.privateNote,
    this.processed,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.isSOTrx,
    this.documentNo,
    this.cDocTypeID,
    this.isPrinted,
    this.dateAcct,
    this.cBPartnerID,
    this.cBPartnerLocationID,
    this.mWarehouseID,
    this.deliveryRule,
    this.freightCostRule,
    this.freightAmt,
    this.deliveryViaRule,
    this.chargeAmt,
    this.priorityRule,
    this.docStatus,
    this.sendEMail,
    this.salesRepID,
    this.noPackages,
    this.isInTransit,
    this.isApproved,
    this.isInDispute,
    this.volume,
    this.weight,
    this.isDropShip,
    this.processedOn,
    this.isAlternateReturnAddress,
    this.lITIsChecked,
    this.isDelivered,
    this.lITGrossWeight,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        movementType = (json['MovementType'] as Map<String, dynamic>?) != null
            ? MovementType.fromJson(
                json['MovementType'] as Map<String, dynamic>)
            : null,
        movementDate = json['MovementDate'] as String?,
        privateNote = json['PrivateNote'] as String?,
        processed = json['Processed'] as bool?,
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
        isSOTrx = json['IsSOTrx'] as bool?,
        documentNo = json['DocumentNo'] as String?,
        cDocTypeID = (json['C_DocType_ID'] as Map<String, dynamic>?) != null
            ? CDocTypeID.fromJson(json['C_DocType_ID'] as Map<String, dynamic>)
            : null,
        isPrinted = json['IsPrinted'] as bool?,
        dateAcct = json['DateAcct'] as String?,
        cBPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        deliveryRule = (json['DeliveryRule'] as Map<String, dynamic>?) != null
            ? DeliveryRule.fromJson(
                json['DeliveryRule'] as Map<String, dynamic>)
            : null,
        freightCostRule =
            (json['FreightCostRule'] as Map<String, dynamic>?) != null
                ? FreightCostRule.fromJson(
                    json['FreightCostRule'] as Map<String, dynamic>)
                : null,
        freightAmt = json['FreightAmt'] as num?,
        deliveryViaRule =
            (json['DeliveryViaRule'] as Map<String, dynamic>?) != null
                ? DeliveryViaRule.fromJson(
                    json['DeliveryViaRule'] as Map<String, dynamic>)
                : null,
        chargeAmt = json['ChargeAmt'] as num?,
        priorityRule = (json['PriorityRule'] as Map<String, dynamic>?) != null
            ? PriorityRule.fromJson(
                json['PriorityRule'] as Map<String, dynamic>)
            : null,
        docStatus = (json['DocStatus'] as Map<String, dynamic>?) != null
            ? DocStatus.fromJson(json['DocStatus'] as Map<String, dynamic>)
            : null,
        sendEMail = json['SendEMail'] as bool?,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        noPackages = json['NoPackages'] as num?,
        isInTransit = json['IsInTransit'] as bool?,
        isApproved = json['IsApproved'] as bool?,
        isInDispute = json['IsInDispute'] as bool?,
        volume = json['Volume'] as num?,
        weight = json['Weight'] as num?,
        isDropShip = json['IsDropShip'] as bool?,
        processedOn = json['ProcessedOn'] as num?,
        isAlternateReturnAddress = json['IsAlternateReturnAddress'] as bool?,
        lITIsChecked = json['LIT_IsChecked'] as bool?,
        isDelivered = json['IsDelivered'] as bool?,
        lITGrossWeight = json['LIT_GrossWeight'] as num?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'MovementType': movementType?.toJson(),
        'MovementDate': movementDate,
        'PrivateNote': privateNote,
        'Processed': processed,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'IsSOTrx': isSOTrx,
        'DocumentNo': documentNo,
        'C_DocType_ID': cDocTypeID?.toJson(),
        'IsPrinted': isPrinted,
        'DateAcct': dateAcct,
        'C_BPartner_ID': cBPartnerID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'DeliveryRule': deliveryRule?.toJson(),
        'FreightCostRule': freightCostRule?.toJson(),
        'FreightAmt': freightAmt,
        'DeliveryViaRule': deliveryViaRule?.toJson(),
        'ChargeAmt': chargeAmt,
        'PriorityRule': priorityRule?.toJson(),
        'DocStatus': docStatus?.toJson(),
        'SendEMail': sendEMail,
        'SalesRep_ID': salesRepID?.toJson(),
        'NoPackages': noPackages,
        'IsInTransit': isInTransit,
        'IsApproved': isApproved,
        'IsInDispute': isInDispute,
        'Volume': volume,
        'Weight': weight,
        'IsDropShip': isDropShip,
        'ProcessedOn': processedOn,
        'IsAlternateReturnAddress': isAlternateReturnAddress,
        'LIT_IsChecked': lITIsChecked,
        'IsDelivered': isDelivered,
        'LIT_GrossWeight': lITGrossWeight,
        'model-name': modelname
      };
}

class MovementType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  MovementType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  MovementType.fromJson(Map<String, dynamic> json)
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

class CDocTypeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CDocTypeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CDocTypeID.fromJson(Map<String, dynamic> json)
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

class CBPartnerLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPartnerLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPartnerLocationID.fromJson(Map<String, dynamic> json)
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

class DeliveryRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DeliveryRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DeliveryRule.fromJson(Map<String, dynamic> json)
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

class FreightCostRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  FreightCostRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  FreightCostRule.fromJson(Map<String, dynamic> json)
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

class DeliveryViaRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DeliveryViaRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DeliveryViaRule.fromJson(Map<String, dynamic> json)
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

class PriorityRule {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  PriorityRule({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PriorityRule.fromJson(Map<String, dynamic> json)
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

class DocStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  DocStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  DocStatus.fromJson(Map<String, dynamic> json)
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
