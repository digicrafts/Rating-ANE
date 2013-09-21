package digicrafts.extensions;

import com.adobe.fre.*;

public class RatingGetPropertyFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		FREObject propertyObj = args[0];
		FREObject result = null;
	    try
	    {	    	
	    		RatingExtensionContext cxt = (RatingExtensionContext)context;
	    		String property = propertyObj.getAsString();
	    		result = FREObject.newObject(cxt.previewMode);
	    		switch(RatingProperty.valueOf(property)){
    				case usesCount:
    					result = FREObject.newObject(cxt.usesCount);
    					break;
				case eventCount:
					result = FREObject.newObject(cxt.eventCount);
    					break;
				case ratedAnyVersion:
					result = FREObject.newObject(cxt.ratedAnyVersion);
					break;
				case ratedThisVersion:
					result = FREObject.newObject(cxt.ratedThisVersion);
					break;
				case declinedThisVersion:
					result = FREObject.newObject(cxt.declinedThisVersion);
					break;
				case declinedAnyVersion:
					result = FREObject.newObject(cxt.declinedAnyVersion);
					break;
    				////////////////////
	    			case appStoreID:
	    				result = FREObject.newObject(cxt.appStoreID);
	    				break;
    				case appStoreGenreID:
    					result = FREObject.newObject(cxt.appStoreGenreID);
	    				break;
    				case appStoreCountry:
    					result = FREObject.newObject(cxt.appStoreCountry);
	    				break;
    				case applicationName:
    					result = FREObject.newObject(cxt.applicationName);
	    				break;
    				case applicationID:
    					result = FREObject.newObject(cxt.applicationID);
	    				break;
    				case packageName:
    					result = FREObject.newObject(cxt.packageName);
	    				break;
    				case daysUntilPrompt:
    					result = FREObject.newObject(cxt.daysUntilPrompt);
	    				break;
    				case usesUntilPrompt:
    					result = FREObject.newObject(cxt.usesUntilPrompt);
	    				break;
    				case eventsUntilPrompt:
    					result = FREObject.newObject(cxt.eventsUntilPrompt);
	    				break;
    				case usesPerWeekForPrompt:
    					result = FREObject.newObject(cxt.usesPerWeekForPrompt);
	    				break;	    		
    				case remindPeriod:
    					result = FREObject.newObject(cxt.remindPeriod);
	    				break;	    		    				
    				case messageTitle:
    					result = FREObject.newObject(cxt.messageTitle);
	    				break;
    				case message:
    					result = FREObject.newObject(cxt.message);
	    				break;
    				case cancelButtonLabel:
    					result = FREObject.newObject(cxt.cancelButtonLabel);
	    				break;
    				case remindButtonLabel:
    					result = FREObject.newObject(cxt.remindButtonLabel);
	    				break;
    				case rateButtonLabel:
    					result = FREObject.newObject(cxt.rateButtonLabel);
	    				break;
    				case previewMode:
    					result = FREObject.newObject(cxt.previewMode);
	    				break;
    				case promptAgainForEachNewVersion:
    					result = FREObject.newObject(cxt.promptAgainForEachNewVersion);
    					break;
	    		}
	    }
	    catch (Exception e) {

		}	
		return result;
	}

}
