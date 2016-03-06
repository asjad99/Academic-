;;Assignment 1
;;CSCI924/CSCI424 Reasoning and Learning
;;Muhammad Asjad 
;;Student Number: 4830568

;;----------------------------------------------------
;;returns 0 in case the num is not prime and 1 otherwise
(defun IsPrime(num)
	
	(if (<= num 1) 
		(setq result 0) 


(progn


(if (= num 2) 
		(setq result 1)

(progn
	(setq i 2)
	(
	loop while (< i num)
	
	do 

	(if (= (mod num i) 0)
		(return 0))
	(setf i (+ 1 i))
	(return 1)
	)



);;end of inner progn
);;end of inner if

);;end of progn
);;end of if
	)

;;----------------------------------------------------
;;recursively iterates through the list by breaking it into sublists
;;car and cdr are used to recursively break down the list into smaller lists
;;base condition for recursion is when its nil or has one element(checked by atom keyword)
;;if one element is left in recurision, we check if its prime using IsPrime function
;;incase its prime we increment counter using the + operator

(defun OccurencesOfPrimes(mylist)

	(cond ((null mylist) 0)
		
		((atom mylist) (IsPrime mylist))
		
		(t (+ (OccurencesOfPrimes (car mylist))
		
			(OccurencesOfPrimes (cdr mylist)))

		)

		)

)

;;----------------------------------------------------
;;temporary/intermediate function used inside checkprimes
;if given number is not prime it returns nil else returns the number itself(to be added later to the result)
(defun IsPrime2(num)

(if (<= num 1) 
		(setq result nil) 


(progn


(if (= num 2) 
		(setq result 1)

(progn

	(setq i 2)
	(
	loop while (< i num)
	
	do 

	(if (= (mod num i) 0)
		 (return nil))
	(setf i (+ 1 i))
	(return num)
	)


);;end of inner progn
);;end of inner if

);;end of progn
);;end of if
	)

;;----------------------------------------------------
;;recursively breaks down the list and checks if the number is prime or not.
;;incase its prime it gets added to the final result
(defun checkprimes(mylist)

	(cond ((null mylist) nil)
	
	((atom mylist) (list (IsPrime2 mylist)))
	
	(t 
		(append (GetListOfPrimes (car mylist))

		(GetListOfPrimes (cdr mylist))

	) ) ))


;;----------------------------------------------------
;;calls checkprimes
(defun GetListOfPrimes(mylist)

	(remove-duplicates (remove nil (checkprimes mylist)))

)


;;----------------------------------------------------
;;flattens a nested list using recurisive startegy
;;car and cdr are used to recursively break down the list into smaller list
;;base condition for recursion is when its nil or has one element(checked by atom keyword)
;;when base condition is reached it backtracks and append statement is used to create one final list
(defun flatten_list(mylist)

	(cond ((null mylist) nil)
	
	((atom mylist) (list mylist))
	
	(t 
		(append (flatten_list (car mylist))

		(flatten_list (cdr mylist))

	) ) )
)

;;----------------------------------------------------
;;Function checks if an element is in a given list or not. 
;;return 0 if not and the element if its present
(defun checkelement (mylist1 element)


(if (equalp (find element (flatten_list mylist1)) nil)
0
element

);;end of if
)

;;----------------------------------------------------
;;Main Function that gets called.
;;calls checkelement inside
(defun SumIfNot(mylist1 mylist2)
	(cond ((null mylist2) 0)
		
		((atom mylist2) (checkelement mylist1 mylist2))
		
		(t (+ (SumIfNot mylist1 (car mylist2))
		
			(SumIfNot mylist1 (cdr mylist2)))
		)))



