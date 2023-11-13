// import 'package:flutter/material.dart';

// import 'package:go_router/go_router.dart';
// import 'package:p_student/ui/pages/login_screen.dart';
// import 'package:p_student/ui/pages/splash_screen.dart';

// class AppRouter {
//   AppRouter._();
//   static final navigationKey = GlobalKey<NavigatorState>();
//   static final GoRouter router = GoRouter(
//     routes: _routes,
//     debugLogDiagnostics: true,
//     navigatorKey: navigationKey,
//   );

//   ///main page
//   static const String splash = "/";
//   static const String onBoarding = "onBoarding";
//   static const String main = "main";
//   static const String login = "Login";
//   static const String signUp = "SignUp";
//   static const String signUpSuccessful = "signUpSuccessful";
//   static const String detailCategory = "detailCategory";
//   static const String product = "product";
//   static const String cart = "cart";
//   static const String noti = "noti";
//   static const String error = "error";

//   // GoRouter configuration
//   static final _routes = <RouteBase>[
//     GoRoute(path: splash, builder: (context, state) => const SplashPage()),
//     //   GoRoute(
//     //     name: main,
//     //     path: "/$main",
//     //     builder: (context, state) => const MainPage(),
//     //   ),
//     GoRoute(
//       name: login,
//       path: "/$login",
//       builder: (context, state) => const LoginPage(),
//     ),
//     //   GoRoute(
//     //     name: signUp,
//     //     path: "/$signUp",
//     //     builder: (context, state) => const SignUpPage(),
//     //   ),
//     //   GoRoute(
//     //     name: onBoarding,
//     //     path: "/$onBoarding",
//     //     builder: (context, state) => const OnBoardingPage(),
//     //     pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//     //       context: context,
//     //       state: state,
//     //       child: const OnBoardingPage(),
//     //     ),
//     //   ),
//     //   GoRoute(
//     //     name: signUpSuccessful,
//     //     path: "/$signUpSuccessful",
//     //     builder: (context, state) => const SuccessfulPage(),
//     //     pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//     //       context: context,
//     //       state: state,
//     //       child: const SuccessfulPage(),
//     //     ),
//     //   ),
//     //   GoRoute(
//     //     name: detailCategory,
//     //     path: "/$detailCategory",
//     //     builder: (context, state) {
//     //       DetailCategory detailCategory = state.extra as DetailCategory;
//     //       return DetailCategoryPage(
//     //         detailCategory: detailCategory,
//     //       );
//     //     },
//     //   ),
//     //   GoRoute(
//     //     name: product,
//     //     path: "/$product",
//     //     builder: (context, state) {
//     //       Map<String, dynamic> data = state.extra as Map<String, dynamic>;

//     //       Product product = data['product'] as Product;
//     //       ProductCart productCart = data['productCart'] as ProductCart;
//     //       return DetailProductPage(
//     //         product: product,
//     //         productCart: productCart,
//     //       );
//     //     },
//     //   ),
//     //   GoRoute(
//     //     name: cart,
//     //     path: "/$cart",
//     //     builder: (context, state) => const CartPage(),
//     //     pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
//     //       context: context,
//     //       state: state,
//     //       child: const CartPage(),
//     //     ),
//     //   ),
//     //   GoRoute(
//     //     name: noti,
//     //     path: "/$noti",
//     //     builder: (context, state) => const NotiPage(),
//     //   ),
//     //   GoRoute(
//     //       name: error,
//     //       path: "/$error",
//     //       builder: (context, state) {
//     //         return const ErrorPage();
//     //       }),
//   ];
// }

// CustomTransitionPage buildPageWithDefaultTransition<T>({
//   required BuildContext context,
//   required GoRouterState state,
//   required Widget child,
// }) {
//   return CustomTransitionPage<T>(
//     transitionDuration: const Duration(milliseconds: 500),
//     key: state.pageKey,
//     child: child,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: const Offset(-1, 0),
//           end: Offset.zero,
//         ).animate(animation),
//         child: child,
//       );
//     },
//   );
// }
