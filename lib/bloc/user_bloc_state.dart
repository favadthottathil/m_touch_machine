part of 'user_bloc_bloc.dart';

sealed class UserBlocState {}

final class UserBlocInitial extends UserBlocState {}

// Pick File State
final class PickFileState extends UserBlocState {
  final File file;

  PickFileState({required this.file});
}

// User Add State
final class UserAddedState extends UserBlocState {}

// GetAll Users State
final class GetAllUsersState extends UserBlocState {
  final List<UserModel> usersList;

  GetAllUsersState({required this.usersList});
}

// Delete User State
final class DeleteUserState extends UserBlocState {}

// Edit User State
final class EditUserState extends UserBlocState {}

// Title already Exist State
final class TitleAlreadyExistState extends UserBlocState {}

// Show Loading
final class LoadingState extends UserBlocState {}

// Pick File Error

final class PickFileErrorState extends UserBlocState {}
