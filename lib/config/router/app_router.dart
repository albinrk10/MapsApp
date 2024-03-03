import 'package:go_router/go_router.dart';
import '../../presentation/screens/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    ///* Auth Routes
    GoRoute(
      path: '/gps_access',
      builder: (context, state) =>  const GpsAccessScreen(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) =>  const LoadingScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) =>  const MapScreen(),
    ),
    GoRoute(
      path: '/test_marker',
      builder: (context, state) =>  const TestMarkerScreen(),
    ),
  ],
);
