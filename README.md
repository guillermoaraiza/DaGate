# DaGate

Introduction
-------------

This is a personal project, just to have fun and learn more about Spark and Swift. I built this iOS application to send the sequence of numbers using swift to open the main gate of the garage.

Configuration
-------------

The module has no menu or modifiable settings. There is no further configuration.

1. In order to use this application you need to create your own spark application and flashed to your spark.
2. Change the elemets the following variables for the ones on your spark: accessToken, deviceToken & deviceFunction.
3. The app sends to the specified spark function a string with 4 numbers i.e "1234"
4. The app handle the connection errors with alerts. If the Spark returns 1 = Correct & 2 = Incorrect.

Hardware
-------------

I basically hacked the remote control button signal using a transistor and a spark.io to communicate through internet and programed the spark to receive a sequence of numbers in order to open the door.
