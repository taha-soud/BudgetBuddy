class Category {
  final String id;
  final String userId;
  final String name;
  final String type;
  final String icon;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type,
      'icon': icon,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      type: json['type'],
      icon: json['icon'],
    );
  }
}
