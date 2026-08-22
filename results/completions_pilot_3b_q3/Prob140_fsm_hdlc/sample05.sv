
module

module TopModule {
  reset : reset,
  input: input,

  disc : disc,
  flag : flag,
  err : err,

  begin {
  if reset == 1 {
    in_ = in_;
  } else {
    if (input & 1) == 1

      if (input | 1) == 0 {
        disc = 0
        flag =  


      } else {
        disc = in_ | 1
        if (disc | flag) == 0 {
          err = .0
        flag = 

      } else {
        disc = in_ | 0
        err =  
        flag = 

      }
    }
    disc = in_ | 0
    flag = 

      }
    disc = in_ | 0
    err =  
    flag = 

      }
    disc = in_ | 0
    err = 

    flag = 

      } else {
        disc = 0
        err = 

        flag = 

      }
    disc = 0
    err = 

    flag = 

      }
    disc = 0
    err = 

    flag =  
      }
    disc = 0
    err = 

    flag = 


endmodule
```
