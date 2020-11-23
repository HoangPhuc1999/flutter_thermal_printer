import 'dart:convert';

import 'package:avprinter/avprinter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/blutooth_paired_devices/bluetooth_paired_bloc.dart';
import 'package:flutter_thermal_printer/entity.dart';

class PairedBluetoothDevices extends StatefulWidget {
  const PairedBluetoothDevices({Key key, this.bluetoothDeviceIndex})
      : super(key: key);

  final ValueChanged<String> bluetoothDeviceIndex;

  @override
  _PairedBluetoothDevicesState createState() => _PairedBluetoothDevicesState();
}

class _PairedBluetoothDevicesState extends State<PairedBluetoothDevices> {
  BluetoothPairedBloc bluetoothPairedBloc = BluetoothPairedBloc();
  static const MethodChannel platform =
      MethodChannel('com.flutter.bluetooth/bluetooth');

  @override
  void initState() {
    getListPairedDevice();
    super.initState();
  }

  @override
  void dispose() {
    bluetoothPairedBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothPairedBloc, BluetoothPairedState>(
      cubit: bluetoothPairedBloc,
      builder: (BuildContext context, BluetoothPairedState state) {
        if (state is ShowBluetoothPairedState) {
          return dropDownList(context, state);
        } else {
          return Container(
            color: Colors.red,
          );
        }
      },
    );
  }

  Widget dropDownList(BuildContext context, ShowBluetoothPairedState state) {
    return GestureDetector(
      onTap: () {
        displayShowModalBottomSheet(context, state.data);
      },
      child: Container(
        height: 40,
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  state.title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.expand_more,
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void displayShowModalBottomSheet(
      BuildContext context, List<BluetoothDevice> bluetoothDevices) {
    showModalBottomSheet<dynamic>(
      elevation: 40,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 16),
          child: ListView(
            shrinkWrap: true,
//            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Text(
                'Danh sách thiết bị',
                style: Theme.of(context).textTheme.headline5,
              ),
              Container(
                height: 8,
              ),
              ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bluetoothDevices.length,
                itemBuilder: (BuildContext context, int index) {
                  final BluetoothDevice bluetoothDevice =
                      bluetoothDevices[index];
                  return listOfType(bluetoothDevice, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget listOfType(BluetoothDevice bluetoothDevice, int index) {
    return GestureDetector(
      onTap: () {
        widget.bluetoothDeviceIndex(bluetoothDevice.address);
        bluetoothPairedBloc
            .add(UpdateTitleBluetoothPairedEvent(bluetoothDevice.name));
        Navigator.pop(context);
      },
      child: ListTile(
        leading: const Icon(Icons.bluetooth),
        title: Text(
          bluetoothDevice.name,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> getListPairedDevice() async {
    try {
//      final dynamic result = await platform.invokeMethod<dynamic>('getList');
      final dynamic result1 = await Avprinter.getListDevices;

      final List<BluetoothDevice> devices = <BluetoothDevice>[];
      result1.forEach((String item) {
        final BluetoothDevice bluetoothDevice =
            BluetoothDevice.fromJson(json.decode(item) as Map<String, dynamic>);

        devices.add(bluetoothDevice);
      });

      print(result1);

      bluetoothPairedBloc.add(GetBluetoothListEvent(devices));
    } on PlatformException catch (e) {
      print('ERROR ERROR ERROR ===============$e');
    }
  }
}
