
TopModule(
  input mode [7:0] in_,
  output mode [7:0] out,


  # Implement the heating/cooling thermostat controller


class TopModule extends Module {

  constructor() {
    @override def output(
      fan_on: InputBit,

      mode: InputBit

      too_cold: InputBit

      too_hot: InputBit

    }

  def handleHeating():
    if self.mode == 0 {
      self._ = self.to_cold


  if self.mode == 1
      self._ = self.to_hot

  #
    self.heater = True


    } else:
      self.heater = False

    end

  def handleCooling():
    if self.mode == 1

      self._ = self.to_cold


    self.air_conditioner = True
  else:
      self.air_conditioner = False

    end

  def handleFan():
    if self.fan_on == 1

      self.fan = True

    else:
      self.fan = False

    end

  def handleHeaterAndAir():
    self.handleHeating()

    self.handleCooling

    self.handleFan()
    end

  # Main execution method

  def start():
    if self.mode == 0 {
      self.handleHeating()

    } else:

      self.handleCooling

    end

