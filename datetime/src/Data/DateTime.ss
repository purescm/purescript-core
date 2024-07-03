;; -*- mode: scheme -*-

(library (Data.DateTime foreign)
  (export calcDiff
          adjustImpl)
  (import (only (rnrs base) define lambda let let*)
          (prefix (purs runtime) rt:)
          (prefix (chezscheme) scm:))

  ;; Note: make-date in chez has a lower bound at 1901:
  ;; https://github.com/cisco/ChezScheme/blob/57f92bb76aed694437a2e201780654e9c03a576f/s/date.ss#L186
  (define make-date
    (lambda (millisecond second minute hour day month year)
      (scm:make-date (scm:fx* 1000000 millisecond) second minute hour day month year 0)))

  (define calcDiff
    (lambda (datetimeRecord1 datetimeRecord2)
      (let* ([year1 (rt:record-ref datetimeRecord1 (scm:quote year))]
            [month1 (rt:record-ref datetimeRecord1 (scm:quote month))]
            [day1 (rt:record-ref datetimeRecord1 (scm:quote day))]
            [hour1 (rt:record-ref datetimeRecord1 (scm:quote hour))]
            [minute1 (rt:record-ref datetimeRecord1 (scm:quote minute))]
            [second1 (rt:record-ref datetimeRecord1 (scm:quote second))]
            [millisecond1 (rt:record-ref datetimeRecord1 (scm:quote millisecond))]
            [year2 (rt:record-ref datetimeRecord2 (scm:quote year))]
            [month2 (rt:record-ref datetimeRecord2 (scm:quote month))]
            [day2 (rt:record-ref datetimeRecord2 (scm:quote day))]
            [hour2 (rt:record-ref datetimeRecord2 (scm:quote hour))]
            [minute2 (rt:record-ref datetimeRecord2 (scm:quote minute))]
            [second2 (rt:record-ref datetimeRecord2 (scm:quote second))]
            [millisecond2 (rt:record-ref datetimeRecord2 (scm:quote millisecond))]
            ;; note: make-date takes nanoseconds, not milliseconds
            [date1 (make-date millisecond1 second1 minute1 hour1 day1 month1 year1)]
            [date2 (make-date millisecond2 second2 minute2 hour2 day2 month2 year2)]
            [difference (scm:time-difference
                          (scm:date->time-utc date1)
                          (scm:date->time-utc date2))]
            [seconds (scm:time-second difference)]
            [nanoseconds (scm:time-nanosecond difference)])
        ;; need to return milliseconds from the sum of seconds and nanoseconds
        (scm:fl+
          (scm:fl* (scm:fixnum->flonum seconds) 1000.0)
          (scm:fl/ (scm:fixnum->flonum nanoseconds) 1000000.0)))))

  (define adjustImpl
    (lambda (just)
      (lambda (nothing)
        (lambda (offset)
          (lambda (datetime-record)
            (let* ([year (rt:record-ref datetime-record (scm:quote year))]
                  [month (rt:record-ref datetime-record (scm:quote month))]
                  [day (rt:record-ref datetime-record (scm:quote day))]
                  [hour (rt:record-ref datetime-record (scm:quote hour))]
                  [minute (rt:record-ref datetime-record (scm:quote minute))]
                  [second (rt:record-ref datetime-record (scm:quote second))]
                  [millisecond (rt:record-ref datetime-record (scm:quote millisecond))]
                  [date (make-date millisecond second minute hour day month year)]
                  [time (scm:date->time-utc date)]
                  [duration-seconds (scm:flonum->fixnum (scm:fldiv offset 1000.0))]
                  [duration-nanoseconds (scm:flonum->fixnum (scm:fl* 1000000.0 (scm:flmod offset 1000.0)))]
                  [duration (scm:make-time (scm:quote time-duration) duration-nanoseconds duration-seconds)]
                  [new-time (scm:add-duration time duration)]
                  [new-date (scm:time-utc->date new-time 0)]
                  [new-datetime-record
                    (scm:list
                      (scm:cons (scm:quote year) (scm:date-year new-date))
                      (scm:cons (scm:quote month) (scm:date-month new-date))
                      (scm:cons (scm:quote day) (scm:date-day new-date))
                      (scm:cons (scm:quote hour) (scm:date-hour new-date))
                      (scm:cons (scm:quote minute) (scm:date-minute new-date))
                      (scm:cons (scm:quote second) (scm:date-second new-date))
                      (scm:cons (scm:quote millisecond) (scm:fx/ (scm:date-nanosecond new-date) 1000000)))])
              (just new-datetime-record)))))))
)
