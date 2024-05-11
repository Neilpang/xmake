--!A cross-toolchain build utility based on Lua
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
-- @file        load.lua
--

-- imports
import("core.project.config")

-- load the cross toolchain
function main(toolchain)
    local cross = toolchain:cross() or ""

    -- add toolset
    --
    -- @note we use add/toolset for cross toolchain, because user maybe use set_toolset to modify them
    -- @see https://github.com/xmake-io/xmake/issues/1024
    --
    toolchain:add("toolset", "cc", cross .. "gcc", cross .. "clang")
    toolchain:add("toolset", "cxx", cross .. "gcc", cross .. "clang", cross .. "g++", cross .. "clang++")
    toolchain:add("toolset", "cpp", cross .. "gcc -E", cross .. "clang -E")
    toolchain:add("toolset", "as", cross .. "gcc", cross .. "clang")
    toolchain:add("toolset", "ld", cross .. "g++", cross .. "gcc", cross .. "clang++", cross .. "clang")
    toolchain:add("toolset", "sh", cross .. "g++", cross .. "gcc", cross .. "clang++", cross .. "clang")
    toolchain:add("toolset", "ar", cross .. "ar")
    toolchain:add("toolset", "ranlib", cross .. "gcc-ranlib", cross .. "ranlib")
    toolchain:add("toolset", "strip", cross .. "strip")

    -- add bin search library for loading some dependent .dll files windows
    local bindir = toolchain:bindir()
    if bindir and is_host("windows") then
        toolchain:add("runenvs", "PATH", bindir)
    end

    -- add lto_plugin.so path for gcc
    -- @see https://github.com/xmake-io/xmake/issues/5015
    --
    -- and we cannot use gcc-ar, @see https://github.com/xmake-io/xmake/issues/5051
    --
    local lto_plugin = toolchain:config("lto_plugin")
    if lto_plugin then
        toolchain:add("arflags", {"--plugin", lto_plugin}, {force = true})
    end
end

