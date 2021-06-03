//
//  ViewController.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 5/18/21.
//

import UIKit
import SimulatorConnect

final class ViewController: UIViewController
{
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var clubSelectLabel: UILabel!
    @IBOutlet weak var statusActivity: UIActivityIndicatorView!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var carryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var spinRateLabel: UILabel!
    @IBOutlet weak var spinAxisLabel: UILabel!
    
    @IBOutlet weak var ballSpeedLabel: UILabel!
    @IBOutlet weak var clubSpeedLabel: UILabel!
    
    @IBOutlet weak var smashLabel: UILabel!
    @IBOutlet weak var clubPathLabel: UILabel!
    
    @IBOutlet weak var faceAngleLabel: UILabel!
    @IBOutlet weak var faceToPathLabel: UILabel!
    
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var apexLabel: UILabel!
    
    @IBOutlet weak var launchLabel: UILabel!
    @IBOutlet weak var hLaunchLabel: UILabel!
    
    @IBOutlet weak var sideCarryLabel: UILabel!
    @IBOutlet weak var sideTotalLabel: UILabel!
    
    @IBOutlet weak var clubSelect: UIPickerView!
    
    private var connect: FSGConnect!
    private var data: AppData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI initialization
        navigationItem.backButtonTitle = "Disconnect"
        statusActivity.isHidden = true
        statusLabel.text = ""
        
        // Do any additional setup after loading the view.
        connect = FSGConnect.shared
        data = AppData.shared
        
        if let device = data.device {
            device.connect(completion: self.deviceConnection(connected:error:))
            statusActivity.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if let device = data.device {
            device.disconnect(completion: self.deviceConnection(connected:error:))
        }
    }
    
    // Connect button handler
    @IBAction func connectAction(_ sender: Any)
    {
        //self.connectToWifi(ssid: self.ssid, passphrase: self.passphrase)
        
        self.connectButton.isEnabled = false
        self.disconnectButton.isEnabled = false
    }
    
    // Disconnect button handler
    @IBAction func disconnectAction(_ sender: Any)
    {
        //self.disconnectFromWifi(ssid: self.ssid)
        //fsgBluetooth.disconnectFromDevice();
        
        self.connectButton.isEnabled = true
        self.disconnectButton.isEnabled = false
    }
    
    // Update button handler
    @IBAction func updateAction(_ sender: Any)
    {
        //self.pushSession()
        //self.pushConfig()
        //self.pushUpdate()
        
        //Test Live video streaming
        //self.showLiveVideo()
    }
    
    private func deviceConnection(connected: Bool, error: Error?)
    {
        if connected {
            data.device?.delegate = self
            data.device?.arm(completion: self.armComplete(success:error:))
            
            title = data.device?.name
            
            statusLabel.text = "Connected"
            statusActivity.isHidden = true
            
            self.clubSelect.isHidden = false
            self.clubSelectLabel.isHidden = false
            
            self.carryLabel.isHidden = false
            self.totalLabel.isHidden = false
            self.spinRateLabel.isHidden = false
            self.spinAxisLabel.isHidden = false
            self.ballSpeedLabel.isHidden = false
            self.clubSpeedLabel.isHidden = false
            self.smashLabel.isHidden = false
            self.clubPathLabel.isHidden = false
            self.faceAngleLabel.isHidden = false
            self.faceToPathLabel.isHidden = false
            self.attackLabel.isHidden = false
            self.apexLabel.isHidden = false
            self.launchLabel.isHidden = false
            self.hLaunchLabel.isHidden = false
            self.sideCarryLabel.isHidden = false
            self.sideTotalLabel.isHidden = false
        }
    }
    
    private func deviceDisconnection(disconnected: Bool, error: Error?)
    {
        if disconnected {
            statusLabel.text = "Disconnected"
            
            self.deviceLabel.text = ""
            self.deviceLabel.isHidden = true
            
            self.clubSelect.isHidden = true
            self.clubSelectLabel.isHidden = true
            
            self.connectButton.isHidden = true
            self.disconnectButton.isHidden = true
            self.connectButton.isEnabled = false
            self.disconnectButton.isEnabled = false
            
            self.carryLabel.isHidden = true
            self.totalLabel.isHidden = true
            self.spinRateLabel.isHidden = true
            self.spinAxisLabel.isHidden = true
            self.ballSpeedLabel.isHidden = true
            self.clubSpeedLabel.isHidden = true
            self.smashLabel.isHidden = true
            self.clubPathLabel.isHidden = true
            self.faceAngleLabel.isHidden = true
            self.faceToPathLabel.isHidden = true
            self.attackLabel.isHidden = true
            self.apexLabel.isHidden = true
            self.launchLabel.isHidden = true
            self.hLaunchLabel.isHidden = true
            self.sideCarryLabel.isHidden = true
            self.sideTotalLabel.isHidden = true
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func armComplete(success: Bool, error: Error?)
    {
        
    }
}

extension ViewController: LMDeviceDelegate
{
    func shotEvent(_ event: ShotEvent)
    {
        self.carryLabel.isHidden = false
        self.totalLabel.isHidden = false
        self.spinRateLabel.isHidden = false
        self.spinAxisLabel.isHidden = false
        self.ballSpeedLabel.isHidden = false
        self.clubSpeedLabel.isHidden = false
        self.smashLabel.isHidden = false
        self.clubPathLabel.isHidden = false
        self.faceAngleLabel.isHidden = false
        self.faceToPathLabel.isHidden = false
        self.attackLabel.isHidden = false
        self.apexLabel.isHidden = false
        self.launchLabel.isHidden = false
        self.hLaunchLabel.isHidden = false
        self.sideCarryLabel.isHidden = false
        self.sideTotalLabel.isHidden = false
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if let carry = event.shot?.carryDistance {
            self.carryLabel.text = "Carry: \(carry)"
        }else{
            self.carryLabel.text = "Carry: ---"
        }
        if let total = event.shot?.totalDistance {
            self.totalLabel.text = "Total: \(total)"
        }else{
            self.totalLabel.text = "Total: ---"
        }
        
        if let spin = event.shot?.spinRate {
            self.spinRateLabel.text = "Rate: \(spin)"
        }else{
            self.spinRateLabel.text = "Rate: ---"
        }
        if let axis = event.shot?.spinAxis {
            self.spinAxisLabel.text = "Axis: \(String(describing: formatter.string(from: axis)!))"
        }else{
            self.spinAxisLabel.text = "Axis: ---"
        }
        
        if let speed = event.shot?.ballSpeed {
            self.ballSpeedLabel.text = "Ball: \(String(describing: formatter.string(from: speed)!))"
        }else{
            self.ballSpeedLabel.text = "Ball: ---"
        }
        if let speed = event.shot?.clubSpeed {
            self.clubSpeedLabel.text = "Club: \(String(describing: formatter.string(from: speed)!))"
        }else{
            self.clubSpeedLabel.text = "Club: ---"
        }
        
        if let smash = event.shot?.smashFactor {
            self.smashLabel.text = "Smash: \(String(describing: formatter.string(from: smash)!))"
        }else{
            self.smashLabel.text = "Smash: ---"
        }
        if let path = event.shot?.clubPath {
            self.clubPathLabel.text = "Path: \(String(describing: formatter.string(from: path)!))"
        }else{
            self.clubPathLabel.text = "Path: ---"
        }
        
        if let face = event.shot?.faceAngle {
            self.faceAngleLabel.text = "Face: \(String(describing: formatter.string(from: face)!))"
        }else{
            self.faceAngleLabel.text = "Face: ---"
        }
        if let face = event.shot?.faceAngle {
            self.faceToPathLabel.text = "Face: \(String(describing: formatter.string(from: face)!))"
        }else{
            self.faceToPathLabel.text = "Face: ---"
        }
        
        if let attack = event.shot?.attackAngle {
            self.attackLabel.text = "Attack: \(String(describing: formatter.string(from: attack)!))"
        }else{
            self.attackLabel.text = "Attack: ---"
        }
        if let apex = event.shot?.apex {
            self.apexLabel.text = "Apex: \(String(describing: formatter.string(from: apex)!))"
        }else{
            self.apexLabel.text = "Apex: ---"
        }
        
        if let vert = event.shot?.vertlaunchAngle {
            self.launchLabel.text = "Vert: \(String(describing: formatter.string(from: vert)!))"
        }else{
            self.launchLabel.text = "Vert: ---"
        }
        if let horz = event.shot?.horizLaunchAngle {
            self.hLaunchLabel.text = "Horiz: \(String(describing: formatter.string(from: horz)!))"
        }else{
            self.hLaunchLabel.text = "Horiz: ---"
        }
        
        if let side = event.shot?.side {
            self.sideCarryLabel.text = "Side: \(side)"
        }else{
            self.sideCarryLabel.text = "Side: ---"
        }
        if let side = event.shot?.sideTotal {
            self.sideTotalLabel.text = "SideTotal: \(side)"
        }else{
            self.sideTotalLabel.text = "SideTotal: ---"
        }
        print("Point Data Updated")
    }
    
    func stateChangedEvent(_ event: StateChangedEvent)
    {
        switch event.state {
        case .disconnected:
            self.deviceDisconnection(disconnected: true, error: nil)
        case .notReady:
            break
        case .waitingForArm:
            break
        case .readyBallFound:
            break
        case .tracking:
            break
        @unknown default:
            break
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        LMClubType.caseStrings.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return LMClubType.caseStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let clubType = LMClubType.allCases[row]
        print("PickerView Selected \(row) \(LMClubType.caseStrings[row]) \(clubType.description)")
        data.device?.setConfiguration(id: .club, value: Data([(UInt8)(clubType.rawValue)])) { success, error in
            print("Club Updated \(clubType.description)")
        }
    }
}
