/*
 * vim: ft=plasma
 * Copyright (C) 2021 Paul Bone
 * Distributed under the terms of the MIT License see LICENSE
 */

module Int

export
func min(a : Int, b : Int) -> Int {
    return if a < b then a else b
}

export
func max(a : Int, b : Int) -> Int {
    return if a > b then a else b
}

