class EventModel {
  final String id;
  final String hostID;
  final String title;
  final String banner;
  final String description;
  final String startTime;
  final String endTime;
  final String location;
  final bool? active;

  EventModel({
    required this.id,
    required this.hostID,
    required this.title,
    required this.banner,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.active,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      hostID: json['hostID'],
      title: json['title'],
      banner: json['banner'],
      description: json['description'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostID': hostID,
      'title': title,
      'banner': banner,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'active': active,
    };
  }
}
