import 'package:flutter/material.dart';
import 'package:taskmanager/models/new_task_model.dart';
import 'package:taskmanager/networks/api_link.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/widgets/bottommdal.dart';
import 'package:taskmanager/widgets/listtile.dart';
import 'package:taskmanager/widgets/statuscard.dart';
import 'package:taskmanager/widgets/textstyle.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => NewTaskScreenState();
}

class NewTaskScreenState extends State<NewTaskScreen> {
  NewTaskModel? _newTaskModel;

  int newTaskCount = 0;
  int completedTaskCount = 0;
  int cancelledTaskCount = 0;
  int inProgressTaskCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTaskFormApi();
    });
  }

  Future<void> getTaskFormApi() async {
    setState(() {
      isLoading = true;
    });

    final newResponse = await NetworkRequester().getRequest(Urls.newTask);
    final completedResponse = await NetworkRequester().getRequest(
      Urls.completedTask,
    );
    final cancelledResponse = await NetworkRequester().getRequest(
      Urls.cancelledTask,
    );
    final progressResponse = await NetworkRequester().getRequest(
      Urls.progressTask,
    );

    if (newResponse['status'] == 'success') {
      _newTaskModel = NewTaskModel.fromJson(newResponse);
      newTaskCount = (_newTaskModel?.data ?? []).length;
    }

    if (completedResponse['status'] == 'success') {
      completedTaskCount = (completedResponse['data'] as List).length;
    }

    if (cancelledResponse['status'] == 'success') {
      cancelledTaskCount = (cancelledResponse['data'] as List).length;
    }

    if (progressResponse['status'] == 'success') {
      inProgressTaskCount = (progressResponse['data'] as List).length;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getDeleteTaskFormApi(String taskId) async {
    final response = await NetworkRequester().getRequest(
      Urls.deleteTask(taskId),
    );
    if (response['status'] == 'success') {
      getTaskFormApi();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete Task Successfully")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete Task Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Top status cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    StatusCard(
                      label: "New Task",
                      count: newTaskCount.toString(),
                    ),
                    StatusCard(
                      label: "Completed",
                      count: completedTaskCount.toString(),
                    ),
                    StatusCard(
                      label: "Cancelled",
                      count: cancelledTaskCount.toString(),
                    ),
                    StatusCard(
                      label: "In Progress",
                      count: inProgressTaskCount.toString(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _newTaskModel?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final task = _newTaskModel!.data![index];
                    return Listtile(
                      status: task.status ?? "New",
                      title: task.title ?? "No Title",
                      description: task.description ?? "No Description",
                      date: task.createdDate ?? "No Date",
                      onEdit: () {
                        if (task.id != null) {
                          showModalBottomShetts(context, task.id!, () {
                            getTaskFormApi();
                          });
                        }
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Delete Task", style: mainText),
                              content: Text(
                                "Are you sure you want to delete this task?",
                                style: subText,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontFamily: "reguler"),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    getDeleteTaskFormApi(task.id!);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(fontFamily: "reguler"),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}
