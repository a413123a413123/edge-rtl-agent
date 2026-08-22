TopModule(
  clk = in_;
  reset = reset_

  in = in_
  out = out

  disc = disc
  flag = flag

  err = err


  state: {
    [1,reset] { 
      [in_ = 
  in_ = in_;
  out = out_ + 1
  flag = flag_ + 1
    err = err_ + 1

      next = 0x0
    }
    [discard_next] = if (clk) && (not out_) && (in_ == in_); {
      next = 1
      disc = 1
      flag = 0
      err = 

    }
    next = 1,0
    disc = 0
    flag = 
  err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err =  
    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 
 
    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 

    disc = 0
    flag = 

    err = 

    }
    next = 

    disc = 0
    flag = 

    err = 

    }
    next = 0
    disc = 0
    flag = 

    err = 

    }
    next = 

    disc = 0
    flag = 

    err = 

    }
    next = 
    disc = 0
    flag =
 
    err = 

    }
    next = 

    disc = 0
    flag = 

    err = 

    }
    next = 

    disc = 0
    flag = 

    err = 

    }
    next = 
    disc = 0
    flag = 

    err = 

    }
    next = 

    disc = 0
    flag = 

    err =


    }
    next = 

    disc = 0
    flag = 

    err =


    }
    next = 

    disc = 0
    flag = 

    err = 

    }
    next = 

    disc = 0
    flag =


    err = err = 

    }
    next = 

    disc = 0
    flag = 

    err = err = 

    }
    next = 

    disc = 0
    flag = 

    err = err = 

    }
    next = 

    disc = 0
    flag = 

    err = err = 

    }
    next = 

    disc = 0
    flag = 

    err = err = 

    }
    next = 


    disc = 0
    flag = 

    err = err =  

    }
    next = 0
    disc = 0
    flag =


    err = err = 

    }
    next = 

    disc = 

   
