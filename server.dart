import 'dart:io';

void main() async {
  final webDir = Directory('build/web');
  if (!await webDir.exists()) {
    print('Error: build/web directory not found. Run flutter build web first.');
    exit(1);
  }

  final server = await HttpServer.bind(
    InternetAddress.anyIPv6,
    5000,
  );
  print('Serving Bilingui-AI at http://0.0.0.0:5000');

  await for (final request in server) {
    try {
      var path = request.uri.path;
      if (path == '/') path = '/index.html';

      final file = File('build/web$path');
      if (await file.exists()) {
        final ext = path.split('.').last;
        final contentType = _getContentType(ext);
        request.response.headers.set('Content-Type', contentType);
        request.response.headers.set('Cache-Control', 'no-store, no-cache, must-revalidate');
        request.response.headers.set('Pragma', 'no-cache');
        request.response.headers.set('Expires', '0');
        await request.response.addStream(file.openRead());
      } else {
        final indexFile = File('build/web/index.html');
        request.response.headers.set('Content-Type', 'text/html');
        request.response.headers.set('Cache-Control', 'no-store');
        await request.response.addStream(indexFile.openRead());
      }
      await request.response.close();
    } catch (e) {
      print('Error: $e');
      try {
        request.response.statusCode = 500;
        await request.response.close();
      } catch (_) {}
    }
  }
}

String _getContentType(String ext) {
  switch (ext) {
    case 'html':
      return 'text/html';
    case 'js':
      return 'application/javascript';
    case 'css':
      return 'text/css';
    case 'json':
      return 'application/json';
    case 'png':
      return 'image/png';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'svg':
      return 'image/svg+xml';
    case 'ico':
      return 'image/x-icon';
    case 'woff':
      return 'font/woff';
    case 'woff2':
      return 'font/woff2';
    case 'ttf':
      return 'font/ttf';
    case 'otf':
      return 'font/otf';
    case 'wasm':
      return 'application/wasm';
    default:
      return 'application/octet-stream';
  }
}
