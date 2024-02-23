import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mtouch_machine_test/Constants/utilities.dart';
import 'package:mtouch_machine_test/Controller/user_controller.dart';
import 'package:mtouch_machine_test/Model/user_model.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBlocBloc extends Bloc<UserBlocEvent, UserBlocState> {
  UserBlocBloc() : super(UserBlocInitial()) {
    on<PickFileEvent>((event, emit) async {
      // pick image
      final file = await pickImage();

      // return error while file is null
      if (file == null) {
        emit(PickFileErrorState());
        return;
      }

      emit(PickFileState(file: file));
    });

    on<AddUserEvent>((event, emit) async {
      // show loading
      emit(LoadingState());

      // check user exist
      final isUserExist = await UserController().checkTitleAlreadyExists(
        event.userModel.title,
      );

      // user exist return error state
      if (isUserExist) {
        emit(TitleAlreadyExistState());
        return;
      }

      // Create new user
      await UserController().createUser(userModel: event.userModel);
      emit(UserAddedState());
    });

    on<GetAllUsersEvent>((event, emit) async {
      final usersList = await UserController().getAllUsers();

      emit(GetAllUsersState(usersList: usersList));
    });

    on<EditUserEvent>((event, emit) async {
      emit(LoadingState());

      final isUserExist = await UserController().checkTitleAlreadyExists(event.userModel.title);

      if (isUserExist) {
        emit(TitleAlreadyExistState());
        return;
      }

      // update user
      await UserController().updateUser(userModel: event.userModel);
      emit(EditUserState());
    });

    on<DeleteUserEvent>((event, emit) {
      // Delete User
      UserController().deleteUser(userModel: event.userModel);
      emit(DeleteUserState());
    });
  }
}
