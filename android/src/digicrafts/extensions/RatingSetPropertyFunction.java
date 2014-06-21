package digicrafts.extensions;

import com.adobe.fre.*;

public class RatingSetPropertyFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		FREObject propertyObj = args[0];
		FREObject valueObj = args[1];
	    try
	    {
	    		RatingExtensionContext cxt = (RatingExtensionContext)context;
	    		String property = propertyObj.getAsString();
	    		double doubleValue;
	    		String stringValue;
	    		boolean boolValue;
	    		
	    		switch(RatingProperty.valueOf(property)){
	    			case appStoreID:
    					stringValue=valueObj.getAsString();
    					cxt.appStoreID=stringValue;
	    				break;
    				case appStoreGenreID:
    					stringValue=valueObj.getAsString();
    					cxt.appStoreGenreID=stringValue;
	    				break;
    				case appStoreCountry:
    					stringValue=valueObj.getAsString();
    					cxt.appStoreCountry=stringValue;
	    				break;
    				case applicationName:
    					stringValue=valueObj.getAsString();
    					cxt.applicationName=stringValue;
	    				break;
    				case applicationID:
    					stringValue=valueObj.getAsString();
    					cxt.applicationID=stringValue;
	    				break;
    				case packageName:
    					stringValue=valueObj.getAsString();
    					cxt.packageName=stringValue;
	    				break;
    				case daysUntilPrompt:
    					doubleValue=valueObj.getAsDouble();
    					cxt.daysUntilPrompt=doubleValue;
	    				break;
    				case usesUntilPrompt:
    					doubleValue=valueObj.getAsDouble();
    					cxt.usesUntilPrompt=doubleValue;
	    				break;
    				case eventsUntilPrompt:
    					doubleValue=valueObj.getAsDouble();
    					cxt.eventsUntilPrompt=doubleValue;
	    				break;
    				case usesPerWeekForPrompt:
    					doubleValue=valueObj.getAsDouble();
    					cxt.usesPerWeekForPrompt=doubleValue;
	    				break;	
    				case remindPeriod:
    					doubleValue=valueObj.getAsDouble();
    					cxt.remindPeriod=doubleValue;
	    				break;		    				
    				case messageTitle:
    					stringValue=valueObj.getAsString();
    					cxt.messageTitle=stringValue;
	    				break;
    				case message:
    					stringValue=valueObj.getAsString();
    					cxt.message=stringValue;
	    				break;
    				case cancelButtonLabel:
    					stringValue=valueObj.getAsString();
    					cxt.cancelButtonLabel=stringValue;
	    				break;
    				case remindButtonLabel:
    					stringValue=valueObj.getAsString();
    					cxt.remindButtonLabel=stringValue;
	    				break;
    				case rateButtonLabel:
    					stringValue=valueObj.getAsString();
    					cxt.rateButtonLabel=stringValue;
	    				break;
    				case previewMode:
    					boolValue=valueObj.getAsBool();
    					cxt.previewMode=boolValue;
	    				break;
    				case promptAgainForEachNewVersion:
    					boolValue=valueObj.getAsBool();
    					cxt.promptAgainForEachNewVersion=boolValue;
    					break;
                    case isKindle:
                        boolValue=valueObj.getAsBool();
                        cxt.isKindle=boolValue;
                        break;
	    				
	    		}

	    }
	    catch (IllegalStateException e) {
	      e.printStackTrace();
	    } catch (FRETypeMismatchException e) {
	      e.printStackTrace();
	    } catch (FREInvalidObjectException e) {
	      e.printStackTrace();
	    } catch (FREWrongThreadException e) {
	      e.printStackTrace();
	    }
		return null;
	}

}
