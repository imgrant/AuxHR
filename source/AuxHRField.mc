using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Activity as Act;
using Toybox.Graphics as Gfx;


class AuxHRField extends Ui.SimpleDataField {

    hidden var mFitContributor;
    hidden var mSensor;

    function initialize(sensor) {
        SimpleDataField.initialize();
        mSensor = sensor;
        mFitContributor = new AuxHRFitContributor(self);
        label = "Heart Rate";
    }

    function compute(info) {
        mFitContributor.compute(mSensor);

        if (mSensor == null) {
            return "No Channel!";
        } else if (true == mSensor.searching) {
            return "Searching...";
        } else {
            var heartRate = mSensor.data.currentHeartRate;
            if (heartRate == null) {
                return "--";
            } else {
                return heartRate.format("%d");
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
