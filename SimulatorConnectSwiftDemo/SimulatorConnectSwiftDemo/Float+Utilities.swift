//
//  Float+Utilities.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 11/30/21.
//

import Foundation

extension Float {
   var bytes: [UInt8] {
       withUnsafeBytes(of: self, Array.init)
   }
}
