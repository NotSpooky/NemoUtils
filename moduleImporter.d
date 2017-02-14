// Credits to Daniel Nielsen
template from(string moduleName)
{
  mixin("import from = " ~ moduleName ~ ";");
}
