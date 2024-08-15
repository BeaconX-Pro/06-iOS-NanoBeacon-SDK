# NanoBeacon iOS Software Development Kit Guide

* iOS SDK for NanoBeacon series products in BeaconX Pro APP.

# Design instructions

* This SDK only for scanning.

`MKNNBCentralManager`：global manager, check system's bluetooth status and scan devices;

`MKNNBBaseBeacon`: instance of devices, MKNNBCentralManager will create an MKNNBBaseBeacon instance while it found a physical device, a device corresponds to an instance.Currently there are *UID broadcast frame*, *URL broadcast frame*, *TLM broadcast frame*, *Sensor information frame*;


## Scanning Stage

in this stage, `MKNNBCentralManager ` will scan and analyze the advertisement data of BeaconX Pro devices, `MKNNBCentralManager ` will create `MKNNBBaseBeacon ` instance for every physical devices, developers can get all advertisement data by its property.

# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS14, we limit the minimum iOS system version to 14.0；

### Import to Project

CocoaPods

SDK is available through [CocoaPods](https://cocoapods.org).

**pod 'MKNanoBeacon/SDK'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to "info.plist" file of your project: Privacy - Bluetooth Peripheral Usage Description - "your description". as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project's info.plist file: Privacy-Bluetooth Always Usage Description-"Your usage description".</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKNanoBeacon *manager = [MKNanoBeacon shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.`manager.delegate = self;` //Set the scan delegate and complete the related delegate methods.
* 2.you can start the scanning task in this way:`[manager startScan];`    
* 3.at the sometime, you can stop the scanning task in this way:`[manager stopScan];`



## Notes

* In development progress, you may find there are multiple MKNNBBaseBeacon instance correspond to a physical device. On this point, we consulted Apple's engineers. they told us that currently on the iOS platform, CoreBluetooth framework unfriendly to the multiple slot devices(especially the advertisement data in changing). due to that sometimes app can't connect to the device, Google Eddystone solve this issue by press button on eddystone devices, our device support this operation too.



# Change log

* 20240815 first version;
