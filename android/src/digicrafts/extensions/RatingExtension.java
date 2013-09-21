package digicrafts.extensions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class RatingExtension implements FREExtension {

	@Override
	public FREContext createContext(String contextType) {
		// TODO Auto-generated method stub
		return new RatingExtensionContext();
	}

	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public void initialize() {
		// TODO Auto-generated method stub

	}

}
