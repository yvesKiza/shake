library shake;

import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:sensors/sensors.dart';

/// Callback for phone shakes
typedef Null PhoneShakeCallback();

/// ShakeDetector class for phone shake functionality
class ShakeDetector {
  /// User callback for phone shake
  final PhoneShakeCallback onPhoneShake;

  /// Shake detection threshold
  final double shakeThresholdGravity;

  /// Minimum time between shake
  final int shakeSlopTimeMS;

  /// Time before shake count resets
  final int shakeCountResetTime;
   
  int mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  DateTime lastSensorTime=DateTime.now();


  /// StreamSubscription for Accelerometer events
  StreamSubscription streamSubscription;

  /// This constructor waits until [startListening] is called
  ShakeDetector.waitForStart(
      {this.onPhoneShake,
      this.shakeThresholdGravity = 2.7,
      this.shakeSlopTimeMS = 500,
      this.shakeCountResetTime = 3000});

  /// This constructor automatically calls [startListening] and starts detection and callbacks.\
  ShakeDetector.autoStart(
      {this.onPhoneShake,
      this.shakeThresholdGravity = 2.7,
      this.shakeSlopTimeMS = 500,
      this.shakeCountResetTime = 3000}) {
    startListening();
  }

  /// Starts listening to accerelometer events
  void startListening() {
    streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      double gX = x / 9.80665;
      double gY = y / 9.80665;
      double gZ = z / 9.80665;

      // gForce will be close to 1 when there is no movement.
      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
       var   now = DateTime.now();
       
        if(now.subtract(new Duration(seconds:shakeSlopTimeMS )).isAfter(lastSensorTime)){
          var dif= (now.subtract(new Duration(seconds:shakeSlopTimeMS )).difference(lastSensorTime));
          print("diffetrec less "+dif.inSeconds.toString());
          lastSensorTime=now;
          return;
        }
       else if(now.subtract(new Duration(seconds:shakeSlopTimeMS )).isbefore(lastSensorTime)){
          var dif= (now.subtract(new Duration(seconds:shakeSlopTimeMS )).difference(lastSensorTime));
          print("diffetrec greeat "+dif.inSeconds.toString());
          
          return;
        }
          

       
       

         lastSensorTime=now;

         

        onPhoneShake();
     
     
        
      }
     
    });
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }
}
