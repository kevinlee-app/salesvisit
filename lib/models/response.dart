class Response {
  
  final String errorMessage;
  bool get success {
    return errorMessage.isEmpty;
  }

  Response({this.errorMessage});
}