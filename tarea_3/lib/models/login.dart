class Login {
  late String email;
  late String password;
  late String username;
  late String name;
  late bool rememberMe = false;
  late int id;

  Login({
    required this.email,
    required this.password,
  });

  Login.fromService(Map<String, dynamic> data) {
    email = data['email'];
    password = data['password'];
    username = data['username'];
    name = data['name'];
    id = data['id'];
  }
  Login.fromProfile(Map<String, dynamic> data) {
    email = data['email'];
    name = data['nombre'];
  }
}
