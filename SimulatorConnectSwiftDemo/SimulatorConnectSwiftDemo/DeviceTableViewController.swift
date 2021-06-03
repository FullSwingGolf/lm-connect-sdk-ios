//
//  DeviceTableViewController.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 5/20/21.
//

import UIKit
import SimulatorConnect
import AWSMobileClient

class DeviceTableViewController: UITableViewController
{
    private var auth: AuthenticationPresenter!
    private var connect: FSGConnect!
    private var data: AppData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the shared instances for FSGConnect and our app data.
        auth = AuthenticationPresenter.shared
        connect = FSGConnect.shared
        data = AppData.shared
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        data.devices = []
        self.tableView.reloadData()
        
        // Uncomment the following to show the web login and allow users to sign in
//        auth.showSignIn(completion: { code, error in
//            self.data.authCode = code
//            self.connect.initialize(accessToken: code)
//            do {
//                try self.connect.findDevicesAsync(completion: self.findDevicesComplete(devices:error:))
//            } catch {}
//        })
        
        // Uncomment the following to authorize with an app key and start scanning for nearby devices
        do {
            try self.connect.initialize(acountId: "ACCOUNT_ID_HERE", accountKey: "ACCOUNT_KEY_HERE")
            try self.connect.findDevicesAsync(completion: self.findDevicesComplete(devices:error:))
        } catch {}
    }
    
    private func findDevicesComplete(devices: [LMDevice]?, error: Error?)
    {
        guard let devices = devices else { return }
        data.devices = devices
        self.tableView.reloadData()
    }
    
    private func deviceConnection(connected: Bool, error: Error?)
    {
        data.connected = connected
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)

        // Configure the cell...
        let device = data.devices[indexPath.row]
        cell.textLabel?.text = "Device \(device.name) UUID: \(device.id)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Devices"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = data.devices[indexPath.row]
        print("Selected device \(device.name)")
        data.device = device
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
