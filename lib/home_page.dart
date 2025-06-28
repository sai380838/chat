import 'package:chat/auth_repo.dart';
import 'package:chat/user_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final u = await AuthRepository().getUser();
    setState(() => user = u);
  }

  void _logout() async {
    await AuthRepository().logout();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('chat'.tr()),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${user!.displayName} (${user!.email})',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: Text('chat'.tr()),
              onPressed: () {
                // Hardcoded peer for now
                context.go(
                  '/chat',
                  extra: {
                    'currentUser': user!.email,
                    'peerUser':
                        'peer@example.com', // update this dynamically later
                    "receiverToken": "",
                  },
                );
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: Text('map'.tr()),
              onPressed: () => context.go('/map'),
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_2),
              label: Text('show_qr'.tr()),
              onPressed: () => context.go('/show-qr'),
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: Text('scan_qr'.tr()),
              onPressed: () => context.go('/scan-qr'),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => context.setLocale(const Locale('en')),
                  child: const Text("English"),
                ),
                TextButton(
                  onPressed: () => context.setLocale(const Locale('ar')),
                  child: const Text("العربية"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
