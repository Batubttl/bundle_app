import 'package:bundle_app/presentation/widgets/close_icon_widget.dart';
import 'package:bundle_app/presentation/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';
import 'forget_password_view_model.dart';
import '../../../services/auth_services.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordViewModel(AuthService()),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Çarpı ikonu
                CloseWidget(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Başlık
                          Text(
                            "Parolanızı mı unuttunuz?",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 16),

                          // Açıklama metni
                          Text(
                            "E-posta adresinizi girin, parolanızı sıfırlamak için kullanacağınız linki içeren bir e-posta göndereceğiz.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  height: 1.5,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),

                          // Form
                          Form(
                            key: viewModel.formKey,
                            child: Column(
                              children: [
                                // E-posta
                                CustomTextFormField(
                                  controller: viewModel.emailController,
                                  hintText: 'E-posta',
                                ),
                                const SizedBox(height: 24),

                                // Şifreyi Sıfırla Butonu
                                CustomButton(
                                  text: viewModel.isLoading
                                      ? 'Gönderiliyor...'
                                      : 'Şifreyi Sıfırla',
                                  onPressed: viewModel.isLoading
                                      ? null
                                      : () => viewModel
                                          .handleForgotPassword(context),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
