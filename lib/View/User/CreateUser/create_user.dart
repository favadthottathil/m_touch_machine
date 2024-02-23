import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mtouch_machine_test/Common/Widgets/custombutton.dart';
import 'package:mtouch_machine_test/Constants/utilities.dart';
import 'package:mtouch_machine_test/Model/user_model.dart';
import 'package:mtouch_machine_test/View/User/All%20Users/show_users.dart';
import 'package:mtouch_machine_test/View/User/CreateUser/Widgets/custom_text_field.dart';
import 'package:mtouch_machine_test/bloc/user_bloc_bloc.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? file;

  @override
  void dispose() {

    // Dispose Controllers
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBlocBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
      ),
      body: BlocConsumer<UserBlocBloc, UserBlocState>(
        bloc: userBloc,
        listener: (context, state) {
          if (state is UserAddedState) {
            showSnackbar(context, 'user Added');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllUsersList(),
                ));
          }

          if (state is PickFileErrorState) {
            showSnackbar(context, 'Failed To Load Image');
          }

          if (state is TitleAlreadyExistState) {
            showSnackbar(context, 'Title Already Exist');
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllUsersList(),
                ));
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      userBloc.add(PickFileEvent());
                    },
                    child: BlocBuilder<UserBlocBloc, UserBlocState>(
                      bloc: userBloc,
                      builder: (context, state) {
                        if (state is PickFileState) {
                          file = state.file;

                          return SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Image.file(file!, fit: BoxFit.contain),
                          );
                        } else {
                          return DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [
                              10,
                              4
                            ],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select Image',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Title',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Create User',
                    onpressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (file != null) {
                          downloadUrl(fileName: titleController.text.toString(), file: file!).then((imageUrl) {
                            final UserModel userModel = UserModel(
                              uid: '',
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              image: imageUrl,
                            );

                            userBloc.add(AddUserEvent(userModel: userModel));
                          });
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
