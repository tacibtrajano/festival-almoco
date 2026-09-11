-- =========================================================
-- FESTIVAL DO RIO 2026 - CONTROLE ALIMENTAÇÃO
-- Schema para Supabase (Postgres) — cole no SQL Editor do
-- seu projeto Supabase e rode uma vez.
-- =========================================================

create extension if not exists "pgcrypto";

-- 1) FUNCIONÁRIOS CADASTRADOS -------------------------------------------
create table if not exists funcionarios (
  id uuid primary key default gen_random_uuid(),
  nome_completo text not null,
  setor text not null,
  criado_em timestamptz not null default now()
);

-- 2) REGISTROS DE ALMOÇO (um por refeição servida) ----------------------
create table if not exists registros_almoco (
  id uuid primary key default gen_random_uuid(),
  funcionario_id uuid references funcionarios(id) on delete set null,
  nome_completo text not null,
  setor text not null,
  tipo text not null check (tipo in ('funcionario','convidado')),
  data date not null default current_date,
  hora time not null default current_time,
  criado_em timestamptz not null default now()
);

create index if not exists idx_registros_data on registros_almoco (data);
create index if not exists idx_registros_funcionario_data on registros_almoco (funcionario_id, data);

-- 3) HISTÓRICO DE RELATÓRIOS PDF GERADOS ---------------------------------
create table if not exists relatorios (
  id uuid primary key default gen_random_uuid(),
  data date not null unique,
  nome_arquivo text not null,
  url text not null,
  total_funcionarios int not null default 0,
  total_convidados int not null default 0,
  total_geral int not null default 0,
  criado_em timestamptz not null default now()
);

-- =========================================================
-- ROW LEVEL SECURITY
-- O app usa uma senha própria (não Supabase Auth), então o
-- acesso ao banco acontece com a chave "anon". Habilitamos RLS
-- e liberamos operações via policies — a senha do app é a
-- única barreira. Se quiser mais segurança, troque para
-- Supabase Auth depois.
-- =========================================================
alter table funcionarios enable row level security;
alter table registros_almoco enable row level security;
alter table relatorios enable row level security;

create policy "anon full access - funcionarios" on funcionarios
  for all using (true) with check (true);

create policy "anon full access - registros_almoco" on registros_almoco
  for all using (true) with check (true);

create policy "anon full access - relatorios" on relatorios
  for all using (true) with check (true);

-- =========================================================
-- STORAGE: bucket público para os PDFs gerados
-- =========================================================
insert into storage.buckets (id, name, public)
values ('relatorios-pdf', 'relatorios-pdf', true)
on conflict (id) do nothing;

create policy "leitura publica relatorios-pdf" on storage.objects
  for select using (bucket_id = 'relatorios-pdf');

create policy "upload anon relatorios-pdf" on storage.objects
  for insert with check (bucket_id = 'relatorios-pdf');

create policy "update anon relatorios-pdf" on storage.objects
  for update using (bucket_id = 'relatorios-pdf');
