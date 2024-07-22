class AttachmentJSON {
  final List<Attachments>? attachments;

  AttachmentJSON({
    this.attachments,
  });

  AttachmentJSON.fromJson(Map<String, dynamic> json)
      : attachments = (json['attachments'] as List?)
            ?.map(
                (dynamic e) => Attachments.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'attachments': attachments?.map((e) => e.toJson()).toList()};
}

class Attachments {
  final int? recordId;
  final String? tableName;
  final String? name;
  final String? contentType;

  Attachments({
    this.recordId,
    this.tableName,
    this.name,
    this.contentType,
  });

  Attachments.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        recordId = json['Record_ID'] as int?,
        tableName = json['TableName'] as String?,
        contentType = json['contentType'] as String?;

  Map<String, dynamic> toJson() => {'name': name, 'contentType': contentType};
}
