//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.FitContributor as Fit;

const CURR_HR_FIELD_ID    = 0;
const LAP_HR_FIELD_ID     = 1;
const AVG_HR_FIELD_ID     = 2;
const MAX_LAP_HR_FIELD_ID = 3;
const MAX_HR_FIELD_ID     = 4;
const MIN_LAP_HR_FIELD_ID = 5;
const MIN_HR_FIELD_ID     = 6;

class AuxHRFitContributor {
    // Variables for computing averages
    hidden var mHRLapAverage        = 0;
    hidden var mHRSessionAverage    = 0;
    hidden var mHRLapMax            = 0;
    hidden var mHRSessionMax        = 0;
    hidden var mHRLapMin            = 255;
    hidden var mHRSessionMin        = 255;
    hidden var mLapRecordCount      = 0;
    hidden var mSessionRecordCount  = 0;
    hidden var mTimerRunning        = false;

    // FIT Contributions variables
    hidden var mCurrentHRField        = null;
    hidden var mLapAverageHRField     = null;
    hidden var mSessionAverageHRField = null;
    hidden var mLapMaxHRField         = null;
    hidden var mSessionMaxHRField     = null;
    hidden var mLapMinHRField         = null;
    hidden var mSessionMinHRField     = null;

    // Constructor
    function initialize(dataField) {
        mCurrentHRField         = dataField.createField("currHeartRate",  CURR_HR_FIELD_ID, Fit.DATA_TYPE_UINT8, { :nativeNum=>3,   :mesgType=>Fit.MESG_TYPE_RECORD,  :units=>"bpm" });
        mLapAverageHRField      = dataField.createField("lapHeartRate",   LAP_HR_FIELD_ID,  Fit.DATA_TYPE_UINT8, { :nativeNum=>15,  :mesgType=>Fit.MESG_TYPE_LAP,     :units=>"bpm" });
        mSessionAverageHRField  = dataField.createField("avgHeartRate",   AVG_HR_FIELD_ID,  Fit.DATA_TYPE_UINT8, { :nativeNum=>16,  :mesgType=>Fit.MESG_TYPE_SESSION, :units=>"bpm" });

        mLapMaxHRField          = dataField.createField("maxLapHeartRate",  MAX_LAP_HR_FIELD_ID,  Fit.DATA_TYPE_UINT8, { :nativeNum=>16, :mesgType=>Fit.MESG_TYPE_LAP,      :units=>"bpm" });
        mSessionMaxHRField      = dataField.createField("maxHeartRate",     MAX_HR_FIELD_ID,      Fit.DATA_TYPE_UINT8, { :nativeNum=>17, :mesgType=>Fit.MESG_TYPE_SESSION,  :units=>"bpm" });

        mLapMinHRField          = dataField.createField("minLapHeartRate",  MIN_LAP_HR_FIELD_ID,  Fit.DATA_TYPE_UINT8, { :nativeNum=>63, :mesgType=>Fit.MESG_TYPE_LAP,      :units=>"bpm" });
        mSessionMinHRField      = dataField.createField("minHeartRate",     MIN_HR_FIELD_ID,      Fit.DATA_TYPE_UINT8, { :nativeNum=>64, :mesgType=>Fit.MESG_TYPE_SESSION,  :units=>"bpm" });

        mCurrentHRField.setData(0);
        mLapAverageHRField.setData(0);
        mSessionAverageHRField.setData(0);

        mLapMaxHRField.setData(0);
        mSessionMaxHRField.setData(0);

        mLapMinHRField.setData(0);
        mSessionMinHRField.setData(0);
    }

    function compute(sensor) {
        if( sensor != null ) {
            var heartRate = sensor.data.currentHeartRate;

            if (heartRate != null) {
                mCurrentHRField.setData( heartRate.toNumber() );

                if( mTimerRunning ) {
                    // Update lap/session data and record counts
                    mLapRecordCount++;
                    mSessionRecordCount++;
                    mHRLapAverage += heartRate;
                    mHRSessionAverage += heartRate;

                    if (heartRate > mHRLapMax) {
                        mHRLapMax = heartRate;
                    }
                    if (heartRate > mHRSessionMax) {
                        mHRSessionMax = heartRate;
                    }

                    if (heartRate < mHRLapMin) {
                        mHRLapMin = heartRate;
                    }
                    if (heartRate < mHRSessionMin) {
                        mHRSessionMin = heartRate;
                    }

                    // Update lap/session FIT Contributions
                    mLapAverageHRField.setData( (mHRLapAverage/mLapRecordCount).toNumber() );
                    mSessionAverageHRField.setData( (mHRSessionAverage/mSessionRecordCount).toNumber() );

                    mLapMaxHRField.setData( mHRLapMax.toNumber() );
                    mSessionMaxHRField.setData( mHRSessionMax.toNumber() );

                    mLapMinHRField.setData( mHRLapMin.toNumber() );
                    mSessionMinHRField.setData( mHRSessionMin.toNumber() );
                }
            }
        }
    }

    function setTimerRunning(state) {
        mTimerRunning = state;
    }

    function onTimerLap() {
        mLapRecordCount = 0;
        mHRLapAverage   = 0;
        mHRLapMax       = 0;
        mHRLapMin       = 255;
    }

    function onTimerReset() {
        mSessionRecordCount = 0;
        mHRSessionAverage   = 0;
        mHRSessionMax       = 0;
        mHRSessionMin       = 255;
    }

}
