# **UniTrack: Offline University Study Tracking Application**

## 2. Abstract

UniTrack is a Flutter-based mobile application designed to help university students organize their academic life by tracking courses, study tasks, notes, and progress. The application follows an offline-first approach, meaning that the main data is stored locally on the device using SQLite through the `sqflite` package. This allows students to continue using the application even without an internet connection.

The application uses `flutter_riverpod` for state management and dependency injection, while `GetX` is used for navigation, dialogs, and snackbars. The `http` package is used to fetch sample tasks from an online API, and the `path` and `path_provider` packages are used to manage local database and backup file paths.

The purpose of UniTrack is to provide a simple, practical, and student-friendly solution for managing academic tasks and notes while demonstrating important Flutter concepts such as local database storage, API integration, state management, routing, and file handling.

---

## 3. Introduction

### 3.1 Introduction

University students usually manage many courses, assignments, notes, and study tasks at the same time. Without a simple organization tool, it becomes difficult to remember what needs to be studied, which tasks are completed, and what notes belong to each course.

UniTrack is developed as a mobile application that helps students track their university courses and academic responsibilities. The app allows students to add courses, create tasks for each course, mark tasks as completed, write notes, import sample tasks from the internet, and export a local backup file.

The project is also designed to demonstrate the use of important Flutter packages, including:

- `GetX`
- `flutter_riverpod`
- `sqflite`
- `http`
- `path`
- `path_provider`

Each package is used for a clear purpose in the project, making the application suitable for academic demonstration and practical learning.

---

### 3.2 Problem Statements

Many students face difficulties in managing their academic work because they depend on scattered tools such as paper notes, phone reminders, screenshots, or chat messages. These methods are not always organized and can cause students to miss tasks or forget important study notes.

The main problems are:

1. Students may forget important study tasks and deadlines.
2. Course notes are often stored in different places and become difficult to find.
3. Some study planner applications require internet access to work properly.
4. Students need a simple app that can work offline.
5. Students need a way to organize courses, tasks, and notes in one place.
6. Students need to track completed and pending tasks easily.

UniTrack solves these problems by providing a local, offline-first study tracking application that stores data on the device and organizes academic information clearly.

---

### 3.3 Project Objectives

The main objective of UniTrack is to develop a mobile application that helps university students organize and track their academic progress.

The specific objectives are:

1. To allow students to create and manage university courses.
2. To allow students to add study tasks for each course.
3. To allow students to mark tasks as completed or pending.
4. To allow students to write and store notes for each course.
5. To store all important data locally using SQLite.
6. To allow the app to work without internet connection.
7. To import sample tasks from an online API using HTTP requests.
8. To export a local JSON backup file.
9. To apply clean Flutter architecture using models, repositories, services, providers, and screens.
10. To demonstrate the use of Riverpod for state management.
11. To demonstrate the use of GetX for navigation and user feedback.
12. To create a simple and user-friendly interface suitable for students.

---

### 3.4 Project Scope and Boundaries

#### Project Scope

The scope of UniTrack includes the following features:

- Course management
- Task management
- Notes management
- Offline local database storage
- Task completion tracking
- Task filtering
- Importing sample tasks from an API
- Exporting local backup data
- Splash screen and simple app branding
- Clean navigation between screens

The application is designed for individual student use. Each user can manage their own courses, tasks, and notes on one device.

#### Project Boundaries

The project has the following boundaries:

1. The application does not include user login or registration.
2. The application does not use cloud storage.
3. The application does not synchronize data across multiple devices.
4. The application does not support real-time collaboration.
5. The application does not send push notifications.
6. The backup file is stored locally on the device only.
7. The API integration is used only for importing sample tasks, not for full online synchronization.

These boundaries keep the project simple, focused, and suitable for a lecture or student project.

---

### 3.5 Project Methodology

The project follows a simple software development methodology based on analysis, design, implementation, testing, and documentation.

#### 1. Requirement Analysis

In this phase, the main needs of students were identified. The required features were selected based on the goal of helping students organize courses, tasks, and notes.

#### 2. System Design

In this phase, the application structure was designed. The system was divided into:

- UI layer
- Provider layer
- Repository layer
- Service layer
- Database layer

The database tables were also designed in this phase.

#### 3. Implementation

In this phase, the Flutter application was built using Dart. The required packages were added and used according to their responsibilities.

#### 4. Testing

The application should be tested by adding courses, tasks, and notes, checking whether the data remains saved after closing the app, importing sample tasks, and exporting backup data.

#### 5. Documentation

The final phase includes writing documentation that explains the project idea, objectives, tools, system design, database structure, and application workflow.

---

### 3.6 Tools and Programming Languages

The following tools and programming languages are used in UniTrack:

| Tool / Language          | Purpose                                            |
| ------------------------ | -------------------------------------------------- |
| Flutter                  | Main framework for building the mobile application |
| Dart                     | Programming language used to write Flutter code    |
| Android Studio / VS Code | Development environment                            |
| GetX                     | Navigation, routes, snackbars, and dialogs         |
| Riverpod                 | State management and dependency injection          |
| sqflite                  | SQLite local database                              |
| http                     | Fetching sample tasks from an online API           |
| path                     | Creating safe file and database paths              |
| path_provider            | Accessing local device directories                 |
| JSON                     | Data format used for API response and backup file  |
| SQLite                   | Local database engine                              |

---

## 4. Background & Related Works

### 4.1 Introduction

This section discusses the background of study tracking applications and related systems. Many students use mobile applications to organize their academic life. These apps usually include task lists, note-taking, reminders, calendar views, and progress tracking.

UniTrack is inspired by the idea of combining course management, task tracking, and notes into one simple mobile application. The project focuses on offline usage and local data storage, which makes it different from applications that depend mainly on cloud services.

---

### 4.2 Background

Academic organization is an important part of student success. Students need to manage many activities such as lectures, assignments, exams, projects, and revision sessions. Mobile applications can help students by giving them a structured way to store and review this information.

In mobile development, offline-first applications are useful because they allow users to access data even without an internet connection. SQLite is commonly used for local storage in mobile apps because it is lightweight and reliable.

Flutter is a suitable framework for this type of application because it allows developers to create beautiful and responsive user interfaces using one codebase. With packages like `sqflite`, `Riverpod`, and `GetX`, Flutter can support database storage, state management, and navigation efficiently.

---

### 4.3 Main Concepts of the Project

The main concepts of UniTrack are:

#### 1. Offline-First Application

The app stores courses, tasks, and notes locally using SQLite. This means the student can use the application even when there is no internet connection.

#### 2. Course Management

The user can create and manage different university courses. Each course has its own tasks and notes.

#### 3. Task Tracking

The user can add tasks, set priority, mark tasks as completed, and filter tasks based on their status.

#### 4. Notes Management

The user can write notes for each course. This helps students keep important information organized.

#### 5. API Integration

The app can import sample tasks from an online API using the `http` package. This demonstrates how the app communicates with external services.

#### 6. Local Backup

The app can export courses, tasks, and notes into a JSON backup file. This demonstrates local file handling using `path` and `path_provider`.

#### 7. State Management

Riverpod is used to manage application state, refresh data, handle loading states, and connect the UI with repositories and services.

#### 8. Navigation

GetX is used to manage named routes and display messages using snackbars and dialogs.

---

### 4.4 Application Work Procedures

The application work procedures describe how the system operates from the user's point of view.

#### Procedure 1: Add a Course

1. The user opens the app.
2. The splash screen appears.
3. The app navigates to the home screen.
4. The user taps the "New Course" button.
5. The user enters the course name.
6. The app saves the course in the SQLite database.
7. The home screen refreshes and displays the new course.

#### Procedure 2: Add a Task

1. The user selects a course.
2. The course details screen opens.
3. The user taps the "Add Task" button.
4. The user enters the task title, description, due date, and priority.
5. The app saves the task in the SQLite database.
6. The task list refreshes and shows the new task.

#### Procedure 3: Mark a Task as Completed

1. The user opens the task list.
2. The user taps the checkbox or completion button.
3. The app updates the task status in SQLite.
4. The UI refreshes and shows the task as completed.

#### Procedure 4: Add a Note

1. The user selects a course.
2. The user opens the notes section.
3. The user taps the "Add Note" button.
4. The user writes a note title and body.
5. The app saves the note in SQLite.
6. The note appears in the course notes section.

#### Procedure 5: Import Sample Tasks

1. The user opens a course.
2. The user taps "Import Sample Tasks".
3. The app sends an HTTP request to the API.
4. The API returns JSON data.
5. The app converts JSON data into task objects.
6. The app saves the tasks into SQLite.
7. The task list refreshes and displays the imported tasks.

#### Procedure 6: Export Backup

1. The user taps the backup button.
2. The app reads courses, tasks, and notes from SQLite.
3. The data is converted into JSON format.
4. The app gets the application documents directory.
5. The app saves the backup file as `unitrack_backup.json`.
6. The app shows a success message with the backup file path.

---

## 5. Analysis & Design

### 5.1 Introduction

System analysis and design are important stages in software development. In this section, the UniTrack system is analyzed based on user needs, system users, functional requirements, non-functional requirements, and use case scenarios.

The design of the system focuses on simplicity, offline access, clean architecture, and clear separation of responsibilities.

---

### 5.2 System Analysis

UniTrack is a mobile application used by university students to organize courses, tasks, and notes. The system stores data locally and provides simple operations for adding, viewing, updating, and deleting academic information.

The system has one main user type: the student. The student interacts with the application through different screens such as the home screen, course details screen, add course screen, add task screen, and add note screen.

---

### 5.2.1 Requirements Gathering

The requirements were gathered by analyzing the common needs of university students and the required technical packages for the project.

The main collected requirements are:

1. Students need to create course records.
2. Students need to add tasks for each course.
3. Students need to mark tasks as completed.
4. Students need to write notes related to courses.
5. Students need to use the app without internet.
6. Students need a simple and clean interface.
7. The app must use a local database.
8. The app must use state management.
9. The app must support navigation between screens.
10. The app must fetch sample data from an API.
11. The app must export a backup file.

---

### 5.2.2 System Users

The main user of the system is the university student.

| User    | Description                                                         | Main Activities                                                                      |
| ------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| Student | A university student who wants to organize academic tasks and notes | Add courses, add tasks, mark tasks completed, add notes, import tasks, export backup |

Since the app is designed for individual use, there is no admin user or multi-user management.

---

### 5.2.3 System Requirements

#### Functional Requirements

Functional requirements describe what the system must do.

| Requirement ID | Requirement                                                            |
| -------------- | ---------------------------------------------------------------------- |
| FR1            | The system shall allow the user to add a course.                       |
| FR2            | The system shall allow the user to view all courses.                   |
| FR3            | The system shall allow the user to delete a course.                    |
| FR4            | The system shall allow the user to add tasks to a course.              |
| FR5            | The system shall allow the user to view tasks by course.               |
| FR6            | The system shall allow the user to mark tasks as completed or pending. |
| FR7            | The system shall allow the user to delete tasks.                       |
| FR8            | The system shall allow the user to filter tasks by status.             |
| FR9            | The system shall allow the user to add notes to a course.              |
| FR10           | The system shall allow the user to view notes by course.               |
| FR11           | The system shall allow the user to delete notes.                       |
| FR12           | The system shall allow the user to import sample tasks from an API.    |
| FR13           | The system shall save all courses, tasks, and notes locally.           |
| FR14           | The system shall allow the user to export a backup file.               |
| FR15           | The system shall display success and error messages.                   |

#### Non-Functional Requirements

Non-functional requirements describe how the system should perform.

| Requirement ID | Requirement                                                       |
| -------------- | ----------------------------------------------------------------- |
| NFR1           | The application should be easy to use.                            |
| NFR2           | The application should have a clean and simple user interface.    |
| NFR3           | The application should work offline.                              |
| NFR4           | The application should save data reliably.                        |
| NFR5           | The application should respond quickly to user actions.           |
| NFR6           | The application should handle errors clearly.                     |
| NFR7           | The application should be maintainable and organized.             |
| NFR8           | The application should run on Android and can be extended to iOS. |

#### Hardware Requirements

| Requirement | Description                                       |
| ----------- | ------------------------------------------------- |
| Smartphone  | Android phone or emulator                         |
| Storage     | Enough local storage for database and backup file |
| Internet    | Required only for importing sample tasks          |

#### Software Requirements

| Requirement                | Description                  |
| -------------------------- | ---------------------------- |
| Flutter SDK                | Required to build the app    |
| Dart SDK                   | Required for programming     |
| Android Studio or VS Code  | Required for development     |
| Android Emulator or Device | Required for testing         |
| SQLite                     | Used through sqflite package |

---

### 5.2.4 Use Case Scenario

#### Use Case 1: Add Course

| Item          | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| Use Case Name | Add Course                                                      |
| Actor         | Student                                                         |
| Precondition  | The app is installed and opened                                 |
| Main Flow     | Student taps New Course, enters course name, and saves it       |
| Postcondition | The course is stored in SQLite and displayed on the home screen |

#### Use Case 2: Add Task

| Item          | Description                                                                       |
| ------------- | --------------------------------------------------------------------------------- |
| Use Case Name | Add Task                                                                          |
| Actor         | Student                                                                           |
| Precondition  | At least one course exists                                                        |
| Main Flow     | Student opens course details, taps Add Task, fills task information, and saves it |
| Postcondition | The task is stored and displayed under the selected course                        |

#### Use Case 3: Complete Task

| Item          | Description                               |
| ------------- | ----------------------------------------- |
| Use Case Name | Complete Task                             |
| Actor         | Student                                   |
| Precondition  | A task exists                             |
| Main Flow     | Student taps the task completion checkbox |
| Postcondition | The task status changes to completed      |

#### Use Case 4: Add Note

| Item          | Description                                                                                           |
| ------------- | ----------------------------------------------------------------------------------------------------- |
| Use Case Name | Add Note                                                                                              |
| Actor         | Student                                                                                               |
| Precondition  | At least one course exists                                                                            |
| Main Flow     | Student opens course details, selects notes section, taps Add Note, writes note content, and saves it |
| Postcondition | The note is stored and displayed under the selected course                                            |

#### Use Case 5: Import Sample Tasks

| Item          | Description                                                                          |
| ------------- | ------------------------------------------------------------------------------------ |
| Use Case Name | Import Sample Tasks                                                                  |
| Actor         | Student                                                                              |
| Precondition  | Internet connection is available and a course is selected                            |
| Main Flow     | Student taps Import Sample Tasks, app fetches tasks from API, and saves them locally |
| Postcondition | Imported tasks are displayed in the selected course                                  |

#### Use Case 6: Export Backup

| Item          | Description                                                                   |
| ------------- | ----------------------------------------------------------------------------- |
| Use Case Name | Export Backup                                                                 |
| Actor         | Student                                                                       |
| Precondition  | Data exists in the app                                                        |
| Main Flow     | Student taps Export Backup, app converts data to JSON, and saves a local file |
| Postcondition | Backup file is created in the application documents directory                 |

---

## 6. Details of the Database Tables

UniTrack uses a local SQLite database to store the main data. The recommended database name is:

```text
unitrack.db
```

The database contains three main tables:

1. `courses`
2. `tasks`
3. `notes`

---

### 6.1 Courses Table

The `courses` table stores university course information.

#### Table Name

```text
courses
```

#### Purpose

This table stores each course created by the student.

#### Columns

| Column Name | Data Type | Constraint                | Description                               |
| ----------- | --------- | ------------------------- | ----------------------------------------- |
| id          | INTEGER   | PRIMARY KEY AUTOINCREMENT | Unique course ID                          |
| name        | TEXT      | NOT NULL                  | Course name                               |
| created_at  | TEXT      | NOT NULL                  | Date and time when the course was created |

#### SQL Statement

```sql
CREATE TABLE courses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

#### Example Data

| id  | name                   | created_at          |
| --- | ---------------------- | ------------------- |
| 1   | Mobile App Development | 2026-04-20T10:30:00 |
| 2   | Database Systems       | 2026-04-20T11:00:00 |

---

### 6.2 Tasks Table

The `tasks` table stores study tasks related to each course.

#### Table Name

```text
tasks
```

#### Purpose

This table stores the tasks that the student must complete for each course.

#### Columns

| Column Name  | Data Type | Constraint                | Description                             |
| ------------ | --------- | ------------------------- | --------------------------------------- |
| id           | INTEGER   | PRIMARY KEY AUTOINCREMENT | Unique task ID                          |
| course_id    | INTEGER   | NOT NULL, FOREIGN KEY     | ID of the related course                |
| title        | TEXT      | NOT NULL                  | Task title                              |
| description  | TEXT      | NULL                      | Optional task description               |
| due_date     | TEXT      | NULL                      | Optional task due date                  |
| priority     | TEXT      | NOT NULL                  | Task priority: low, medium, high        |
| is_completed | INTEGER   | NOT NULL DEFAULT 0        | Task status: 0 = pending, 1 = completed |
| created_at   | TEXT      | NOT NULL                  | Date and time when the task was created |

#### SQL Statement

```sql
CREATE TABLE tasks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  course_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  due_date TEXT,
  priority TEXT NOT NULL,
  is_completed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
);
```

#### Example Data

| id  | course_id | title            | description                    | due_date   | priority | is_completed | created_at          |
| --- | --------- | ---------------- | ------------------------------ | ---------- | -------- | ------------ | ------------------- |
| 1   | 1         | Study GetX       | Learn navigation and snackbars | 2026-04-22 | high     | 0            | 2026-04-20T12:00:00 |
| 2   | 1         | Practice sqflite | Create CRUD operations         | 2026-04-23 | high     | 1            | 2026-04-20T12:20:00 |
| 3   | 2         | Review ERD       | Study database relationships   | 2026-04-24 | medium   | 0            | 2026-04-20T12:40:00 |

---

### 6.3 Notes Table

The `notes` table stores course notes.

#### Table Name

```text
notes
```

#### Purpose

This table stores notes written by the student for each course.

#### Columns

| Column Name | Data Type | Constraint                | Description                             |
| ----------- | --------- | ------------------------- | --------------------------------------- |
| id          | INTEGER   | PRIMARY KEY AUTOINCREMENT | Unique note ID                          |
| course_id   | INTEGER   | NOT NULL, FOREIGN KEY     | ID of the related course                |
| title       | TEXT      | NOT NULL                  | Note title                              |
| body        | TEXT      | NOT NULL                  | Main note content                       |
| created_at  | TEXT      | NOT NULL                  | Date and time when the note was created |

#### SQL Statement

```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  course_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE
);
```

#### Example Data

| id  | course_id | title         | body                                                            | created_at          |
| --- | --------- | ------------- | --------------------------------------------------------------- | ------------------- |
| 1   | 1         | Riverpod Note | Riverpod is used for state management and dependency injection. | 2026-04-20T13:00:00 |
| 2   | 1         | GetX Note     | GetX is used for navigation, snackbars, and dialogs.            | 2026-04-20T13:15:00 |
| 3   | 2         | SQLite Note   | SQLite is used to store data locally on the device.             | 2026-04-20T13:30:00 |

---

### 6.4 Database Relationships

The database has one-to-many relationships.

#### Relationship 1: Course to Tasks

One course can have many tasks.

```text
courses.id  --->  tasks.course_id
```

Example:

One course named `Mobile App Development` can have many tasks such as:

- Study GetX
- Practice sqflite
- Learn Riverpod

#### Relationship 2: Course to Notes

One course can have many notes.

```text
courses.id  --->  notes.course_id
```

Example:

One course named `Database Systems` can have many notes related to database concepts.

---

### 6.5 Cascade Delete

The database uses `ON DELETE CASCADE`.

This means that if a course is deleted, all tasks and notes related to that course should also be deleted automatically.

Example:

If the user deletes:

```text
Mobile App Development
```

Then the related tasks and notes should also be removed.

This keeps the database clean and prevents unused records.

---

### 6.6 Database Summary

| Table   | Purpose                      | Relationship     |
| ------- | ---------------------------- | ---------------- |
| courses | Stores course information    | Parent table     |
| tasks   | Stores tasks for each course | Child of courses |
| notes   | Stores notes for each course | Child of courses |

The database design is simple, organized, and suitable for an offline-first student planner application.
