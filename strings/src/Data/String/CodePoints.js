/* global Symbol */

export const singleton = String.fromCodePoint;

export const fromCodePointArray = function (cps) {
  // Function.prototype.apply will fail for very large second parameters,
  // so we don't use it for arrays with 10,000 or more entries.
  if (cps.length < 10e3) {
    return String.fromCodePoint.apply(String, cps);
  }
  return cps.map(String.fromCodePoint).join("");
};

export const toCodePointArray = function (str) {
  return Array.from(str, function (s) { return s.codePointAt(0); });
};

export const _codePointAt = function (Just) {
  return function (Nothing) {
    return function (index) {
      return function (str) {
        var iter = str[Symbol.iterator]();
        for (var i = index;; --i) {
          var o = iter.next();
          if (o.done) return Nothing;
          if (i === 0) return Just(o.value.codePointAt(0));
        }
      };
    };
  };
};

export const _uncons = function (Just) {
  return function (Nothing) {
    return function (str) {
      if (str.length === 0) return Nothing;
      var cp = str.codePointAt(0);
      // Supplementary code points use 2 UTF-16 code units
      var headLen = cp > 0xFFFF ? 2 : 1;
      return Just({ head: cp, tail: str.substring(headLen) });
    };
  };
};

export const length = function (str) {
  return Array.from(str).length;
};

export const countPrefix = function (pred) {
  return function (str) {
    var iter = str[Symbol.iterator]();
    for (var cpCount = 0; ; ++cpCount) {
      var o = iter.next();
      if (o.done) return cpCount;
      if (!pred(o.value.codePointAt(0))) return cpCount;
    }
  };
};

export const take = function (n) {
  return function (str) {
    var accum = "";
    var iter = str[Symbol.iterator]();
    for (var i = 0; i < n; ++i) {
      var o = iter.next();
      if (o.done) return accum;
      accum += o.value;
    }
    return accum;
  };
};

export const unsafeCodePointAt0 = function (str) {
  return str.codePointAt(0);
};
