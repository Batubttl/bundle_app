import 'package:bundle_app/core/theme/app_texts.dart';
import 'package:bundle_app/presentation/views/auth/login_view_model.dart';
import 'package:bundle_app/presentation/widgets/close_icon_widget.dart';
import 'package:bundle_app/presentation/widgets/custom_button.dart';
import 'package:bundle_app/presentation/widgets/custom_text_form.dart';
import 'package:bundle_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  // StatefulWidget'tan StatelessWidget'a çevirdik
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(AuthService()),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    // Çarpı ikonu
                    const CloseWidget(),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            // Başlık
                            Text(
                              LoginViewModel.titleText,
                              style: AppTextStyles.h1.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Form
                            _buildLoginForm(context, viewModel),

                            // Parolanızı mı unuttunuz?
                            const SizedBox(height: 16),
                            _buildForgotPasswordButton(context, viewModel),

                            const Spacer(),

                            // Hesabınız mı yok?
                            _buildSignUpButton(context, viewModel),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: viewModel.emailController,
            hintText: LoginViewModel.emailHint,
            validator: viewModel.validateEmail,
          ),
          CustomTextFormField(
            controller: viewModel.passwordController,
            hintText: LoginViewModel.passwordHint,
            isPassword: true,
            validator: viewModel.validatePassword,
          ),
          if (viewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                viewModel.errorMessage!,
                style: AppTextStyles.caption.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 24),
          CustomButton(
            text: viewModel.isLoading
                ? LoginViewModel.loadingText
                : LoginViewModel.loginButtonText,
            onPressed: viewModel.isLoading
                ? null
                : () => viewModel.handleLogin(context),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordButton(
      BuildContext context, LoginViewModel viewModel) {
    return TextButton(
      onPressed: () => viewModel.navigateToForgotPassword(context),
      child: Text(
        LoginViewModel.forgotPasswordText,
        style: AppTextStyles.body.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, LoginViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: TextButton(
        onPressed: () => viewModel.navigateToSignUp(context),
        child: Text.rich(
          viewModel.signUpTextSpan,
          style: AppTextStyles.body.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
