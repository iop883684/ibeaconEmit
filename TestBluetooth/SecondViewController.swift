//
//  SecondViewController.swift
//  TestBluetooth
//
//  Created by Lee on 6/4/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import UIKit
import CoreBluetooth
//import CoreLocation

class SecondViewController: UIViewController, CBPeripheralManagerDelegate {
    
//    var localBeacon: CLBeaconRegion!
    @IBOutlet var btStart:UIButton!
    var beaconPeripheralData: [String:Any]!
    var peripheralManager: CBPeripheralManager!
    
    var isReady = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let localBeaconUUID = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
        beaconPeripheralData = [
            CBAdvertisementDataLocalNameKey: "what up",
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: localBeaconUUID)]
            ] as [String : Any]
        
        
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        
    }
    
    @IBAction func startiBeacon(sender:UIButton){
        
        guard isReady else {
            return
        }
        
        if peripheralManager.isAdvertising{
            peripheralManager.stopAdvertising()
        } else{
            peripheralManager.startAdvertising(beaconPeripheralData)
        }
        
        sender.isSelected = !sender.isSelected
        
    }


    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            isReady = true
        } else if peripheral.state == .poweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("peripheralManagerDidStartAdvertising")
        btStart.isSelected = true
    }
    

}

