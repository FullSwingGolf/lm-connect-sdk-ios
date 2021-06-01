//
//  NavigationViewController.swift
//  SimulatorConnectSwiftDemo
//
//  Created by Chad Godsey on 5/20/21.
//

import UIKit

class NavigationViewController: UINavigationController {

    weak var tableViewController: UITableViewController!
    weak var deviceViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewController = self.storyboard?.instantiateViewController(identifier: "deviceTableVC")
        deviceViewController = self.storyboard?.instantiateViewController(identifier: "deviceVC")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func didSelectDevice(sender: Any) {
        self.navigationController?.pushViewController(deviceViewController, animated: true)
    }

}
