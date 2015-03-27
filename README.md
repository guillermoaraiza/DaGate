# DaGate

Introduction
-------------

This is a personal project, just to have fun and learn more about Spark and Swift (Also because I needed). I built this iOS application to send the sequence of numbers using swift to open the main gate of the garage at the office, the interface is similar to the iPhone lock screen.

Configuration
-------------

The module has no menu or modifiable settings. There is no further configuration.

1. In order to use this application you need to create your own spark application and flashed to your spark.
2. Change the following variables at ViewController: accessToken, deviceToken & deviceFunction.
3. The app sends to the specified spark function a string with 4 numbers i.e "1234"
4. The app handle connection errors with alerts. Spark function return 1 = Correct / return 2 = Incorrect.

Hardware
-------------

I basically hacked the remote control button spark.io to communicate through internet and programed the spark to receive a sequence of numbers in order to open the door. I used a transistor as a switch.
