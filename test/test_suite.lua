lu = require('luaunit')

package.path = package.path..";../source/?.lua"

require('continents_test')
require('territories_test')
require('trades_test')

os.exit(lu.LuaUnit.run())