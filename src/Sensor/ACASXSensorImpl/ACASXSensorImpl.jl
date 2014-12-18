# Author: Ritchie Lee, ritchie.lee@sv.cmu.edu
# Date: 11/23/2014

module ACASXSensorImpl

export
    initialize,
    step,

    updateSensor,

    ACASXSensor,
    ACASXSensorState,
    ACASXSensorInput,
    ACASXSensorOutput


using AbstractSensorImpl
using AbstractSensorInterfaces
using CommonInterfaces

using Base.Test
using CCAS

import CommonInterfaces.initialize
import CommonInterfaces.step
import AbstractSensorInterfaces.updateSensor

type ACASXSensorState
  x::Float64
  y::Float64
  z::Float64
  vx::Float64
  vy::Float64
  vz::Float64
end

type ACASXSensorInput
  states::Vector{ACASXSensorState}
end

typealias ACASXSensorOutput InputVals

type ACASXSensor <: AbstractSensor
  my_id::Int64 #my id
  max_intruders::Int64
  outputVals::ACASXSensorOutput

  function ACASXSensor(my_id::Int,max_intruders::Int)
    obj = new()
    obj.my_id = my_id
    obj.max_intruders = max_intruders
    obj.outputVals = ACASXSensorOutput(max_intruders)

    return obj
  end
end

function updateSensor(sensor::ACASXSensor, input::ACASXSensorInput)

  own_state = input[sensor.my_id]
  ownInput = sensor.outputVals.ownInput

  ownInput.dz = own_state.vz
  ownInput.z = own_state.z #baro alt
  ownInput.psi = atan2(own_state.vy,own_state.vx) #zero when aligned with y-axis / north
  ownInput.h = own_state.z #agl alt
  ownInput.modes = uint32(sensor.my_id)

  intruders = sensor.outputVals.intruders

  for i = 1:endof(input.states)
    if i != sensor.my_id
      intr_i = i > my_id ? i-1 : i
      intr_state = input.states[i]
      intruders[intr_i].valid = true
      intruders[intr_i].id = uint32(i)
      intruders[intr_i].modes = uint32(i)
      intruders[intr_i].sr = norm([own_state.x,own_state.y,own_state.z]-
                                    [intr_state.x,intr_state.y,intr_state.z]) #slant range (feet)
      trueAngle = atan2(intr_state.y-own_state.y,intr_states.x-own_state.x)
      intruders[intr_i].chi = mod(trueAngle-ownInput.psi,pi) #bearing (radians, nose is 0, clockwise is positive)
      intruders[intr_i].z = intr_state.z #altitude (feet)

      ## These are the defaults.  Modified through coordination
      intruders[intr_i].cvc = 0x0
      intruders[intr_i].vrc = 0x0
      intruders[intr_i].vsb = 0x0
      intruders[intr_i].equipage = EQUIPAGE.EQUIPAGE_ATCRBS #FIXME
      intruders[intr_i].quant = intruders[intr_i].equipage == EQUIPAGE.EQUIPAGE_ATCRBS ? 25 : 100
      intruders[intr_i].sensitivity_index = 0x0
      intruders[intr_i].protection_mode = 0x0
    end
  end

  return sensor.outputVals
end

step(sensor::ACASXSensor, input::ACASXSensorInput) = updateSensor(sensor, input)

function initialize(sensor::ACASXSensor)

end

end

