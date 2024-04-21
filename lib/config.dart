var serverConfig = 
{
  "host": "0.0.0.0",
  "port": 9000,
  "fileRoot": "./lib/www",
  "pathMap": {"/": "index.html", "/about": "about.html", "/contact": "contact.html", "/api/*": "@api"},
};

Map getServerConfig({List<String>? arguments}) 
{
  _ParamMode mode = _ParamMode.normal;

  if (arguments != null) 
  {
    for (final arg in arguments) 
    {
      switch (mode) 
      {
        case _ParamMode.normal:
        {
          switch (arg) 
          {
            case '--host':
            case '-h':
            mode = _ParamMode.host;
            break;

            case '--port':
            case '-p':
            mode = _ParamMode.port;
            break;

            case '--fileRoot':
            case '-r':
            mode = _ParamMode.root;
            break;
          }
        }
        break;

        case _ParamMode.host:
        {
          serverConfig['host'] = arg;
          mode = _ParamMode.normal;
        }
        break;

        case _ParamMode.port:
        {
          serverConfig['port'] = int.parse(arg);
          mode = _ParamMode.normal;
        }
        break;

        case _ParamMode.root:
        {
          serverConfig['fileRoot'] = arg;
          mode = _ParamMode.normal;
        }
        break;
      }
    }
  }
  return serverConfig;
}

enum _ParamMode 
{
  normal,
  host,
  port,
  root,
}