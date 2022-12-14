local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__SetDescriptor = ____lualib.__TS__SetDescriptor
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local Ped
____exports.Entity = __TS__Class()
local Entity = ____exports.Entity
Entity.name = "Entity"
function Entity.prototype.____constructor(self, handle)
    self.godmode = false
    self.handle = handle
end
__TS__SetDescriptor(
    Entity.prototype,
    "Handle",
    {get = function(self)
        return self.handle
    end},
    true
)
__TS__SetDescriptor(
    Entity.prototype,
    "Exists",
    {get = function(self)
        return ENTITY.DOES_ENTITY_EXIST(self.handle)
    end},
    true
)
__TS__SetDescriptor(
    Entity.prototype,
    "Model",
    {get = function(self)
        return ENTITY.GET_ENTITY_MODEL(self.handle)
    end},
    true
)
__TS__SetDescriptor(
    Entity.prototype,
    "Invincible",
    {
        get = function(self)
            return self.godmode
        end,
        set = function(self, value)
            self.godmode = value
            ENTITY.SET_ENTITY_INVINCIBLE(self.handle, self.godmode)
        end
    },
    true
)
__TS__SetDescriptor(
    Entity.prototype,
    "Position",
    {
        get = function(self)
            return ENTITY.GET_ENTITY_COORDS(self.handle, false)
        end,
        set = function(self, pos)
            ENTITY.SET_ENTITY_COORDS(
                self.handle,
                pos.x,
                pos.y,
                pos.z,
                false,
                false,
                false,
                false
            )
        end
    },
    true
)
function Entity.prototype.TeleportTo(self, target)
    local pos = ENTITY.GET_ENTITY_COORDS(target, false)
    self.Position = pos
end
____exports.LicensePlateDesign = LicensePlateDesign or ({})
____exports.LicensePlateDesign.BlueOnWhite1 = 3
____exports.LicensePlateDesign[____exports.LicensePlateDesign.BlueOnWhite1] = "BlueOnWhite1"
____exports.LicensePlateDesign.BlueOnWhite2 = 0
____exports.LicensePlateDesign[____exports.LicensePlateDesign.BlueOnWhite2] = "BlueOnWhite2"
____exports.LicensePlateDesign.BlueOnWhite3 = 4
____exports.LicensePlateDesign[____exports.LicensePlateDesign.BlueOnWhite3] = "BlueOnWhite3"
____exports.LicensePlateDesign.YellowOnBlue = 2
____exports.LicensePlateDesign[____exports.LicensePlateDesign.YellowOnBlue] = "YellowOnBlue"
____exports.LicensePlateDesign.YellowOnBlack = 1
____exports.LicensePlateDesign[____exports.LicensePlateDesign.YellowOnBlack] = "YellowOnBlack"
____exports.LicensePlateDesign.NorthYankton = 5
____exports.LicensePlateDesign[____exports.LicensePlateDesign.NorthYankton] = "NorthYankton"
____exports.LicensePlatePosition = LicensePlatePosition or ({})
____exports.LicensePlatePosition.NoPlates = 3
____exports.LicensePlatePosition[____exports.LicensePlatePosition.NoPlates] = "NoPlates"
____exports.LicensePlatePosition.FrontAndBack = 0
____exports.LicensePlatePosition[____exports.LicensePlatePosition.FrontAndBack] = "FrontAndBack"
____exports.LicensePlatePosition.OnlyFront = 1
____exports.LicensePlatePosition[____exports.LicensePlatePosition.OnlyFront] = "OnlyFront"
____exports.LicensePlatePosition.OnlyBack = 2
____exports.LicensePlatePosition[____exports.LicensePlatePosition.OnlyBack] = "OnlyBack"
____exports.Vehicle = __TS__Class()
local Vehicle = ____exports.Vehicle
Vehicle.name = "Vehicle"
__TS__ClassExtends(Vehicle, ____exports.Entity)
function Vehicle.prototype.____constructor(self, handle, pos, heading)
    if pos == nil then
        pos = {x = 0, y = 0, z = 0}
    end
    if heading == nil then
        heading = 0
    end
    Vehicle.____super.prototype.____constructor(self, handle)
    self.health = __TS__New(____exports.VehicleHealth, self)
    self.seats = __TS__New(____exports.VehicleSeats, self)
end
__TS__SetDescriptor(
    Vehicle.prototype,
    "Health",
    {get = function(self)
        return self.health
    end},
    true
)
__TS__SetDescriptor(
    Vehicle.prototype,
    "Seats",
    {get = function(self)
        return self.seats
    end},
    true
)
__TS__SetDescriptor(
    Vehicle.prototype,
    "EngineRunning",
    {get = function(self)
        return VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(self.handle)
    end},
    true
)
__TS__SetDescriptor(
    Vehicle.prototype,
    "LicensePlateText",
    {
        get = function(self)
            return VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(self.handle)
        end,
        set = function(self, text)
            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(self.handle, text)
        end
    },
    true
)
__TS__SetDescriptor(
    Vehicle.prototype,
    "LicensePlateDesign",
    {
        get = function(self)
            return VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(self.handle)
        end,
        set = function(self, design)
            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(self.handle, design)
        end
    },
    true
)
__TS__SetDescriptor(
    Vehicle.prototype,
    "LicensePlatePositions",
    {get = function(self)
        return VEHICLE.GET_VEHICLE_PLATE_TYPE(self.handle)
    end},
    true
)
function Vehicle.FromHandle(handle)
    return __TS__New(____exports.Vehicle, handle)
end
function Vehicle.SpawnByName(name, pos, heading)
    local hash = util.joaat(name)
    return ____exports.Vehicle.Spawn(hash, pos, heading)
end
function Vehicle.Spawn(model, pos, heading)
    if heading == nil then
        heading = 0
    end
    STREAMING.REQUEST_MODEL(model)
    while not STREAMING.HAS_MODEL_LOADED(model) do
        util.yield()
    end
    if pos == nil then
        pos = {x = 0, y = 0, z = 0}
    end
    local handle = entities.create_vehicle(model, pos, heading)
    return __TS__New(____exports.Vehicle, handle, pos, heading)
end
function Vehicle.prototype.StartEngine(self, instant, noAutostart)
    if instant == nil then
        instant = true
    end
    if noAutostart == nil then
        noAutostart = false
    end
    self:SetEngineState(true, instant, noAutostart)
end
function Vehicle.prototype.StopEngine(self, noAutostart)
    if noAutostart == nil then
        noAutostart = false
    end
    self:SetEngineState(false, false, noAutostart)
end
function Vehicle.prototype.SetEngineState(self, state, instantly, noAutostart)
    if instantly == nil then
        instantly = true
    end
    if noAutostart == nil then
        noAutostart = false
    end
    VEHICLE.SET_VEHICLE_ENGINE_ON(self.handle, state, instantly, noAutostart)
end
____exports.VehicleSeat = VehicleSeat or ({})
____exports.VehicleSeat.FrontDriverSide = -1
____exports.VehicleSeat[____exports.VehicleSeat.FrontDriverSide] = "FrontDriverSide"
____exports.VehicleSeat.FrontPassengerSide = 0
____exports.VehicleSeat[____exports.VehicleSeat.FrontPassengerSide] = "FrontPassengerSide"
____exports.VehicleSeat.BackDriverSide = 1
____exports.VehicleSeat[____exports.VehicleSeat.BackDriverSide] = "BackDriverSide"
____exports.VehicleSeat.BackPassengerSide = 2
____exports.VehicleSeat[____exports.VehicleSeat.BackPassengerSide] = "BackPassengerSide"
____exports.VehicleSeat.AltFrontDriverSide = 3
____exports.VehicleSeat[____exports.VehicleSeat.AltFrontDriverSide] = "AltFrontDriverSide"
____exports.VehicleSeat.AltFrontPassengerSide = 4
____exports.VehicleSeat[____exports.VehicleSeat.AltFrontPassengerSide] = "AltFrontPassengerSide"
____exports.VehicleSeat.AltBackDriverSide = 5
____exports.VehicleSeat[____exports.VehicleSeat.AltBackDriverSide] = "AltBackDriverSide"
____exports.VehicleSeat.AltBackPassengerSide = 6
____exports.VehicleSeat[____exports.VehicleSeat.AltBackPassengerSide] = "AltBackPassengerSide"
____exports.VehicleExitFlags = VehicleExitFlags or ({})
____exports.VehicleExitFlags.Normal = 1
____exports.VehicleExitFlags[____exports.VehicleExitFlags.Normal] = "Normal"
____exports.VehicleExitFlags.TeleportOutside = 16
____exports.VehicleExitFlags[____exports.VehicleExitFlags.TeleportOutside] = "TeleportOutside"
____exports.VehicleExitFlags.NormalSlow = 64
____exports.VehicleExitFlags[____exports.VehicleExitFlags.NormalSlow] = "NormalSlow"
____exports.VehicleExitFlags.DoorKeptOpen = 256
____exports.VehicleExitFlags[____exports.VehicleExitFlags.DoorKeptOpen] = "DoorKeptOpen"
____exports.VehicleExitFlags.BailFromVehicle = 4160
____exports.VehicleExitFlags[____exports.VehicleExitFlags.BailFromVehicle] = "BailFromVehicle"
____exports.VehicleExitFlags.PassengerSideExit = 262144
____exports.VehicleExitFlags[____exports.VehicleExitFlags.PassengerSideExit] = "PassengerSideExit"
____exports.VehicleEnterFlag = VehicleEnterFlag or ({})
____exports.VehicleEnterFlag.Normal = 1
____exports.VehicleEnterFlag[____exports.VehicleEnterFlag.Normal] = "Normal"
____exports.VehicleEnterFlag.TeleportTo = 3
____exports.VehicleEnterFlag[____exports.VehicleEnterFlag.TeleportTo] = "TeleportTo"
____exports.VehicleEnterFlag.PullFromSeat = 8
____exports.VehicleEnterFlag[____exports.VehicleEnterFlag.PullFromSeat] = "PullFromSeat"
____exports.VehicleEnterFlag.TeleportInto = 16
____exports.VehicleEnterFlag[____exports.VehicleEnterFlag.TeleportInto] = "TeleportInto"
____exports.VehicleHealth = __TS__Class()
local VehicleHealth = ____exports.VehicleHealth
VehicleHealth.name = "VehicleHealth"
function VehicleHealth.prototype.____constructor(self, vehicle)
    self.vehicle = vehicle
end
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "EngineOnFire",
    {get = function(self)
        return VEHICLE:_IS_VEHICLE_ENGINE_ON_FIRE(self.vehicle.Handle)
    end},
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "Body",
    {
        get = function(self)
            return VEHICLE.GET_VEHICLE_HEALTH_PERCENTAGE(
                self.vehicle.Handle,
                0,
                0,
                0,
                0,
                0,
                0
            )
        end,
        set = function(self, health)
            VEHICLE.SET_VEHICLE_BODY_HEALTH(self.vehicle.Handle, health)
        end
    },
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "Fuel",
    {
        get = function(self)
            return VEHICLE.GET_VEHICLE_PETROL_TANK_HEALTH(self.vehicle.Handle)
        end,
        set = function(self, health)
            VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(self.vehicle.Handle, health)
        end
    },
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "Engine",
    {
        get = function(self)
            return VEHICLE.GET_VEHICLE_ENGINE_HEALTH(self.vehicle.Handle)
        end,
        set = function(self, health)
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(self.vehicle.Handle, health)
        end
    },
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "HeliMainRotor",
    {
        get = function(self)
            return VEHICLE.GET_HELI_MAIN_ROTOR_HEALTH(self.vehicle.Handle)
        end,
        set = function(self, health)
            VEHICLE.SET_HELI_MAIN_ROTOR_HEALTH(self.vehicle.Handle, health)
        end
    },
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "HeliTailRotor",
    {
        get = function(self)
            return VEHICLE.GET_HELI_TAIL_ROTOR_HEALTH(self.vehicle.Handle)
        end,
        set = function(self, health)
            VEHICLE.SET_HELI_TAIL_ROTOR_HEALTH(self.vehicle.Handle, health)
        end
    },
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "HeliTailBoom",
    {get = function(self)
        return VEHICLE.GET_HELI_TAIL_BOOM_HEALTH(self.vehicle.Handle)
    end},
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "PropellersIntact",
    {get = function(self)
        return VEHICLE.ARE_PLANE_PROPELLERS_INTACT(self.vehicle.Handle)
    end},
    true
)
__TS__SetDescriptor(
    VehicleHealth.prototype,
    "PropellersHealth",
    {set = function(self, health)
        VEHICLE.SET_PLANE_PROPELLER_HEALTH(self.vehicle.Handle, health)
    end},
    true
)
function VehicleHealth.prototype.GetTires(self)
    local healths = {}
    do
        local i = 0
        while i < 7 do
            healths[#healths + 1] = VEHICLE.GET_TYRE_HEALTH(self.vehicle.Handle, i)
            i = i + 1
        end
    end
    return healths
end
function VehicleHealth.prototype.SetTire(self, wheelIndex, health)
    VEHICLE.SET_TYRE_HEALTH(self.vehicle.Handle, wheelIndex, health)
end
____exports.VehicleSeats = __TS__Class()
local VehicleSeats = ____exports.VehicleSeats
VehicleSeats.name = "VehicleSeats"
function VehicleSeats.prototype.____constructor(self, vehicle)
    self.vehicle = vehicle
end
__TS__SetDescriptor(
    VehicleSeats.prototype,
    "AreFull",
    {get = function(self)
        return not VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(self.vehicle.Handle)
    end},
    true
)
__TS__SetDescriptor(
    VehicleSeats.prototype,
    "Max",
    {get = function(self)
        return VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(self.vehicle.Model)
    end},
    true
)
function VehicleSeats.prototype.GetLastPed(self, seat)
    local ped = VEHICLE.GET_LAST_PED_IN_VEHICLE_SEAT(self.vehicle.Handle, seat)
    if ped == 0 then
        return nil
    end
    return Ped.FromHandle(ped)
end
function VehicleSeats.prototype.GetPedInSeat(self, seat)
    local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(self.vehicle.Handle, seat, false)
    if ped == 0 then
        return nil
    end
    return Ped.FromHandle(ped)
end
function VehicleSeats.prototype.IsSeatFree(self, seat)
    return VEHICLE.IS_VEHICLE_SEAT_FREE(self.vehicle.Handle, seat, false)
end
function VehicleSeats.prototype.CanEnterSeat(self, seat, ped, side)
    if side == nil then
        side = false
    end
end
function VehicleSeats.prototype.CanExitSeat(self, seat, ped, side)
    if side == nil then
        side = false
    end
end
function VehicleSeats.prototype.ExitSeat(self, ped, flags)
    if flags == nil then
        flags = ____exports.VehicleExitFlags.Normal
    end
    TASK.TASK_LEAVE_VEHICLE(ped.Handle, self.vehicle.Handle, flags)
end
function VehicleSeats.prototype.EnterSeat(self, ped, seat, timeout, speed, flag)
    if flag == nil then
        flag = ____exports.VehicleEnterFlag.Normal
    end
    TASK.TASK_ENTER_VEHICLE(
        ped.Handle,
        self.vehicle.Handle,
        timeout,
        seat,
        speed,
        flag,
        ""
    )
end
Ped = __TS__Class()
Ped.name = "Ped"
__TS__ClassExtends(Ped, ____exports.Entity)
function Ped.prototype.____constructor(self, handle)
    Ped.____super.prototype.____constructor(self, handle)
end
function Ped.FromHandle(handle)
    return __TS__New(Ped, handle)
end
return ____exports
