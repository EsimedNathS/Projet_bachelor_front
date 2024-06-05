
class StatusErrorException {
  final int statusCode;
  const StatusErrorException(this.statusCode);
}
class TokenInvalidExcepetion {}
class NetworkException {}

abstract class MyAPI {
  //static const apiServ = "10.0.2.2:3333" ;
  static const apiServ = "main-bvxea6i-ybo7esrumgank.fr-3.platformsh.site" ;
}