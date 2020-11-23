
import 'package:json_annotation/json_annotation.dart';
import 'constant.dart';

@JsonSerializable(nullable: false)
String getString(String key, Map<String, dynamic> data) {
  String result = '';
  if (data == null) {
    result = '';
  } else if (data[key] == null) {
    result = '';
  } else if (!data.containsKey(key)) {
    result = '';
  } else {
    result = data[key].toString();
  }
  return result;
}

@JsonSerializable(nullable : false)
class BluetoothDevice {
  BluetoothDevice({
    this.name,
    this.address,
  });

  factory BluetoothDevice.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    return BluetoothDevice(
      name: getString(Constant.name, data),
      address: getString(Constant.address, data),
    );
  }


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      Constant.name: name,
      Constant.address: address,

    };
  }

  final String name;
  final String address;
}
