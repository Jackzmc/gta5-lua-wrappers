export class Entity {
    protected handle: number
    protected godmode: boolean
    protected constructor(handle: EntityHandle) {
        this.godmode = false
        this.handle = handle;
    }
    public get Handle() {
        return this.handle
    }
    public get Exists() {
        return ENTITY.DOES_ENTITY_EXIST(this.handle)
    }
    
    public get Model() {
        return ENTITY.GET_ENTITY_MODEL(this.handle)
    }

    public get Invincible() {
        return this.godmode
    }

    public set Invincible(value: boolean) {
        this.godmode = value;
        ENTITY.SET_ENTITY_INVINCIBLE(this.handle, this.godmode)
    }

    public get Position() {
        return ENTITY.GET_ENTITY_COORDS(this.handle, false)
    }

    public set Position(pos: Vector3) {
        ENTITY.SET_ENTITY_COORDS(this.handle, pos.x, pos.y, pos.z, false, false, false, false)
    }

    public TeleportTo(target: number) {
        const pos = ENTITY.GET_ENTITY_COORDS(target, false)
        this.Position = pos
    }

}

export enum LicensePlateDesign {
    BlueOnWhite1 = 3,  
    BlueOnWhite2 = 0,  
    BlueOnWhite3 = 4,  
    YellowOnBlue = 2,  
    YellowOnBlack = 1,  
    NorthYankton = 5,  
}

export enum LicensePlatePosition {
    NoPlates = 3,
    FrontAndBack = 0,
    OnlyFront = 1,
    OnlyBack = 2
}

export default class Vehicle extends Entity {
    private seats: VehicleSeats
    private health: VehicleHealth

    public static FromHandle(this: void, handle: EntityHandle) {
        return new Vehicle(handle)
    }

    public static SpawnByName(this: void, name: string, pos?: Vector3, heading?: number) {
        const hash = util.joaat(name)
        return Vehicle.Spawn(hash, pos, heading)
    }

    public static Spawn(this: void, model: Hash, pos?: Vector3, heading: number = 0) {
        STREAMING.REQUEST_MODEL(model)
        while(!STREAMING.HAS_MODEL_LOADED(model)) {
            util.yield()
        }
        if(pos == undefined) pos = { x: 0, y: 0, z: 0}
        const handle = entities.create_vehicle(model, pos, heading)
        return new Vehicle(handle, pos, heading)
    }

    private constructor(handle: number, pos: Vector3 = {x: 0, y: 0, z: 0}, heading = 0) {
        super(handle)
        this.health = new VehicleHealth(this)
        this.seats = new VehicleSeats(this)
    }

    public get Health() {
        return this.health
    }

    public get Seats() {
        return this.seats
    }

    public get EngineRunning() {
        return VEHICLE.GET_IS_VEHICLE_ENGINE_RUNNING(this.handle)
    }

    public StartEngine(instant: boolean = true, noAutostart = false) {
        this.SetEngineState(true, instant, noAutostart)
    }

    public StopEngine(noAutostart = false) {
        this.SetEngineState(false, false, noAutostart)
    }

    public SetEngineState(state: boolean, instantly = true, noAutostart = false) {
        VEHICLE.SET_VEHICLE_ENGINE_ON(this.handle, state, instantly, noAutostart)
    }

    public get LicensePlateText() {
        return VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(this.handle)
    }

    public set LicensePlateText(text: string) {
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(this.handle, text)
    }

    public get LicensePlateDesign() {
        return VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(this.handle)
    }

    public set LicensePlateDesign(design: LicensePlateDesign) {
        VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT_INDEX(this.handle, design)
    }

    public get LicensePlatePositions(): LicensePlatePosition {
        return VEHICLE.GET_VEHICLE_PLATE_TYPE(this.handle)
    }

}

export enum VehicleSeat {
    FrontDriverSide = -1,
    FrontPassengerSide = 0,
    BackDriverSide = 1,
    BackPassengerSide = 2,
    AltFrontDriverSide = 3,
    AltFrontPassengerSide = 4,
    AltBackDriverSide = 5,
    AltBackPassengerSide = 6,
};

export enum VehicleExitFlags {
    Normal = 1,
    TeleportOutside = 16,
    NormalSlow = 64,
    DoorKeptOpen = 256,
    BailFromVehicle = 4160,
    PassengerSideExit = 262144,
}

export enum VehicleEnterFlag {
    Normal = 1, 
    TeleportTo = 3,
    PullFromSeat = 8,
    TeleportInto = 16
}

export class VehicleHealth {
    private vehicle: Vehicle;
    constructor(vehicle: Vehicle) {
        this.vehicle = vehicle
    }

    public get EngineOnFire() {
        // @ts-ignore
        return VEHICLE._IS_VEHICLE_ENGINE_ON_FIRE(this.vehicle.Handle)
    }

    public get Body() {
        return VEHICLE.GET_VEHICLE_HEALTH_PERCENTAGE(this.vehicle.Handle, 0, 0, 0 , 0, 0, 0)
    }

    public set Body(health: number) {
        VEHICLE.SET_VEHICLE_BODY_HEALTH(this.vehicle.Handle, health)
    }

    public get Fuel() {
        return VEHICLE.GET_VEHICLE_PETROL_TANK_HEALTH(this.vehicle.Handle)
    }

    public set Fuel(health: number) {
        VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(this.vehicle.Handle, health)
    }

    public get Engine() {
        return VEHICLE.GET_VEHICLE_ENGINE_HEALTH(this.vehicle.Handle)
    }

    public set Engine(health: number) {
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(this.vehicle.Handle, health)
    }

    public get HeliMainRotor() {
        return VEHICLE.GET_HELI_MAIN_ROTOR_HEALTH(this.vehicle.Handle)
    }

    public set HeliMainRotor(health: number) {
        VEHICLE.SET_HELI_MAIN_ROTOR_HEALTH(this.vehicle.Handle, health)
    }

    public get HeliTailRotor() {
        return VEHICLE.GET_HELI_TAIL_ROTOR_HEALTH(this.vehicle.Handle)
    }

    public set HeliTailRotor(health: number) {
        VEHICLE.SET_HELI_TAIL_ROTOR_HEALTH(this.vehicle.Handle, health)
    }

    public get HeliTailBoom() {
        return VEHICLE.GET_HELI_TAIL_BOOM_HEALTH(this.vehicle.Handle)
    }


    public get PropellersIntact() {
        return VEHICLE.ARE_PLANE_PROPELLERS_INTACT(this.vehicle.Handle)
    }

    public set PropellersHealth(health: number) {
        VEHICLE.SET_PLANE_PROPELLER_HEALTH(this.vehicle.Handle, health)
    }

    public GetTires() {
        const healths = []
        for(let i = 0; i < 7; i++) {
            healths.push(VEHICLE.GET_TYRE_HEALTH(this.vehicle.Handle, i))
        }
        return healths
    }

    public SetTire(wheelIndex: number, health: number) {
        VEHICLE.SET_TYRE_HEALTH(this.vehicle.Handle, wheelIndex, health)
    }
}


export class VehicleSeats {
    private vehicle: Vehicle;
    constructor(vehicle: Vehicle) {
        this.vehicle = vehicle
    }

    public get AreFull() {
        return !VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(this.vehicle.Handle)
    }

    public get Max() {
        return VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(this.vehicle.Model)
    }

    public GetLastPed(seat: VehicleSeat): Ped | null {
        const ped = VEHICLE.GET_LAST_PED_IN_VEHICLE_SEAT(this.vehicle.Handle, seat)
        if(ped == 0) return null
        return Ped.FromHandle(ped)
    }

    public GetPedInSeat(seat: VehicleSeat): Ped | null {
        const ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(this.vehicle.Handle, seat, false)
        if(ped == 0) return null
        return Ped.FromHandle(ped)
    }

    public IsSeatFree(seat: VehicleSeat): boolean {
        return VEHICLE.IS_VEHICLE_SEAT_FREE(this.vehicle.Handle, seat, false)
    }

    public CanEnterSeat(seat: VehicleSeat, ped: Ped, side = false) {
        // return VEHICLE._IS_VEHICLE_SEAT_ACCESSIBLE(ped.Handle, this.vehicle.Handle, seat, side, true)
    }

    public CanExitSeat(seat: VehicleSeat, ped: Ped, side = false) {
        // return VEHICLE._IS_VEHICLE_SEAT_ACCESSIBLE(ped.Handle, this.vehicle.Handle, seat, side, false)
    }

    public ExitSeat(ped: Ped, flags = VehicleExitFlags.Normal) {
        TASK.TASK_LEAVE_VEHICLE(ped.Handle, this.vehicle.Handle, flags)
    }

    public EnterSeat(ped: Ped, seat: VehicleSeat, timeout: number, speed: number, flag = VehicleEnterFlag.Normal) {
        TASK.TASK_ENTER_VEHICLE(ped.Handle, this.vehicle.Handle, timeout, seat, speed, flag, "");
    }

}


class Ped extends Entity {

    public static FromHandle(this: void, handle: EntityHandle) {
        return new Ped(handle)
    }

    constructor(handle: EntityHandle) {
        super(handle)
    }
}