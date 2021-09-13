# Auxiliary Heart Rate

This is a data field for Garmin Connect IQ.

## Description

This is a rebuild with a recent SDK supporting more devices of IMGrant's data field https://apps.garmin.com/en-US/apps/88ce4547-7d84-4289-b2c7-3e15ca00185f

It searches and tracks an ANT+ heart rate sensor in addition to the sensor paired in the system settings.

Initially, the strongest sensor is picked up and remembered throughout the activity.

To avoid tracking the wrong sensor, the ID can be fixed in the data field settings.

The heart rate data is recorded in a seperate stream in the FIT for later analysis.

Use cases:

- Compare heart rate sensors. Two ANT+ sensors, or the internal optical of a watch and an ANT+ sensor.

- Watching and recording a training partners heart rate for pacing

My example use case is pacing training partners in cycling. My Edge device natively connects to my heart rate sensor and this data field connects to my partners, such that I can see how hard she is already going while pacing in the front, and still -- in parallel -- record an watch my own heart rate.
