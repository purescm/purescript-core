"use strict";

exports.throwErr = function(msg) {
  return function() {
    throw new Error(msg);
  };
};

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

