import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loginTextFields(controller: _emailController, labelText: 'Email'),
              const SizedBox(height: 16.0),
              passwordTextField(),
              const SizedBox(height: 16.0),
              loginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>
      passwordTextField() {
    return BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
      builder: (context, state) {
        return loginTextFields(
            controller: _passwordController,
            labelText: 'Password',
            obscureText: state is PasswordHiddenState,
            suffixIcon: IconButton(
              icon: Icon(state is PasswordHiddenState
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () => context
                  .read<PasswordVisibilityBloc>()
                  .add(TogglePasswordVisibilityEvent()),
            ));
      },
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(
            AuthSignInEvent(_emailController.text, _passwordController.text));
      },
      child: const Text('Login'),
    );
  }

  TextField loginTextFields({
    required TextEditingController controller,
    required String labelText,
    bool obscureText = false,
    suffixIcon,
  }) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
