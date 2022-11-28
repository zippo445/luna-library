//
//  File.swift
//
//
//  Created by Philippe Jean on 2022-11-27.
//
import Foundation

public struct DeviceDescription {
    var id: String;
    
    init(id: String){
        self.id = id;
    }
}

public class LunaLibrary : NSObject, MelodyManagerDelegate {
    private var objects: [MelodySmart]!
    private var melodyManager: MelodyManager!
    private var initialized = false;
   
    private var scanning:Bool = false;
    
    func scan () {
        self.scanning = true;
        melodyManager.scanForMelody();
    }
    
    func stopScan () {
        melodyManager.stopScanning();
        self.scanning = false;
    }
    
    public func isScanning () -> Bool {
        return self.scanning;
    }
    
    func initialize() -> String {
        if (initialized){
            return "Already initialized";
        }
        initialized = true;
        objects = []
        melodyManager = MelodyManager()
        melodyManager.setForService(nil, andDataCharacterisitc:nil, andPioReportCharacteristic:nil, andPioSettingCharacteristic:nil)
        melodyManager.delegate = self

        let msge = "Using MelodyManager v\(String(describing: melodyManager.version))";
        print(msge)
        
        return msge;
    }

    public func melodyManagerDiscoveryDidRefresh(_ manager: MelodyManager!) {
//        println("discoveryDidRefresh")
       for i in objects.count..<MelodyManager.numberOfFoundDevices() {
           insertNewObject(device: MelodyManager.foundDevice(at: i))
       }
   }
    
    func insertNewObject(device: MelodySmart) {
        objects.append(device)
    }

    func getDevices() -> [DeviceDescription]{
        
        var devices = [DeviceDescription]();
        
        for d in objects {
            devices.append(DeviceDescription(id:d.name()));
        }
        return devices;
    }
}
