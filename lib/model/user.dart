class User {
  final String device, id, message;

  User({required this.device, required this.id, required this.message});

  static User jsonToUser(Map p){
    return User(device:  p ['device'] , id: p['id'], message: p['message']);
  }
}

