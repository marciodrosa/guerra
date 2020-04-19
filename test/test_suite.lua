lu = require('luaunit')

package.path = package.path..";../source/?.lua"

require('cards_test')
require('dice_test')
require('continents_test')
require('game_test')
require('goals_test')
require('idioms_test')
require('state_test')
require('territories_test')
require('trades_test')

os.exit(lu.LuaUnit.run())