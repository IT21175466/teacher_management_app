class Teacher {
  final int id;
  final String name;
  final String subject;

  Teacher({required this.id, required this.name, required this.subject});

  factory Teacher.fromMap(Map<String, dynamic> map) =>
      Teacher(id: map['id'], name: map['name'], subject: map['subject']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'subject': subject};
}
