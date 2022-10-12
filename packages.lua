local lua_version = _VERSION:match("%d+%.%d+")

package.path = './rocks/share/lua/' .. lua_version .. '/?.lua;' .. package.path
package.cpath = './rocks/lib/lua/' .. lua_version .. '/?.so;' .. package.cpath

_DEBUG = true