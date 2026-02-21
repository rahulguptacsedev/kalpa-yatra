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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/admin/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminShell(),
      },
    );
  }
}
