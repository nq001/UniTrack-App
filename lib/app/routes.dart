import 'package:get/get.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/courses/screens/home_screen.dart';
import '../features/courses/screens/add_course_screen.dart';
import '../features/tasks/screens/course_details_screen.dart';
import '../features/tasks/screens/add_task_screen.dart';
import '../features/notes/screens/add_note_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String addCourse = '/add-course';
  static const String courseDetails = '/course-details';
  static const String addTask = '/add-task';
  static const String addNote = '/add-note';

  static final pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: addCourse, page: () => const AddCourseScreen()),
    GetPage(name: courseDetails, page: () => const CourseDetailsScreen()),
    GetPage(name: addTask, page: () => const AddTaskScreen()),
    GetPage(name: addNote, page: () => const AddNoteScreen()),
  ];
}
