import 'package:admin_dashboard/router/dashboard_handler.dart';
import 'package:fluro/fluro.dart';
import 'package:admin_dashboard/router/no_page_found_handlers.dart';
import 'package:admin_dashboard/router/admin_handlers.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  static String rootRoute = '/';

  // Auth Router
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';

  // Auth Dashboard
  static String asignaturaRoute = '/dashboard/asignaturas';
  static String asignarRoute = '/dashboard/asignar';
  static String blankRoute = '/dashboard/blank';
  static String cursoRoute = '/dashboard/curso';
  static String categoryRoute = '/dashboard/categories';
  static String dashboardRoute = '/dashboard';
  static String profesorRoute = '/dashboard/profesores';
  static String profesorCursoRoute = '/dashboard/profesores/curso';
  static String iconsRoute = '/dashboard/icons';
  static String usersRoute = '/dashboard/users';
  static String userRoute = '/dashboard/users/:uid';

  static void configureRoutes() {
    // Auth Router
    router.define(rootRoute, handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(loginRoute, handler: AdminHandlers.login, transitionType: TransitionType.none);
    router.define(registerRoute, handler: AdminHandlers.register, transitionType: TransitionType.none);

    // Dashboard Route
    router.define(asignaturaRoute, handler: DashboardHandlers.asignatura, transitionType: TransitionType.fadeIn);
    router.define(blankRoute, handler: DashboardHandlers.blank, transitionType: TransitionType.fadeIn);
    router.define(categoryRoute, handler: DashboardHandlers.category, transitionType: TransitionType.fadeIn);
    router.define(cursoRoute, handler: DashboardHandlers.cursoEstado, transitionType: TransitionType.fadeIn);
    router.define(dashboardRoute, handler: DashboardHandlers.dashboard, transitionType: TransitionType.fadeIn);
    router.define(iconsRoute, handler: DashboardHandlers.icons, transitionType: TransitionType.fadeIn);
    router.define(asignarRoute, handler: DashboardHandlers.asignar, transitionType: TransitionType.fadeIn);
    router.define(profesorRoute, handler: DashboardHandlers.profesor, transitionType: TransitionType.fadeIn);
    router.define(profesorCursoRoute, handler: DashboardHandlers.profesorCurso, transitionType: TransitionType.fadeIn);
    // users
    router.define(usersRoute, handler: DashboardHandlers.users, transitionType: TransitionType.fadeIn);
    router.define(userRoute, handler: DashboardHandlers.user, transitionType: TransitionType.fadeIn);
    // 404
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}
