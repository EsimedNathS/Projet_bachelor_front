class AuthenticationResult {
  late String username;
  late String login;
  late String token;

  AuthenticationResult(this.login, this.username, this.token);

  AuthenticationResult.fromMap(Map<String, dynamic> json) {
    token = json['token'];
  }

}