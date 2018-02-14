;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname businessman) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

;; Brute force businessman
;;
;; You are looking to buy some used phones to fix and resell.
;; Each phone has a cost, a selling price, and a probability of successfully
;; fixing it.
;; ASSUME you will always sell the phone for the retail price,
;;        and that if you can't repair the phone, it is worthless.
;; ASSUME the retail of every phone is greater than the cost
;;
;; Given a certain amount of money, choose which phones to buy to maximize profit.


(define-struct phone (cost retail prob))
;; Phone is (make-phone Number Number Number[0,1])
;; interp. a phone bought for a given cost, sold for price retail, with a given prob to repair.
;; (1 = guaranteed to succeed, 0 = guaranteed to fail)
(define P1 (make-phone 100 200 0.3))
(define P2 (make-phone 50 70 1))
(define P3 (make-phone 200 400 0.7))

#;
(define (fn-for-phone p)
  (... (phone-cost p)
       (phone-retail p)
       (phone-prob p)))

;; Combination is (listof Phone)

;; (listof Phone) Number -> (listof Phone)
;; produce a list of phones that you can buy without going over the given budget that maximizes profit
(check-expect (max-profit (list P1) 0) empty)       ; no money
(check-expect (max-profit (list P1) 50) empty)      ; not enough money
(check-expect (max-profit (list P1) 100) (list P1)) ; only choice
(check-expect (max-profit (list P1 P3) 200) (list P3))
(check-expect (max-profit (list P1 P3) 300) (list P1 P3))
(check-expect (max-profit (list P1 P2) 100) (list P1))

;(define (max-profit lop budget) empty) ;stub

(define (max-profit lop budget)
  (local [(define (under-budget? lop)
            (<= (total-cost lop) budget))]
    
    (get-max-profit (filter under-budget?
                            (produce-combinations lop)))))

;; (listof Phone) -> (listof Combination)
;; produce all possible combinations (order doesn't matter, can be any length >= 1)

(check-expect (produce-combinations (list P1))
              (list
               (list P1)))

(check-expect (produce-combinations (list P1 P2))
              (list
               (list P1)
               (list P2)
               (list P1 P2)))

(check-expect (produce-combinations (list P1 P2 P3))
              (list
               (list P1)
               (list P2)
               (list P3)
               (list P2 P3)
               (list P1 P2)
               (list P1 P3)
               (list P1 P2 P3)))

;; C(m, n) = m! / ((n!) (m-n)!)
;; C(3, 1) = 3
;; C(3, 2) = 3
;; C(3, 3) = 1

;(define (produce-combinations lop) empty) ;stub

(define (produce-combinations lop)
  (cond [(= (length lop) 1) (list (list (first lop)))]
        [else
         (combine (list (first lop))
                  (produce-combinations (rest lop)))]))

;; Combination (listof Combination) -> (listof Combination)
;; produce a list consisting of the original loc and the original loc with the first combination and the first combination
(check-expect (combine (list P2) (list
                                  (list P3)))
              (list
               (list P2)
               (list P3)
               (list P2 P3)))

(check-expect (combine (list P1) (list
                                  (list P3)
                                  (list P2)
                                  (list P2 P3)))
              (list
               (list P1)
               (list P3)
               (list P2)
               (list P2 P3)
               (list P1 P3)
               (list P1 P2)
               (list P1 P2 P3)))

(define (combine c loc)
  (append (list c)
          loc
          (add-c c loc)))

;; Combination (listof Combination) -> (listof Combination)
;; produce the given loc with c tacked on the front
(check-expect (add-c (list P1) (list
                                (list P2)
                                (list P3)))
              (list
               (list P1 P2)
               (list P1 P3)))

(define (add-c c loc)
  (cond [(empty? loc) empty]
        [else
         (cons (append c (first loc))
               (add-c c (rest loc)))]))

;; (listof Combination) -> Combination
;; produce the combination with the maximum amount of profit
(check-expect (get-max-profit (list
                               (list P1)
                               (list P2)))
              (list P1))
(check-expect (get-max-profit (list
                               (list P1 P2)  ;$50
                               (list P2 P3)  ;$160
                               (list P3)))   ;$140
              (list P2 P3))

;(define (get-max-profit loc) empty) ;stub

(define (get-max-profit loc0)
  (local [(define (get-max-profit loc rsf)
            (cond [(empty? loc) rsf]
                  [else
                   (if (> (total-profit (first loc))
                          (total-profit rsf))
                       (get-max-profit (rest loc) (first loc))
                       (get-max-profit (rest loc) rsf))]))]
    (get-max-profit loc0 empty)))


;; Combination -> Number
;; produce the total profit for this combination of phones
(check-expect (total-profit (list P1 P2)) 50)
(check-expect (total-profit (list P2 P3)) 160)
(check-expect (total-profit (list P3)) 140)

;(define (total-profit lop) 0) ;stub

(define (total-profit lop)
  (cond [(empty? lop) 0]
        [else
         (+ (phone-profit (first lop))
            (total-profit (rest lop)))]))

;; Phone -> Number
;; produce the profit for a single phone
(define (phone-profit p)
  (* (- (phone-retail p) (phone-cost p))
     (phone-prob p)))


;; Combination -> Number
;; produce the total cost for this combination of phones
(check-expect (total-cost (list P1)) 100)
(check-expect (total-cost empty) 0)
(check-expect (total-cost (list P1 P2)) 150)

;(define (total-cost lop) 0) ;stub

(define (total-cost lop)
  (cond [(empty? lop) 0]
        [else
         (+ (phone-cost (first lop))
            (total-cost (rest lop)))]))

