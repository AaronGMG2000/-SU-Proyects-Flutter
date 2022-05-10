class Login {
  late String email;
  late String password;
  late String username;
  late String name;
  late bool rememberMe = false;
  late int id;

  Login() {
    email = "";
    password = "";
    username = "";
    name = "";
    rememberMe = false;
    id = 0;
  }

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

  Map<String, dynamic> toDatabase() => {
        'email': email,
        'password': password,
        'username': username,
        'name': name,
      };
}
