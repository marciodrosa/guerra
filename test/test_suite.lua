lu = require('luaunit')

package.path = package.path..";../source/?.lua"

require('territories_test')

os.exit(lu.LuaUnit.run())