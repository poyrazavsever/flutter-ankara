-- Flutter Ankara Soru Panosu: questions tablosu, RLS ve Realtime

create table public.questions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  author_name text not null,
  content     text not null check (char_length(content) between 1 and 280),
  created_at  timestamptz not null default now()
);

create index questions_created_at_idx on public.questions (created_at desc);
create index questions_user_id_idx on public.questions (user_id);

-- Erişim kuralları veritabanında: istemci ne gönderirse göndersin bunlar geçerli.
alter table public.questions enable row level security;

-- 1) Giriş yapan kullanıcılar soruları okuyabilir.
create policy "Authenticated users can read questions"
  on public.questions for select
  to authenticated
  using (true);

-- 2) Kullanıcı yalnızca kendi kimliğiyle soru ekleyebilir.
create policy "Users can insert their own questions"
  on public.questions for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

-- 3) Kullanıcı yalnızca kendi sorusunu silebilir.
create policy "Users can delete their own questions"
  on public.questions for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- Güncelleme politikası yok: sorular düzenlenemez.

-- Realtime: yeni ve silinen sorular açık ekranlara ulaşsın.
alter publication supabase_realtime add table public.questions;
