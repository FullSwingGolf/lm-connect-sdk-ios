//
//  ViewController.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 5/18/21.
//

import UIKit
import SimulatorConnect

enum SessionEnvironment: Int, StringCase {
    case outdoor = 0
    case screen
    case net
    
    public var description: String {
        switch self {
        case .net: return "Net"
        case .screen: return "Screen"
        case .outdoor: return "Outdoor"
        }
    }
    
    var render: String {
        switch self {
        case .outdoor:
            return "Outdoor"
        case .screen:
            return "Screen"
        case .net:
            return "Net"
        }
    }
    
    var location: LMLocation {
        switch self {
        case .screen:
            return .screen
        case .net:
            return .net
        case .outdoor:
            return .outdoorRange
        }
    }
    
    static func fromLMLocation(location: LMLocation) -> SessionEnvironment {
        switch location {
        case .screen:
            return .screen
        case .net:
            return .net
        default:
            return .outdoor
        }
    }
}

final class ViewController: UIViewController
{
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var clubSelectLabel: UILabel!
    @IBOutlet weak var locationSelectLabel: UILabel!
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
    
    @IBOutlet weak var locationSelect: UIPickerView!
    @IBOutlet weak var clubSelect: UIPickerView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var distanceSelect: UISlider!
    
    @IBOutlet weak var shortShotLabel: UILabel!
    @IBOutlet weak var shortShot: UISwitch!
    
    @IBOutlet weak var normalizedLabel: UILabel!
    @IBOutlet weak var normalized: UISwitch!
    
    private var connect: FSGConnect!
    private var data: AppData!
    private var lastShot: ShotEvent?
    private var lastShotNormalized: ShotEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI initialization
        navigationItem.backButtonTitle = "Disconnect"
        statusActivity.isHidden = true
        statusLabel.text = ""
        normalized.setOn(true, animated: false)
        
        // Do any additional setup after loading the view.
        connect = FSGConnect.shared
        data = AppData.shared
        
        if let device = data.device {
            device.setConfiguration(id: .location, value: Data([UInt8(LMLocation.outdoorRange.rawValue)])) { success, error in
                print("Location Updated")
            }
            device.setConfiguration(id: .normalizedEnabled, value: Data([UInt8(1)])) { success, error in
                print("Normalized Updated")
            }
            device.getConfiguration(id: .firmwareVersion) { data, error in
                print("Firmware Version \(data)")
            }
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
    
    // Update distance to pin
    @IBAction func distanceValueChanged(_ sender: Any)
    {
        self.distanceValueLabel.text = "\(Int(self.distanceSelect.value))"
        
        if let device = data.device {
            device.setConfiguration(id: .autoShortShotEnabled, value: Data([0x1])) { success, error in
                print("Auto Short Shot Updated ")
            }
            device.setConfiguration(id: .distanceToPin, value: Data(distanceSelect.value.bytes)) { success, error in
                print("Distance Updated")
            }
        }
    }
    
    // Toggle Short shot on/off
    @IBAction func shortShotValueChanged(_ sender: Any)
    {
        if let device = data.device {
            device.setConfiguration(id: .autoShortShotEnabled, value: Data([0x0])) { success, error in
                print("Auto Short Shot Updated ")
            }
            device.setConfiguration(id: .shortShot, value: Data([self.shortShot.isOn ? 0x1 : 0x0])) { success, error in
                print("Short Shot Updated ")
            }
        }
    }
    
    // Toggle Normalized data on/off
    @IBAction func normalizedValueChanged(_ sender: Any)
    {
        if let device = data.device {
            device.setConfiguration(id: .normalizedEnabled, value: Data([self.normalized.isOn ? 0x1 : 0x0])) { success, error in
                print("Normalized Updated ")
            }
        }
        if self.normalized.isOn {
            guard let shot = lastShotNormalized else { return }
            displayShot(shot)
        } else {
            guard let shot = lastShot else { return }
            displayShot(shot)
        }
    }
    
    // Device connected, do initial config and UI setup
    private func deviceConnection(connected: Bool, error: Error?)
    {
        if connected {
            data.device?.delegate = self
            data.device?.arm(completion: self.armComplete(success:error:))
//            data.device?.setConfiguration(id: .dataDisplay, value: Data([UInt8(LMDataDisplay.multiDataPoint.rawValue)])) { success, error in
//                print("Data Display Updated ")
//            }
            
            title = data.device?.name
            
            statusLabel.text = "Connected"
            statusActivity.isHidden = true
            
            self.clubSelect.isHidden = false
            self.clubSelectLabel.isHidden = false
            
            self.locationSelect.isHidden = false
            self.locationSelectLabel.isHidden = false
            
            self.distanceLabel.isHidden = false
            self.distanceValueLabel.isHidden = false
            self.distanceSelect.isHidden = false
            
            self.shortShot.isHidden = false
            self.shortShotLabel.isHidden = false
            
            self.normalized.isHidden = false
            self.normalizedLabel.isHidden = false
            
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
    
    // Device disconnected, update UI
    private func deviceDisconnection(disconnected: Bool, error: Error?)
    {
        if disconnected {
            statusLabel.text = "Disconnected"
            
            self.deviceLabel.text = ""
            self.deviceLabel.isHidden = true
            
            self.clubSelect.isHidden = true
            self.clubSelectLabel.isHidden = true
            
            self.locationSelect.isHidden = true
            self.locationSelectLabel.isHidden = true
            
            self.distanceLabel.isHidden = true
            self.distanceValueLabel.isHidden = true
            self.distanceSelect.isHidden = true
            
            self.shortShot.isHidden = true
            self.shortShotLabel.isHidden = true
            
            self.normalized.isHidden = true
            self.normalizedLabel.isHidden = true
            
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
    
    // Arming complete, can do post setup here.
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
        
        if event.type == .launch {
            print("Launch Data")
            lastShot = event
        }
        if event.type == .flight {
            print("Flight Data")
            lastShot = event
        }
        if event.type == .normalized {
            print("Normalized Data")
            lastShotNormalized = event
        }
        
        displayShot(event)
    }
    
    func displayShot(_ event: ShotEvent)
    {
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
            statusLabel.text = "NotReady"
            break
        case .waitingForArm:
            statusLabel.text = "WaitingForArm"
            break
        case .readyBallFound:
            statusLabel.text = "ReadyBallFound"
            break
        case .tracking:
            statusLabel.text = "Tracking"
            break
        @unknown default:
            break
        }
        print("StateChange: \(statusLabel.text)")
    }

    // Sample config de-serialize
    func configurationChanged(_ event: ConfigChangedEvent)
    {
        switch event.configId {
        case .autoArm:
            let autoArm:Bool = (event.value[0] != 0)
            print("AutoArm: \(autoArm)")
        case .club:
            guard let clubType = LMClubType.init(rawValue: Int(event.value[0])) else {
                print("Bad Club Value")
                return
            }
            print("Club: \(clubType)")
            // FIXME: UI not updating
            self.clubSelect.selectRow(clubType.rawValue, inComponent: 0, animated: true)
            self.clubSelect.reloadAllComponents()
        case .dataDisplay:
            guard let dataDisplay = LMDataDisplay.init(rawValue: Int(event.value[0])) else {
                print("Bad Data Display Value")
                return
            }
            print("Data Display: \(dataDisplay)")
        case .screenLayout:
            var layout: [Int] = []
            for val in event.value {
                guard let dataPoint = LMDataType.init(rawValue: Int(val)) else {
                    print("Bad Data Point Value")
                    return
                }
                layout.append(dataPoint.rawValue)
            }
            print("Screen Layout: \(layout)")
        case .distanceUnits:
            guard let distance = LMDistanceUnits.init(rawValue: Int(event.value[0])) else {
                print("Bad Distance Unit Value")
                return
            }
            print("Disance Units: \(distance)")
        case .apexUnits:
            guard let apex = LMApexUnits.init(rawValue: Int(event.value[0])) else {
                print("Bad apex Unit Value")
                return
            }
            print("Apex Units: \(apex)")
        case .speedUnits:
            guard let speed = LMSpeedUnit.init(rawValue: Int(event.value[0])) else {
                print("Bad speed Unit Value")
                return
            }
            print("Speed Units: \(speed)")
        case .elevationUnits:
            guard let elevation = LMApexUnits.init(rawValue: Int(event.value[0])) else {
                print("Bad elevation Unit Value")
                return
            }
            print("Elevation Units: \(elevation)")
        case .temperatureUnits:
            guard let temp = TemperatureUnit.init(rawValue: Int(event.value[0])) else {
                print("Bad temperature Unit Value")
                return
            }
            print("Temperature Units: \(temp)")
        case .location:
            guard let location = LMLocation.init(rawValue: Int(event.value[0])) else {
                print("Bad Location Value")
                return
            }
            print("Location: \(location)")
            let sessionLocation = SessionEnvironment.fromLMLocation(location: location)
            // FIXME: UI not updating
            self.locationSelect.selectRow(sessionLocation.rawValue, inComponent: 0, animated: true)
            self.locationSelect.reloadAllComponents()
        case .elevation:
            let elevation:Float = event.value.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float.self)
            }
            print("Elevation: \(elevation)")
        case .temperature:
            let temperature:Float = event.value.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float.self)
            }
            print("Temperature: \(temperature)")
        case .autoShortShotEnabled:
            let autoChip:Bool = (event.value[0] != 0)
            print("Auto Short Shot Enabled: \(autoChip)")
        case .shortShot:
            let chipMode:Bool = (event.value[0] != 0)
            print("Shot Shot Enabled: \(chipMode)")
        case .distanceToPin:
            let distance:Float = event.value.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float.self)
            }
            print("Distance To Pin: \(distance)")
        case .normalizedEnabled:
            let enabled:Bool = (event.value[0] != 0)
            print("Normalized Enabled: \(enabled)")
        case .normalizedElevation:
            let elevation:Float = event.value.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float.self)
            }
            print("Normalized Elevation: \(elevation)")
        case .normalizedTemperature:
            let temperature:Float = event.value.withUnsafeBytes {
                $0.load(fromByteOffset: 0, as: Float.self)
            }
            print("Normalized Temperature: \(temperature)")
        case .normalizedIndoorBallType:
            guard let ball = BallType.init(rawValue: Int(event.value[0])) else {
                print("Bad Ball Type Value")
                return
            }
            print("Normalized Indoor Ball Type: \(ball)")
        case .normalizedOutdoorBallType:
            guard let ball = BallType.init(rawValue: Int(event.value[0])) else {
                print("Bad Ball Type Value")
                return
            }
            print("Normalized Outdoor Ball Type: \(ball)")
        case .videoRecordingEnabled:
            let enabled:Bool = (event.value[0] != 0)
            print("Video Recording Enabled: \(enabled)")
        case .firmwareVersion:
            guard let version = String(data: event.value, encoding: .utf8) else {
                print("Bad Firmware Version Value")
                return
            }
            print("Firmware Version updated: \(version)")
        case .radarVersion:
            guard let version = String(data: event.value, encoding: .utf8) else {
                print("Bad Radar Version Value")
                return
            }
            print("Radar Version updated: \(version)")
        @unknown default:
            print("Unknown config: \(event.configId)")
        }
        print("ConfigChange: \(event.configId)")
    }
    
    func batteryLevelChanged(_ level: UInt8)
    {
        
    }
    
    func shortShotChanged(_ enabled: Bool)
    {
        self.shortShot.isOn = enabled
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
        if (pickerView == clubSelect) {
            return LMClubType.caseStrings.count
        } else {
            // LMLocation: Screen, Net, Outdoor
            return SessionEnvironment.caseStrings.count
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if (pickerView == clubSelect) {
            return LMClubType.caseStrings[row]
        } else {
            // Screen, Net, Outdoor
            return SessionEnvironment.caseStrings[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (pickerView == clubSelect) {
            let clubType = LMClubType.allCases[row]
            print("PickerView Selected \(row) \(LMClubType.caseStrings[row]) \(clubType.description)")
            data.device?.setConfiguration(id: .club, value: Data([(UInt8)(clubType.rawValue)])) { success, error in
                print("Club Updated \(clubType.description)")
            }
        } else {
            let location = SessionEnvironment.allCases[row]
            print("PickerView Selected \(row) \(SessionEnvironment.caseStrings[row]) \(location.description)")
            data.device?.setConfiguration(id: .location, value: Data([(UInt8)(location.location.rawValue)])) { success, error in
                print("Location Updated \(location.description)")
            }
        }
    }
}
