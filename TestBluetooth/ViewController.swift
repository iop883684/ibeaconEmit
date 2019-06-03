//
//  ViewController.swift
//  TestBluetooth
//
//  Created by Lee on 6/1/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyBluetooth

// UUID for the one peripheral service, declared outside the class:
var peripheralServiceUUID = CBUUID(string: "9BC1F0DC-F4CB-4159-BD38-7375CD0DD545")

// UUID for one characteristic of the service above, declared outside the class:
var nameCharacteristicUUID = CBUUID(string: "9BC1F0DC-F4CB-4159-BD38-7B74CD0CD546")

class ViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    var listId = [UUID]()
    
    var peripheralManager: CBCentralManager?
    var discoveredPeripheral: CBPeripheral?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        // You can pass in nil if you want to discover all Peripherals
       
//        peripheralManager = CBPeripheralManager(delegate:self, queue:nil)
//        bluetoothServices = CBMutableService(type: peripheralServiceUUID, primary: true)
    
    }
    /*
    
    func configureUtilityForIdentity(identity:Point!) {
        var characteristicsArray:[CBCharacteristic] = []
        myIdentity = identity
        
        if (identity.name != nil) {
            nameCharacteristic =
                CBMutableCharacteristic(type: nameCharacteristicUUID,
                                        properties: (CBCharacteristicProperties.Read),
                                        value: myIdentity?.name?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                                        permissions: CBAttributePermissions.Readable)
            
            characteristicsArray.append(nameCharacteristic!)
        }
        
        // more characteristics built here and added to the characteristicsArray[]...
        // ... then all are added to the CBMutableService at the bottom...
        bluetoothServices?.characteristics = characteristicsArray as [CBCharacteristic]
    }
    
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        switch (peripheral.state) {
        case .PoweredOn:
            print("Current Bluetooth State:  PoweredOn")
            publishServices(bluetoothServices)
            break;
        case .PoweredOff:
            print("Current Bluetooth State:  PoweredOff")
            break;
        case .Resetting:
            print("Current Bluetooth State:  Resetting")
            break;
        case .Unauthorized:
            print("Current Bluetooth State:  Unauthorized")
        case .Unknown:
            print("Current Bluetooth State:  Unknown")
            break;
        case .Unsupported:
                print("Current Bluetooth State:  Unsupported")
            break;
        }
    }
    
    func publishServices(newService:CBMutableService!) {
        peripheralManager?.addService(newService)
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
        
        if (error != nil) {
            print("PerformerUtility.publishServices() returned error: \(error!.localizedDescription)")
            print("Providing the reason for failure: \(error!.localizedFailureReason)")
        }
        else {
            peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : service.UUID])
        }
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager,
                                              error: NSError?) {
        if (error != nil) {
            print("peripheralManagerDidStartAdvertising encountered an error.")
            print(error!.localizedDescription)  // Error: One or more parameters were invalid
            print(error!.localizedFailureReason)  // Error: nil
        }
        print ("Debug: peripheralManagerDidStartAdvertising()")
    }
}
*/

    
    @IBAction func scanBtnPress(){
        
        SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: nil, timeoutAfter: 5) { scanResult in
            switch scanResult {
            case .scanStarted:
            // The scan started meaning CBCentralManager scanForPeripherals(...) was called
                print("scanStarted")
                self.listId = []
            case .scanResult(let peripheral, _ , _):
                // A peripheral was found, your closure may be called multiple time with a .ScanResult enum case.
                // You can save that peripheral for future use, or call some of its functions directly in this closure.
                print(peripheral.identifier)
                self.listId.append(peripheral.identifier)
                self.tableView.reloadData()
                
            case .scanStopped(let error):
                // The scan stopped, an error is passed if the scan stopped unexpectedly
                print(error?.localizedDescription ?? "")
                print("scanStopped")
                
            }
        }
       
        
    }
    

    
    
    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
//
//        let peripheralLocalName_advertisement = ((advertisementData as NSDictionary).value(forKey: "kCBAdvDataLocalName")) as? String
//
//        if (((advertisementData as NSDictionary).value(forKey: "kCBAdvDataLocalName")) != nil)
//
//        print(peripheralLocalName_advertisement)//peripheral name from advertismentData
//
//        print(peripheral.name)//peripheral name from peripheralData
//
//        peripherals.append(peripheral)
//
//        arrayPeripheral.append(advertisementData)
//    }


}

extension ViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(listId[indexPath.row])"
        return cell
    }
    
}
