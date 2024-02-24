;; -*- mode: scheme -*-

(library (Data.DateTime.Instant foreign)
  (export fromDateTimeImpl
          toDateTimeImpl)
  (import (only (rnrs base) define lambda let let* if)
          (prefix (chezscheme) scm:))

  ;; Note: make-date in chez has a lower bound at 1901:
  ;; https://github.com/cisco/ChezScheme/blob/57f92bb76aed694437a2e201780654e9c03a576f/s/date.ss#L186
  (define make-date
    (lambda (millisecond second minute hour day month year)
      (scm:make-date (scm:fx* 1000000 millisecond) second minute hour day month year 0)))

  (define fromDateTimeImpl
    (lambda (year month day hour minute second millisecond)
      (let* ([date (make-date millisecond second minute hour day month year)]
            [utc-time (scm:date->time-utc date)]
            [seconds (scm:time-second utc-time)]
            [nanoseconds (scm:time-nanosecond utc-time)])
        ;; need to return milliseconds from the sum of seconds and nanoseconds
        (scm:fl+
          (scm:fl* (scm:fixnum->flonum seconds) 1000.0)
          (scm:fl/ (scm:fixnum->flonum nanoseconds) 1000000.0)))))

  (define toDateTimeImpl
    (lambda (ctor)
      (lambda (instant)
        (let* ([instant-seconds (scm:flonum->fixnum (scm:fldiv instant 1000.0))]
              [instant-nanoseconds (scm:flonum->fixnum (scm:fl* 1000000.0 (scm:flmod instant 1000.0)))]
              [utc-time (scm:make-time (scm:quote time-utc) instant-nanoseconds instant-seconds)]
              [date (scm:time-utc->date utc-time 0)]
              [year (scm:date-year date)]
              [month (scm:date-month date)]
              [day (scm:date-day date)]
              [hour (scm:date-hour date)]
              [minute (scm:date-minute date)]
              [second (scm:date-second date)]
              [millisecond (scm:fxdiv (scm:date-nanosecond date) 1000000)])
          (((((((ctor year) month) day) hour) minute) second) millisecond)))))
)
