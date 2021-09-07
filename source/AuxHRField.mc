using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;


class AuxHRField extends Ui.SimpleDataField {

    hidden var mFitContributor;
    hidden var mSensor;
    hidden var mSensorFound = false;
    hidden var mTicker = 0;

    function initialize(sensor) {
        SimpleDataField.initialize();
        mSensor = sensor;
        mFitContributor = new AuxHRFitContributor(self);
        label = "Aux. Heart Rate";
    }

    function compute(info) {
        mFitContributor.compute(mSensor);

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

    function onTimerStart() {
        mFitContributor.setTimerRunning( true );
    }

    function onTimerStop() {
        mFitContributor.setTimerRunning( false );
    }

    function onTimerPause() {
        mFitContributor.setTimerRunning( false );
    }

    function onTimerResume() {
        mFitContributor.setTimerRunning( true );
    }

    function onTimerLap() {
        mFitContributor.onTimerLap();
    }

    function onTimerReset() {
        mFitContributor.onTimerReset();
    }

}
