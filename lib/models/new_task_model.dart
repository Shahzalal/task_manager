class NewTaskModel {
  final String? status;
  final List<TaskData>? data;

  NewTaskModel({this.status, this.data});

  factory NewTaskModel.fromJson(Map<String, dynamic> json) {
    return NewTaskModel(
      status: json['status'],
      data: json['data'] != null
          ? List<TaskData>.from(
              json['data'].map((item) => TaskData.fromJson(item)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class TaskData {
  final String? id;
  final String? title;
  final String? description;
  final String? status;
  final String? createdDate;

  TaskData({
    this.id,
    this.title,
    this.description,
    this.status,
    this.createdDate,
  });

  factory TaskData.fromJson(Map<String, dynamic> json) {
    return TaskData(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdDate: json['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdDate': createdDate,
    };
  }
}
