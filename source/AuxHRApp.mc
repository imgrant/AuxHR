using Toybox.Application as App;

class AuxHRApp extends App.AppBase {
	var mSensor;
    var mAntID = 0;

    function initialize() {
        AppBase.initialize();
        var mApp = Application.getApp();
        mAntID = mApp.getProperty("pAuxHRAntID");
    }

    // onStart() is called on application start up
    function onStart(state) {
    	try {
            //Create the sensor object and open it
            mSensor = new AuxHRSensor(mAntID);
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
