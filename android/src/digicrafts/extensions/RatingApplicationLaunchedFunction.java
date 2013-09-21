package digicrafts.extensions;

import com.adobe.fre.*;

public class RatingApplicationLaunchedFunction implements FREFunction {
	
	@Override
  	public FREObject call(FREContext context, FREObject[] args)
	{

		RatingExtensionContext cxt = (RatingExtensionContext)context;
		cxt.applicationLaunched();
	    return null;
	}
}
