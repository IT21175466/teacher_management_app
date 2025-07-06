import 'package:attendence_manager/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubstitutionScreen extends StatefulWidget {
  const SubstitutionScreen({super.key});

  @override
  _SubstitutionScreenState createState() => _SubstitutionScreenState();
}

class _SubstitutionScreenState extends State<SubstitutionScreen> {
  List<Map<String, dynamic>> absentTeachers = [];
  List<Map<String, dynamic>> teachers = [];
  List<Map<String, dynamic>> timetable = [];
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final weekday = DateFormat('EEEE').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final db = await DatabaseHelper.instance.database;
    teachers = await db.query('teachers');
    timetable = await db.query(
      'timetable',
      where: 'day = ?',
      whereArgs: [weekday],
    );
    print("Filtered timetable for $weekday: $timetable");

    final absents = await db.rawQuery(
      'SELECT teacher_id FROM attendance WHERE date = ? AND is_present = 0',
      [today],
    );
    absentTeachers = teachers
        .where((t) => absents.any((a) => a['teacher_id'] == t['id']))
        .toList();

    print("Today's date: $today");
    print("Today's weekday: $weekday");
    print("All teachers: $teachers");
    print("Timetable today: $timetable");

    print(
      "Absent teacher IDs: ${absents.map((a) => a['teacher_id']).toList()}",
    );
    setState(() {});
  }

  List<int> getTeacherPeriods(int teacherId) {
    return timetable
        .where((t) => t['teacher_id'] == teacherId)
        .map((t) => t['period'] as int)
        .toList();
  }

  List<Map<String, dynamic>> getFreeTeachers(int period) {
    final busyIds = timetable
        .where((t) => t['period'] == period)
        .map((t) => t['teacher_id'])
        .toSet();
    print(busyIds);
    return teachers
        .where((t) => !busyIds.contains(t['id']) && !absentTeachers.contains(t))
        .toList();
  }

  Future<void> assignSubstitute(
    int period,
    int absentId,
    int subId,
    String grade,
  ) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('substitutions', {
      'date': today,
      'day': weekday,
      'period': period,
      'grade': grade,
      'absent_teacher_id': absentId,
      'substitute_teacher_id': subId,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Substitute Assigned')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Substitution Assignment')),
      body: absentTeachers.isEmpty
          ? Center(child: Text("No absent teachers or no classes today."))
          : ListView(
              padding: EdgeInsets.all(16),
              children: absentTeachers.expand((absent) {
                final periods = getTeacherPeriods(absent['id']);
                return periods.map((p) {
                  final grade = timetable.firstWhere(
                    (t) => t['teacher_id'] == absent['id'] && t['period'] == p,
                  )['grade'];
                  final free = getFreeTeachers(p);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${absent['name']} absent in Period $p (Grade $grade)',
                          ),
                          Wrap(
                            spacing: 8,
                            children: free.map((f) {
                              return ElevatedButton(
                                child: Text(f['name']),
                                onPressed: () => assignSubstitute(
                                  p,
                                  absent['id'],
                                  f['id'],
                                  grade,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }).toList(),
            ),
    );
  }
}
