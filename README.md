# FESTIVAL DO RIO 2026 — Controle de Alimentação

## Arquivos
- `index.html` — app completo (login, cadastro, leitor de QR, histórico)
- `manifest.json` / `sw.js` / `icon-192.png` / `icon-512.png` — deixam o app instalável (PWA)
- `schema.sql` — schema do banco para colar no Supabase

## 1. Criar o banco (Supabase — gratuito)
1. Crie uma conta em https://supabase.com e um novo projeto (plano Free).
2. No painel do projeto, vá em **SQL Editor** → cole todo o conteúdo de `schema.sql` → **Run**.
3. Vá em **Project Settings → API** e copie:
   - `Project URL`
   - `anon public key`
4. Abra `index.html` e edite o topo do `<script>` de configuração:
   ```js
   const CONFIG = {
     SUPABASE_URL: "https://SEU-PROJETO.supabase.co",
     SUPABASE_ANON_KEY: "SUA_CHAVE_ANON_PUBLICA",
     ACCESS_PASSWORD: "escolha-uma-senha-aqui"
   };
   ```

## 2. Publicar gratuitamente

### Opção A — Vercel (mais simples)
1. Crie uma conta grátis em https://vercel.com.
2. Crie um repositório no GitHub com esses arquivos (ou use "Deploy" arrastando a pasta).
3. Em Vercel: **Add New → Project** → importe o repositório → Deploy.
4. Pronto: você recebe uma URL `https://seu-app.vercel.app` com HTTPS (necessário para a câmera funcionar).

### Opção B — GitHub Pages
1. Crie um repositório no GitHub e envie os arquivos (`index.html`, `manifest.json`, `sw.js`, `icon-192.png`, `icon-512.png`).
2. Vá em **Settings → Pages** → Source: `main` branch, pasta `/root` → Save.
3. Aguarde alguns minutos: o app fica em `https://seu-usuario.github.io/seu-repositorio/`.

> A câmera do celular só funciona em HTTPS — tanto Vercel quanto GitHub Pages já entregam isso automaticamente.

## 3. Instalar como app no celular
- **Android (Chrome):** abra o link → menu ⋮ → "Adicionar à tela inicial".
- **iOS (Safari):** abra o link → botão Compartilhar → "Adicionar à Tela de Início".

## 4. Uso no dia a dia
- Cadastro dos funcionários: feito uma vez (pode ser pelo computador).
- Leitura dos QR Codes: pelo celular, aba "Leitor & Almoço".
- Ao final do horário de almoço: toque em "Encerrar almoço do dia" para gerar e salvar o PDF.
