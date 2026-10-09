import 'package:flutter/material.dart';

import 'questions_repo.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final _name = TextEditingController();
  bool _busy = false;

  Future<void> _join() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    setState(() => _busy = true);
    try {
      await QuestionsRepo.join(name);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Giriş yapılamadı: $e')));
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('FLUTTER ANKARA',
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: theme.colorScheme.primary, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text('Soru Panosu', style: theme.textTheme.headlineLarge),
                const SizedBox(height: 8),
                Text('Konuşmacıya soru sor. Sorular herkesin ekranına anında düşer.',
                    style: theme.textTheme.bodyLarge),
                const SizedBox(height: 32),
                TextField(
                  controller: _name,
                  autofocus: true,
                  maxLength: 40,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _join(),
                  decoration: const InputDecoration(
                    labelText: 'Adın',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _busy ? null : _join,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(_busy ? 'Katılıyor…' : 'Katıl'),
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
