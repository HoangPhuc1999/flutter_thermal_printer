part of 'bluetooth_paired_bloc.dart';

@immutable
abstract class BluetoothPairedState {}

class BluetoothPairedInitial extends BluetoothPairedState {}

class ShowBluetoothPairedState extends BluetoothPairedState {
  ShowBluetoothPairedState(this.data, this.title);

  final List<BluetoothDevice> data;
  final String title;
}
