//
//  ScanViewController.swift
//  TestBluetooth
//
//  Created by Le Hoang Do on 6/4/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import UIKit
import CoreBluetooth
import UserNotifications

struct BeaconStruct {
    var uuid = ""
    var distance = ""
}


class ScanViewController: UIViewController {
    
    @IBOutlet var lbDistance:UILabel!
    var isReady = false
    var isConnected = false
    var myPeripheral:CBPeripheral!
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print(peripheral.state)
    }
    
    
    var centralManager: CBCentralManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if centralManager == nil{
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
        
    }
    
    @IBAction func scanPress(sender: UIButton){
        
        guard isReady else {
            return
        }
        
        if centralManager.isScanning{
            centralManager.stopScan()
        } else{
            startScan()
        }
        
        sender.isSelected = !sender.isSelected
        
        
    }
    
    func startScan(){
        let identifier = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
        let scanOptions = [
            CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true)
        ]
        let services = [CBUUID(string: identifier)]
        centralManager.scanForPeripherals(withServices: services, options: scanOptions)
    }
    

}

extension ScanViewController:CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        if central.state == .poweredOn{
            isReady = true
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        

//        print("RSSI: \(RSSI.intValue)")
//        print(advertisementData["kCBAdvDataLocalName"] ?? "")
        let proximity = RSSI.intValue
        let stringValue = convertRSSItoINProximity(proximity: RSSI.intValue)
        print(convertRSSItoINProximity(proximity: RSSI.intValue))
        lbDistance.text = "proximity: \(proximity) (\(stringValue))"

//        print(peripheral)
        if isConnected == false{
            isConnected = true
            myPeripheral = peripheral
            myPeripheral.delegate = self
            central.connect(peripheral, options: nil)
            central.stopScan()
        }
        
//       sendLocalNoti()
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        print("didConnect")
        print(peripheral)
        
    }
    
    func sendLocalNoti(){
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            content.title = "Forget Me Not"
            content.body = "Are you forgetting something?"
            content.sound = .default
            
            let request = UNNotificationRequest(identifier: "ForgetMeNot", content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        } else {
            // Fallback on earlier versions
            
            let notification = UILocalNotification()
            notification.fireDate = Date()
            notification.alertBody = "Alert!"
            notification.alertAction = "open"
            notification.hasAction = true
            notification.userInfo = ["UUID": "reminderID" ]
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
    }
    
    
    
    
    func  convertRSSItoINProximity(proximity: Int) -> String {
        
        if proximity < -70 {
            return "Far"
        }
        if proximity < -55 {
            return "Near"
        }
        if proximity < 0 {
            return "Immediate"
        }
        
        return "Unknown"
    }
    
}

extension ScanViewController: CBPeripheralDelegate{
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        
        print(peripheral)
        
    }
    
}
