"use strict";

export const pureE = function (a) {
  return function () {
    return a;
  };
};

export const bindE = function (a) {
  return function (f) {
    return function () {
      return f(a())();
    };
  };
};

