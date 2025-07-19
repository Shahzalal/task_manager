import 'package:flutter/material.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/widgets/appbar.dart';
import 'package:taskmanager/widgets/backgroundimage.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/textfield.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class AddnewtaskScreen extends StatefulWidget {
  const AddnewtaskScreen({super.key});

  @override
  State<AddnewtaskScreen> createState() => _AddnewtaskScreenState();
}

class _AddnewtaskScreenState extends State<AddnewtaskScreen> {
  final _formTask = GlobalKey<FormState>();
  final TextEditingController subTEController = TextEditingController();
  final TextEditingController desTEController = TextEditingController();

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBarWidget(isTappable: false),
      body: BackgroundImage(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formTask,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text("Add New Task", style: mainText),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: subTEController,
                    decoration: textFieldDecoration("Subject"),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter A New Task Title";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: desTEController,
                    decoration: textFieldDecoration("Description"),
                    maxLines: 10,
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter A New Task Description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (isProgress)
                    Center(child: CircularProgressIndicator())
                  else
                    MyButton(
                      onTap: () async {
                        if (_formTask.currentState!.validate()) {
                          setState(() {
                            isProgress = true;
                          });
                          final result = await NetworkRequester().postRequest(
                            "https://task.teamrabbil.com/api/v1/createTask",
                            {
                              "title": subTEController.text.trim(),
                              "description": desTEController.text.trim(),
                              "status": "New",
                            },
                          );
                          setState(() {
                            isProgress = false;
                          });
                          if (result['status'] == 'success') {
                            subTEController.clear();
                            desTEController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Create New Task Successfully"),
                              ),
                            );
                            Navigator.pop(context, true);
                          }
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
