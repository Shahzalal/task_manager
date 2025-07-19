import 'package:flutter/material.dart';
import 'package:taskmanager/models/new_task_model.dart';
import 'package:taskmanager/networks/api_link.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/widgets/listtile.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({super.key});

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
  NewTaskModel? _newTaskModel;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskCancelledFormAPi();
    });
  }

  Future<void> taskCancelledFormAPi() async {
    final response = await NetworkRequester().getRequest(Urls.cancelledTask);
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
      return const Center(child: Text('No Cancelled Tasks'));
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _newTaskModel!.data!.length,
        itemBuilder: (context, index) {
          final task = _newTaskModel!.data![index];
          return Listtile(
            status: task.status ?? "Canceled",
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
