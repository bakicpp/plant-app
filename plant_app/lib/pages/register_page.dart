import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/bloc/auth_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc.dart';

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
      appBar: AppBar(
        title: const Text('Register'),
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
              const SizedBox(height: 16.0),
              registerTextFields(
                controller: _emailController,
                labelText: 'Email',
              ),
              passwordTextField(),
              const SizedBox(height: 16.0),
              registerButton(context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<AuthBloc>().add(
            AuthSignUpEvent(_emailController.text, _passwordController.text));
      },
      child: const Text('Register'),
    );
  }

  BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>
      passwordTextField() {
    return BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
      builder: (context, state) {
        return registerTextFields(
            controller: _passwordController,
            labelText: "Password",
            obscureText: state is PasswordHiddenState,
            suffixIcon: IconButton(
              onPressed: () {
                context
                    .read<PasswordVisibilityBloc>()
                    .add(TogglePasswordVisibilityEvent());
              },
              icon: Icon(state is PasswordHiddenState
                  ? Icons.visibility_off
                  : Icons.visibility),
            ));
      },
    );
  }

  TextField registerTextFields({
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
