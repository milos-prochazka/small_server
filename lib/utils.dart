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