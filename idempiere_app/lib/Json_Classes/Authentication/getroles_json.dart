class GetRoles {
  GetRoles({
    required this.roles,
  });
  final List<Role> roles;

  factory GetRoles.fromJson(Map<String, dynamic> data) {
    // cast to a nullable list as the reviews may be missing
    final clientsData = data['roles'] as List<dynamic>;

    final clients = clientsData
        .map((clientData) => Role.fromJson(clientData))
        // map() returns an Iterable so we convert it to a List
        .toList();

    // return result passing all the arguments
    return GetRoles(
      roles: clients,
    );
  }
}

class Role {
  Role({required this.id, required this.name});
  // non-nullable - assuming the score field is always present
  final int id;
  final String name;

  factory Role.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as int;
    final name = data['name'] as String;
    return Role(id: id, name: name);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
