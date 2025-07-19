class Urls {
  static String baseUrl = 'https://task.teamrabbil.com/api/v1';
  static String updateProfile = '$baseUrl/profileUpdate';
  static String newTask = '$baseUrl/listTaskByStatus/New';
  static String completedTask = '$baseUrl/listTaskByStatus/Completed';
  static String cancelledTask = '$baseUrl/listTaskByStatus/Cancelled';
  static String progressTask = '$baseUrl/listTaskByStatus/Progress';

  static String deleteTask(String taskId) => '$baseUrl/deleteTask/$taskId';

  static String statusTask(String taskId, String status) =>
      '$baseUrl/updateTaskStatus/$taskId/$status';
}
