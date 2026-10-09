import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'board_page.dart';
import 'join_page.dart';

// Publishable key gizli değildir: uygulamaya gömülür, neyin görüleceğine RLS karar verir.
// Kendi projen için: flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_PUBLISHABLE_KEY=...
const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'https://pkogepiquzktbflmumop.supabase.co',
);
const supabaseKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
  defaultValue: 'sb_publishable_UcifQkKdgQdtJQeFYFUFUQ_vLL2CrBa',
);

Future<void> main() async {
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const SoruPanosuApp());
}

class SoruPanosuApp extends StatelessWidget {
  const SoruPanosuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soru Panosu · Flutter Ankara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF3ECF8E),
        scaffoldBackgroundColor: const Color(0xFFF3F6F4),
      ),
      // Oturum değişince (giriş / çıkış) doğru ekranı göster.
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, _) {
          final session = Supabase.instance.client.auth.currentSession;
          return session == null ? const JoinPage() : const BoardPage();
        },
      ),
    );
  }
}
