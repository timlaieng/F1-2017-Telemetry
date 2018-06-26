//
//  DataPacket.swift
//  UDPTest
//
//  Created by Danny Grob on 09/07/2017.
//  Copyright © 2017 DigitalFactor. All rights reserved.
//

import UIKit

extension UInt16 {
    init?(bytes: [UInt8]) {
        if bytes.count != 2 {
            return nil
        }
        
        var value: UInt16 = 0
        for byte in bytes.reversed() {
            value = value << 8
            value = value | UInt16(byte)
        }
        self = value
    }
}

//TODO: Ask Danny about this UInt32 extension.
extension UInt32 {
    init?(bytes: [UInt8]) {
        if bytes.count != 4 || bytes.count != 1 {
            return nil
        }
        
        var value: UInt32 = 0
        for byte in bytes.reversed() {
            value = value << 8
            value = value | UInt32(byte)
        }
        self = value
    }
}

extension UInt8 {
    init?(bytes: [UInt8]) {
        if bytes.count != 1 {
            return nil
        }
        
        var value: UInt8 = 0
        for byte in bytes.reversed() {
            value = value << 8 //what bitshift would be required here?
            value = value | UInt8(byte)
        }
        self = value
    }
}

extension Float {
    init?(bytes: [UInt8]) {
        //var bytes:Array<UInt8> = [allBytes[0], allBytes[1], allBytes[2], allBytes[3]] //19.20000
        var f:Float = 0.0
        memcpy(&f, bytes, 4)
        self = f
    }
}


/*
// Note that variable names are the same as indicated in Codemasters forum.
// http://forums.codemasters.com/discussion/53139/f1-2017-d-box-and-udp-output-specification/p1
*/

class CarUDPData {
    
    
    static var modernLastNames: [UInt8:String] = [0:"Vettel", 1:"Kvyat", 2:"Alonso", 3:"Massa", 5:"Perez", 6:"Räikkönen",
                                                  7:"Grosjean", 9:"Hamilton", 10:"Hulkenberg", 14:"Magnussen", 15:"Bottas",
                                                  16:"Ricciardo", 18:"Ericsson", 20:"Palmer", 22:"Verstappen", 23:"Sainz",
                                                  31:"Wehrlein",33:"Ocon", 34:"Vandoorne", 35:"Stroll"]
    
    static var modernFirstNames: [UInt8:String] = [0:"Sebastian", 1:"Daniil", 2:"Fernando", 3:"Felipe", 5:"Sergio", 6:"Kimi",
                                                   7:"Romain", 9:"Lewis", 10:"Nico", 14:"Kevin", 15:"Valtteri", 16:"Daniel",
                                                   18:"Marcus", 20:"Jolyon", 22:"Max", 23:"Carlos", 31:"Pascal",33:"Esteban",
                                                   34:"Stoffel", 35:"Lance"]
    
    static var classicLastNames:[UInt8:String] = [0:"Michalski", 1: "Giles", 2:"Correia", 3:"Levasseur", 4: "Forest", 5: "Moreno",
                                                  6: "Saari", 7: "Belousov", 8: "Kaufmann", 9: "Atiyeh", 10: "Clarke", 14:"Laursen",
                                                  15: "Coppens", 16: "Murray", 18: "Calabresi", 20: "Letourneau", 22: "Izum", 23:"Barnes",
                                                  24: "Schiffer", 31: "Nieves", 32: "Visser", 33: "Waldmuller", 34:"Quesada", 68:"Roth"]
    static var classicFirstNames:[UInt8:String] = [0: "Klimek", 1: "Martin", 2:"Igor", 3:"Sophie", 4: "Alain", 5: "Santiago",
                                                   6: "Esto", 7: "Peter", 8: "Lars", 9: "Yasar", 10: "Howard", 14: "Marie",
                                                   15: "Benjamin", 16: "Alex", 18: "Callisto", 20: "Jay", 22: "Naota", 23: "Arron",
                                                   24: "Jonas", 31: "Flavio", 32: "Noah", 33: "Gert", 34: "Julian", 68: "Lucas"]
    
    var m_teamId:UInt8? = nil;
    var isClassic:Bool?
    static var modernTeams:[UInt8:String] = [0: "Red Bull", 1: "Ferrari", 2: "McLaren", 3: "Renault", 4: "Mercedes", 5: "Sauber", 6: "Force India", 7: "Williams", 8: "Toro Rosso", 11: "Haas"]
    
    static var classicTeams:[UInt8:String] = [0: "Williams 1992", 1: "McLaren 1988", 2: "McLaren 2008", 3: "Ferrari 2004", 4: "Ferrari 1995", 5: "Ferrari 2007", 6: "McLaren 1998",
                                              7: "Williams 1996", 8: "Renault 2006", 10: "Ferrari 2002", 11: "Redbull 2010", 12: "McLaren 1991"]
    
    
    var m_tyreCompound:UInt8? = nil;
    static var tyreCompounds: [UInt8:String] = [0: "US", 1:"SS", 2:"S", 3:"M", 4:"H", 5:"I", 6:"W"]
    
    
    var m_worldPosition:[Float]? = nil; // world co-ordinates of vehicle
    var m_lastLapTime:Float? = nil;
    var m_currentLapTime:Float? = nil;
    var m_bestLapTime:Float? = nil;
    var m_sector1Time:Float? = nil;
    var m_sector2Time:Float? = nil;
    var m_lapDistance:Float? = nil;
    var m_driverId:UInt8? = nil;
    var m_carPosition:UInt8? = nil;     // UPDATED: track positions of vehicle
    var m_currentLapNum:UInt8? = nil;
    var m_inPits:UInt8? = nil;           // 0 = none, 1 = pitting, 2 = in pit area
    var m_sector:UInt8? = nil;           // 0 = sector1, 1 = sector2, 2 = sector3
    var m_currentLapInvalid:UInt8? = nil; // current lap invalid - 0 = valid, 1 = invalid
    var m_penalties:UInt8? = nil;  // NEW: accumulated time penalties in seconds to be added
};

class UDPPacket {
    var m_time:Float? = nil;
    var  m_lapTime:Float? = nil;
    var  m_lapDistance:Float? = nil;
    var  m_totalDistance:Float? = nil;
    var  m_x:Float? = nil;    // World space position
    var  m_y:Float? = nil;     //World space position
    var  m_z:Float? = nil;     //World space position
    var  m_speed:Float? = nil;   //  Speed of car in m/s
    var  m_xv:Float? = nil;     //Velocity in world space
    var  m_yv:Float? = nil;     //Velocity in world space
    var  m_zv:Float? = nil;     //Velocity in world space
    var  m_xr:Float? = nil;    // World space right direction
    var  m_yr:Float? = nil;     //World space right direction
    var  m_zr:Float? = nil;     //World space right direction
    var  m_xd:Float? = nil;     //World space forward direction
    var  m_yd:Float? = nil;    // World space forward direction
    var  m_zd:Float? = nil;    // World space forward direction
    var m_susp_pos:[Float]? = nil;    // Note: All wheel arrays have the order:
    var  m_susp_vel:[Float]? = nil;    // RL, RR, FL, FR
    var  m_wheel_speed:[Float]? = nil;
    var  m_throttle:Float? = nil;
    var  m_steer:Float? = nil;
    var  m_brake:Float? = nil;
    var  m_clutch:Float? = nil;
    var  m_gear:Float? = nil;
    var  m_gforce_lat:Float? = nil;
    var  m_gforce_lon:Float? = nil;
    var  m_lap:Float? = nil;
    var  m_engineRate:Float? = nil;
    var  m_sli_pro_native_support:Float? = nil; //    SLI Pro support
    var  m_car_position:Float? = nil;   //  car race position
    var  m_kers_level:Float? = nil;     //kers energy left
    var  m_kers_max_level:Float? = nil;   //  kers maximum energy
    var  m_drs:Float? = nil;    // 0 = off, 1 = on
    var  m_traction_control:Float? = nil;    // 0 (off) - 2 (high)
    var  m_anti_lock_brakes:Float? = nil;  //   0 (off) - 1 (on)
    var  m_fuel_in_tank:Float? = nil;    // current fuel mass
    var  m_fuel_capacity:Float? = nil;  //   fuel capacity
    var  m_in_pits:Float? = nil;   //  0 = none, 1 = pitting, 2 = in pit area
    var  m_sector:Float? = nil;  //   0 = sector1, 1 = sector2, 2 = sector3
    var  m_sector1_time:Float? = nil;   //  time of sector1 (or 0)
    var  m_sector2_time:Float? = nil;   //  time of sector2 (or 0)
    var  m_brakes_temp:[Float]? = nil;   //  brakes temperature (centigrade)
    var  m_tyres_pressure:[Float]? = nil;  //   tyres pressure PSI
    var  m_team_info:Float? = nil;  //   Team ID
    /*
     2017 Team
     Team ID
     0 Redbull, 1 Ferrari, 2 McLaren, 3 Renault, 4 Mercedes, 5 Sauber, 6 Force India, 7 Williams, 8 Toro Rosso, 11 Haas
     
     Classic Team
     Team ID
     0 Williams 1992, 1 McLaren 1988, 2 McLaren 2008, 3 Ferrari 2004, 4 Ferrari 1995, 5 Ferrari 2007, 6 McLaren 1998
     7 Williams 1996, 8 Renault 2006, 10 Ferrari 2002, 11 Redbull 2010, 12 McLaren 1991
     */
    
    var  m_total_laps:Float? = nil;   //  total number of laps in this race
    var  m_track_size:Float? = nil;   //  track size meters
    var  m_last_lap_time:Float? = nil;  //   last lap time
    var  m_max_rpm:Float? = nil;  //   cars max RPM, at which point the rev limiter will kick in
    var  m_idle_rpm:Float? = nil;  //   cars idle RPM
    var  m_max_gears:Float? = nil;  //   maximum number of gears
    var  m_sessionType:Float? = nil;  //   0 = unknown, 1 = practice, 2 = qualifying, 3 = race
    var  m_drsAllowed:Float? = nil;   //  0 = not allowed, 1 = allowed, -1 = invalid / unknown
    var  m_track_number:Float? = nil;  //   -1 for unknown, see below for rest.
    /*
     Track Number
     0 Melbourne, 1 Sepang, 2 Shanghai, 3 Sakhir (Bahrain), 4 Catalunya, 5 Monaco, 6 Montreal, 7 Silverstone, 8 Hockenheim
     9 Hungaroring, 10 Spa, 11 Monza, 12 Singapore, 13 Suzuka, 14 Abu Dhabi, 15 Texas, 16 Brazil, 17 Austria
     18 Sochi, 19 Mexico, 20 Baku (Azerbaijan), 21 Sakhir Short, 22 Silverstone Short, 23 Texas Short, 24 Suzuka Short
     */
    
    var  m_vehicleFIAFlags:Float? = nil;   //  -1 = invalid/unknown, 0 = none, 1 = green, 2 = blue, 3 = yellow, 4 = red
    var  m_era:Float? = nil;                 //        era, 2017 (modern) or 1980 (classic)
    var  m_engine_temperature:Float? = nil;   //    engine temperature (centigrade)
    var  m_gforce_vert:Float? = nil;   //  vertical g-force component
    var  m_ang_vel_x:Float? = nil;    // angular velocity x-component
    var  m_ang_vel_y:Float? = nil;   //  angular velocity y-component
    var  m_ang_vel_z:Float? = nil;   //  angular velocity z-component
    
    //bytes data:
    var  m_tyres_temperature:[UInt8]? = nil  //   tyres temperature (centigrade)
    var  m_tyres_wear:[UInt8]? = nil;   //  tyre wear percentage
    var  m_tyre_compound:UInt8? = nil  //   compound of tyre – 0 = ultra soft, 1 = super soft, 2 = soft, 3 = medium, 4 = hard, 5 = inter, 6 = wet
    var  m_front_brake_bias:UInt8?  = nil  //       front brake bias (percentage)
    var  m_fuel_mix:UInt8?   = nil          //      fuel mix - 0 = lean, 1 = standard, 2 = rich, 3 = max
    var  m_currentLapInvalid:UInt8?  = nil  //      current lap invalid - 0 = valid, 1 = invalid
    var  m_tyres_damage:[UInt8]? = nil;  //   tyre damage (percentage)
    var  m_front_left_wing_damage:UInt8? = nil //   front left wing damage (percentage)
    var  m_front_right_wing_damage:UInt8? = nil  //   front right wing damage (percentage)
    var  m_rear_wing_damage:UInt8? = nil   //  rear wing damage (percentage)
    var  m_engine_damage:UInt8? = nil   //  engine damage (percentage)
    var  m_gear_box_damage:UInt8? = nil //   gear box damage (percentage)
    var  m_exhaust_damage:UInt8? = nil  //   exhaust damage (percentage)
    var  m_pit_limiter_status:UInt8? = nil   //  pit limiter status – 0 = off, 1 = on
    var  m_pit_speed_limit:UInt8? = nil   //  pit speed limit in
    var  m_session_time_left:Float? = nil;  // NEW: time left in session in seconds
    var m_rev_lights_percent:UInt8? = nil;  // NEW: rev lights indicator (percentage)
    var m_is_spectating:UInt8? = nil;  // NEW: whether the player is spectating
    var m_spectator_car_index: UInt8? = nil;
    
    // Car data
    var m_num_cars:UInt8? = nil               //   number of cars in data
    var m_player_car_index:UInt8? = nil         //    index of player's car in the array
    var m_car_data:[CarUDPData] = []; // Array length 20, CarUDPData for all cars on track
    var m_yaw:Float? = nil;  // NEW (v1.8)
    var m_pitch:Float? = nil;  // NEW (v1.8)
    var m_roll:Float? = nil;  // NEW (v1.8)
    var m_x_local_velocity:Float? = nil;          // NEW (v1.8) Velocity in local space
    var m_y_local_velocity:Float? = nil;          // NEW (v1.8) Velocity in local space
    var m_z_local_velocity:Float? = nil;          // NEW (v1.8) Velocity in local space
    var m_susp_acceleration:[Float]? = nil;   // array of 4 floats,  RL, RR, FL, FR
    var m_ang_acc_x:Float? = nil;                 // NEW (v1.8) angular acceleration x-component
    var m_ang_acc_y:Float? = nil;                 // NEW (v1.8) angular acceleration y-component
    var m_ang_acc_z:Float? = nil;
    
    
    func floatFromBytes(_ bytes:[UInt8], startIndex: Int, size: Int) -> Float {
        guard bytes.count > startIndex+size else {return 0}
        
        if let f = Float(bytes: Array(bytes[startIndex..<startIndex+size])) {
            return f
        }
        return 0
    }
    
    func intFromByte(_ bytes:[UInt8], startIndex: Int) -> UInt8 {
        guard bytes.count > startIndex+1 else {return 0}
    
        if let integer = UInt8(bytes: Array(bytes[startIndex..<startIndex+1])) {
            return integer
        }
        return 0
    }
    
    init(data: Data) {
        if data.count == 280 || data.count == 1289 {
            let allBytes = data.withUnsafeBytes {
                [UInt8](UnsafeBufferPointer(start: $0, count: data.count))
            }
            
            var index = 0
            let lengthCarDataArray = 20
            
            self.m_time             = floatFromBytes(allBytes, startIndex: 0, size: 4);index+=4;
            self.m_lapTime          = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_lapDistance      = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_totalDistance    = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_x                = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    // World space position
            self.m_y                = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    //World space position
            self.m_z                = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;     //World space position
            self.m_speed            = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4; //  Speed of car in MPH
            self.m_xv               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;     //Velocity in world space
            self.m_yv               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;     //Velocity in world space
            self.m_zv               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    //Velocity in world space
            self.m_xr               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   // World space right direction
            self.m_yr               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    //World space right direction
            self.m_zr               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;     //World space right direction
            self.m_xd               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;     //World space forward direction
            self.m_yd               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    // World space forward direction
            self.m_zd               = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   // World space forward direction
            self.m_susp_pos         =  [floatFromBytes(allBytes, startIndex: index, size: 4),
                                        floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                        floatFromBytes(allBytes, startIndex: index+8, size: 4),
                                        floatFromBytes(allBytes, startIndex: index+12, size: 4)];index+=16;    // Note: All wheel arrays have the order:
            // RL, RR, FL, FR
            self.m_susp_vel         = [floatFromBytes(allBytes, startIndex: index, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+8, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+12, size: 4)];index+=16;
            
            self.m_wheel_speed      = [floatFromBytes(allBytes, startIndex: index, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+8, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+12, size: 4)];index+=16;
            
            self.m_throttle         = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_steer            = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_brake            = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_clutch           = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_gear             = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_gforce_lat       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_gforce_lon       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_lap              = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_engineRate       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            self.m_sli_pro_native_support = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4; //    SLI Pro support
            self.m_car_position     = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //  car race position
            self.m_kers_level       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;     //kers energy left
            self.m_kers_max_level   = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  kers maximum energy
            self.m_drs              = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    // 0 = off, 1 = on
            self.m_traction_control = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    // 0 (off) - 2 (high)
            self.m_anti_lock_brakes = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   0 (off) - 1 (on)
            self.m_fuel_in_tank     = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    // current fuel mass
            self.m_fuel_capacity    = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   fuel capacity
            self.m_in_pits          = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  0 = none, 1 = pitting, 2 = in pit area
            self.m_sector           = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   0 = sector1, 1 = sector2, 2 = sector3
            self.m_sector1_time     = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  time of sector1 (or 0)
            self.m_sector2_time     = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  time of sector2 (or 0)
            
            self.m_brakes_temp      = [floatFromBytes(allBytes, startIndex: index, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+8, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+12, size: 4)];index+=16;   //  brakes temperature (centigrade)
            
            self.m_tyres_pressure   = [floatFromBytes(allBytes, startIndex: index, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+8, size: 4),
                                       floatFromBytes(allBytes, startIndex: index+12, size: 4)];index+=16;  //   tyres pressure PSI
            
            self.m_team_info        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   team ID
            self.m_total_laps       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  total number of laps in this race
            self.m_track_size       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  track size meters
            self.m_last_lap_time    = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   last lap time
            self.m_max_rpm          = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   cars max RPM, at which point the rev limiter will kick in
            self.m_idle_rpm         = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   cars idle RPM
            self.m_max_gears        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   maximum number of gears
            self.m_sessionType      = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   0 = unknown, 1 = practice, 2 = qualifying, 3 = race
            self.m_drsAllowed       = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  0 = not allowed, 1 = allowed, -1 = invalid / unknown
            self.m_track_number     = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  //   -1 for unknown, 0-21 for tracks
            self.m_vehicleFIAFlags  = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  -1 = invalid/unknown, 0 = none, 1 = green, 2 = blue, 3 = yellow, 4 = red
            self.m_era              = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;                 //        era, 2017 (modern) or 1980 (classic)
            self.m_engine_temperature = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //    engine temperature (centigrade)
            self.m_gforce_vert      = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  vertical g-force component
            self.m_ang_vel_x        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;    // angular velocity x-component
            self.m_ang_vel_y        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  angular velocity y-component
            self.m_ang_vel_z        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;   //  angular velocity z-component
            
            self.m_tyres_temperature = [allBytes[index],
                                        allBytes[index+1],
                                        allBytes[index+2],
                                        allBytes[index+3]];index+=4; //   tyres temperature (centigrade)
            self.m_tyres_wear       = [allBytes[index],
                                            allBytes[index+1],
                                            allBytes[index+2],
                                            allBytes[index+3]];index+=4//  tyre wear percentage
            self.m_tyre_compound    = allBytes[index];index+=1; //   compound of tyre – 0 = ultra soft, 1 = super soft, 2 = soft, 3 = medium, 4 = hard, 5 = inter, 6 = wet
            self.m_front_brake_bias = allBytes[index];index+=1;  //       front brake bias (percentage)
            self.m_fuel_mix         = allBytes[index];index+=1;       //      fuel mix - 0 = lean, 1 = standard, 2 = rich, 3 = max
            self.m_currentLapInvalid    = allBytes[index];index+=1;  //      current lap invalid - 0 = valid, 1 = invalid
            self.m_tyres_damage     = [allBytes[index],
                                       allBytes[index+1],
                                       allBytes[index+2],
                                       allBytes[index+3]];index+=4;  //   tyre damage (percentage)
            self.m_front_left_wing_damage   = allBytes[index];index+=1; //   front left wing damage (percentage)
            self.m_front_right_wing_damage  = allBytes[index];index+=1;  //   front right wing damage (percentage)
            self.m_rear_wing_damage = allBytes[index];index+=1;  //  rear wing damage (percentage)
            self.m_engine_damage    = allBytes[index];index+=1;  //  engine damage (percentage)
            self.m_gear_box_damage  = allBytes[index];index+=1; //   gear box damage (percentage)
            self.m_exhaust_damage   = allBytes[index];index+=1;  //   exhaust damage (percentage)
            self.m_pit_limiter_status   = allBytes[index];index+=1;   //  pit limiter status – 0 = off, 1 = on
            self.m_pit_speed_limit  = allBytes[index];index+=1; //  pit speed limit in
            self.m_session_time_left = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  // NEW: time left in session in seconds
            self.m_rev_lights_percent   = allBytes[index];index+=1;  // NEW: rev lights indicator (percentage)
            self.m_is_spectating    = allBytes[index];index+=1;  // NEW: whether the player is spectating
            self.m_spectator_car_index  = allBytes[index];index+=1;
            
            // Car data
            self.m_num_cars         = allBytes[index];index+=1              //   number of cars in data
            self.m_player_car_index = allBytes[index];index+=1        //    index of player's car in the array
            
            for _ in 0..<lengthCarDataArray {
                
                let car = CarUDPData()

                    car.isClassic = self.m_era != 2017
                    car.m_worldPosition = [floatFromBytes(allBytes, startIndex: index, size: 4),
                                                             floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                                             floatFromBytes(allBytes, startIndex: index+8, size: 4)];index+=12; // world co-ordinates of vehicle
                    car.m_lastLapTime = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
                    car.m_currentLapTime = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
                    car.m_bestLapTime = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
                    car.m_sector1Time = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
                    car.m_sector2Time = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
                    car.m_lapDistance = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
                    car.m_driverId = allBytes[index];index+=1; // Array length 20, CarUDPData for all cars on track
                    car.m_teamId = allBytes[index];index+=1;
                    car.m_carPosition = allBytes[index];index+=1;     // UPDATED: track positions of vehicle
                    car.m_currentLapNum = allBytes[index];index+=1;
                    car.m_tyreCompound = allBytes[index];index+=1;    // compound of tyre – 0 = ultra soft, 1 = super soft, 2 = soft, 3 = medium, 4 = hard, 5 = inter, 6 = wet
                    car.m_inPits = allBytes[index];index+=1;         // 0 = none, 1 = pitting, 2 = in pit area
                    car.m_sector = allBytes[index];index+=1;           // 0 = sector1, 1 = sector2, 2 = sector3
                    car.m_currentLapInvalid = allBytes[index];index+=1; // current lap invalid - 0 = valid, 1 = invalid
                    car.m_penalties = allBytes[index];index+=1;
                
                self.m_car_data.append(car)
                
                };
            
            self.m_yaw              = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  // NEW (v1.8)
            self.m_pitch            = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  // NEW (v1.8)
            self.m_roll             = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;  // NEW (v1.8)
            self.m_x_local_velocity = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4 ;          // NEW (v1.8) Velocity in local space
            self.m_y_local_velocity = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;          // NEW (v1.8) Velocity in local space
            self.m_z_local_velocity = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;          // NEW (v1.8) Velocity in local space
            self.m_susp_acceleration = [floatFromBytes(allBytes, startIndex: index, size: 4),
                                        floatFromBytes(allBytes, startIndex: index+4, size: 4),
                                        floatFromBytes(allBytes, startIndex: index+8, size: 4),
                                        floatFromBytes(allBytes, startIndex: index+12, size: 4)];index+=16;   // array of 4 floats,  RL, RR, FL, FR
            self.m_ang_acc_x        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;                 // NEW (v1.8) angular acceleration x-component
            self.m_ang_acc_y        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;                 // NEW (v1.8) angular acceleration y-component
            self.m_ang_acc_z        = floatFromBytes(allBytes, startIndex: index, size: 4);index+=4;
            
        } else {
            self.m_time = 0
            self.m_ang_vel_x = 0
        }
    }
}


