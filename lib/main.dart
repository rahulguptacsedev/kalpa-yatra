import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/providers/client_config_provider.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/admin/pages/login_page.dart';
import 'presentation/admin/pages/admin_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: TravelApp()));
}

class TravelApp extends ConsumerWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(clientConfigProvider);

    return MaterialApp(
      title: config.clientName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildTheme(config),
      onGenerateRoute: (settings) {
        // Any path starting with /p/ (e.g. /p/client_a) should load the home page.
        // The TenantResolver will handle the actual data switching.
        final path = settings.name ?? '/';
        if (path.startsWith('/p/')) {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }

        // Conventional routes
        switch (path) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/admin/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/admin':
            return MaterialPageRoute(builder: (_) => const AdminShell());
          default:
            return MaterialPageRoute(builder: (_) => const HomePage());
        }
      },
    );
  }
}
