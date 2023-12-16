import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc.dart';
import 'package:plant_app/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticatedState) {
              state.authSuccess(context);
            } else if (state is AuthErrorState) {
              state.showErrorMessage(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sign Up",
                      style: GoogleFonts.manrope(
                          fontSize: 32, fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Do you have an account?",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      SizedBox(width: 4),
                      goLoginPage(context)
                    ],
                  ),
                  SizedBox(height: 36.0),
                  Text("E-mail",
                      style: GoogleFonts.manrope(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 56,
                    child: registerTextFields(
                        controller: _emailController,
                        hintText: 'Enter your email'),
                  ),
                  const SizedBox(height: 16.0),
                  Text("Password",
                      style: GoogleFonts.manrope(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(height: 56, child: passwordTextField()),
                  const SizedBox(height: 24.0),
                  SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: registerButton(context)),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          )),
    );
  }

  GestureDetector goLoginPage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => PasswordVisibilityBloc(),
                    child: const LoginPage(),
                  )),
        );
      },
      child: Text("Sign In",
          style: GoogleFonts.manrope(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green)),
    );
  }

  ElevatedButton registerButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: () {
        context.read<AuthBloc>().add(
            AuthSignUpEvent(_emailController.text, _passwordController.text));
      },
      child: Text('Sign up',
          style: GoogleFonts.manrope(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>
      passwordTextField() {
    return BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
      builder: (context, state) {
        return registerTextFields(
            controller: _passwordController,
            hintText: "Enter your password",
            obscureText: state is PasswordHiddenState,
            suffixIcon: IconButton(
              onPressed: () {
                context
                    .read<PasswordVisibilityBloc>()
                    .add(TogglePasswordVisibilityEvent());
              },
              icon: Icon(state is PasswordHiddenState
                  ? Icons.visibility
                  : Icons.visibility_off),
            ));
      },
    );
  }

  TextField registerTextFields({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    suffixIcon,
  }) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          gapPadding: 3.0,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.black12, width: 2.0),
          gapPadding: 3.0,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
          gapPadding: 3.0,
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
