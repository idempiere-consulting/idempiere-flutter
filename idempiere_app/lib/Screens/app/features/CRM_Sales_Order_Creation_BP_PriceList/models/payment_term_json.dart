class PaymentTermsJson {
  final int? pagecount;
  final int? recordssize;
  final int? skiprecords;
  final int? rowcount;
  final List<PTRecords>? records;

  PaymentTermsJson({
    this.pagecount,
    this.recordssize,
    this.skiprecords,
    this.rowcount,
    this.records,
  });

  PaymentTermsJson.fromJson(Map<String, dynamic> json)
      : pagecount = json['page-count'] as int?,
        recordssize = json['records-size'] as int?,
        skiprecords = json['skip-records'] as int?,
        rowcount = json['row-count'] as int?,
        records = (json['records'] as List?)
            ?.map((dynamic e) => PTRecords.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'page-count': pagecount,
        'records-size': recordssize,
        'skip-records': skiprecords,
        'row-count': rowcount,
        'records': records?.map((e) => e.toJson()).toList()
      };
}

class PTRecords {
  final int? id;
  final String? uid;
  final ADClientID? aDClientID;
  final ADOrgID? aDOrgID;
  final bool? isActive;
  final String? created;
  final CreatedBy? createdBy;
  final String? updated;
  final UpdatedBy? updatedBy;
  final String? name;
  final String? description;
  final bool? afterDelivery;
  final int? netDays;
  final int? discount;
  final int? discountDays;
  final bool? isDueFixed;
  final int? fixMonthCutoff;
  final int? fixMonthDay;
  final int? fixMonthOffset;
  final int? discountDays2;
  final int? discount2;
  final bool? isNextBusinessDay;
  final bool? isDefault;
  final int? graceDays;
  final String? value;
  final bool? isValid;
  final PaymentTermUsage? paymentTermUsage;
  final bool? afterOrder;
  final bool? lITVAT1;
  final String? modelname;

  PTRecords({
    this.id,
    this.uid,
    this.aDClientID,
    this.aDOrgID,
    this.isActive,
    this.created,
    this.createdBy,
    this.updated,
    this.updatedBy,
    this.name,
    this.description,
    this.afterDelivery,
    this.netDays,
    this.discount,
    this.discountDays,
    this.isDueFixed,
    this.fixMonthCutoff,
    this.fixMonthDay,
    this.fixMonthOffset,
    this.discountDays2,
    this.discount2,
    this.isNextBusinessDay,
    this.isDefault,
    this.graceDays,
    this.value,
    this.isValid,
    this.paymentTermUsage,
    this.afterOrder,
    this.lITVAT1,
    this.modelname,
  });

  PTRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        uid = json['uid'] as String?,
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
        name = json['Name'] as String?,
        description = json['Description'] as String?,
        afterDelivery = json['AfterDelivery'] as bool?,
        netDays = json['NetDays'] as int?,
        discount = json['Discount'] as int?,
        discountDays = json['DiscountDays'] as int?,
        isDueFixed = json['IsDueFixed'] as bool?,
        fixMonthCutoff = json['FixMonthCutoff'] as int?,
        fixMonthDay = json['FixMonthDay'] as int?,
        fixMonthOffset = json['FixMonthOffset'] as int?,
        discountDays2 = json['DiscountDays2'] as int?,
        discount2 = json['Discount2'] as int?,
        isNextBusinessDay = json['IsNextBusinessDay'] as bool?,
        isDefault = json['IsDefault'] as bool?,
        graceDays = json['GraceDays'] as int?,
        value = json['Value'] as String?,
        isValid = json['IsValid'] as bool?,
        paymentTermUsage =
            (json['PaymentTermUsage'] as Map<String, dynamic>?) != null
                ? PaymentTermUsage.fromJson(
                    json['PaymentTermUsage'] as Map<String, dynamic>)
                : null,
        afterOrder = json['AfterOrder'] as bool?,
        lITVAT1 = json['LIT_VAT1'] as bool?,
        modelname = json['model-name'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'AD_Client_ID': aDClientID?.toJson(),
        'AD_Org_ID': aDOrgID?.toJson(),
        'IsActive': isActive,
        'Created': created,
        'CreatedBy': createdBy?.toJson(),
        'Updated': updated,
        'UpdatedBy': updatedBy?.toJson(),
        'Name': name,
        'Description': description,
        'AfterDelivery': afterDelivery,
        'NetDays': netDays,
        'Discount': discount,
        'DiscountDays': discountDays,
        'IsDueFixed': isDueFixed,
        'FixMonthCutoff': fixMonthCutoff,
        'FixMonthDay': fixMonthDay,
        'FixMonthOffset': fixMonthOffset,
        'DiscountDays2': discountDays2,
        'Discount2': discount2,
        'IsNextBusinessDay': isNextBusinessDay,
        'IsDefault': isDefault,
        'GraceDays': graceDays,
        'Value': value,
        'IsValid': isValid,
        'PaymentTermUsage': paymentTermUsage?.toJson(),
        'AfterOrder': afterOrder,
        'LIT_VAT1': lITVAT1,
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

class PaymentTermUsage {
  final String? propertyLabel;
  final String? id;
  final String? identifier;
  final String? modelname;

  PaymentTermUsage({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelname,
  });

  PaymentTermUsage.fromJson(Map<String, dynamic> json)
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
