using Toybox.Application as App;

class AuxHRApp extends App.AppBase {
	var mSensor;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    	try {
            //Create the sensor object and open it
            mSensor = new AuxHRSensor();
            mSensor.open();
        } catch(e instanceof Ant.UnableToAcquireChannelException) {
            Sys.println(e.getErrorMessage());
            mSensor = null;
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	return false;
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new AuxHRField(mSensor) ];
    }

}
