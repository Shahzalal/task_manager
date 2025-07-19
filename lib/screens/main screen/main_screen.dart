import 'package:flutter/material.dart';
import 'package:taskmanager/screens/main%20screen/addnewtask_screen.dart';
import 'package:taskmanager/screens/main%20screen/cancelled_screen.dart';
import 'package:taskmanager/screens/main%20screen/completed_screen.dart';
import 'package:taskmanager/screens/main%20screen/inprogress_screen.dart';
import 'package:taskmanager/screens/main%20screen/new_task_screen.dart';
import 'package:taskmanager/widgets/appbar.dart';

class TaskDashboardScreen extends StatefulWidget {
  const TaskDashboardScreen({super.key});

  @override
  State<TaskDashboardScreen> createState() => _TaskDashboardScreenState();
}

class _TaskDashboardScreenState extends State<TaskDashboardScreen> {
  int _selectedCurrentIndex = 0;

  final GlobalKey<NewTaskScreenState> newTaskScreenKey =
      GlobalKey<NewTaskScreenState>();

  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      NewTaskScreen(key: newTaskScreenKey),
      CompletedScreen(),
      InprogressScreen(),
      CancelledScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: MyAppBarWidget(),
      body: screens[_selectedCurrentIndex],

      floatingActionButton: _selectedCurrentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddnewtaskScreen()),
                ).then((value) {
                  if (value == true) {
                    newTaskScreenKey.currentState?.getTaskFormApi();
                  }
                });
              },
              backgroundColor: Color(0xFFA1045A),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFA1045A),
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedCurrentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedCurrentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: "New Task",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: "Completed"),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Progress",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.cancel), label: "Canceled"),
        ],
      ),
    );
  }
}
