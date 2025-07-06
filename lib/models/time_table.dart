class TimetableEntry {
  final int id;
  final int teacherId;
  final String day;
  final int period;
  final String grade;

  TimetableEntry({
    required this.id,
    required this.teacherId,
    required this.day,
    required this.period,
    required this.grade,
  });

  factory TimetableEntry.fromMap(Map<String, dynamic> map) => TimetableEntry(
    id: map['id'],
    teacherId: map['teacher_id'],
    day: map['day'],
    period: map['period'],
    grade: map['grade'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'teacher_id': teacherId,
    'day': day,
    'period': period,
    'grade': grade,
  };
}
