import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:plant_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:plant_app/bloc/auth_bloc/auth_event.dart';
import 'package:plant_app/bloc/auth_bloc/auth_state.dart';
import 'package:plant_app/bloc/password_visibility_bloc/password_visibility_bloc.dart';
import 'package:plant_app/bloc/password_visibility_bloc/password_visibility_event.dart';
import 'package:plant_app/bloc/password_visibility_bloc/password_visibility_state.dart';
import 'package:plant_app/pages/register_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    double pageHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(200.0),
          child: AppBar(
              flexibleSpace: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(200),
                bottomRight: Radius.circular(200),
              ),
              image: DecorationImage(
                  image: AssetImage("assets/images/login_image.jpg"),
                  fit: BoxFit.cover),
            ),
          ))),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticatedState) {
            state.authSuccess(context);
          } else if (state is AuthErrorState) {
            state.showErrorMessage(context);
          }
        },
        child: pageView(context, pageHeight),
      ),
    );
  }

  Padding pageView(BuildContext context, double pageHeight) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.sign_in,
                style: GoogleFonts.manrope(
                    fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(
              height: pageHeight / 50,
            ),
            Text(AppLocalizations.of(context)!.email,
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: pageHeight / 50,
            ),
            SizedBox(
              height: 56,
              child: loginTextFields(
                controller: _emailController,
                hintText: AppLocalizations.of(context)!.enter_email,
              ),
            ),
            SizedBox(
              height: pageHeight / 50,
            ),
            Text(AppLocalizations.of(context)!.password,
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(height: 56, child: passwordTextField()),
            const SizedBox(height: 24.0),
            SizedBox(
                width: double.infinity,
                height: 56,
                child: loginButton(context)),
            SizedBox(
              height: pageHeight / 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.dont_have_account,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(width: 4),
                goRegisterPage(context)
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector goRegisterPage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: BlocProvider(
                  create: (context) => PasswordVisibilityBloc(),
                  child: const RegisterPage(),
                ),
                type: PageTransitionType.leftToRightWithFade));
      },
      child: Text(AppLocalizations.of(context)!.sign_up,
          style: GoogleFonts.manrope(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green)),
    );
  }

  BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>
      passwordTextField() {
    return BlocBuilder<PasswordVisibilityBloc, PasswordVisibilityState>(
      builder: (context, state) {
        return loginTextFields(
            controller: _passwordController,
            hintText: AppLocalizations.of(context)!.enter_password,
            obscureText: state is PasswordHiddenState,
            suffixIcon: IconButton(
              icon: Icon(
                state is PasswordHiddenState
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () => context
                  .read<PasswordVisibilityBloc>()
                  .add(TogglePasswordVisibilityEvent()),
            ));
      },
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      onPressed: () {
        context.read<AuthBloc>().add(
            AuthSignInEvent(_emailController.text, _passwordController.text));
      },
      child: Text(AppLocalizations.of(context)!.sign_in,
          style: GoogleFonts.manrope(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  TextField loginTextFields({
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
