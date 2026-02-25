#!/bin/bash
set -e

echo "Building Flutter web (HTML renderer)..."
flutter build web --release --web-renderer html --base-href "/" --pwa-strategy=none

echo "Patching flutter_bootstrap.js..."
cd build/web

VERSION=$(grep -oP 'serviceWorkerVersion: "\K[0-9]+' flutter_bootstrap.js || echo "")
if [ -n "$VERSION" ]; then
  sed -i "s/serviceWorkerSettings: {//" flutter_bootstrap.js
  sed -i "s/serviceWorkerVersion: \"$VERSION\"//" flutter_bootstrap.js
  sed -i '/^  }$/d' flutter_bootstrap.js
  sed -i 's/_flutter.loader.load({[[:space:]]*});/_flutter.loader.load();/' flutter_bootstrap.js
fi

dart -e 'import "dart:io"; var f=File("flutter_bootstrap.js"); var c=f.readAsStringSync(); c=c.replaceAll(RegExp(r"_flutter\.loader\.load\(\{\s*\}\);"),"_flutter.loader.load();"); f.writeAsStringSync(c);' 2>/dev/null || true

echo "Writing no-op service worker..."
cat > flutter_service_worker.js << 'SWEOF'
self.addEventListener("install", () => { self.skipWaiting(); });
self.addEventListener("activate", e => {
  e.waitUntil(caches.keys().then(k => Promise.all(k.map(n => caches.delete(n)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", e => { e.respondWith(fetch(e.request)); });
SWEOF

echo "Build complete!"
