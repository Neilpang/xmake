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
-- @file        checker.lua
--

-- imports
import("core.base.option")

-- get all checkers
function checkers()
    local checkers = _g._CHECKERS
    if not checkers then
        checkers = {
            -- target api checkers
            ["api.target.version"]   = {description = "Check version configuration in target."},
            ["api.target.optimize"]  = {description = "Check optimize configuration in target."},
            ["api.target.languages"] = {description = "Check languages configuration in target."},
            ["api.target.packages"]  = {description = "Check packages configuration in target."},
            -- clang tidy checker
            ["clang.tidy"]           = {description = "Check project code using clang-tidy.", showstats = false}
        }
        _g._CHECKERS = checkers
    end
    return checkers
end

-- complete checkers
function complete(complete, opt)
    return try
    {
        function ()
            local list = {}
            for name, _ in table.orderpairs(checkers()) do
                if not complete then
                    if #list < 16 then
                        table.insert(list, name)
                    else
                        table.insert(list, "...")
                    end
                elseif name:startswith(complete) then
                    table.insert(list, name)
                end
            end
            return list
        end
    }
end

-- update stats
function update_stats(level, count)
    local stats = _g.stats
    if not stats then
        stats = {}
        _g.stats = stats
    end
    count = count or 1
    stats[level] = (stats[level] or 0) + count
end

-- show stats
function show_stats()
    local stats = _g.stats or {}
    cprint("${bright}%d${clear} notes, ${color.warning}%d${clear} warnings, ${color.error}%d${clear} errors", stats.note or 0, stats.warning or 0, stats.error or 0)
end
