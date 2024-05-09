import 'dart:async';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';

class SerialUtil {
  SerialPort? port;

  Stream<Uint8List>? receivingStream;
  List<String> availablePorts = [];

  // Future<void> streamAdd() async {
  //   availablePorts = portsController.stream.asBroadcastStream();
  // }

  Future<void> getAvailablePorts() async {
 
     if (SerialPort.availablePorts.isNotEmpty) {
      availablePorts = SerialPort.availablePorts;

      // portsController.add(SerialPort.availablePorts);
    } else {
      availablePorts.clear();
    }
  }

  void writeToPort({required Uint8List bytesMesage, String? address}) {
    if (port?.name == address) {
      try {
        int? writeBytes = port?.write(bytesMesage);
        // print("the written bytes $writeBytes");
      } catch (err, _) {
        port!.close();
      }
    }
  }

 void setConfig() {
  if (port != null) {
    SerialPortConfig config = SerialPortConfig();
    config.baudRate = 115200;
    config.bits = 8;
    config.stopBits = 1;
    
    // try {
    //   if(port!.isOpen){
      port!.config = config;
    
  //     }
  //   } catch (e) {
  //     print("Error setting serial port configuration: $e");
  //   }
  } else {
    print("Error: Serial port is null.");
  }
}

  bool _openPort() {
    bool isOpen = false;
    if (!port!.isOpen) {
      isOpen = port!.openReadWrite();
    }
    setConfig();
    return isOpen;
  }

  Stream<Uint8List>? openPortToListen(String? portName) {
    if (portName == null) {
      return null;
    }

    // Close the port if it's already open
    if (port != null) {
      port!.close();
    }

    // Create a new SerialPort instance
    port = SerialPort(portName);

    // Check if the port was created successfully
    if (port?.name == portName) {
      // Try to open the port
      if (_openPort()) {
        SerialPortReader reader = SerialPortReader(port!);
        reader.close();
        receivingStream = reader.stream.asBroadcastStream();
        

        
      }
    }

    return null;
  }

  void portCLose() async {
    port!.close();
  }
}