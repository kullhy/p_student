// import 'package:flutter/material.dart';
// import 'package:p_student/view_model/splash_view_model.dart';
// import 'package:provider/provider.dart';

// class SplashPage extends StatelessWidget {
//   const SplashPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<SplashViewModel>(
//       create: (_) => SplashViewModel(),
//       child: const SplashView(),
//     );
//   }
// }

// class SplashView extends StatefulWidget {
//   const SplashView({super.key});

//   @override
//   State<SplashView> createState() => _SplashViewState();
// }

// class _SplashViewState extends State<SplashView> {
//   late SplashViewModel viewModel;

//   @override
//   void initState() {
//     super.initState();
//     viewModel = context.read<SplashViewModel>();
//     viewModel.checkLogin(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text("P-Student"),
//     );
//   }
// }
