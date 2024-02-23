part of 'user_bloc_bloc.dart';

sealed class UserBlocEvent {}

// Pick File Event
final class PickFileEvent extends UserBlocEvent {}

// Add users Event
final class AddUserEvent extends UserBlocEvent {
  final UserModel userModel;

  AddUserEvent({required this.userModel});
}

// Get All Users Event
final class GetAllUsersEvent extends UserBlocEvent {}

// Delete User Event
final class DeleteUserEvent extends UserBlocEvent {
  final UserModel userModel;

  DeleteUserEvent({required this.userModel});
}

// Edit User Event
final class EditUserEvent extends UserBlocEvent {
  final UserModel userModel;

  EditUserEvent({required this.userModel});
}


