import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryPage extends StatefulWidget {
  const BatteryPage({super.key});

  @override
  State<BatteryPage> createState() => _BatteryPageState();
}

class _BatteryPageState extends State<BatteryPage> {
  final battery = Battery();
  int batteryLevel = 100;
  BatteryState batteryState = BatteryState.full;
  late Timer timer;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    listenBatteryLevel();
    listenBatteryState();
  }

  void listenBatteryState() {
    subscription = battery.onBatteryStateChanged.listen(
      (batteryState) => setState(() => this.batteryState = batteryState),
    );
  }

  void listenBatteryLevel() {
    updateBatteryLevel();
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) async => updateBatteryLevel(),
    );
  }

  Future updateBatteryLevel() async {
    final batteryLevel = await battery.batteryLevel;
    setState(() => this.batteryLevel = batteryLevel);
  }

  @override
  void dispose() {
    timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battery Level Checker"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildBatteryLevel(batteryLevel),
            const SizedBox(height: 20),
            buildBatteryState(batteryState),
          ],
        ),
      ),
    );
  }

  Widget buildBatteryState(BatteryState batteryState) {
    final style = const TextStyle(fontSize: 32, color: Colors.black);
    const double size = 100;

    switch (batteryState) {
      case BatteryState.full:
        final color = Colors.green;
        return Column(
          children: [
            Icon(Icons.battery_full, size: size, color: color),
            Text("Full", style: style.copyWith(color: color)),
          ],
        );
      case BatteryState.charging:
        final color = Colors.orange;
        return Column(
          children: [
            Icon(Icons.battery_charging_full, size: size, color: color),
            Text("Charging...", style: style.copyWith(color: color)),
          ],
        );
      case BatteryState.discharging:
      default:
        final color = Colors.red;
        return Column(
          children: [
            Icon(Icons.battery_alert, size: size, color: color),
            Text("Discharging...", style: style.copyWith(color: color)),
          ],
        );
    }
  }

  Widget buildBatteryLevel(int batteryLevel) {
    return Text(
      '$batteryLevel%',
      style: const TextStyle(
        fontSize: 46,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}