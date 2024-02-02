
class StatusErrorException {
  final int statusCode;
  const StatusErrorException(this.statusCode);
}

abstract class MyAPI {
  static const apiServ = "192.168.2.107:3333" ;

}