#!/usr/bin/env bash

set -e

echo "Testing prelude"
purescm run --main Test.Prelude.Main
echo

echo "Testing arrays"
purescm run --main Test.Array.Main
echo

echo "Testing console"
purescm run --main Test.Console.Main
echo

echo "Testing control"
purescm run --main Test.Control.Main
echo

echo "Testing enums"
purescm run --main Test.Enum.Main
echo

echo "Testing foldable"
purescm run --main Test.Foldable.Main
echo

echo "Testing integers"
purescm run --main Test.Int.Main
echo

echo "Testing json"
purescm run --main Test.JSON.Main
echo

echo "Testing lazy"
purescm run --main Test.Lazy.Main
echo

echo "Testing refs"
purescm run --main Test.Effect.Ref.Main
echo

echo "Testing st"
purescm run --main Test.Main
echo

echo "Testing string"
purescm run --main Test.Data.String.Main
echo

echo "Testing minibench"
purescm run --main Test.Minibench.Main
echo

echo "Testing numbers"
purescm run --main Test.Number.Main
echo

echo "Testing record"
purescm run --main Test.Record.Main
echo

echo "Testing quickcheck"
purescm run --main Test.QuickCheck.Main
echo

echo "Test foreign-object"
purescm run --main Test.Foreign.Object.Main

echo "All good!"
