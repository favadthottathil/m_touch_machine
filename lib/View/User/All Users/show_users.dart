import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtouch_machine_test/Model/user_model.dart';
import 'package:mtouch_machine_test/View/User/All%20Users/users_details.dart';
import 'package:mtouch_machine_test/View/User/CreateUser/create_user.dart';
import 'package:mtouch_machine_test/bloc/user_bloc_bloc.dart';

class AllUsersList extends StatelessWidget {
  const AllUsersList({super.key});

  navigateToUserDetailsScreen(BuildContext context, UserModel userModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetail(userModel: userModel),
        ));
  }

  navigateToCreateUserScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateUser(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBlocBloc>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userBloc.add(GetAllUsersEvent());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: BlocBuilder<UserBlocBloc, UserBlocState>(
        bloc: userBloc,
        builder: (context, state) {
          if (state is GetAllUsersState) {
            final usersList = state.usersList;

            if (usersList.isEmpty) {
              return const Center(
                  child: Text(
                'List Is Empty',
                style: TextStyle(
                  fontSize: 20,
                ),
              ));
            } else {
              return ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  final user = usersList[index];

                  return GestureDetector(
                    onTap: () => navigateToUserDetailsScreen(context, user),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Image.network(user.image),
                      ),
                      title: Text(user.title),
                      subtitle: Text(
                        user.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToCreateUserScreen(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
