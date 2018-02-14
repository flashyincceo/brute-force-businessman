# brute-force-businessman
 OSSU Project: How to code - complex data

You are looking to buy some used phones to fix and resell. Each phone has a cost, a selling price, and a probability of successfully fixing it.

ASSUME you will always sell the phone for the retail price, and that if you can't repair the phone, it is worthless.
ASSUME the retail of every phone is greater than the cost.

Given a certain amount of money, this program chooses which phones to buy to maximize profit.

### How to use ###
1. Download Dr. Racket (https://racket-lang.org/)
2. Download and open the file businessman.rkt in Dr. Racket
3. The main command to run is `(max-profit lop budget)`, where **lop** is a list of Phones and **budget** is the maximum amount of money you want to spend.
4. Create a phone using the command `(make-phone cost retail prob)`, where **cost** is the cost to buy the phone, **retail** is what you expect to sell it for, and **prob** is the probability of successfully repairing the phone (0 is certain failure, 1 is certain success)
5. You can create a list of Phones with the command `(list P1 P2 P3)`, where P1 P2 and P3 are phones created with the (make-phone ...) method
