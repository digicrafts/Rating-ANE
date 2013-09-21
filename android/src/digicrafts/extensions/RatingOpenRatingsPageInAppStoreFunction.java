package digicrafts.extensions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class RatingOpenRatingsPageInAppStoreFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		RatingExtensionContext cxt = (RatingExtensionContext)context;
		cxt.openRatingsPageInAppStore();
		return null;
	}

}
