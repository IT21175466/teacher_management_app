// ignore_for_file: use_build_context_synchronously

import 'package:attendence_manager/constants/app_colors.dart';
import 'package:attendence_manager/services/db_helper.dart';
import 'package:attendence_manager/views/attendance_screen.dart';
import 'package:attendence_manager/views/time_table_screen.dart';
import 'package:attendence_manager/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> clearAllTables(BuildContext context) async {
    final db = await DatabaseHelper.instance.database;

    await db.delete('attendance');
    await db.delete('substitutions');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.done, size: 20, color: Colors.white),
            SizedBox(width: 10),
            CustomText(text: 'Completed', fontsize: 16, color: Colors.white),
          ],
        ),
        backgroundColor: AppColors.greenAccentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accentColor,
        title: CustomText(
          text: 'Principal Dashboard',
          fontsize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight / 2,
                width: screenWidth,
                child: Center(child: Image.asset('assets/images/bg.png')),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.accentColor, width: 1),
                    ),
                  ),
                  child: CustomText(
                    text: '1. Mark Attendance',
                    fontsize: 15,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AttendanceScreen()),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.accentColor, width: 1),
                    ),
                  ),
                  child: CustomText(
                    text: '2. Assign Time Table',
                    fontsize: 15,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TimetableScreen()),
                  ),
                ),
              ),
              SizedBox(height: 60),
              SizedBox(
                height: 50,
                width: screenWidth,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(
                        color: AppColors.redAccentColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Spacer(),
                      Icon(
                        Icons.clear,
                        color: AppColors.redAccentColor,
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      CustomText(
                        text: 'Reset',
                        fontsize: 16,
                        color: AppColors.redAccentColor,
                      ),
                      Spacer(),
                    ],
                  ),
                  onPressed: () {
                    clearAllTables(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
