Update: 07/09/2014

SISL + ES
= Stanford Intelligent Systems Laboratory + Encounter Simulation

Author: Youngjun Kim, youngjun@stanford.edu
        Mykel Kochenderfer, mykel@stanford.edu


+ Example
To run example code, PyPlot, HDF5 are required.

$ cd examples
$ julia tcas_simulation.jl
$ julia plot_simulation.jl


+ Layout

SISLES.jl                           encounter simulation module

include/
    SISLES.jl                       top-level include file for developers
    CommonInterfaces.jl             list common interfaces for modules

common/
    Util.jl                         utilility module
    format_string.jl                output "%g" format string
    ObserverImpl/                   observer pattern implementation for modules

Encounter/
    Encounter.jl                    encounter generation module
    AbstractEncounterModelImpl.jl   define abstract type for the module
    CorAEMImpl/                     Correlated Airspace Encounter Model
    LLAEMImpl/                      Lincoln Laboratory Airspace Encounter Model

PilotResponse/
    PilotResponse.jl                pilot response module
    AbstractPilotResponseImpl.jl    define abstract type for the module
    SimplePilotResponseImpl/        simple model for pilot response

DynamicModel/
    DynamicModel.jl                 model for dynamics
    AbstractDynamicModelImpl.jl     define abstract type for the module
    SimpleADMImpl/                  simple model for aircraft dynamics

WorldModel/
    WorldModel.jl                   model representing world
    AbstractWorldModelImpl.jl       define abstract type for the module
    AirSpaceImpl/                   represent airspace

Sensor/
    Sensor.jl                       sensor module
    AbstractSensorImpl.jl           define abstract type for the module
    SimpleTCASSensorImpl/           simple TCAS sensor

CollisionAvoidanceSystem/
    CollisionAvoidanceSystem.jl     collision avoidance system module
    AbstractCollisionAvoidanceSystemImpl.jl define abstract type for the module
    SimpleTCASImpl/                 simplified version of TCAS

Simulator/
    Simulator.jl                    simulator module
    AbstractSimulatorImpl.jl        define abstract type for the module
    TCASSimulatorImpl/              TCAS simulator

examples/
    tcas_simulation.jl              example of running simulator
    plot_simulation.jl              example of plotting result


