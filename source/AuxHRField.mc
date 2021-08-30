using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;


class AuxHRField extends Ui.SimpleDataField {

    hidden var mSensor;
    hidden var mSensorFound = false;
    hidden var mTicker = 0;

    function initialize(sensor) {
        SimpleDataField.initialize();
        mSensor = sensor;
        label = "Aux. Heart Rate";
    }

    function compute(info) {

        if (mSensor == null) {
            mSensorFound = false;
            return "No Channel!";
        } else if (true == mSensor.searching) {
            mSensorFound = false;
            return "Searching...";
        } else {
            if (!mSensorFound) {
                mSensorFound = true;
                mTicker = 0;
            }
            if (mSensorFound && mTicker < 5) {
                var auxHRAntID = mSensor.deviceCfg.deviceNumber;
                mTicker++;
                return "Found " + auxHRAntID;
            } else {
                var heartRate = mSensor.data.currentHeartRate;
                if (heartRate == null) {
                    return "--";
                } else {
                    return heartRate.format("%d");
                }
            }
        }
    }
 }
