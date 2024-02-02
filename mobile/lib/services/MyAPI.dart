
class StatusErrorException {
  final int statusCode;
  const StatusErrorException(this.statusCode);
}

abstract class MyAPI {
  static const apiServ = "10.0.2.2:3333" ;

}