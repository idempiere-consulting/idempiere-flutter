class LeadJson {
  final int? pagecount;
  final int? pagesize;
  final int? pagenumber;
  final int? rowcount;
  final List<Windowrecords>? windowrecords;

  LeadJson({
    this.pagecount,
    this.pagesize,
    this.pagenumber,
    this.rowcount,
    this.windowrecords,
  });

  LeadJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        pagesize = json['page-size'] as int?,
        pagenumber = json['page-number'] as int?,
        rowcount = json['row-count'] as int?,
        windowrecords = (json['records'] as List?)
            ?.map((dynamic e) =>
                Windowrecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'page-size': pagesize,
        'page-number': pagenumber,
        'row-count': rowcount,
        'records': windowrecords?.map((e) => e.toJson()).toList()
      };
}

class Windowrecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final String? value;
  final LeadStatus? leadStatus;
  final SalesRepID? salesRepID;
  final bool? isActive;
  final String? name;
  final String? description;
  final String? note;
  final bool? isVendorLead;
  final CJobID? cJobID;
  final LeadSource? leadSource;
  final String? phone;
  final String? eMail;
  final String? url;
  final String? name2;
  final String? bPName;
  final BPLocationID? bPLocationID;
  final CBPartnerID? cbPartnerID;
  final bool? isPublic;
  final bool? lITIsPartner;
  final bool? isConfirmed;
  final CCampaignID? cCampaignID;
  final LitLeadSizeID? litLeadSizeID;
  final LitIndustrySectorID? litIndustrySectorID;
  final String? latestJPToDoName;
  final String? latestJPToDoStatus;
  final int? latestJPToDoID;
  final String? latestActivityName;
  final int? latestActivityID;
  final String? slug;

  Windowrecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.value,
    this.leadStatus,
    this.salesRepID,
    this.isActive,
    this.name,
    this.description,
    this.note,
    this.isVendorLead,
    this.cJobID,
    this.leadSource,
    this.phone,
    this.eMail,
    this.url,
    this.name2,
    this.bPName,
    this.bPLocationID,
    this.cbPartnerID,
    this.isPublic,
    this.lITIsPartner,
    this.isConfirmed,
    this.cCampaignID,
    this.litLeadSizeID,
    this.litIndustrySectorID,
    this.latestJPToDoID,
    this.latestJPToDoName,
    this.latestJPToDoStatus,
    this.latestActivityID,
    this.latestActivityName,
    this.slug,
  });

  Windowrecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
        aDClientID = (json['AD_Client_ID'] as Map<String, dynamic>?) != null
            ? ADClientID.fromJson(json['AD_Client_ID'] as Map<String, dynamic>)
            : null,
        aDOrgID = (json['AD_Org_ID'] as Map<String, dynamic>?) != null
            ? ADOrgID.fromJson(json['AD_Org_ID'] as Map<String, dynamic>)
            : null,
        value = json['Value'] as String?,
        leadStatus = (json['LeadStatus'] as Map<String, dynamic>?) != null
            ? LeadStatus.fromJson(json['LeadStatus'] as Map<String, dynamic>)
            : null,
        salesRepID = (json['SalesRep_ID'] as Map<String, dynamic>?) != null
            ? SalesRepID.fromJson(json['SalesRep_ID'] as Map<String, dynamic>)
            : null,
        isActive = json['IsActive'] as bool?,
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        note = json['Note'] as String?,
        isVendorLead = json['IsVendorLead'] as bool?,
        cJobID = (json['C_Job_ID'] as Map<String, dynamic>?) != null
            ? CJobID.fromJson(json['C_Job_ID'] as Map<String, dynamic>)
            : null,
        litIndustrySectorID =
            (json['lit_IndustrySector_ID'] as Map<String, dynamic>?) != null
                ? LitIndustrySectorID.fromJson(
                    json['lit_IndustrySector_ID'] as Map<String, dynamic>)
                : null,
        leadSource = (json['LeadSource'] as Map<String, dynamic>?) != null
            ? LeadSource.fromJson(json['LeadSource'] as Map<String, dynamic>)
            : null,
        phone = json['Phone'] as String?,
        url = json['URL'] as String?,
        eMail = json['EMail'] as String?,
        name2 = json['Name2'] as String?,
        bPName = json['BPName'] as String?,
        bPLocationID = (json['BP_Location_ID'] as Map<String, dynamic>?) != null
            ? BPLocationID.fromJson(
                json['BP_Location_ID'] as Map<String, dynamic>)
            : null,
        cbPartnerID = (json['C_BPartner_ID'] as Map<String, dynamic>?) != null
            ? CBPartnerID.fromJson(
                json['C_BPartner_ID'] as Map<String, dynamic>)
            : null,
        cCampaignID = (json['C_Campaign_ID'] as Map<String, dynamic>?) != null
            ? CCampaignID.fromJson(
                json['C_Campaign_ID'] as Map<String, dynamic>)
            : null,
        litLeadSizeID =
            (json['lit_LeadSize_ID'] as Map<String, dynamic>?) != null
                ? LitLeadSizeID.fromJson(
                    json['lit_LeadSize_ID'] as Map<String, dynamic>)
                : null,
        isPublic = json['IsPublic'] as bool?,
        lITIsPartner = json['LIT_IsPartner'] as bool?,
        isConfirmed = json['IsConfirmed'] as bool?,
        latestJPToDoID = json['latest_jptodo_id'] as int?,
        latestJPToDoName = json['latest_jptodo'] as String?,
        latestJPToDoStatus = json['latest_jptodo_status'] as String?,
        latestActivityID = json['latest_activity_id'] as int?,
        latestActivityName = json['latest_activity'] as String?,
        slug = json['slug'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'Value': value,
        'LeadStatus': leadStatus?.toJson(),
        'SalesRep_ID': salesRepID?.toJson(),
        'IsActive': isActive,
        'Name': name,
        'Description': description,
        'Note': note,
        'IsVendorLead': isVendorLead,
        'C_Job_ID': cJobID?.toJson(),
        'LeadSource': leadSource?.toJson(),
        'Phone': phone,
        'URL': url,
        'EMail': eMail,
        'Name2': name2,
        'BPName': bPName,
        'BP_Location_ID': bPLocationID?.toJson(),
        'C_BPartner_ID': cbPartnerID?.toJson(),
        'IsPublic': isPublic,
        'LIT_IsPartner': lITIsPartner,
        'C_Campaign_ID': cCampaignID?.toJson(),
        'lit_IndustrySector_ID': litIndustrySectorID?.toJson(),
        'lit_LeadSize_ID': litLeadSizeID?.toJson(),
        'IsConfirmed': isConfirmed,
        'latest_jptodo': latestJPToDoName,
        'latest_jptodo_status': latestJPToDoStatus,
        'latest_jptodo_id': latestJPToDoID,
        'latest_activity_id': latestActivityID,
        'latest_activity': latestActivityName,
        'slug': slug
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

class LeadStatus {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LeadStatus({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LeadStatus.fromJson(Map<String, dynamic> json)
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

class CJobID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CJobID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CJobID.fromJson(Map<String, dynamic> json)
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

class LitIndustrySectorID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LitIndustrySectorID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LitIndustrySectorID.fromJson(Map<String, dynamic> json)
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

class LitLeadSizeID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  LitLeadSizeID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LitLeadSizeID.fromJson(Map<String, dynamic> json)
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

class CCampaignID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  CCampaignID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  CCampaignID.fromJson(Map<String, dynamic> json)
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

class LeadSource {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  LeadSource({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  LeadSource.fromJson(Map<String, dynamic> json)
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

class BPLocationID {
  final String? propertyLabel;
  final int? id;
  final String? identifier;
  final String? modelname;

  BPLocationID({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  BPLocationID.fromJson(Map<String, dynamic> json)
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
