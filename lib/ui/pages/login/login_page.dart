import 'package:flutter/material.dart';
import 'package:p_student/ui/pages/login/login_view_model.dart';
import 'package:p_student/ui/widgets/gradient_button.dart';
import 'package:p_student/ui/widgets/login_field.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: const LoginView(
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final _viewModel = context.read<LoginViewModel>();

  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController passEditingController = TextEditingController();

  Future<void> login() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://p-care-e73a4-default-rtdb.firebaseio.com/account.json'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/signin_balls.png'),
              const Text(
                'ĐĂNG NHẬP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'or',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Tài khoản',
                textEditingController: userNameEditingController,
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Mật khẩu',
                textEditingController: passEditingController,
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'login',
                onPressed:(){
                   _viewModel.checkLogin(username: userNameEditingController.text,password: passEditingController.text,context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
