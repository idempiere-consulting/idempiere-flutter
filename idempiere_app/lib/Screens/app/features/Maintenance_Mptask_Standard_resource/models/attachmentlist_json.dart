class AttachmentListJson {
  final List<Attachment>? attachments;

  AttachmentListJson({this.attachments});

  AttachmentListJson.fromJson(Map<String, dynamic> json)
      : attachments = (json['attachments'] as List?)
            ?.map((dynamic e) => Attachment.fromJson(e as Map<String, dynamic>))
            .toList();
}

class Attachment {
  final int? id;
  final String? name;
  final String? value;

  Attachment({this.id, this.name, this.value});

  Attachment.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        value = json['value'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'value': value};
}
