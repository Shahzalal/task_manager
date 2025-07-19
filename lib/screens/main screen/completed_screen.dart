import 'package:flutter/material.dart';
import 'package:taskmanager/models/new_task_model.dart';
import 'package:taskmanager/networks/api_link.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/widgets/listtile.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  NewTaskModel? _newTaskModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskCompletedFormAPi();
    });
  }

  Future<void> taskCompletedFormAPi() async {
    final response = await NetworkRequester().getRequest(Urls.completedTask);
    if (response['status'] == 'success') {
      setState(() {
        _newTaskModel = NewTaskModel.fromJson(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_newTaskModel == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_newTaskModel?.data?.isEmpty ?? true) {
      return const Center(child: Text('No Completed Tasks'));
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _newTaskModel!.data!.length,
        itemBuilder: (context, index) {
          final task = _newTaskModel!.data![index];
          return Listtile(
            status: task.status ?? "Completed",
            title: task.title ?? "No Title",
            description: task.description ?? "No Description",
            date: task.createdDate ?? "No Date",
            onEdit: () {},
            onDelete: () {},
          );
        },
      ),
    );
  }
}
