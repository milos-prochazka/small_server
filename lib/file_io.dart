import 'dart:io' as io;

import 'package:mime/mime.dart';

Future getFile(io.HttpRequest request, String fileName) async 
{
  var file = io.File(fileName);
  if (await file.exists()) 
  {
    request.response.headers.contentType = io.ContentType.parse(lookupMimeType(fileName) ?? "text/html");
    await file.openRead().pipe(request.response);
    request.response.close();
  } 
  else 
  {
    request.response.statusCode = io.HttpStatus.notFound;
    request.response.headers.contentType = io.ContentType.html;
    request.response.write("Not Found");
    request.response.close();
  }
}