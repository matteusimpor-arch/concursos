create extension if not exists pgcrypto;

create table if not exists public.concursos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  orgao text not null,
  cargo text not null,
  banca text,
  situacao text not null default 'Inscrito',
  prova date,
  inscricao_fim date,
  prioridade text not null default 'Média',
  progresso integer not null default 0 check (progresso between 0 and 100),
  observacoes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.concursos enable row level security;
create policy "Usuário lê os próprios concursos" on public.concursos for select to authenticated using (auth.uid() = user_id);
create policy "Usuário cria os próprios concursos" on public.concursos for insert to authenticated with check (auth.uid() = user_id);
create policy "Usuário atualiza os próprios concursos" on public.concursos for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "Usuário exclui os próprios concursos" on public.concursos for delete to authenticated using (auth.uid() = user_id);
