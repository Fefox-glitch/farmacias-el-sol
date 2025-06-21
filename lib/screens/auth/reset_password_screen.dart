import 'package:flutter/material.dart';
import '../../providers/provider_locator.dart';
import '../../widgets/loading_indicator.dart';
import '../../utils/helpers.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = ProviderLocator.getAuth(context);

    try {
      await authProvider.resetPassword(_emailController.text.trim());

      if (mounted) {
        AppHelpers.showSuccessSnackBar(
          context,
          'Se ha enviado un correo electrónico con instrucciones para restablecer tu contraseña.',
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        AppHelpers.showErrorSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ProviderLocator.watchAuth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer Contraseña'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ícono
                  const Icon(
                    Icons.lock_reset_outlined,
                    size: 64,
                  ),

                  const SizedBox(height: 32),

                  // Título
                  Text(
                    'Restablecer Contraseña',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Descripción
                  Text(
                    'Ingresa tu correo electrónico y te enviaremos instrucciones para restablecer tu contraseña.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Campo de email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      hintText: 'ejemplo@correo.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa tu correo electrónico';
                      }
                      if (!AppHelpers.isValidEmail(value)) {
                        return 'Por favor, ingresa un correo electrónico válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Botón de enviar
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleResetPassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: authProvider.isLoading
                        ? const LoadingIndicator(
                            color: Colors.white,
                            size: 24,
                          )
                        : const Text('Enviar Instrucciones'),
                  ),

                  const SizedBox(height: 24),

                  // Botón de volver
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Volver al inicio de sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
