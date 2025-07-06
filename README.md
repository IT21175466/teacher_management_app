# 📚 Teacher Substitution & Attendance Manager

A smart, Flutter-powered app for managing **teacher attendance**, **daily timetables**, and **automatic substitution assignments** in schools. Designed for principals or school admins to easily track absent teachers and assign substitutes with just a tap.

## 🚀 Features

- ✅ Mark teacher attendance daily
- 📅 View a daily timetable by grade and period
- ❌ Highlight absent teachers clearly
- 🔁 Suggest available substitute teachers
- 🧠 Filters out busy or overworked teachers (≥ 7 periods)
- 🧑‍🏫 Assign substitutes and store them in a dedicated substitutions table
- 📊 Prevent duplicate assignments for the same period and teacher
- 🔍 See which teachers are free at a specific time
- 🧹 Admin option to clear all data (reset database)

## 🧠 Tech Stack

- **Flutter** (UI)
- **SQFlite** (Local SQLite DB)
- **Dart** (Backend logic)
- **Intl** (Date handling)

## 📦 Database Schema

### 1. `teachers`
| id | name        | subject  |
|----|-------------|----------|
| 1  | Mr. Saman   | Math     |

### 2. `timetable`
| id | teacher_id | day    | period | grade |
|----|------------|--------|--------|-------|

### 3. `attendance`
| id | teacher_id | date       | is_present |
|----|------------|------------|------------|

### 4. `substitutions`
| id | date       | day    | period | grade | absent_teacher_id | substitute_teacher_id |
|----|------------|--------|--------|-------|--------------------|------------------------|

## 📸 Screenshots
![image](https://github.com/user-attachments/assets/d1d06261-bd58-4072-b4c9-8a38fd387574)
![image](https://github.com/user-attachments/assets/87f01387-dda6-4f7b-9efe-d1ac70aacd2a)
![image](https://github.com/user-attachments/assets/49cca84c-ed1f-4c85-9b4d-54cb5a54ad7f)
![image](https://github.com/user-attachments/assets/febdd088-d529-4986-aa0a-dd06c1c37546)
![image](https://github.com/user-attachments/assets/d445f4c0-9a7c-4566-a6b8-4eecf1a0770c)


