import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/post/home_screen.dart';
import 'screens/post/post_detail_screen.dart';
import 'screens/post/edit_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const BlogApp());
}

class BlogApp extends StatelessWidget {
  const BlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService()..checkAuth(),   // auto-login if token cached
        ),
        // More providers (e.g. PostService) can be added here
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'Blog App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              useMaterial3: true,
            ),
            initialRoute: '/',
            routes: {
              '/':      (_) => const SplashScreen(),
              '/login': (_) => const LoginScreen(),
              '/signup':(_) => const SignUpScreen(),
              '/home':  (_) => const HomeScreen(),
            },
            onGenerateRoute: (settings) {
              // Dynamic routes for detail/edit screens
              if (settings.name == PostDetailScreen.routeName) {
                final postId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (_) => PostDetailScreen(postId: postId),
                );
              }
              if (settings.name == EditPostScreen.routeName) {
                final postId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (_) => EditPostScreen(postId: postId),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
