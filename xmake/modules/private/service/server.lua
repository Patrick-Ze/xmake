--!A cross-platform build utility based on Lua
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Copyright (C) 2015-present, TBOOX Open Source Group.
--
-- @author      ruki
-- @file        server.lua
--

-- imports
import("core.base.object")
import("core.base.socket")

-- define module
local server = server or object()

-- init server
function server:init()
end

-- set handler
function server:handler_set(handler)
    self._HANDLER = handler
end

-- get the listen address
function server:addr()
    return "127.0.0.1"
end

-- get the listen port
function server:port()
    return 90091
end

-- run main loop
function server:runloop()
    assert(self._HANDLER, "no handler found!")
    local sock = socket.bind(self:addr(), self:port())
    sock:listen(100)
    print("%s: listening %s:%d ..", self, self:addr(), self:port())
    while true do
        local sock_client = sock:accept()
        if sock_client then
            scheduler.co_start(function (sock)
                self._HANDLER(self, sock)
                sock:close()
            end, sock_client)
        end
    end
    sock:close()
end

-- get class
function server:class()
    return server
end

function server:__tostring()
    return "<server>"
end

function main()
    local instance = server()
    instance:init()
    return instance
end