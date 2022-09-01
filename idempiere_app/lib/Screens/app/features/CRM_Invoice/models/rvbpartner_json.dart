class RVbpartnerJSON {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<Records>? records;

  RVbpartnerJSON({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  RVbpartnerJSON.fromJson(Map<String, dynamic> json)
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
  final String? name;
  final bool? isCustomer;
  final double? sOCreditUsed;
  final double? sOCreditAvailable;
  final int? sOCreditLimit;
  final ADClientID? aDClientID;
  final bool? isVendor;
  final String? city;
  final String? postal;
  final String? value;
  final ADOrgID? aDOrgID;
  final String? eMail;
  final bool? isActive;
  final double? totalOpenBalance;
  final ADUserID? aDUserID;
  final CBPartnerLocationID? cBPartnerLocationID;
  final String? countryName;
  final String? regionName;
  final CCountryID? cCountryID;
  final String? address1;
  final CRegionID? cRegionID;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final bool? isSummary;
  final CBPGroupID? cBPGroupID;
  final bool? isOneTime;
  final bool? isProspect;
  final bool? isEmployee;
  final bool? isSalesRep;
  final ADLanguage? aDLanguage;
  final String? taxID;
  final bool? isTaxExempt;
  final int? salesVolume;
  final String? firstSale;
  final int? acqusitionCost;
  final int? potentialLifeTimeValue;
  final double? actualLifeTimeValue;
  final int? shareOfCustomer;
  final CPaymentTermID? cPaymentTermID;
  final MPriceListID? mPriceListID;
  final bool? isDiscountPrinted;
  final bool? sendEMail;
  final ADOrgBPID? aDOrgBPID;
  final String? contactName;
  final NotificationType? notificationType;
  final bool? cBpIsmanufacturer;
  final bool? cBpIspotaxexempt;
  final CBPLocationADOrgID? cBPLocationADOrgID;
  final CBPLocationCBPartnerID? cBPLocationCBPartnerID;
  final CBPLocationCLocationID? cBPLocationCLocationID;
  final String? cBpLocationCreated;
  final CBPLocationCreatedBy? cBPLocationCreatedBy;
  final bool? cBpLocationIsactive;
  final bool? cBpLocationIsbillto;
  final bool? cBpLocationIspayfrom;
  final bool? cBpLocationIsremitto;
  final bool? cBpLocationIsshipto;
  final String? cBpLocationName;
  final String? cBpLocationUpdated;
  final CBPLocationUpdatedBy? cBPLocationUpdatedBy;
  final ADUserADOrgID? aDUserADOrgID;
  final ADUserCBPartnerID? aDUserCBPartnerID;
  final String? adUserCreated;
  final ADUserCreatedBy? aDUserCreatedBy;
  final bool? adUserIsactive;
  final String? adUserUpdated;
  final ADUserUpdatedBy? aDUserUpdatedBy;
  final String? adUserValue;
  final CLocationADOrgID? cLocationADOrgID;
  final CLocationID? cLocationID;
  final String? cLocationCreated;
  final CLocationCreatedBy? cLocationCreatedBy;
  final bool? cLocationIsactive;
  final String? cLocationUpdated;
  final CLocationUpdatedBy? cLocationUpdatedBy;
  final CRegionADOrgID? cRegionADOrgID;
  final CRegionCCountryID? cRegionCCountryID;
  final String? cRegionDescription;
  final bool? cRegionIsactive;
  final bool? isDefault;
  final String? cCountryAdLanguage;
  final CCountryCCurrencyID? cCountryCCurrencyID;
  final CountryCode? countryCode;
  final String? cCountryDescription;
  final bool? cCountryIsactive;
  final String? modelname;

  Records({
    this.id,
    this.name,
    this.isCustomer,
    this.sOCreditUsed,
    this.sOCreditAvailable,
    this.sOCreditLimit,
    this.aDClientID,
    this.isVendor,
    this.city,
    this.postal,
    this.value,
    this.aDOrgID,
    this.eMail,
    this.isActive,
    this.totalOpenBalance,
    this.aDUserID,
    this.cBPartnerLocationID,
    this.countryName,
    this.regionName,
    this.cCountryID,
    this.address1,
    this.cRegionID,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.isSummary,
    this.cBPGroupID,
    this.isOneTime,
    this.isProspect,
    this.isEmployee,
    this.isSalesRep,
    this.aDLanguage,
    this.taxID,
    this.isTaxExempt,
    this.salesVolume,
    this.firstSale,
    this.acqusitionCost,
    this.potentialLifeTimeValue,
    this.actualLifeTimeValue,
    this.shareOfCustomer,
    this.cPaymentTermID,
    this.mPriceListID,
    this.isDiscountPrinted,
    this.sendEMail,
    this.aDOrgBPID,
    this.contactName,
    this.notificationType,
    this.cBpIsmanufacturer,
    this.cBpIspotaxexempt,
    this.cBPLocationADOrgID,
    this.cBPLocationCBPartnerID,
    this.cBPLocationCLocationID,
    this.cBpLocationCreated,
    this.cBPLocationCreatedBy,
    this.cBpLocationIsactive,
    this.cBpLocationIsbillto,
    this.cBpLocationIspayfrom,
    this.cBpLocationIsremitto,
    this.cBpLocationIsshipto,
    this.cBpLocationName,
    this.cBpLocationUpdated,
    this.cBPLocationUpdatedBy,
    this.aDUserADOrgID,
    this.aDUserCBPartnerID,
    this.adUserCreated,
    this.aDUserCreatedBy,
    this.adUserIsactive,
    this.adUserUpdated,
    this.aDUserUpdatedBy,
    this.adUserValue,
    this.cLocationADOrgID,
    this.cLocationID,
    this.cLocationCreated,
    this.cLocationCreatedBy,
    this.cLocationIsactive,
    this.cLocationUpdated,
    this.cLocationUpdatedBy,
    this.cRegionADOrgID,
    this.cRegionCCountryID,
    this.cRegionDescription,
    this.cRegionIsactive,
    this.isDefault,
    this.cCountryAdLanguage,
    this.cCountryCCurrencyID,
    this.countryCode,
    this.cCountryDescription,
    this.cCountryIsactive,
    this.modelname,
  });

  Records.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['Name'] as String?,
        isCustomer = json['IsCustomer'] as bool?,
        sOCreditUsed = json['SO_CreditUsed'] as double?,
        sOCreditAvailable = json['SO_CreditAvailable'] as double?,
        sOCreditLimit = json['SO_CreditLimit'] as int?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        isVendor = json['IsVendor'] as bool?,
        city = json['City'] as String?,
        postal = json['Postal'] as String?,
        value = json['Value'] as String?,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        eMail = json['EMail'] as String?,
        isActive = json['IsActive'] as bool?,
        totalOpenBalance = json['TotalOpenBalance'] as double?,
        aDUserID = (json['AD_User_ID'] as Map<String, dynamic>?) != null
            ? ADUserID.fromJson(json['AD_User_ID'] as Map<String, dynamic>)
            : null,
        cBPartnerLocationID =
            (json['C_BPartner_Location_ID'] as Map<String, dynamic>?) != null
                ? CBPartnerLocationID.fromJson(
                    json['C_BPartner_Location_ID'] as Map<String, dynamic>)
                : null,
        countryName = json['CountryName'] as String?,
        regionName = json['RegionName'] as String?,
        cCountryID = (json['C_Country_ID'] as Map<String, dynamic>?) != null
            ? CCountryID.fromJson(json['C_Country_ID'] as Map<String, dynamic>)
            : null,
        address1 = json['Address1'] as String?,
        cRegionID = (json['C_Region_ID'] as Map<String, dynamic>?) != null
            ? CRegionID.fromJson(json['C_Region_ID'] as Map<String, dynamic>)
            : null,
        created = json['Created'] as String?,
        createdBy = (json['CreatedBy'] as Map<String, dynamic>?) != null
            ? CreatedBy.fromJson(json['CreatedBy'] as Map<String, dynamic>)
            : null,
        updated = json['Updated'] as String?,
        updatedBy = (json['UpdatedBy'] as Map<String, dynamic>?) != null
            ? UpdatedBy.fromJson(json['UpdatedBy'] as Map<String, dynamic>)
            : null,
        isSummary = json['IsSummary'] as bool?,
        cBPGroupID = (json['C_BP_Group_ID'] as Map<String, dynamic>?) != null
            ? CBPGroupID.fromJson(json['C_BP_Group_ID'] as Map<String, dynamic>)
            : null,
        isOneTime = json['IsOneTime'] as bool?,
        isProspect = json['IsProspect'] as bool?,
        isEmployee = json['IsEmployee'] as bool?,
        isSalesRep = json['IsSalesRep'] as bool?,
        aDLanguage = (json['AD_Language'] as Map<String, dynamic>?) != null
            ? ADLanguage.fromJson(json['AD_Language'] as Map<String, dynamic>)
            : null,
        taxID = json['TaxID'] as String?,
        isTaxExempt = json['IsTaxExempt'] as bool?,
        salesVolume = json['SalesVolume'] as int?,
        firstSale = json['FirstSale'] as String?,
        acqusitionCost = json['AcqusitionCost'] as int?,
        potentialLifeTimeValue = json['PotentialLifeTimeValue'] as int?,
        actualLifeTimeValue = json['ActualLifeTimeValue'] as double?,
        shareOfCustomer = json['ShareOfCustomer'] as int?,
        cPaymentTermID =
            (json['C_PaymentTerm_ID'] as Map<String, dynamic>?) != null
                ? CPaymentTermID.fromJson(
                    json['C_PaymentTerm_ID'] as Map<String, dynamic>)
                : null,
        mPriceListID = (json['M_PriceList_ID'] as Map<String, dynamic>?) != null
            ? MPriceListID.fromJson(
                json['M_PriceList_ID'] as Map<String, dynamic>)
            : null,
        isDiscountPrinted = json['IsDiscountPrinted'] as bool?,
        sendEMail = json['SendEMail'] as bool?,
        aDOrgBPID = (json['AD_OrgBP_ID'] as Map<String, dynamic>?) != null
            ? ADOrgBPID.fromJson(json['AD_OrgBP_ID'] as Map<String, dynamic>)
            : null,
        contactName = json['ContactName'] as String?,
        notificationType =
            (json['NotificationType'] as Map<String, dynamic>?) != null
                ? NotificationType.fromJson(
                    json['NotificationType'] as Map<String, dynamic>)
                : null,
        cBpIsmanufacturer = json['c_bp_ismanufacturer'] as bool?,
        cBpIspotaxexempt = json['c_bp_ispotaxexempt'] as bool?,
        cBPLocationADOrgID =
            (json['C_BP_Location_AD_Org_ID'] as Map<String, dynamic>?) != null
                ? CBPLocationADOrgID.fromJson(
                    json['C_BP_Location_AD_Org_ID'] as Map<String, dynamic>)
                : null,
        cBPLocationCBPartnerID =
            (json['C_BP_Location_C_BPartner_ID'] as Map<String, dynamic>?) !=
                    null
                ? CBPLocationCBPartnerID.fromJson(
                    json['C_BP_Location_C_BPartner_ID'] as Map<String, dynamic>)
                : null,
        cBPLocationCLocationID =
            (json['C_BP_Location_C_Location_ID'] as Map<String, dynamic>?) !=
                    null
                ? CBPLocationCLocationID.fromJson(
                    json['C_BP_Location_C_Location_ID'] as Map<String, dynamic>)
                : null,
        cBpLocationCreated = json['c_bp_location_created'] as String?,
        cBPLocationCreatedBy =
            (json['C_BP_Location_CreatedBy'] as Map<String, dynamic>?) != null
                ? CBPLocationCreatedBy.fromJson(
                    json['C_BP_Location_CreatedBy'] as Map<String, dynamic>)
                : null,
        cBpLocationIsactive = json['c_bp_location_isactive'] as bool?,
        cBpLocationIsbillto = json['c_bp_location_isbillto'] as bool?,
        cBpLocationIspayfrom = json['c_bp_location_ispayfrom'] as bool?,
        cBpLocationIsremitto = json['c_bp_location_isremitto'] as bool?,
        cBpLocationIsshipto = json['c_bp_location_isshipto'] as bool?,
        cBpLocationName = json['c_bp_location_name'] as String?,
        cBpLocationUpdated = json['c_bp_location_updated'] as String?,
        cBPLocationUpdatedBy =
            (json['C_BP_Location_UpdatedBy'] as Map<String, dynamic>?) != null
                ? CBPLocationUpdatedBy.fromJson(
                    json['C_BP_Location_UpdatedBy'] as Map<String, dynamic>)
                : null,
        aDUserADOrgID =
            (json['AD_User_AD_Org_ID'] as Map<String, dynamic>?) != null
                ? ADUserADOrgID.fromJson(
                    json['AD_User_AD_Org_ID'] as Map<String, dynamic>)
                : null,
        aDUserCBPartnerID =
            (json['AD_User_C_BPartner_ID'] as Map<String, dynamic>?) != null
                ? ADUserCBPartnerID.fromJson(
                    json['AD_User_C_BPartner_ID'] as Map<String, dynamic>)
                : null,
        adUserCreated = json['ad_user_created'] as String?,
        aDUserCreatedBy =
            (json['AD_User_CreatedBy'] as Map<String, dynamic>?) != null
                ? ADUserCreatedBy.fromJson(
                    json['AD_User_CreatedBy'] as Map<String, dynamic>)
                : null,
        adUserIsactive = json['ad_user_isactive'] as bool?,
        adUserUpdated = json['ad_user_updated'] as String?,
        aDUserUpdatedBy =
            (json['AD_User_UpdatedBy'] as Map<String, dynamic>?) != null
                ? ADUserUpdatedBy.fromJson(
                    json['AD_User_UpdatedBy'] as Map<String, dynamic>)
                : null,
        adUserValue = json['ad_user_value'] as String?,
        cLocationADOrgID =
            (json['C_Location_AD_Org_ID'] as Map<String, dynamic>?) != null
                ? CLocationADOrgID.fromJson(
                    json['C_Location_AD_Org_ID'] as Map<String, dynamic>)
                : null,
        cLocationID = (json['C_Location_ID'] as Map<String, dynamic>?) != null
            ? CLocationID.fromJson(
                json['C_Location_ID'] as Map<String, dynamic>)
            : null,
        cLocationCreated = json['c_location_created'] as String?,
        cLocationCreatedBy =
            (json['C_Location_CreatedBy'] as Map<String, dynamic>?) != null
                ? CLocationCreatedBy.fromJson(
                    json['C_Location_CreatedBy'] as Map<String, dynamic>)
                : null,
        cLocationIsactive = json['c_location_isactive'] as bool?,
        cLocationUpdated = json['c_location_updated'] as String?,
        cLocationUpdatedBy =
            (json['C_Location_UpdatedBy'] as Map<String, dynamic>?) != null
                ? CLocationUpdatedBy.fromJson(
                    json['C_Location_UpdatedBy'] as Map<String, dynamic>)
                : null,
        cRegionADOrgID =
            (json['C_Region_AD_Org_ID'] as Map<String, dynamic>?) != null
                ? CRegionADOrgID.fromJson(
                    json['C_Region_AD_Org_ID'] as Map<String, dynamic>)
                : null,
        cRegionCCountryID =
            (json['C_Region_C_Country_ID'] as Map<String, dynamic>?) != null
                ? CRegionCCountryID.fromJson(
                    json['C_Region_C_Country_ID'] as Map<String, dynamic>)
                : null,
        cRegionDescription = json['c_region_description'] as String?,
        cRegionIsactive = json['c_region_isactive'] as bool?,
        isDefault = json['IsDefault'] as bool?,
        cCountryAdLanguage = json['c_country_ad_language'] as String?,
        cCountryCCurrencyID =
            (json['C_Country_C_Currency_ID'] as Map<String, dynamic>?) != null
                ? CCountryCCurrencyID.fromJson(
                    json['C_Country_C_Currency_ID'] as Map<String, dynamic>)
                : null,
        countryCode = (json['CountryCode'] as Map<String, dynamic>?) != null
            ? CountryCode.fromJson(json['CountryCode'] as Map<String, dynamic>)
            : null,
        cCountryDescription = json['c_country_description'] as String?,
        cCountryIsactive = json['c_country_isactive'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'Name': name,
        'IsCustomer': isCustomer,
        'SO_CreditUsed': sOCreditUsed,
        'SO_CreditAvailable': sOCreditAvailable,
        'SO_CreditLimit': sOCreditLimit,
        'AD_Client_ID': aDClientID?.toJson(),
        'IsVendor': isVendor,
        'City': city,
        'Postal': postal,
        'Value': value,
        'AD_Org_ID': aDOrgID?.toJson(),
        'EMail': eMail,
        'IsActive': isActive,
        'TotalOpenBalance': totalOpenBalance,
        'AD_User_ID': aDUserID?.toJson(),
        'C_BPartner_Location_ID': cBPartnerLocationID?.toJson(),
        'CountryName': countryName,
        'RegionName': regionName,
        'C_Country_ID': cCountryID?.toJson(),
        'Address1': address1,
        'C_Region_ID': cRegionID?.toJson(),
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'IsSummary': isSummary,
        'C_BP_Group_ID': cBPGroupID?.toJson(),
        'IsOneTime': isOneTime,
        'IsProspect': isProspect,
        'IsEmployee': isEmployee,
        'IsSalesRep': isSalesRep,
        'AD_Language': aDLanguage?.toJson(),
        'TaxID': taxID,
        'IsTaxExempt': isTaxExempt,
        'SalesVolume': salesVolume,
        'FirstSale': firstSale,
        'AcqusitionCost': acqusitionCost,
        'PotentialLifeTimeValue': potentialLifeTimeValue,
        'ActualLifeTimeValue': actualLifeTimeValue,
        'ShareOfCustomer': shareOfCustomer,
        'C_PaymentTerm_ID': cPaymentTermID?.toJson(),
        'M_PriceList_ID': mPriceListID?.toJson(),
        'IsDiscountPrinted': isDiscountPrinted,
        'SendEMail': sendEMail,
        'AD_OrgBP_ID': aDOrgBPID?.toJson(),
        'ContactName': contactName,
        'NotificationType': notificationType?.toJson(),
        'c_bp_ismanufacturer': cBpIsmanufacturer,
        'c_bp_ispotaxexempt': cBpIspotaxexempt,
        'C_BP_Location_AD_Org_ID': cBPLocationADOrgID?.toJson(),
        'C_BP_Location_C_BPartner_ID': cBPLocationCBPartnerID?.toJson(),
        'C_BP_Location_C_Location_ID': cBPLocationCLocationID?.toJson(),
        'c_bp_location_created': cBpLocationCreated,
        'C_BP_Location_CreatedBy': cBPLocationCreatedBy?.toJson(),
        'c_bp_location_isactive': cBpLocationIsactive,
        'c_bp_location_isbillto': cBpLocationIsbillto,
        'c_bp_location_ispayfrom': cBpLocationIspayfrom,
        'c_bp_location_isremitto': cBpLocationIsremitto,
        'c_bp_location_isshipto': cBpLocationIsshipto,
        'c_bp_location_name': cBpLocationName,
        'c_bp_location_updated': cBpLocationUpdated,
        'C_BP_Location_UpdatedBy': cBPLocationUpdatedBy?.toJson(),
        'AD_User_AD_Org_ID': aDUserADOrgID?.toJson(),
        'AD_User_C_BPartner_ID': aDUserCBPartnerID?.toJson(),
        'ad_user_created': adUserCreated,
        'AD_User_CreatedBy': aDUserCreatedBy?.toJson(),
        'ad_user_isactive': adUserIsactive,
        'ad_user_updated': adUserUpdated,
        'AD_User_UpdatedBy': aDUserUpdatedBy?.toJson(),
        'ad_user_value': adUserValue,
        'C_Location_AD_Org_ID': cLocationADOrgID?.toJson(),
        'C_Location_ID': cLocationID?.toJson(),
        'c_location_created': cLocationCreated,
        'C_Location_CreatedBy': cLocationCreatedBy?.toJson(),
        'c_location_isactive': cLocationIsactive,
        'c_location_updated': cLocationUpdated,
        'C_Location_UpdatedBy': cLocationUpdatedBy?.toJson(),
        'C_Region_AD_Org_ID': cRegionADOrgID?.toJson(),
        'C_Region_C_Country_ID': cRegionCCountryID?.toJson(),
        'c_region_description': cRegionDescription,
        'c_region_isactive': cRegionIsactive,
        'IsDefault': isDefault,
        'c_country_ad_language': cCountryAdLanguage,
        'C_Country_C_Currency_ID': cCountryCCurrencyID?.toJson(),
        'CountryCode': countryCode?.toJson(),
        'c_country_description': cCountryDescription,
        'c_country_isactive': cCountryIsactive,
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

class CCountryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CCountryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CCountryID.fromJson(Map<String, dynamic> json)
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

class CRegionID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CRegionID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CRegionID.fromJson(Map<String, dynamic> json)
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

class CBPGroupID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPGroupID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPGroupID.fromJson(Map<String, dynamic> json)
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

class ADLanguage {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  ADLanguage({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADLanguage.fromJson(Map<String, dynamic> json)
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

class CPaymentTermID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CPaymentTermID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CPaymentTermID.fromJson(Map<String, dynamic> json)
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

class ADOrgBPID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADOrgBPID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADOrgBPID.fromJson(Map<String, dynamic> json)
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

class NotificationType {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  NotificationType({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  NotificationType.fromJson(Map<String, dynamic> json)
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

class CBPLocationADOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPLocationADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPLocationADOrgID.fromJson(Map<String, dynamic> json)
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

class CBPLocationCBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPLocationCBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPLocationCBPartnerID.fromJson(Map<String, dynamic> json)
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

class CBPLocationCLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPLocationCLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPLocationCLocationID.fromJson(Map<String, dynamic> json)
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

class CBPLocationCreatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPLocationCreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPLocationCreatedBy.fromJson(Map<String, dynamic> json)
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

class CBPLocationUpdatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CBPLocationUpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CBPLocationUpdatedBy.fromJson(Map<String, dynamic> json)
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

class ADUserADOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserADOrgID.fromJson(Map<String, dynamic> json)
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

class ADUserCBPartnerID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserCBPartnerID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserCBPartnerID.fromJson(Map<String, dynamic> json)
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

class ADUserCreatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserCreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserCreatedBy.fromJson(Map<String, dynamic> json)
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

class ADUserUpdatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  ADUserUpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  ADUserUpdatedBy.fromJson(Map<String, dynamic> json)
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

class CLocationADOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CLocationADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CLocationADOrgID.fromJson(Map<String, dynamic> json)
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

class CLocationCreatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CLocationCreatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CLocationCreatedBy.fromJson(Map<String, dynamic> json)
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

class CLocationUpdatedBy {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CLocationUpdatedBy({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CLocationUpdatedBy.fromJson(Map<String, dynamic> json)
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

class CRegionADOrgID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CRegionADOrgID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CRegionADOrgID.fromJson(Map<String, dynamic> json)
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

class CRegionCCountryID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CRegionCCountryID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CRegionCCountryID.fromJson(Map<String, dynamic> json)
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

class CCountryCCurrencyID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CCountryCCurrencyID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CCountryCCurrencyID.fromJson(Map<String, dynamic> json)
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

class CountryCode {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  CountryCode({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CountryCode.fromJson(Map<String, dynamic> json)
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
