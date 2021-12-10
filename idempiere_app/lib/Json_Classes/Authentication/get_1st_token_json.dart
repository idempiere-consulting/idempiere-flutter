class LoginAuthentication {
  LoginAuthentication({
    required this.token,
    required this.clients,
  });
  final String token;
  final List<Client> clients;

  factory LoginAuthentication.fromJson(Map<String, dynamic> data) {
    final token = data['token'] as String;
    // cast to a nullable list as the reviews may be missing
    final clientsData = data['clients'] as List<dynamic>;
    // if the reviews are not missing
    final clients =
        // map each review to a Review object
        clientsData
            .map((clientData) => Client.fromJson(clientData))
            // map() returns an Iterable so we convert it to a List
            .toList();

    // return result passing all the arguments
    return LoginAuthentication(
      token: token,
      clients: clients,
    );
  }
}

class Client {
  Client({required this.id, required this.name});
  // non-nullable - assuming the score field is always present
  final int id;
  final String name;

  factory Client.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as int;
    final name = data['name'] as String;
    return Client(id: id, name: name);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
