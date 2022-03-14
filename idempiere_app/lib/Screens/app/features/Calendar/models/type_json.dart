class TypeJson {
  final List<Types>? types;

  TypeJson({this.types});

  TypeJson.fromJson(Map<String, dynamic> json)
      : types = (json['types'] as List?)
            ?.map((dynamic e) => Types.fromJson(e as Map<String, dynamic>))
            .toList();
}

class Types {
  final String? id;
  final String? name;
  final String? value;

  Types({this.id, this.name, this.value});

  Types.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        name = json['name'] as String?,
        value = json['value'] as String?;

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'value': value};
}
