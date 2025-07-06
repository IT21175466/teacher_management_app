import 'package:attendence_manager/services/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> teachers = [];
  Map<int, bool> attendance = {};
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final db = await DatabaseHelper.instance.database;
    teachers = await db.query('teachers');
    final rows = await db.query(
      'attendance',
      where: 'date = ?',
      whereArgs: [today],
    );
    for (var row in rows) {
      attendance[row['teacher_id'] as int] = (row['is_present'] as int) == 1;
    }
    for (var t in teachers) {
      attendance.putIfAbsent(t['id'] as int, () => true);
    }
    setState(() {});
  }

  Future<void> markAttendance(int teacherId, bool isPresent) async {
    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      'attendance',
      where: 'teacher_id = ? AND date = ?',
      whereArgs: [teacherId, today],
    );

    if (existing.isNotEmpty) {
      // Update existing record
      await db.update(
        'attendance',
        {'is_present': isPresent ? 1 : 0},
        where: 'teacher_id = ? AND date = ?',
        whereArgs: [teacherId, today],
      );
    } else {
      // Insert new record
      await db.insert('attendance', {
        'teacher_id': teacherId,
        'date': today,
        'is_present': isPresent ? 1 : 0,
      });
    }

    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mark Attendance')),
      body: ListView(
        children: teachers.map((t) {
          final id = t['id'] as int;
          return SwitchListTile(
            title: Text(t['name']),
            subtitle: Text(attendance[id]! ? 'Present' : 'Absent'),
            value: attendance[id]!,
            onChanged: (val) => markAttendance(id, val),
          );
        }).toList(),
      ),
    );
  }
}
