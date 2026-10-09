import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase ile konuşan her şey bu dosyada.
class QuestionsRepo {
  static final _db = Supabase.instance.client;

  static User? get currentUser => _db.auth.currentUser;

  static String get currentName =>
      (currentUser?.userMetadata?['name'] as String?) ?? 'Anonim';

  /// Auth: e-posta yok, sadece isim. Her tarayıcı ayrı bir anonim kullanıcı olur.
  static Future<void> join(String name) =>
      _db.auth.signInAnonymously(data: {'name': name});

  static Future<void> leave() => _db.auth.signOut();

  /// Realtime: önce mevcut soruları getirir, sonra her değişiklikte listeyi günceller.
  /// Tablonun supabase_realtime yayınında olması gerekir (migration'da var).
  static Stream<List<Map<String, dynamic>>> watch() => _db
      .from('questions')
      .stream(primaryKey: ['id'])
      .order('created_at', ascending: false)
      .limit(100);

  /// user_id veritabanında auth.uid() ile dolar; RLS başkası adına eklemeyi reddeder.
  static Future<void> ask(String content) => _db
      .from('questions')
      .insert({'author_name': currentName, 'content': content});

  /// RLS izin vermezse hata gelmez, 0 satır silinir. Bu yüzden sonucu kontrol ediyoruz.
  static Future<bool> delete(String id) async {
    final deleted = await _db.from('questions').delete().eq('id', id).select();
    return deleted.isNotEmpty;
  }
}
