import 'package:flutter/material.dart';
import 'package:taskmanager/models/new_task_model.dart';
import 'package:taskmanager/networks/api_link.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/widgets/listtile.dart';

class InprogressScreen extends StatefulWidget {
  const InprogressScreen({super.key});

  @override
  State<InprogressScreen> createState() => _InprogressScreenState();
}

class _InprogressScreenState extends State<InprogressScreen> {
  NewTaskModel? _newTaskModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      inprogressTaskFormApi();
    });
  }

  Future<void> inprogressTaskFormApi() async {
    final response = await NetworkRequester().getRequest(Urls.progressTask);
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
      return const Center(child: Text("No In-Progress Task"));
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _newTaskModel!.data!.length,
        itemBuilder: (context, index) {
          final task = _newTaskModel!.data![index];
          return Listtile(
            status: task.status ?? "Progress",
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
