import 'package:chat/auth_bloc.dart';
import 'package:chat/auth_repo.dart';
import 'package:chat/chat_page.dart';
import 'package:chat/home_page.dart';
import 'package:chat/live_map_page.dart';
import 'package:chat/login_page.dart';
import 'package:chat/register_page.dart';
import 'package:chat/scan_qr_page.dart';
import 'package:chat/show_qr_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
 initialLocation: '/home', // Attempt to go to home
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // If not logged in and trying to access anything other than login, redirect
    final loggingIn = state.uri.toString() == '/login';

    if (!isLoggedIn && !loggingIn) return '/login';
    if (isLoggedIn && loggingIn) return '/home'; // prevent going back to login

    return null; // allow
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (_) => AuthBloc(AuthRepository()),
        child: const LoginPage(),
      ),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final data = state.extra as Map<String, String>;
        return ChatPage(
          currentUser: data['currentUser']!,
          peerUser: data['peerUser']!,
          receiverToken: data['receiverToken']!,
        );
      },
    ),
    GoRoute(path: '/map', builder: (context, state) => const LiveMapPage()),
    GoRoute(path: '/show-qr', builder: (context, state) => const ShowQrPage()),
    GoRoute(path: '/scan-qr', builder: (context, state) => const ScanQrPage()),
  ],
);
