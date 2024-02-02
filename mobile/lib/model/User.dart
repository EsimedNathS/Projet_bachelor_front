class User {
  late String login;
  String? password;

  User({ required this.login, this.password });

  User.fromJson(Map<String, dynamic> map){
    login = map['login'];
  }

  Map<String, dynamic> toJson() => {
    'login' : login,
    'password' : password
  };

}