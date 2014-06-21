package digicrafts.extensions;

import android.widget.*;
import android.app.Dialog;
import android.content.*;
import android.util.Log;
import android.view.View;
import android.content.pm.*;
import android.net.*;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class RatingExtensionContext extends FREContext {

	private static final String TAG = RatingExtensionContext.class.getName();	
    
    public String appStoreID =	"";
	public String appStoreGenreID =	"";
	public String appStoreCountry =	"";
    public String applicationName =	"";
    public String applicationID =	"";
    public String packageName =	"";
    
    public double daysUntilPrompt=10;
    public double usesUntilPrompt=10;
    public double eventsUntilPrompt=10;
    public double usesPerWeekForPrompt=0;
    public double remindPeriod=1;    
 
    public String messageTitle="";
    public String message="";
    public String cancelButtonLabel="No, Thanks";
    public String remindButtonLabel="Remind Me Later";
    public String rateButtonLabel="Rate It Now";    
    
    public long usesCount=0;
    public long eventCount=0;
    public double usesPerWeek=0;    
    public boolean previewMode=false;
    public boolean promptAgainForEachNewVersion=true;
    public boolean ratedAnyVersion=false;
    public boolean ratedThisVersion=false;
    public boolean declinedThisVersion=false;
    public boolean declinedAnyVersion=false;

    public boolean isKindle=false;
    private boolean isFirstLaunch=false;
    private int	lastVersion=0;
    private int	lastRatedVersion=0;
    private int	thisVersion=0;
    private long firstUsed=0;
    private long lastReminded=0;
    
	
	@Override
	public void dispose() {

	}


	@Override
	public Map<String, FREFunction> getFunctions() {
		
		// Check if Kindle
		isKindle=android.os.Build.MANUFACTURER.equals("Amazon")
					&& (android.os.Build.MODEL.equals("Kindle Fire")
	                || android.os.Build.MODEL.startsWith("KF"));
		
		// Build function map
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
	    
		// Methods
		functionMap.put("isSupported", new RatingIsSupportedFunction());
		functionMap.put("applicationLaunched", new RatingApplicationLaunchedFunction());
		functionMap.put("logEvent", new RatingLogEventFunction());
		functionMap.put("shouldPromptForRating", new RatingShouldPromptForRatingFunction());		
		functionMap.put("promptForRating", new RatingPromptForRatingFunction());
		functionMap.put("promptIfNetworkAvailable", new RatingPromptIfNetworkAvailableFunction());
		functionMap.put("openRatingsPageInAppStore", new RatingOpenRatingsPageInAppStoreFunction());
		
		// Properties
		functionMap.put("setProperty", new RatingSetPropertyFunction());
		functionMap.put("getProperty", new RatingGetPropertyFunction());	
		
		Context mContext=this.getActivity();
		
		Log.d(TAG,"MAP");
		
		// Get saved perference
        SharedPreferences prefs = mContext.getSharedPreferences("RatingExtensionSharedPreferences", 0);
        usesCount = prefs.getLong("usesCount", 0);
        firstUsed = prefs.getLong("firstUsed", 0);
        lastVersion = prefs.getInt("lastVersion", 0);
        lastRatedVersion = prefs.getInt("lastRatedVersion", 0);
        ratedAnyVersion= prefs.getBoolean("ratedAnyVersion", false);
        declinedThisVersion= prefs.getBoolean("declinedThisVersion", false);
        declinedAnyVersion= prefs.getBoolean("declinedAnyVersion", false);
        isKindle= prefs.getBoolean("isKindle", false);
        
        SharedPreferences.Editor editor = prefs.edit();
        
        // Check if first use
        if(firstUsed==0){
            firstUsed = System.currentTimeMillis();
            editor.putLong("firstUsed", firstUsed);
            isFirstLaunch=true;
        }
        	
        // Set per week count
        usesPerWeek=usesCount/firstUsed/604800;
        
        // Check version
        try {
            PackageInfo info = mContext.getPackageManager().getPackageInfo(this.getActivity().getApplicationContext().getPackageName(),0);
            thisVersion=info.versionCode;
            if(thisVersion!=lastVersion){
                declinedThisVersion=false;
                editor.putBoolean("declinedThisVersion", false);
                editor.putInt("lastVersion", thisVersion);
            }
        } catch (PackageManager.NameNotFoundException e) {
            
        }
        if(lastRatedVersion==thisVersion)ratedThisVersion=true;
        
        editor.commit();
        
		updateMessage();
		
		return functionMap;
	}
	
	private void updateMessage()
	{
        Log.d(TAG,"updateMessage() applicationName:"+applicationName);

        // Replace text
        if(messageTitle=="") messageTitle="Rate " + applicationName;
//        if(message=="")
            message="If you enjoy using " + applicationName + ", would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!";
        if(packageName=="")packageName=this.getActivity().getApplicationContext().getPackageName();
        
	}
	
	public Boolean shouldPromptForRating() 
	{
		Log.d(TAG,"checkshouldPromptForRating");
		
		float usesPerWeek=0;
		
	    //preview mode?
	    if (previewMode)
	    {
            Log.d(TAG,"iRate preview mode is enabled - make sure you disable this for release");
	        return true;
	    }	    
	    //check if we've rated this version
	    else if (ratedThisVersion)
	    {
            Log.d(TAG,"iRate did not prompt for rating because the user has already rated this version");
	        return false;
	    }
	    //check if we've rated any version
	    else if (!promptAgainForEachNewVersion && ratedAnyVersion)
	    {
            Log.d(TAG,"iRate did not prompt for rating because the user has already rated this app, and promptAgainForEachNewVersion is disabled");
	        return false;
	    }	    
	    //check if we've declined to rate this version
	    else if (declinedThisVersion)
	    {
	    		Log.d(TAG,"iRate did not prompt for rating because the user has declined to rate this version");
	        return false;
	    }	    
	    //check for first launch
	    else if ((daysUntilPrompt > 0.0 || usesPerWeekForPrompt > 0.0) && isFirstLaunch)
	    {
            Log.d(TAG,"iRate did not prompt for rating because this is the first time the app has been launched");
	        return false;
	    }
	    
	    //check how long we've been using this version
	    else if (System.currentTimeMillis() < firstUsed + (daysUntilPrompt * 24 * 60 * 60 * 1000))
	    {
            Log.d(TAG,"iRate did not prompt for rating because the app was first used less than "+daysUntilPrompt+" days ago");
	        return false;
	    }
	    
	    //check how many times we've used it and the number of significant events
	    else if (usesCount < usesUntilPrompt && eventCount < eventsUntilPrompt)
	    {
            Log.d(TAG,"iRate did not prompt for rating because the app has only been used "+(int)usesCount+" times and only "+(int)eventCount+" events have been logged");
	        return false;
	    }
	    
	    //check if usage frequency is high enough
	    else if (usesPerWeek < usesPerWeekForPrompt)
	    {
            Log.d(TAG,"iRate did not prompt for rating because the app has only been used "+usesPerWeek+" times per week on average since it was installed");
	        return false;
	    }

	    //check if within the reminder period
	    else if (lastReminded != 0 && System.currentTimeMillis() - lastReminded < remindPeriod * 86400)
	    {
            Log.d(TAG,"iRate did not prompt for rating because the user last asked to be reminded less than "+remindPeriod+" days ago");
	        return false;
	    }	  
	    
		return true;
	}
	
	public void applicationLaunched() {
		
		Log.d(TAG,"applicationLaunched A");
		
		Context mContext=this.getActivity();
		
        SharedPreferences prefs = mContext.getSharedPreferences("RatingExtensionSharedPreferences", 0);        
//        if (!previewMode&&prefs.getBoolean("dontshowagain", false)) { return ; }
        SharedPreferences.Editor editor = prefs.edit();        
        
        // Increment launch counter
        usesCount = prefs.getLong("usesCount", 0) + 1;
        editor.putLong("usesCount", usesCount);
        
        // Get date of first launch
        firstUsed = prefs.getLong("date_firstlaunch", 0);
        if (firstUsed == 0) {
        		firstUsed = System.currentTimeMillis();
            editor.putLong("firstUsed", firstUsed);
        }
        
        // Wait at least n days before opening
//        if (usesCount >= usesUntilPrompt) {
//            if (System.currentTimeMillis() >= date_firstLaunch + 
//                    (daysUntilPrompt * 24 * 60 * 60 * 1000)) {
//                showRateDialog(mContext, editor);
//            }
//        }
        // Check if need to Prompt
        if(shouldPromptForRating())
        		showRateDialog(mContext, editor);
        
        editor.commit();
	}   
	
	public void logEvent(String msg)
	{

	}
	
	public void promptForRating()
	{
		Context mContext=this.getActivity();
        SharedPreferences prefs = mContext.getSharedPreferences("RatingExtensionSharedPreferences", 0);        
        SharedPreferences.Editor editor = prefs.edit();		
		showRateDialog(mContext,editor);
	}
	
	public void promptIfNetworkAvailable()
	{
		ConnectivityManager connectivityManager = (ConnectivityManager) this.getActivity().getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo activeNetworkInfo = connectivityManager.getActiveNetworkInfo();
		if(activeNetworkInfo != null){
			promptForRating();
		}
	}
	
	public void openRatingsPageInAppStore()
	{
		
		Context mContext=this.getActivity();		
		if(packageName=="")packageName=mContext.getPackageName();
		String url="market://details?id=" + packageName;
		if(isKindle) url="http://www.amazon.com/gp/mas/dl/android?p=" + packageName;
		mContext.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
	}	
	
	public void showRateDialog(final Context mContext,final SharedPreferences.Editor editor) 
	{	   
		
		updateMessage(); 
		
		final RatingExtensionContext cxt=this;
        final Dialog dialog = new Dialog(mContext);        

        // Set Dialog Title
        dialog.setTitle(messageTitle);
        // Layout
        LinearLayout ll = new LinearLayout(mContext);
        ll.setOrientation(LinearLayout.VERTICAL);
        // Message
        TextView tv = new TextView(mContext);
        tv.setText(message);
        tv.setWidth(240);
        tv.setPadding(4, 0, 4, 10);
        ll.addView(tv);        
        // Add Rate Button
        Button b1 = new Button(mContext);
        b1.setText(rateButtonLabel);
        View.OnClickListener l1=new View.OnClickListener() {
            public void onClick(View v) {
            		// Open link
            		cxt.openRatingsPageInAppStore();
                dialog.dismiss();
                
                // Set rated version
                editor.putInt("lastRatedVersion", thisVersion);
                editor.putBoolean("ratedAnyVersion",true);                
                editor.commit();
                lastRatedVersion=thisVersion;
                
            }
        };
        b1.setOnClickListener(l1);
        ll.addView(b1);
        // Add Remind Button
        Button b2 = new Button(mContext);
        b2.setText(remindButtonLabel);
        View.OnClickListener l2=new View.OnClickListener() {
            public void onClick(View v) {
                dialog.dismiss();
            }
        };
        b2.setOnClickListener(l2);
        ll.addView(b2);
        // Add No Thanks Button
        Button b3 = new Button(mContext);
        b3.setText(cancelButtonLabel);
        View.OnClickListener l3=new View.OnClickListener() {
            public void onClick(View v) {
                if (editor != null) {
                    declinedThisVersion=true;
                    declinedAnyVersion=true;
                    editor.putBoolean("dontshowagain", true);
                    editor.putBoolean("declinedThisVersion", true);
                    editor.putBoolean("declinedAnyVersion", true);
                    editor.commit();
                }
                dialog.dismiss();
            }
        };
        b3.setOnClickListener(l3);
        ll.addView(b3);

        dialog.setContentView(ll);        
        dialog.show();        
    }
	
}
