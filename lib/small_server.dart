import 'dart:io' as io;
import 'file_io.dart';
import 'config.dart';

enum CmpMode 
{
  normal,
  start,
  end,
  api,
}

class PathMap 
{
  CmpMode mode = CmpMode.normal;
  String path = "";
  String file;
  PathMap(String path, this.file) 
  {
    if (path.startsWith('*')) 
    {
      if (path.endsWith('*')) 
      {
        mode = CmpMode.api;
        this.path = path.substring(1, path.length - 1);
      } 
      else 
      {
        mode = CmpMode.start;
        this.path = path.substring(1);
      }
    } 
    else if (path.endsWith('*')) 
    {
      mode = CmpMode.end;
      this.path = path.substring(0, path.length - 1);
    } 
    else if (path == '@api') 
    {
      mode = CmpMode.api;
    } 
    else 
    {
      this.path = path;
    }
  }
}

String joinPath(String path1, String path2) 
{
  if (path1.startsWith('/')) 
  {
    path1 = path1.substring(1);
  }
  if (path1.endsWith('/')) 
  {
    return path1 + path2;
  }
  return '$path1/$path2';
}

Future serverMain(dynamic config) async 
{
  try 
  {
    ///
    final pathMaps = <PathMap>[];
    for (var item in (config['pathMap'] as Map<String, dynamic>).entries) 
    {
      pathMaps.add(PathMap(item.key, item.value));
    }
    ////
    final fileRoot = config['fileRoot'];

    print("start bind {${config['host']}:${config['port']}}");
    var httpServer = await io.HttpServer.bind(config['host'], config['port'], shared: true);
    print("binded");
    await for (var request in httpServer) 
    {
      try 
      {
        print("receive requested ${request.uri}");
        bool isFound = false;

        search:
        for (var pathMap in pathMaps) 
        {
          switch (pathMap.mode) 
          {
            case CmpMode.normal:
            case CmpMode.start:
            case CmpMode.end:
            {
              bool isMatch = switch (pathMap.mode) 
              {
                CmpMode.normal => request.uri.path == pathMap.path,
                CmpMode.start => request.uri.path.startsWith(pathMap.path),
                CmpMode.end => request.uri.path.endsWith(pathMap.path),
                _ => false,
              };

              if (isMatch) 
              {
                await getFile(request, joinPath(fileRoot, pathMap.file));
                isFound = true;
                break search;
              }
            }
            break;

            case CmpMode.api:
            {
              request.response.headers.contentType = io.ContentType.html;
              request.response.write("Api");
              request.response.close();
              isFound = true;
              break search;
            }
            // ignore: dead_code
            break;
          }
        }

        if (!isFound) 
        {
          await getFile(request, joinPath(fileRoot, request.uri.path));
        }
      } 
      catch (e, s) 
      {
        print("$e");
        print("$s");
      }
    }
  } 
  catch (e, s) 
  {
    print("$e");
    print("$s");
  }
}

void smallServerStart() async 
{
  await serverMain(getServerConfig());
}