class Queen {
    pane : Int;
};

class King inherits Queen {};

class Bishop inherits Queen {
    soldier : Int;
};

class AA {
    x : Bool <- true;
};

class BB {
    y : Int <- 10;
};

class CC {
    z : String <- "here";
};

class DD {
    temp : Int;
    x : Int <- (temp <- 5);
    tempK : King;
    tempQ : Queen;
    xp : Object <- (tempQ <- tempK); -- You cannot assign sth superior to sth inferior
    xp2 : Object <- (tempQ <- new King);
};

class AAA inherits King {
    kA1 : King;
    bA1 : Bishop;
    xA1 : Object <- (if true then 5 else 3 fi);
    xA2 : Object <- (if true then "cond" else 3 fi);
    xA4 : Object <- (if true then kA1 else bA1 fi);
};

class BBB inherits Bishop {
    xB1 : Object <- {new SELF_TYPE; new AAA; };
    xB2 : Object <- {5; if true then soldier else 5 fi; };
    xB3 : Object <- {5; "str";};
    --xB4 : Object <- (isvoid 5);
};

class Test {
    s : String;
    t : SELF_TYPE;
    t2 : LetTest;
    r1 : Int;
    r2 : String;
    xT0 : Object <- {
        t <- (new SELF_TYPE);
        --t <- (new LetTest);
        --t2 <- (new SELF_TYPE);
    };
    --xT1 : Object <- (let s : SELF_TYPE <- (new LetTest) in s);
    xT2 : Object <- (let s : SELF_TYPE in (if true then s else 5 fi));
    --xT3 : Object <- (let tar : Int, s : SELF_TYPE <- (new LetTest) in (s));
    xT3 : Object <- (let tar : Int, s : Test <- (new SELF_TYPE) in (s));
};

class LetTest inherits Test {
    xL0 : Object <- {
        t2 <- (new SELF_TYPE);
    };
    xL1 : Object <- (let s : Int <- 5 in true);
    xL2 : Object <- (let s : Int in true);
    xL3 : Object <- (let what : Int in s);

};

class CaseTest inherits Test {
    xC1 : Object <- (
        case 0 of r1 : Bishop => r1; r2 : King => r2; esac
    );
    xC2 : Object <- (
        case 0 of rho1 : Int => r1; r2 : Int => r2; esac
    );
};

class Un {
    xU1 : Object <- {
        isvoid (if true then 5 else 10 fi);
        not (true);
        ~ (5);
    };
};

class Bin {
    --xBin1 : Object <- {3 + 4; 3 - 4; 3 * 4; 3 / 4; 3 < 4; 3 <= 4; };
    xBin2 : Object <- {
        true = false;
        1 = 2;
        "ad" = "bc";
        (new Queen) = (new King);
    };
};

class A2I_adv inherits A2I {

    flag : Int <- 0;

    -- Check the a character and tell whether it is a digit.
    chr_is_num(s : String) : Bool {
       if s.substr(0, 1) = "0" then true else
       if s.substr(0, 1) = "1" then true else
       if s.substr(0, 1) = "2" then true else
       if s.substr(0, 1) = "3" then true else
       if s.substr(0, 1) = "4" then true else
       if s.substr(0, 1) = "5" then true else
       if s.substr(0, 1) = "6" then true else
       if s.substr(0, 1) = "7" then true else
       if s.substr(0, 1) = "8" then true else
       if s.substr(0, 1) = "9" then true else false
       fi fi fi fi fi fi fi fi fi fi
    };

    -- Check whether a string is a number
    str_is_num(s : String) : Bool {{
        flag <- 0;

        (let j : Int <- s.length() in
            (let i : Int <- 0 in
                while i < j loop {
                    if chr_is_num(s.substr(i, 1)) = false then flag <- flag + 1
                    else flag <- flag fi;
                    i <- i + 1;
                } pool
            )
        );

        if flag = 0 then true else false fi;
    }};
};



(*
    * The class Stack keeps track of all the integers or symbols that have been pushed.
    * The Stack has the following operations:
    *   size() : the number of elements the stack contains.
    *   top() : the top element.
    *   push() : push a new element onto the top. Return the pushed element itself.
    *   pop() : remove the top element. Return the popped element itself.
    *   eval() : do the required operations as stated in PA1.
    *   display() : display all elements in the stack.
*)


(*
    * The parent class
*)
class Stack inherits IO {
    size(): Int {0};

    top() : String {"You are on the stack bottom. "};

    pop() : Stack {
        -- If the stack is empty, there is nothing to be popped. Thus, return self.
        self
    };

    push(s : String) : Stack {   -- Why SELF_TYPE wouldn't work?
        (new Cons).init(s, size() + 1, self)
    };

    eval() : Stack {{
        if top() = "+" then (new Cons_plus).pop_then_plus(self)
        else if top() = "s" then (new Cons_swap).pop_then_swap(self)
        else if (new A2I_adv).str_is_num(top()) = true then self
        else if size() = 0 then self
        else {abort(); self;}
        fi fi fi fi;
    }};

    display() : Object {
        out_string("")
    };
};


(*
    * Subclass 1: Cons
    * Take care of size(), top(), pop(), and push()
*)
class Cons inherits Stack {
    top : String;
    size : Int;
    next : Stack;

    size() : Int {size};

    top() : String {top};

    pop() : Stack {{
        size <- size - 1;
        next;
    }};

    init(s : String, new_size : Int, rest : Stack) : Stack {{
        top <- s;
        size <- new_size;
        next <- rest;
        self;
    }};

    display() : Object {{
        out_string(top()).out_string("\n");
        next.display();
    }};

};


(*
    * Subclass 2: Cons_plus
    * Take care of the "+" command: pop the top "+" and the top two numbers, add, and push
*)
class Cons_plus inherits Cons {
    x1 : Int;
    x2 : Int;

    pop_then_plus(curr : Stack) : Stack {{
        curr <- curr.pop();         -- pop the "+" sign on the top.

        -- If less than 2 elements are left, then the operation is illegal.

        if not curr.size() < 2 then {
            x1 <- (new A2I_adv).a2i(curr.top()); curr <- curr.pop();
            x2 <- (new A2I_adv).a2i(curr.top()); curr <- curr.pop();

            -- Push the new sum as string onto the top.
            curr <- curr.push((new A2I_adv).i2a(x1 + x2));

        } else abort() fi;
        curr;
    }};
};



(*
    * Subclass 3: Cons_swap
    * Take care of the "s" command in PA1: pop the top "s" sign and swap the top two numbers
*)
class Cons_swap inherits Cons {
    s1 : String;
    s2 : String;

    pop_then_swap(curr : Stack) : Stack {{
        curr <- curr.pop();      -- Pop the top "s"

        -- If less than 2 elements are left, then the operation is illegal.

        if not curr.size() < 2 then {
            s1 <- curr.top(); curr <- curr.pop();
            s2 <- curr.top(); curr <- curr.pop();
            curr <- curr.push(s1).push(s2);
        } else abort() fi;

        curr;
    }};
};


class Main inherits IO {
    read_str : String;
    myStack : Stack;
    running : Bool;

    main() : Object {{
        myStack <- (new Stack);
        running <- true;

        while running = true loop {
            out_string(">");
            read_str <- in_string();
            if read_str = "x" then running <- false
            else if read_str = "e" then myStack <- myStack.eval()
            else if read_str = "d" then myStack.display()
            else myStack <- myStack.push(read_str)
            fi fi fi;
        } pool;
    }};
};

class A2I {
  (*
    c2i converts a 1-character string to an integer. Aborts
    if the string is not "0" through "9"
  *)
  c2i(char : String) : Int {
    if char = "0" then 0 else
    if char = "1" then 1 else
    if char = "2" then 2 else
    if char = "3" then 3 else
    if char = "4" then 4 else
    if char = "5" then 5 else
    if char = "6" then 6 else
    if char = "7" then 7 else
    if char = "8" then 8 else
    if char = "9" then 9 else
    { abort(); 0; }  -- the 0 is needed to satisfy the type checking
    fi fi fi fi fi fi fi fi fi fi
  };

  (*
    i2c is the inverse of c2i.
  *)
  i2c(i : Int) : String {
    if i = 0 then "0" else
    if i = 1 then "1" else
    if i = 2 then "2" else
    if i = 3 then "3" else
    if i = 4 then "4" else
    if i = 5 then "5" else
    if i = 6 then "6" else
    if i = 7 then "7" else
    if i = 8 then "8" else
    if i = 9 then "9" else
    { abort(); ""; }  -- the "" is needed to satisfy the typchecker
      fi fi fi fi fi fi fi fi fi fi
  };

  (*
    a2i converts an ASCII string into an integer. The empty string
    is converted to 0. Signed and unsigned strings are handled.  The
    method aborts if the string does not represent an integer. Very
    long strings of digits produce strange answers because of arithmetic
    overflow.
  *)
  a2i(s : String) : Int {
    if s.length() = 0 then 0 else
      if s.substr(0,1) = "-" then ~a2i_aux(s.substr(1, s.length()-1)) else
        if s.substr(0,1) = "+" then a2i_aux(s.substr(1, s.length()-1)) else
          a2i_aux(s)
    fi fi fi
  };

  (*
    a2i_aux converts the usigned portion of the string.  As a programming
    example, this method is written iteratively.
  *)
  a2i_aux(s : String) : Int {
    (let int : Int <- 0 in {
      (let j : Int <- s.length() in
        (let i : Int <- 0 in
          while i < j loop
            {
              int <- int * 10 + c2i(s.substr(i,1));
              i <- i + 1;
            }
          pool
        )
      );
      int;
    })
  };

  (*
    i2a converts an integer to a string.  Positive and negative
    numbers are handled correctly.
  *)
  i2a(i : Int) : String {
    if i = 0 then "0" else
      if 0 < i then i2a_aux(i) else
        "-".concat(i2a_aux(i * ~1))
    fi fi
  };

    (*
      i2a_aux is an example using recursion.
    *)
    i2a_aux(i : Int) : String {
      if i = 0 then "" else
	      (let next : Int <- i / 10 in
		      i2a_aux(next).concat(i2c(i - next * 10))
	      )
      fi
    };

};
