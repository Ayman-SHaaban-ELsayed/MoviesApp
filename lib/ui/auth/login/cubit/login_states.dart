import '../../../../model/my_user.dart';


abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class GoogleLoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final MyUser user;
  LoginSuccessState({required this.user});
}

class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState({required this.errorMessage});
}
