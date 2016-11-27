module Test where

import Test.HUnit

plop :: Integer
plop = 1

test1 :: Test
test1 = TestCase $ assertEqual "test1" plop plop

test2 :: Test
test2 = TestCase $ assertEqual "test2" plop plop

tests :: Test
tests = TestList
    [ TestLabel "test1" test1
    , TestLabel "test2" test2]
