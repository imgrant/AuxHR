//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Ant as Ant;
using Toybox.Time as Time;

class AuxHRSensor extends Ant.GenericChannel {
    const DEVICE_TYPE = 120;
    const PERIOD = 8070;

    hidden var chanAssign;

    var data;
    var searching;
    var deviceCfg;

    class AuxHRData {
        var currentHeartRate;

        function initialize() {
            currentHeartRate = 0;
        }
    }

    class HeartRateDataPage {
        static const INVALID_HR = 0x00;

        function parse(payload, data) {
            data.currentHeartRate = parseCurrentHR(payload);
        }

        hidden function parseCurrentHR(payload) {
            return payload[7];
        }
    }

    function initialize() {
        // Get the channel
        chanAssign = new Ant.ChannelAssignment(
            Ant.CHANNEL_TYPE_RX_NOT_TX,
            Ant.NETWORK_PLUS);
        GenericChannel.initialize(method(:onMessage), chanAssign);

        // Set the configuration
        deviceCfg = new Ant.DeviceConfig( {
            :deviceNumber => 0,                 //Wildcard our search
            :deviceType => DEVICE_TYPE,
            :transmissionType => 0,
            :messagePeriod => PERIOD,
            :radioFrequency => 57,              //Ant+ Frequency
            :searchTimeoutLowPriority => 10,    //Timeout in 25s
            :searchThreshold => 0} );           //Pair to all transmitting sensors
        GenericChannel.setDeviceConfig(deviceCfg);

        data = new AuxHRData();
        searching = true;
    }

    function open() {
        // Open the channel
        GenericChannel.open();

        data = new AuxHRData();
        searching = true;
    }

    function closeSensor() {
        GenericChannel.close();
    }

    function onMessage(msg) {
        // Parse the payload
        var payload = msg.getPayload();

        if( Ant.MSG_ID_BROADCAST_DATA == msg.messageId ) {
            // Were we searching?
            if (searching) {
                searching = false;
                // Update our device configuration primarily to see the device number of the sensor we paired to
                deviceCfg = GenericChannel.getDeviceConfig();
            }
            var dp = new HeartRateDataPage();
            dp.parse(msg.getPayload(), data);
        } else if(Ant.MSG_ID_CHANNEL_RESPONSE_EVENT == msg.messageId) {
            if (Ant.MSG_ID_RF_EVENT == (payload[0] & 0xFF)) {
                if (Ant.MSG_CODE_EVENT_CHANNEL_CLOSED == (payload[1] & 0xFF)) {
                    // Channel closed, re-open
                    open();
                } else if( Ant.MSG_CODE_EVENT_RX_FAIL_GO_TO_SEARCH  == (payload[1] & 0xFF) ) {
                    searching = true;
                }
            } else {
                //It is a channel response.
            }
        }
    }

}
