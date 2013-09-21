package digicrafts.extensions;

import com.adobe.fre.*;

public class RatingPromptForRatingFunction implements FREFunction {
	
	  @Override
	  public FREObject call(FREContext context, FREObject[] args)
	  {
		RatingExtensionContext cxt = (RatingExtensionContext)context;
		cxt.promptForRating();
	    return null;
	  }

}
