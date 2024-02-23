import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtouch_machine_test/Common/Widgets/custombutton.dart';
import 'package:mtouch_machine_test/Constants/utilities.dart';
import 'package:mtouch_machine_test/Model/user_model.dart';
import 'package:mtouch_machine_test/View/User/All%20Users/show_users.dart';
import 'package:mtouch_machine_test/View/User/CreateUser/Widgets/custom_text_field.dart';
import 'package:mtouch_machine_test/bloc/user_bloc_bloc.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  TextEditingController titleController = TextEditingController();

  TextEditingController desController = TextEditingController();

  dynamic file;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose Controllers
    titleController.dispose();
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBlocBloc>(context);

    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Expanded(child: Text(widget.userModel.title)),
          IconButton(
            onPressed: () {
              titleController.text = widget.userModel.title;
              desController.text = widget.userModel.description;

              customBottomSheet(context, userBloc);
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete User'),
                    content: Text('Do You Want to Delete ${widget.userModel.title}'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => userBloc.add(
                                DeleteUserEvent(userModel: widget.userModel),
                              ),
                          child: const Text('Ok'))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_forever),
          )
        ],
      )),
      body: BlocListener<UserBlocBloc, UserBlocState>(
        bloc: userBloc,
        listener: (context, state) {
          if (state is EditUserState) {
            showSnackbar(context, 'user edited');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllUsersList(),
                ),
                (route) => false);
          }

          if (state is TitleAlreadyExistState) {
            showSnackbar(context, 'Title Already Exist');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllUsersList(),
                ));
          }

          if (state is DeleteUserState) {
            showSnackbar(context, 'user Deleted');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllUsersList(),
                ),
                (route) => false);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                child: Image.network(
                  widget.userModel.image,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.userModel.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(widget.userModel.description,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> customBottomSheet(BuildContext context, UserBlocBloc userBloc) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 500,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  BlocConsumer<UserBlocBloc, UserBlocState>(
                    bloc: userBloc,
                    listener: (context, state) {
                      if (state is PickFileErrorState) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Failed to Load Image'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ok'),
                              )
                            ],
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      // Show Profile To User

                      if (state is PickFileState) {
                        file = state.file;

                        return CircleAvatar(
                          radius: 60,
                          child: Image.file(file),
                        );
                      } else if (file is File) {
                        return CircleAvatar(
                          radius: 60,
                          child: Image.file(file),
                        );
                      } else {
                        return CircleAvatar(
                          radius: 60,
                          child: Image.network(widget.userModel.image),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => userBloc.add(PickFileEvent()),
                    child: const Text('change profile'),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Title',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: desController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: 'Update User',
                      onpressed: () {
                        if (_formKey.currentState!.validate()) {
                          // check file type is not File
                          if (file is! File) {
                            final UserModel userModel = UserModel(
                              uid: widget.userModel.uid,
                              title: titleController.text.trim(),
                              description: desController.text.trim(),
                              image: widget.userModel.image,
                            );

                            userBloc.add(EditUserEvent(userModel: userModel));
                          } else {
                            downloadUrl(fileName: titleController.text.toString(), file: file!).then((imageUrl) {
                              final UserModel userModel = UserModel(
                                uid: widget.userModel.uid,
                                title: titleController.text.trim(),
                                description: desController.text.trim(),
                                image: imageUrl,
                              );

                              userBloc.add(EditUserEvent(userModel: userModel));
                            });
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
