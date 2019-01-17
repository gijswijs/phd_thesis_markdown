-- file: git-revision.lua

function Meta(m)
  local handle = io.popen("git describe --always --tags","r")
  local result = handle:read("*a")
  handle:close()
  m.revision = result
  handle = io.popen("git log -1 --format=\"%ad\" --date=short","r")
  result = handle:read("*a")
  m.date = result
  return m
end