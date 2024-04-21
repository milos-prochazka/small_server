import 'dart:io' as io;
import 'package:small_server/api/api.dart';
import 'package:small_server/utils.dart';

import 'file_io.dart';
import 'config.dart';

void smallServerStart(List<String> arguments) async 
{
  await serverMain(getServerConfig(arguments: arguments));
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

    final httpServer = await startServer(config);

    await for (var request in httpServer) 
    {
      try 
      {
        print("receive requested ${request.uri}");
        bool isFound = false;

        search:
        for (var pathMap in pathMaps) 
        {
          bool isMatch = switch (pathMap.mode) 
          {
            CmpMode.normal => request.uri.path == pathMap.path,
            CmpMode.start => request.uri.path.startsWith(pathMap.path),
            CmpMode.end => request.uri.path.endsWith(pathMap.path),
            CmpMode.contains => request.uri.path.contains(pathMap.path),
            // ignore: unreachable_switch_case
            _ => false,
          };

          if (isMatch) 
          {
            if (pathMap.api) 
            {
              await apiRequest(request, request.uri.path.substring(pathMap.path.length), config);
            } 
            else 
            {
              await getFile(request, joinPath(fileRoot, pathMap.file));
            }
            isFound = true;
            break search;
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

Future<io.HttpServer> startServer(dynamic config) async 
{
  print("start bind {${config['host']}:${config['port']}}");
  final result = await io.HttpServer.bind(config['host'], config['port'], shared: true);
  print("binded");
  return result;
}

enum CmpMode 
{
  normal,
  start,
  end,
  contains,
}

class PathMap 
{
  CmpMode mode = CmpMode.normal;
  String path = "";
  String file;
  bool api = false;
  PathMap(String path, this.file) 
  {
    if (path.startsWith('*')) 
    {
      if (path.endsWith('*')) 
      {
        mode = CmpMode.contains;
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
      mode = CmpMode.start;
      this.path = path.substring(0, path.length - 1);
    } 
    else 
    {
      this.path = path;
    }

    switch (file) 
    {
      case "@api":
      api = true;
      break;
    }
  }
}