import 'dart:io' as io;

Future apiRequest(io.HttpRequest request, String path, dynamic config) async 
{
  request.response.headers.contentType = io.ContentType.html;
  request.response.write("API: ${request.method} $path ${request.uri.queryParameters} ");
  request.response.close();
}