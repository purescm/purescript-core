# purescript-lists

This is a fork of the `lists` package for the `purescm` Chez Scheme backend for PureScript.
The `purescm` backend compiles the `List` data type to native scheme lists and this fork further optimizes some of the operations by providing native implementations.

[![Latest release](http://img.shields.io/github/release/purescript/purescript-lists.svg)](https://github.com/purescript/purescript-lists/releases)
[![Build status](https://github.com/purescript/purescript-lists/workflows/CI/badge.svg?branch=master)](https://github.com/purescript/purescript-lists/actions?query=workflow%3ACI+branch%3Amaster)
[![Pursuit](https://pursuit.purescript.org/packages/purescript-lists/badge)](https://pursuit.purescript.org/packages/purescript-lists)

This library defines strict and lazy linked lists, and associated helper functions and type class instances.

_Note_: This module is an improvement over `Data.Array` when working with immutable lists of data in a purely-functional setting, but does not have good random-access performance.

## Installation

```
spago install lists
```

## Licensing

Some of this code is derived from GHC's standard libraries (`base`);
according to its terms, we have included GHC's license in the file
`LICENSE-GHC.md`.

## Documentation

Module documentation is [published on Pursuit](http://pursuit.purescript.org/packages/purescript-lists).
