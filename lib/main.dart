import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:linux_software/model/serial_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.flutter
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ExampleApp(),
    );
  }
}

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class _ExampleAppState extends State<ExampleApp> {
  
 SerialUtil serialUtil = SerialUtil(); 


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Serial Port example'),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              for (final address in serialUtil.availablePorts)
                Builder(builder: (context) {
                  final port = SerialPort(address);
                  return ExpansionTile(
                    title: Text(address),
                    children: [
                      CardListTile('Description', port.description),
                      CardListTile('Transport', port.transport.toTransport()),
                      CardListTile('USB Bus', port.busNumber?.toPadded()),
                      GestureDetector(
                        onTap: ()async {
                          
                      
                          
                        },
                        child: const Text("connect port"),
                      ),
                      GestureDetector(
                        onTap: () {
                           serialUtil.openPortToListen(address);
                           serialUtil.receivingStream?.listen((event) {
                            print("the incoming strean ${String.fromCharCodes(event)}");
                            });
                        
                        },
                        child: const Text("Listen port"),
                      ),

                      // StreamBuilder<Uint8List>(stream: serialUtil.receivingStream, builder: (context,snapshot){
                      //   if(snapshot.hasData){
                      //    return Text("the serial data ${String.fromCharCodes(snapshot.data!)}");
                      //   } else{
                      //     return const CircularProgressIndicator();
                      //   }
                      // })

                      // CardListTile('USB Device', port.deviceNumber?.toPadded()),
                      // CardListTile('Vendor ID', port.vendorId?.toHex()),
                      // CardListTile('Product ID', port.productId?.toHex()),
                      // CardListTile('Manufacturer', port.manufacturer),
                      // CardListTile('Product Name', port.productName),
                      // CardListTile('Serial Number', port.serialNumber),
                      // CardListTile('MAC Address', port.macAddress),
                    ],
                  );
                }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()async{
             await serialUtil.getAvailablePorts();
       setState(() {
         
       });
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

}

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  const CardListTile(this.name, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(value ?? 'N/A'),
        subtitle: Text(name),
      ),
    );
  }
}
