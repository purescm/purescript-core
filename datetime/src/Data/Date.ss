;; -*- mode: scheme -*-

(library (Data.Date foreign)
  (export canonicalDateImpl
          calcWeekday
          calcDiff)
  (import (only (rnrs base) define lambda let let* if)
          (prefix (chezscheme) scm:))

  ;; Note: make-date in chez has a lower bound at 1901:
  ;; https://github.com/cisco/ChezScheme/blob/57f92bb76aed694437a2e201780654e9c03a576f/s/date.ss#L186
  (define make-date
    (lambda (millisecond second minute hour day month year)
      (scm:make-date (scm:fx* 1000000 millisecond) second minute hour day month year 0)))

  (define canonicalDateImpl
    (lambda (ctor y m d)
      (let* ([date (make-date 0 0 0 0 d m y)]
            [year (scm:date-year date)]
            [month (scm:date-month date)]
            [day (scm:date-day date)])
        (((ctor year) month) day))))

  (define calcWeekday
    (lambda (year month day)
      (let ([date (make-date 0 0 0 0 day month year)])
        (scm:date-week-day date))))

  (define calcDiff
    (lambda (year1 month1 day1 year2 month2 day2)
      (let ([date1 (make-date 0 0 0 0 day1 month1 year1)]
            [date2 (make-date 0 0 0 0 day2 month2 year2)])
        (scm:fl*
          1000.0
          (scm:fixnum->flonum
            (scm:time-second
              (scm:time-difference
                (scm:date->time-utc date1)
                (scm:date->time-utc date2))))))))
)
