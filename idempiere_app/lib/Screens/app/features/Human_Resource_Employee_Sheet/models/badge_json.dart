class BadgeJSON {
  final Nfca? nfca;
  final Mifareclassic? mifareclassic;
  final Ndef? ndef;

  BadgeJSON({
    this.nfca,
    this.mifareclassic,
    this.ndef,
  });

  BadgeJSON.fromJson(Map<String, dynamic> json)
      : nfca = (json['nfca'] as Map<String, dynamic>?) != null
            ? Nfca.fromJson(json['nfca'] as Map<String, dynamic>)
            : null,
        mifareclassic = (json['mifareclassic'] as Map<String, dynamic>?) != null
            ? Mifareclassic.fromJson(
                json['mifareclassic'] as Map<String, dynamic>)
            : null,
        ndef = (json['ndef'] as Map<String, dynamic>?) != null
            ? Ndef.fromJson(json['ndef'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {
        'nfca': nfca?.toJson(),
        'mifareclassic': mifareclassic?.toJson(),
        'ndef': ndef?.toJson()
      };
}

class Nfca {
  final List<int>? identifier;
  final List<int>? atqa;
  final int? maxTransceiveLength;
  final int? sak;
  final int? timeout;

  Nfca({
    this.identifier,
    this.atqa,
    this.maxTransceiveLength,
    this.sak,
    this.timeout,
  });

  Nfca.fromJson(Map<String, dynamic> json)
      : identifier = (json['identifier'] as List?)
            ?.map((dynamic e) => e as int)
            .toList(),
        atqa = (json['atqa'] as List?)?.map((dynamic e) => e as int).toList(),
        maxTransceiveLength = json['maxTransceiveLength'] as int?,
        sak = json['sak'] as int?,
        timeout = json['timeout'] as int?;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'atqa': atqa,
        'maxTransceiveLength': maxTransceiveLength,
        'sak': sak,
        'timeout': timeout
      };
}

class Mifareclassic {
  final List<int>? identifier;
  final int? blockCount;
  final int? maxTransceiveLength;
  final int? sectorCount;
  final int? size;
  final int? timeout;
  final int? type;

  Mifareclassic({
    this.identifier,
    this.blockCount,
    this.maxTransceiveLength,
    this.sectorCount,
    this.size,
    this.timeout,
    this.type,
  });

  Mifareclassic.fromJson(Map<String, dynamic> json)
      : identifier = (json['identifier'] as List?)
            ?.map((dynamic e) => e as int)
            .toList(),
        blockCount = json['blockCount'] as int?,
        maxTransceiveLength = json['maxTransceiveLength'] as int?,
        sectorCount = json['sectorCount'] as int?,
        size = json['size'] as int?,
        timeout = json['timeout'] as int?,
        type = json['type'] as int?;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'blockCount': blockCount,
        'maxTransceiveLength': maxTransceiveLength,
        'sectorCount': sectorCount,
        'size': size,
        'timeout': timeout,
        'type': type
      };
}

class Ndef {
  final List<int>? identifier;
  final bool? isWritable;
  final int? maxSize;
  final bool? canMakeReadOnly;
  final CachedMessage? cachedMessage;
  final String? type;

  Ndef({
    this.identifier,
    this.isWritable,
    this.maxSize,
    this.canMakeReadOnly,
    this.cachedMessage,
    this.type,
  });

  Ndef.fromJson(Map<String, dynamic> json)
      : identifier = (json['identifier'] as List?)
            ?.map((dynamic e) => e as int)
            .toList(),
        isWritable = json['isWritable'] as bool?,
        maxSize = json['maxSize'] as int?,
        canMakeReadOnly = json['canMakeReadOnly'] as bool?,
        cachedMessage = (json['cachedMessage'] as Map<String, dynamic>?) != null
            ? CachedMessage.fromJson(
                json['cachedMessage'] as Map<String, dynamic>)
            : null,
        type = json['type'] as String?;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'isWritable': isWritable,
        'maxSize': maxSize,
        'canMakeReadOnly': canMakeReadOnly,
        'cachedMessage': cachedMessage?.toJson(),
        'type': type
      };
}

class CachedMessage {
  final List<Records>? records;

  CachedMessage({
    this.records,
  });

  CachedMessage.fromJson(Map<String, dynamic> json)
      : records = (json['records'] as List?)
            ?.map((dynamic e) => Records.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'records': records?.map((e) => e.toJson()).toList()};
}

class Records {
  final int? typeNameFormat;
  final List<int>? type;
  final List<dynamic>? identifier;
  final List<int>? payload;

  Records({
    this.typeNameFormat,
    this.type,
    this.identifier,
    this.payload,
  });

  Records.fromJson(Map<String, dynamic> json)
      : typeNameFormat = json['typeNameFormat'] as int?,
        type = (json['type'] as List?)?.map((dynamic e) => e as int).toList(),
        identifier = json['identifier'] as List?,
        payload =
            (json['payload'] as List?)?.map((dynamic e) => e as int).toList();

  Map<String, dynamic> toJson() => {
        'typeNameFormat': typeNameFormat,
        'type': type,
        'identifier': identifier,
        'payload': payload
      };
}
