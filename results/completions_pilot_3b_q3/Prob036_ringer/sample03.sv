
module TopModule(
  input ring, output ringer, output motor

  ringer = 
  ring === 0
  motor = input ring === 1
  ringerOn = false

  motorOn = false
  vibrate_mode = false

  ringOn = true if (input ring > 0) else false;
  motorOn = true if (input ring > 0) else false;

  if (vibrate_mode)

  motorOn = true;
  ringerOn = true;
  ringOn = true;
  ringerOn = true;
  motorOn = true;

  ringOn = true;
  ringerOn = true;
  motorOn = true;
  ringerOn = true;

  endmodule
