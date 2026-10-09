import 'package:flutter/material.dart';

import 'questions_repo.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  final _stream = QuestionsRepo.watch();
  final _input = TextEditingController();
  bool _sending = false;

  /// Geliştirici modu: Sil butonunu herkesin sorusunda gösterir.
  /// Butonu göstermek arayüz davranışıdır; silmeye izin vermek RLS'nin işidir.
  bool _devMode = false;

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await QuestionsRepo.ask(text);
      _input.clear();
    } catch (e) {
      _toast('Gönderilemedi: $e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _delete(String id) async {
    try {
      final ok = await QuestionsRepo.delete(id);
      _toast(ok ? 'Soru silindi.' : '0 satır silindi: RLS izin vermedi.', denied: !ok);
    } catch (e) {
      _toast('Silinemedi: $e', denied: true);
    }
  }

  void _toast(String message, {bool denied = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: denied ? const Color(0xFFB42E2E) : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myId = QuestionsRepo.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Soru Panosu'),
        actions: [
          Text('Geliştirici modu', style: theme.textTheme.bodySmall),
          Switch(value: _devMode, onChanged: (v) => setState(() => _devMode = v)),
          const SizedBox(width: 8),
          Chip(label: Text(QuestionsRepo.currentName)),
          IconButton(
            tooltip: 'Çıkış',
            icon: const Icon(Icons.logout),
            onPressed: QuestionsRepo.leave,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Bağlantı hatası: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final questions = snapshot.data!;
                    if (questions.isEmpty) {
                      return const Center(child: Text('Henüz soru yok. İlk soruyu sen sor!'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: questions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final q = questions[i];
                        final mine = q['user_id'] == myId;
                        return Card(
                          elevation: 0,
                          color: mine ? theme.colorScheme.primaryContainer : Colors.white,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            title: Text(q['content'] as String,
                                style: theme.textTheme.titleMedium),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                  '${q['author_name']} · ${_time(q['created_at'] as String)}'),
                            ),
                            trailing: (mine || _devMode)
                                ? IconButton(
                                    tooltip: 'Sil',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _delete(q['id'] as String),
                                  )
                                : null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        maxLength: 280,
                        minLines: 1,
                        maxLines: 3,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: const InputDecoration(
                          hintText: 'Sorunu yaz…',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FilledButton.icon(
                        onPressed: _sending ? null : _send,
                        icon: const Icon(Icons.send),
                        label: const Text('Gönder'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _time(String iso) {
    final t = DateTime.parse(iso).toLocal();
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
