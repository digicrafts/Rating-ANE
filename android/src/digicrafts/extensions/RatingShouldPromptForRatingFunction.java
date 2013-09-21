package digicrafts.extensions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class RatingShouldPromptForRatingFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		FREObject result = null;
	    try
	    {	    	
	    		RatingExtensionContext cxt = (RatingExtensionContext)context;
	    		result = FREObject.newObject(cxt.shouldPromptForRating());
	    }
	    catch (Exception e) {

		}	
		return result;
	}

}
