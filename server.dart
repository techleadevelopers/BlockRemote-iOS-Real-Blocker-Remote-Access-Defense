import 'dart:io';

void main() async {
  final server = await HttpServer.bind('0.0.0.0', 5000);
  print('BlockRemote server running on http://0.0.0.0:5000');

  await for (final request in server) {
    var path = request.uri.path;
    if (path == '/') path = '/index.html';

    final file = File('build/web$path');
    if (await file.exists()) {
      final ext = path.split('.').last;
      final contentType = _mimeType(ext);
      request.response.headers.set('Content-Type', contentType);
      request.response.headers.set('Cache-Control', 'no-cache');
      await request.response.addStream(file.openRead());
    } else {
      final indexFile = File('build/web/index.html');
      request.response.headers.set('Content-Type', 'text/html');
      await request.response.addStream(indexFile.openRead());
    }
    await request.response.close();
  }
}

String _mimeType(String ext) {
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
    default:
      return 'application/octet-stream';
  }
}
