class SubstitutionEntry {
  final int id;
  final String date;
  final String day;
  final int period;
  final String grade;
  final int absentTeacherId;
  final int substituteTeacherId;

  SubstitutionEntry({
    required this.id,
    required this.date,
    required this.day,
    required this.period,
    required this.grade,
    required this.absentTeacherId,
    required this.substituteTeacherId,
  });

  factory SubstitutionEntry.fromMap(Map<String, dynamic> map) {
    return SubstitutionEntry(
      id: map['id'],
      date: map['date'],
      day: map['day'],
      period: map['period'],
      grade: map['grade'],
      absentTeacherId: map['absent_teacher_id'],
      substituteTeacherId: map['substitute_teacher_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'day': day,
      'period': period,
      'grade': grade,
      'absent_teacher_id': absentTeacherId,
      'substitute_teacher_id': substituteTeacherId,
    };
  }
}
