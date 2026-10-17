import '../../../../model/my_user.dart';


abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  final MyUser user;
  RegisterSuccessState({required this.user});
}

class RegisterErrorState extends RegisterState {
  final String errorMessage;
  RegisterErrorState({required this.errorMessage});
}
