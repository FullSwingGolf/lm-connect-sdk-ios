//
//  AppData.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 5/25/21.
//

import Foundation
import SimulatorConnect

public class AppData: NSObject
{
    static public var shared: AppData = AppData()
    
    public var authCode: String?
    public var devices: [LMDevice] = []
    public var device: LMDevice?
    public var shots: [LMShot] = []
    public var clubType: LMClubType = .unknown
    public var connected: Bool
    
    public override init()
    {
        connected = false
    }
    
    deinit
    {
    }
}
