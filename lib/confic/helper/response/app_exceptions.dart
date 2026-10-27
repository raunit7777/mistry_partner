class AppExceptions implements Exception{

  final _massage ;
  final _prefix ;
  AppExceptions([this._massage,this._prefix]);

  String toString(){
    return "$_prefix$_massage";
  }

}

class FetchDataExceptions extends AppExceptions{

  FetchDataExceptions([String? message]): super(message,"Error During Communication");
}

class BadRequestException extends AppExceptions {

  BadRequestException([String? message,]):super (message,"Invaild request");
}
class UserNotFoundException extends AppExceptions {

  UserNotFoundException([String? message,]):super (message,"Invaild request");
}
class UnauthorisedExceptions extends AppExceptions{

  UnauthorisedExceptions([String? message]):super(message,"UnauthorisedExceptions request");
}
class InvalidInputExceptions extends AppExceptions{

  InvalidInputExceptions([String? message]):super(message,"InvalidInputExceptions request");
}