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
    @IBOutlet weak var statusActivity: UIActivityIndicatorView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var carryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var launchLabel: UILabel!
    @IBOutlet weak var backspinLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var axisLabel: UILabel!
    
    @IBOutlet weak var clubSelect: UISegmentedControl!
    
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
    
    @IBAction func clubSelectAction(_ sender: Any)
    {
        var clubType = LMClubType.driver
        switch self.clubSelect.selectedSegmentIndex {
        case 0:
            clubType = LMClubType.driver
        default:
            //FIXME: Should not normally set unknown to LM.  Only used if club not yet set.
            clubType = LMClubType.unknown
        }
        data.device?.setConfiguration(id: .club, value: Data([(UInt8)(clubType.rawValue)])) { success, error in
            print("Club Updated")
        }
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
            
            self.carryLabel.isHidden = false
            self.totalLabel.isHidden = false
            self.launchLabel.isHidden = false
            self.backspinLabel.isHidden = false
            self.attackLabel.isHidden = false
            self.axisLabel.isHidden = false
        }
    }
    
    private func deviceDisconnection(disconnected: Bool, error: Error?)
    {
        if disconnected {
            self.deviceLabel.text = ""
            self.deviceLabel.isHidden = true
            
            self.clubSelect.isHidden = true
            
            self.connectButton.isHidden = true
            self.disconnectButton.isHidden = true
            self.connectButton.isEnabled = false
            self.disconnectButton.isEnabled = false
            
            self.updateButton.isHidden = true
            
            self.carryLabel.isHidden = true
            self.totalLabel.isHidden = true
            self.launchLabel.isHidden = true
            self.backspinLabel.isHidden = true
            self.attackLabel.isHidden = true
            self.axisLabel.isHidden = true
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
        self.launchLabel.isHidden = false
        self.backspinLabel.isHidden = false
        self.attackLabel.isHidden = false
        self.axisLabel.isHidden = false
        
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
        if let vert = event.shot?.vertlaunchAngle {
            self.launchLabel.text = "Launch: \(String(describing: formatter.string(from: vert)!))"
        }else{
            self.launchLabel.text = "Launch: ---"
        }
        if let spin = event.shot?.spinRate {
            self.backspinLabel.text = "Backspin: \(spin)"
        }else{
            self.backspinLabel.text = "Backspin: ---"
        }
        if let attack = event.shot?.attackAngle {
            self.attackLabel.text = "Attack: \(String(describing: formatter.string(from: attack)!))"
        }else{
            self.attackLabel.text = "Attack: ---"
        }
        if let axis = event.shot?.spinAxis {
            self.axisLabel.text = "Axis: \(String(describing: formatter.string(from: axis)!))"
        }else{
            self.axisLabel.text = "Axis: ---"
        }
        print("Point Data Updated")
    }
    
    func stateChangedEvent(_ event: StateChangedEvent) {
        
    }
}
