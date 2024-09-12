class OrgInfoJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  OrgInfoJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  OrgInfoJSON.fromJson(Map<String, dynamic> json)
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
  final CLocationID? cLocationID;
  final ADClientID? aDClientID;
  final ADOrgID? adOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? dUNS;
  final String? taxID;
  final ParentOrgID? parentOrgID;
  final MWarehouseID? mWarehouseID;
  final LCOISICID? lCOISICID;
  final String? lITNationalIdNumberID;
  final String? lITReportParam;
  final LITTaxRegime? lITTaxRegime;
  final LITPriceListCostID? lITPriceListCostID;
  final String? lITFEIdCodTrasmit;
  final String? lITReportParam1;
  final LITCBPartnerFiscalID? lITCBPartnerFiscalID;
  final LITVATCChargeID? lITVATCChargeID;
  final LITVATCChargeCredit1ID? lITVATCChargeCredit1ID;
  final LITVATCChargeDebit1ID? lITVATCChargeDebit1ID;
  final LITVATCChargeDebit2ID? lITVATCChargeDebit2ID;
  final LITBPartnerRevenueAgencyID? lITBPartnerRevenueAgencyID;
  final String? lITMemberPosition;
  final String? lITDeclarant;
  final String? lITPresentationType;
  final String? lITFEPAIPA;
  final String? phone;
  final String? email;
  final String? modelname;

  Records({
    this.id,
    this.uid,
    this.cLocationID,
    this.aDClientID,
    this.adOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.dUNS,
    this.taxID,
    this.parentOrgID,
    this.mWarehouseID,
    this.lCOISICID,
    this.lITNationalIdNumberID,
    this.lITReportParam,
    this.lITTaxRegime,
    this.lITPriceListCostID,
    this.lITFEIdCodTrasmit,
    this.lITReportParam1,
    this.lITCBPartnerFiscalID,
    this.lITVATCChargeID,
    this.lITVATCChargeCredit1ID,
    this.lITVATCChargeDebit1ID,
    this.lITVATCChargeDebit2ID,
    this.lITBPartnerRevenueAgencyID,
    this.lITMemberPosition,
    this.lITDeclarant,
    this.lITPresentationType,
    this.lITFEPAIPA,
    this.phone,
    this.email,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        cLocationID = (json['C_Location_ID'] as Map<String, dynamic>?) != null
            ? CLocationID.fromJson(
                json['C_Location_ID'] as Map<String, dynamic>)
            : null,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        adOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
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
        dUNS = json['DUNS'] as String?,
        taxID = json['TaxID'] as String?,
        parentOrgID = (json['Parent_Org_ID'] as Map<String, dynamic>?) != null
            ? ParentOrgID.fromJson(
                json['Parent_Org_ID'] as Map<String, dynamic>)
            : null,
        mWarehouseID = (json['M_Warehouse_ID'] as Map<String, dynamic>?) != null
            ? MWarehouseID.fromJson(
                json['M_Warehouse_ID'] as Map<String, dynamic>)
            : null,
        lCOISICID = (json['LCO_ISIC_ID'] as Map<String, dynamic>?) != null
            ? LCOISICID.fromJson(json['LCO_ISIC_ID'] as Map<String, dynamic>)
            : null,
        lITNationalIdNumberID = json['LIT_NationalIdNumber_ID'] as String?,
        lITReportParam = json['LIT_Report_Param'] as String?,
        lITTaxRegime = (json['LIT_TaxRegime'] as Map<String, dynamic>?) != null
            ? LITTaxRegime.fromJson(
                json['LIT_TaxRegime'] as Map<String, dynamic>)
            : null,
        lITPriceListCostID =
            (json['LIT_PriceList_Cost_ID'] as Map<String, dynamic>?) != null
                ? LITPriceListCostID.fromJson(
                    json['LIT_PriceList_Cost_ID'] as Map<String, dynamic>)
                : null,
        lITFEIdCodTrasmit = json['LIT_FE_idCodTrasmit'] as String?,
        lITReportParam1 = json['LIT_Report_Param1'] as String?,
        lITCBPartnerFiscalID =
            (json['LIT_C_BPartnerFiscal_ID'] as Map<String, dynamic>?) != null
                ? LITCBPartnerFiscalID.fromJson(
                    json['LIT_C_BPartnerFiscal_ID'] as Map<String, dynamic>)
                : null,
        lITVATCChargeID =
            (json['LIT_VATC_Charge_ID'] as Map<String, dynamic>?) != null
                ? LITVATCChargeID.fromJson(
                    json['LIT_VATC_Charge_ID'] as Map<String, dynamic>)
                : null,
        lITVATCChargeCredit1ID =
            (json['LIT_VATC_Charge_Credit1_ID'] as Map<String, dynamic>?) !=
                    null
                ? LITVATCChargeCredit1ID.fromJson(
                    json['LIT_VATC_Charge_Credit1_ID'] as Map<String, dynamic>)
                : null,
        lITVATCChargeDebit1ID =
            (json['LIT_VATC_Charge_Debit1_ID'] as Map<String, dynamic>?) != null
                ? LITVATCChargeDebit1ID.fromJson(
                    json['LIT_VATC_Charge_Debit1_ID'] as Map<String, dynamic>)
                : null,
        lITVATCChargeDebit2ID =
            (json['LIT_VATC_Charge_Debit2_ID'] as Map<String, dynamic>?) != null
                ? LITVATCChargeDebit2ID.fromJson(
                    json['LIT_VATC_Charge_Debit2_ID'] as Map<String, dynamic>)
                : null,
        lITBPartnerRevenueAgencyID = (json['LIT_BPartner_RevenueAgency_ID']
                    as Map<String, dynamic>?) !=
                null
            ? LITBPartnerRevenueAgencyID.fromJson(
                json['LIT_BPartner_RevenueAgency_ID'] as Map<String, dynamic>)
            : null,
        lITMemberPosition = json['LIT_MemberPosition'] as String?,
        lITDeclarant = json['LIT_Declarant'] as String?,
        lITPresentationType = json['LIT_PresentationType'] as String?,
        lITFEPAIPA = json['LIT_FEPA_IPA'] as String?,
        phone = json['Phone'] as String?,
        email = json['EMail'] as String?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'C_Location_ID': cLocationID?.toJson(),
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': adOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'DUNS': dUNS,
        'TaxID': taxID,
        'Parent_Org_ID': parentOrgID?.toJson(),
        'M_Warehouse_ID': mWarehouseID?.toJson(),
        'LCO_ISIC_ID': lCOISICID?.toJson(),
        'LIT_NationalIdNumber_ID': lITNationalIdNumberID,
        'LIT_Report_Param': lITReportParam,
        'LIT_TaxRegime': lITTaxRegime?.toJson(),
        'LIT_PriceList_Cost_ID': lITPriceListCostID?.toJson(),
        'LIT_FE_idCodTrasmit': lITFEIdCodTrasmit,
        'LIT_Report_Param1': lITReportParam1,
        'LIT_C_BPartnerFiscal_ID': lITCBPartnerFiscalID?.toJson(),
        'LIT_VATC_Charge_ID': lITVATCChargeID?.toJson(),
        'LIT_VATC_Charge_Credit1_ID': lITVATCChargeCredit1ID?.toJson(),
        'LIT_VATC_Charge_Debit1_ID': lITVATCChargeDebit1ID?.toJson(),
        'LIT_VATC_Charge_Debit2_ID': lITVATCChargeDebit2ID?.toJson(),
        'LIT_BPartner_RevenueAgency_ID': lITBPartnerRevenueAgencyID?.toJson(),
        'LIT_MemberPosition': lITMemberPosition,
        'LIT_Declarant': lITDeclarant,
        'LIT_PresentationType': lITPresentationType,
        'LIT_FEPA_IPA': lITFEPAIPA,
        'model-name': modelname
      };
}

class CLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CLocationID.fromJson(Map<String, dynamic> json)
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

class ParentOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ParentOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ParentOrgID.fromJson(Map<String, dynamic> json)
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

class LCOISICID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LCOISICID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LCOISICID.fromJson(Map<String, dynamic> json)
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

class LITTaxRegime {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LITTaxRegime({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITTaxRegime.fromJson(Map<String, dynamic> json)
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

class LITPriceListCostID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITPriceListCostID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITPriceListCostID.fromJson(Map<String, dynamic> json)
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

class LITCBPartnerFiscalID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITCBPartnerFiscalID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITCBPartnerFiscalID.fromJson(Map<String, dynamic> json)
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

class LITVATCChargeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITVATCChargeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITVATCChargeID.fromJson(Map<String, dynamic> json)
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

class LITVATCChargeCredit1ID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITVATCChargeCredit1ID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITVATCChargeCredit1ID.fromJson(Map<String, dynamic> json)
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

class LITVATCChargeDebit1ID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITVATCChargeDebit1ID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITVATCChargeDebit1ID.fromJson(Map<String, dynamic> json)
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

class LITVATCChargeDebit2ID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITVATCChargeDebit2ID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITVATCChargeDebit2ID.fromJson(Map<String, dynamic> json)
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

class LITBPartnerRevenueAgencyID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LITBPartnerRevenueAgencyID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LITBPartnerRevenueAgencyID.fromJson(Map<String, dynamic> json)
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
