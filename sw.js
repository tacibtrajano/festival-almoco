// Service Worker mínimo — cacheia o "app shell" para permitir instalação
// e uma abertura básica offline. Os dados (Supabase) sempre exigem rede.
const CACHE_NAME = "fr2026-almoco-v1";
const APP_SHELL = ["./index.html", "./manifest.json", "./icon-192.png", "./icon-512.png"];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  // Network-first para tudo (o app depende de dados ao vivo do Supabase);
  // cai para cache só se a rede falhar (ex.: abrir o app sem internet).
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );
});
