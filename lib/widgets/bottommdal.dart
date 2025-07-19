import 'package:flutter/material.dart';
import 'package:taskmanager/networks/api_link.dart';
import 'package:taskmanager/networks/network_requester.dart';
import 'package:taskmanager/widgets/button.dart';
import 'package:taskmanager/widgets/textstyle.dart';

void showModalBottomShetts(
  BuildContext context,
  String taskId,
  VoidCallback onStatusChangeSuccess,
) {
  String taskStatus = "In Progress";
  bool isProgressBar = false;

  Map<String, String> statusMap = {
    "In Progress": "Progress",
    "Completed": "Completed",
    "Cancelled": "Cancelled",
  };

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, changeState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text("Change Status For Task", style: mainText),
                const SizedBox(height: 10),
                ...statusMap.keys.map((status) {
                  return RadioListTile(
                    value: status,
                    groupValue: taskStatus,
                    title: Text(status),
                    onChanged: (value) {
                      changeState(() {
                        taskStatus = value!;
                      });
                    },
                  );
                }),
                const SizedBox(height: 20),
                if (isProgressBar)
                  CircularProgressIndicator()
                else
                  MyButton(
                    text: "Submit",
                    onTap: () async {
                      changeState(() => isProgressBar = true);
                      String apiStatus = statusMap[taskStatus]!;
                      final response = await NetworkRequester().getRequest(
                        Urls.statusTask(taskId, apiStatus),
                      );
                      changeState(() => isProgressBar = false);
                      if (response['status'] == 'success') {
                        onStatusChangeSuccess();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Status Update Successfully")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Status Update Failed")),
                        );
                      }
                    },
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
