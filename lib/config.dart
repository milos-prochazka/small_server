var serverConfig = 
{
  "host": "0.0.0.0",
  "port": 9000,
  "fileRoot": "./lib/www",
  "pathMap": {"/": "index.html", "/about": "about.html", "/contact": "contact.html", "/api/*": "@api"},
};

Map getServerConfig() 
{
  return serverConfig;
}