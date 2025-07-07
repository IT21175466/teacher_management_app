import 'dart:ui';
import 'package:attendence_manager/constants/app_colors.dart';
import 'package:attendence_manager/models/substitutions.dart';
import 'package:attendence_manager/models/teacher.dart';
import 'package:attendence_manager/models/time_table.dart';
import 'package:attendence_manager/services/db_helper.dart';
import 'package:attendence_manager/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<Teacher> teachers = [];
  List<TimetableEntry> timetable = [];

  final grades = ['6', '7', '8', '9', '10'];
  final periods = ['1', '2', '3', '4', '5', '6', '7', '8'];
  int selectedGradeIndex = 0;
  String today = DateFormat('EEEE').format(DateTime.now());
  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<Map<String, dynamic>> attendance = [];
  List<SubstitutionEntry> substitutions = [];

  @override
  void initState() {
    super.initState();
    loadTeachersAndTimetable();
  }

  bool isTeacherPresent(int teacherId) {
    final entry = attendance.firstWhere(
      (a) => a['teacher_id'] == teacherId,
      orElse: () => {},
    );
    return entry.isNotEmpty ? entry['is_present'] == 1 : true;
  }

  Future<void> loadTeachersAndTimetable() async {
    final db = await DatabaseHelper.instance.database;
    final grade = grades[selectedGradeIndex];

    final teacherResult = await db.query('teachers');
    final timetableResult = await db.query(
      'timetable',
      where: 'grade = ? AND day = ?',
      whereArgs: [grade, today],
    );

    final attendanceResult = await db.query(
      'attendance',
      where: 'date = ?',
      whereArgs: [todayDate],
    );

    final substitutionsResult = await db.query(
      'substitutions',
      where: 'date = ? AND day = ?',
      whereArgs: [todayDate, today],
    );

    setState(() {
      teachers = teacherResult.map((e) => Teacher.fromMap(e)).toList();
      timetable = timetableResult
          .map((e) => TimetableEntry.fromMap(e))
          .toList();
      attendance = attendanceResult;
      substitutions = substitutionsResult
          .map((e) => SubstitutionEntry.fromMap(e))
          .toList();
    });

    print('Teachers Loaded:');
    for (var t in teachers) {
      print('ID: ${t.id}, Name: ${t.name}, Subject: ${t.subject}');
    }

    print('Timetable Loaded:');
    for (var entry in timetable) {
      print(
        'Period ${entry.period} - Grade: ${entry.grade}, Teacher ID: ${entry.teacherId}',
      );
    }

    print('Subtitutions Loaded:');
    for (var entry in substitutions) {
      print(
        'Absent Teacher ID ${entry.absentTeacherId} - Grade: ${entry.grade}, Substitute Teacher ID: ${entry.substituteTeacherId}',
      );
    }
  }

  int getWorkingPeriods(int teacherId) {
    return timetable
        .where((t) => t.teacherId == teacherId && t.day == today)
        .length;
  }

  // List<Teacher> getFreeTeachers(int period) {
  //   final busyTeacherIds = timetable
  //       .where((t) => t.period == period)
  //       .map((t) => t.teacherId)
  //       .toSet();
  //   return teachers.where((t) {
  //     final isBusy = busyTeacherIds.contains(t.id);
  //     final isPresent = isTeacherPresent(t.id);
  //     final periodCount = getWorkingPeriods(t.id);
  //     return !isBusy && isPresent && periodCount < 7;
  //   }).toList();
  // }

  // Future<List<Teacher>> getFreeTeachers(int period) async {
  //   final db = await DatabaseHelper.instance.database;

  //   final busyTeacherIds = timetable
  //       .where((t) => t.period == period)
  //       .map((t) => t.teacherId)
  //       .toSet();

  //   final subResult = await db.query(
  //     'substitutions',
  //     where: 'date = ? AND day = ? AND period = ?',
  //     whereArgs: [todayDate, today, period],
  //   );

  //   final assignedTeacherIds = subResult
  //       .map((s) => s['substitute_teacher_id'] as int)
  //       .toSet();

  //   return teachers.where((t) {
  //     final isBusy = busyTeacherIds.contains(t.id);
  //     final isPresent = isTeacherPresent(t.id);
  //     final periodCount = getWorkingPeriods(t.id);
  //     final isAlreadySubstituted = assignedTeacherIds.contains(t.id);
  //     return !isBusy && isPresent && periodCount <= 7 && !isAlreadySubstituted;
  //   }).toList();
  // }

  Future<List<Teacher>> getFreeTeachers(int period) async {
    final db = await DatabaseHelper.instance.database;

    // ✅ Get all timetable entries for today (for all grades)
    final fullDayTimetable = await db.query(
      'timetable',
      where: 'day = ?',
      whereArgs: [today],
    );

    // ✅ Get substitutions already done for this date/day/period
    final subResult = await db.query(
      'substitutions',
      where: 'date = ? AND day = ? AND period = ?',
      whereArgs: [todayDate, today, period],
    );

    final assignedSubstituteIds = subResult
        .map((e) => e['substitute_teacher_id'] as int)
        .toSet();

    // ✅ Find teacher IDs already busy for this period (default timetable)
    final busyAtPeriodTeacherIds = fullDayTimetable
        .where((e) => e['period'] == period)
        .map((e) => e['teacher_id'] as int)
        .toSet();

    return teachers.where((t) {
      final isPresent = isTeacherPresent(t.id);

      // ✅ Count total periods today for this teacher (not just selected grade)
      final periodsToday = fullDayTimetable
          .where((e) => e['teacher_id'] == t.id)
          .length;

      final isBusy = busyAtPeriodTeacherIds.contains(t.id);
      final isAlreadySubstituted = assignedSubstituteIds.contains(t.id);

      return isPresent && !isBusy && !isAlreadySubstituted && periodsToday < 7;
    }).toList();
  }

  bool isAlreadySubstituted(int teacherId, int period, String grade) {
    return substitutions.any(
      (sub) =>
          sub.absentTeacherId == teacherId &&
          sub.period == period &&
          sub.grade == grade &&
          sub.day == today,
    );
  }

  String? getSubstitutedTeacherName(
    int absentTeacherId,
    int period,
    String grade,
  ) {
    // Find the substitution that matches the given details
    final subTeacher = substitutions.firstWhere(
      (sub) =>
          sub.absentTeacherId == absentTeacherId &&
          sub.period == period &&
          sub.grade == grade &&
          sub.day == today,
      orElse: () => SubstitutionEntry(
        id: 0,
        date: 'date',
        day: 'day',
        period: 0,
        grade: 'grade',
        absentTeacherId: 0,
        substituteTeacherId: 0,
      ),
    );

    // Find the teacher by absentTeacherId
    final teacher = teachers.firstWhere(
      (teacher) => teacher.id == subTeacher.substituteTeacherId,
      orElse: () => Teacher(id: 0, name: 'No Name', subject: 'No Subject'),
    );

    return teacher.name;
  }

  int? getSubstitutedTeacherID(int absentTeacherId, int period, String grade) {
    // Find the substitution that matches the given details
    final subTeacher = substitutions.firstWhere(
      (sub) =>
          sub.absentTeacherId == absentTeacherId &&
          sub.period == period &&
          sub.grade == grade &&
          sub.day == today,
      orElse: () => SubstitutionEntry(
        id: 0,
        date: 'date',
        day: 'day',
        period: 0,
        grade: 'grade',
        absentTeacherId: 0,
        substituteTeacherId: 0,
      ),
    );

    // Find the teacher by absentTeacherId
    final teacher = teachers.firstWhere(
      (teacher) => teacher.id == subTeacher.substituteTeacherId,
      orElse: () => Teacher(id: 0, name: 'No Name', subject: 'No Subject'),
    );

    return teacher.id;
  }

  void showAvailableTeachersDialog(int period, String grade) async {
    final freeTeachers = await getFreeTeachers(period);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Available Teachers for Period $period'),
        content: freeTeachers.isEmpty
            ? Text('No available teachers found.')
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: freeTeachers
                      .map(
                        (t) => ListTile(
                          title: Text(t.name),
                          subtitle: Text(t.subject),
                          trailing: TextButton(
                            child: Text("Assign"),
                            onPressed: () async {
                              final db = await DatabaseHelper.instance.database;
                              await db.insert('substitutions', {
                                'date': todayDate,
                                'day': today,
                                'period': period,
                                'grade': grade,
                                'absent_teacher_id': timetable
                                    .firstWhere((e) => e.period == period)
                                    .teacherId,
                                'substitute_teacher_id': t.id,
                              });
                              setState(() {
                                teachers = [];
                                attendance = [];
                                substitutions = [];
                                timetable = [];
                              });
                              loadTeachersAndTimetable();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Substitute assigned successfully",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void showAlreadyAssignedAvailableTeachersDialog(
    int period,
    String grade,
    String assignedName,
    int absentTeacherId,
    int substituteTeacherId,
  ) async {
    final freeTeachers = await getFreeTeachers(period);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Assigned - $assignedName',
          style: TextStyle(
            color: AppColors.redAccentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: freeTeachers.isEmpty
            ? Text('No available teachers found.')
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: freeTeachers
                      .map(
                        (t) => ListTile(
                          title: Text(t.name),
                          subtitle: Text(t.subject),
                          trailing: TextButton(
                            child: t.name == assignedName
                                ? Text("Assigned")
                                : Text("Assign"),
                            onPressed: () async {
                              final db = await DatabaseHelper.instance.database;

                              await db.delete(
                                'substitutions',
                                where:
                                    'date = ? AND day = ? AND period = ? AND grade = ? AND absent_teacher_id = ? AND substitute_teacher_id = ?',
                                whereArgs: [
                                  todayDate,
                                  today,
                                  period,
                                  grade,
                                  absentTeacherId,
                                  substituteTeacherId,
                                ],
                              );

                              await db.insert('substitutions', {
                                'date': todayDate,
                                'day': today,
                                'period': period,
                                'grade': grade,
                                'absent_teacher_id': timetable
                                    .firstWhere((e) => e.period == period)
                                    .teacherId,
                                'substitute_teacher_id': t.id,
                              });
                              setState(() {
                                teachers = [];
                                attendance = [];
                                substitutions = [];
                                timetable = [];
                              });

                              loadTeachersAndTimetable();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Substitute assigned successfully",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Substitution Assignment', fontsize: 20),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(grades.length, (index) {
                    final isSelected = selectedGradeIndex == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () async {
                          setState(() => selectedGradeIndex = index);
                          await loadTeachersAndTimetable();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.white
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.accentColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: CustomText(
                          text: 'Grade ${grades[index]}',
                          fontWeight: FontWeight.w500,
                          fontsize: 15,
                          color: isSelected
                              ? AppColors.accentColor
                              : AppColors.textGrayColor,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    final periodNumber = index + 1;
                    final entry = timetable.firstWhere(
                      (e) => e.period == periodNumber,
                      orElse: () => TimetableEntry(
                        id: 0,
                        teacherId: 0,
                        day: today,
                        period: periodNumber,
                        grade: grades[selectedGradeIndex],
                      ),
                    );

                    final teacher = teachers.firstWhere(
                      (t) => t.id == entry.teacherId,
                      orElse: () => Teacher(id: 0, name: 'Off', subject: 'Off'),
                    );

                    return GestureDetector(
                      onTap: () {
                        if (isAlreadySubstituted(
                              teacher.id,
                              periodNumber,
                              grades[selectedGradeIndex],
                            ) ==
                            true) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: CustomText(
                          //       text:
                          //           'You’ve already assigned a teacher for this period.',
                          //       fontsize: 11,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // );

                          showAlreadyAssignedAvailableTeachersDialog(
                            periodNumber,
                            grades[selectedGradeIndex],
                            getSubstitutedTeacherName(
                                  teacher.id,
                                  periodNumber,
                                  grades[selectedGradeIndex],
                                ) ??
                                '',
                            teacher.id,
                            getSubstitutedTeacherID(
                                  teacher.id,
                                  periodNumber,
                                  grades[selectedGradeIndex],
                                ) ??
                                -1,
                          );
                        } else {
                          if (isTeacherPresent(teacher.id) && teacher.id != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: CustomText(
                                  text:
                                      'You’ve already assigned a teacher for this period.',
                                  fontsize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          } else {
                            if (teacher.id == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: CustomText(
                                    text: 'Off period in the timetable!',
                                    fontsize: 11,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              showAvailableTeachersDialog(
                                periodNumber,
                                grades[selectedGradeIndex],
                              );
                            }
                          }
                        }
                      },
                      child: _buildPeriodTile(
                        teacher.subject,
                        teacher.name,
                        isAlreadySubstituted(
                              teacher.id,
                              periodNumber,
                              grades[selectedGradeIndex],
                            )
                            ? Colors.yellow
                            : isTeacherPresent(teacher.id)
                            ? teacher.id == 0
                                  ? AppColors.borderGrayColor
                                  : AppColors.greenAccentColor
                            : AppColors.redAccentColor,
                        isAlreadySubstituted(
                              teacher.id,
                              periodNumber,
                              grades[selectedGradeIndex],
                            )
                            ? AppColors.textBlackColor
                            : isTeacherPresent(teacher.id)
                            ? teacher.id == 0
                                  ? AppColors.textBlackColor
                                  : Colors.white
                            : Colors.white,
                        isAlreadySubstituted(
                              teacher.id,
                              periodNumber,
                              grades[selectedGradeIndex],
                            )
                            ? '${periodNumber.toString()}\nAssigned ${getSubstitutedTeacherName(teacher.id, periodNumber, grades[selectedGradeIndex])}'
                            : isTeacherPresent(teacher.id)
                            ? periodNumber.toString()
                            : '${periodNumber.toString()}\nTeacher Absent!',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodTile(
    String subject,
    String teacher,
    Color color,
    Color textColor,
    String number,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Period $number',
                fontsize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
                textalign: TextAlign.left,
              ),
              CustomText(text: subject, fontsize: 13, color: textColor),
            ],
          ),
          //SizedBox(width: 15),
          //CustomText(text: time, fontsize: 13),
          Spacer(),
          CustomText(
            text: teacher,
            fontsize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
