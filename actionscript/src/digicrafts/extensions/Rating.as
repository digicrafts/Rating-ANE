/*
Rating Native Extension for Adobe Air

Copyright (c) 2012, Digicrafts
All rights reserved.
http://www.digicrafts.com.hk/components

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of the FreeBSD Project.

*/
package digicrafts.extensions
{
	
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.system.System;
	
	/**
	 * Rating ANE is a library to help you promote your apps by prompting users to rate 
	 * the app after using it for a few days. This approach is one of the best ways to 
	 * get positive app reviews by targeting only regular users (who presumably like the app or they wouldn't keep using it!).
	 * 
	 * Rating ANE have a easy way for developers to intergrade the rating dialog into
	 * mobile app which developed with Adobe Air.
	 * 
	 * @author Digicrafts
	 * 
	 */	
	public class Rating
	{
		/**
		 * @private 
		 */		
		public static var instance:Rating;
		private static var allowInstance:Boolean=false;
		private static var extensionContext:ExtensionContext = null;
		private static var isIOS:Boolean=false;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function Rating()
		{
			if(!allowInstance){
				throw new Error("Error: Instantiation failed: Use Rating.getInstance() instead of new.");
			}
		}
		
// Private Static Function
/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * @private
		 * @return 
		 * 
		 */		
		private static function getInstance():Rating
		{
			if(instance==null){
				allowInstance=true;
				instance=new Rating();			
				if ( !extensionContext )
				{
					trace("[Rating] Get Rating Extension Instance...");
					extensionContext = ExtensionContext.createExtensionContext("digicrafts.extensions.Rating","Rating");					
					if(Capabilities.os.indexOf("iPhone")!=-1) isIOS=true;
				}
				allowInstance=false;
			}
			return instance;
		}
		
// Public Static Function
/////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		 * Call this when application launched
		 * 
		 */		
		public static function applicationLaunched():void
		{
			getInstance()._applicationLaunched();
		}
		/**
		 * 
		 * @param deferPrompt
		 * 
		 */	
//		public static function logEvent(deferPrompt:Boolean=false):void
//		{
//			getInstance()._logEvent(deferPrompt);
//		}
		/**
		 * Call this when application launched
		 * 
		 */		
		public static function shouldPromptForRating():Boolean
		{
			return getInstance()._shouldPromptForRating();
		}
		/**
		 * Open dialog prompt for rating
		 * This method will immediately trigger the rating prompt without checking that the app store is available, and without calling the iRateShouldShouldPromptForRating delegate method. Note that this method depends on the appStoreID and applicationGenre properties, which are only retrieved after polling the iTunes server, so if you intend to call this method directly, you will need to set these properties yourself beforehand, or use the promptIfNetworkAvailable method instead.
		 */		
		public static function promptForRating():void
		{
			getInstance()._promptForRating();
		}
		/**
		 * Open dialog prompt for rating if there is network connection
		 * This method will check if the app store is available, and if it is, it will display the rating prompt to the user. The iRateShouldShouldPromptForRating delegate method will be called before the alert is shown, so you can intercept it. Note that if your app is sandboxed and does not have the network access permission, this method will ignore the network availability status, however in this case you will need to manually set the appStoreID or iRate cannot function.
		 */		
		public static function promptIfNetworkAvailable():void
		{
			getInstance()._promptIfNetworkAvailable();	
		}
		/**
		 * Open the rating page in correspoding store.
		 * This method skips the user alert and opens the application ratings page in the Mac or iPhone app store, depending on which platform is running. This method does not perform any checks to verify that the machine has network access or that the app store is available. It also does not call any delegate methods. You should use this method instead of the ratingsURL property if you are running on Mac OS as the process for launching the Mac app store is more complex than merely opening the URL. Note that this method depends on the appStoreID which is only retrieved after polling the iTunes server, so if you intend to call this method directly, you will need to set the appStoreID property yourself beforehand.
		 */		
		public static function openRatingsPage():void
		{
			getInstance()._openRatingsPageInAppStore();
		}

// Public Static Value
/////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Return the uses count.
		 * The number of times the current version of the app has been used (launched).
		 * @return 
		 * 
		 */		
		public static function get usesCount():Number
		{
			return getInstance()._getPropertyNumber("usesCount");
		}
//		/**
//		 * The number of significant application events that have been recorded since the current version was installed. This is incremented by the logEvent method, but can also be manipulated directly. Check out the Events Demo to see how this os used.
//		 * @return 
//		 * 
//		 */		
//		public static function get eventCount():Number
//		{
//			return getInstance()._getPropertyNumber("eventCount");
//		}
		/**
		 * Return the uses count per week.
		 * The average number of times per week that the current version of the app has been used (launched).
		 * @return 
		 * 
		 */		
		public static function get usesPerWeek():Number
		{
			return getInstance()._getPropertyNumber("usesPerWeek");
		}
		
		
		public static function get declinedThisVersion():Boolean
		{
			return getInstance()._getPropertyBool("declinedThisVersion");
		}
		
		public static function get declinedAnyVersion():Boolean
		{
			return getInstance()._getPropertyBool("declinedAnyVersion");
		}
		
		public static function get ratedThisVersion():Boolean
		{
			return getInstance()._getPropertyBool("ratedThisVersion");
		}
		
		public static function get ratedAnyVersion():Boolean
		{
			return getInstance()._getPropertyBool("ratedAnyVersion");
		}
		
		
		//
		/**
		 * Enable/disable preview mode.  
		 * If set to YES, iRate will always display the rating prompt on launch, regardless of how long the app has been in use or whether it's the latest version. Use this to proofread your message and check your configuration is correct during testing, but disable it for the final release (defaults to NO).
		 * @return 
		 * @default false
		 */
		public static function get previewMode():Boolean
		{
			return getInstance()._getPropertyBool("previewMode");
		}
		/**
		 * @private 
		 */		
		public static function set previewMode(value:Boolean):void
		{
			getInstance()._setPropertyBool("previewMode",value);
		}
		/**
		 * Set the days until the rating dialog start popup.
		 * This is the number of days the user must have had the app installed before they are prompted to rate it. The time is measured from the first time the app is launched. This is a floating point value, so it can be used to specify a fractional number of days (e.g. 0.5). The default value is 10 days. 
		 * @return 
		 * @default 10
		 */
		public static function get daysUntilPrompt():Number
		{
			return getInstance()._getPropertyNumber("daysUntilPrompt");
		}
		/**
		 * @private 
		 */		
		public static function set daysUntilPrompt(value:Number):void
		{
			getInstance()._setPropertyNumber("daysUntilPrompt",value);
		}
		/**
		 * Set the uses count until the rating dialog start popup.
		 * This is the minimum number of times the user must launch the app before they are prompted to rate it. This avoids the scenario where a user runs the app once, doesn't look at it for weeks and then launches it again, only to be immediately prompted to rate it. The minimum use count ensures that only frequent users are prompted. The prompt will appear only after the specified number of days AND uses has been reached. This defaults to 10 events. This defaults to 10 uses.
		 * @return 
		 * @default 10
		 */		
		public static function get usesUntilPrompt():Number
		{
			return getInstance()._getPropertyNumber("usesUntilPrompt");
		}
		public static function set usesUntilPrompt(value:Number):void
		{
			getInstance()._setPropertyNumber("usesUntilPrompt",value);
		}
//		/**
//		 * For some apps, launches are not a good metric for usage. For example the app might be a daemon that runs constantly, or a game where the user can't write an informed review until they've reached a particular level. In this case you can manually log significant events and have the prompt appear after a predetermined number of these events. Like the usesUntilPrompt setting, the prompt will appear only after the specified number of days AND events, however once the day threshold is reached, the prompt will appear if EITHER the event threshold OR uses threshold is reached. This defaults to 10 events.
//		 * @return 
//		 * 
//		 */				
//		public static function get eventsUntilPrompt():Number
//		{
//			return getInstance()._getPropertyNumber("eventsUntilPrompt");
//		}		
//		public static function set eventsUntilPrompt(value:Number):void
//		{
//			getInstance()._setPropertyNumber("eventsUntilPrompt",value);
//		}		
		/**
		 * Set the uses count per week until the rating dialog start popup. Set to 0 if you don't want this features.
		 * If you are less concerned with the total number of times the app is used, but would prefer to use the frequency of times the app is used, you can use the usesPerWeekForPrompt property to set a minimum threshold for the number of times the user must launch the app per week (on average) for the prompt to be shown. Note that this is the average since the app was installed, so if the user goes for a long period without running the app, it may throw off the average. The default value is zero.
		 * @return 
		 * @default 0
		 */		
		public static function get usesPerWeekForPrompt():Number
		{
			return getInstance()._getPropertyNumber("usesPerWeekForPrompt");
		}
		public static function set usesPerWeekForPrompt(value:Number):void
		{
			getInstance()._setPropertyNumber("usesPerWeekForPrompt",value);
		}
		/**
		 * Set the days until the rating dialog popup again after user click on reminds button. 
		 * How long the app should wait before reminding a user to rate after they select the "remind me later" option (measured in days). A value of zero means the app will remind the user next launch. Note that this value supersedes the other criteria, so the app won't prompt for a rating during the reminder period, even if a new version is released in the meantime. This defaults to 1 day.
		 * @return 
		 * @default 1
		 */		
		public static function get remindPeriod():Number
		{
			return getInstance()._getPropertyNumber("remindPeriod");
		}
		public static function set remindPeriod(value:Number):void
		{
			getInstance()._setPropertyNumber("remindPeriod",value);
		}

		//
		/**
		 * Set the App Store id. (IOS only) 
		 * This should match the iTunes app ID of your application, which you can get from iTunes connect after setting up your app. This value is not normally necessary and is generally only required if you have the aforementioned conflict between bundle IDs for your Mac and iOS apps, or in the case of Sandboxed Mac apps, if your app does not have network permission because it won't be able to fetch the appStoreID automatically using iTunes services.
		 * @return 
		 * 
		 */
		public static function get appStoreID():Number
		{
			return getInstance()._getPropertyNumber("appStoreID");
		}
		public static function set appStoreID(value:Number):void
		{
			getInstance()._setPropertyNumber("appStoreID",value);
		}
		/**
		 * Set the App Store GenreID. (IOS only) 
		 * This is the type of app, used to determine the default text for the rating dialog. This is set automatically by calling an iTunes service, so you shouldn't need to set it manually for most purposes. If you do wish to override this value, setting it to the iRateAppStoreGameGenreID constant will cause iRate to use the "game" version of the rating dialog, and setting it to any other value will use the "app" version of the rating dialog.
		 * @return 
		 * 
		 */
		public static function get appStoreGenreID():Number
		{
			return getInstance()._getPropertyNumber("appStoreGenreID");
		}
		public static function set appStoreGenreID(value:Number):void
		{
			getInstance()._setPropertyNumber("appStoreGenreID",value);
		}
		/**
		 * Set the rating page country. (IOS only) 
		 * This is the two-letter country code used to specify which iTunes store to check. It is set automatically from the device locale preferences, so shouldn't need to be changed in most cases. You can override this to point to the US store, or another specific store if you prefer, which may be a good idea if your app is only available in certain countries.
		 * @return 
		 * 
		 */
		public static function get appStoreCountry():String
		{
			return getInstance()._getPropertyString("appStoreCountry");
		}
		public static function set appStoreCountry(value:String):void
		{
			getInstance()._setPropertyString("appStoreCountry",value);
		}
		/**
		 * Set the package name. (Android only) 
		 * @return 
		 * 
		 */
		public static function get packageName():String
		{
			return getInstance()._getPropertyString("packageName");
		}
		public static function set packageName(value:String):void
		{
			getInstance()._setPropertyString("packageName",value);
		}
		/**
		 * Set/get the application name. The application name will appear in the rating dialog. Default value is get from the package application name.
		 * <br/>
		 * This is the name of the app displayed in the iRate alert. It is set automatically from the application's info.plist, but you may wish to override it with a shorter or longer version. 
		 * @return 
		 * 
		 */
		public static function get applicationName():String
		{
			return getInstance()._getPropertyString("applicationName");
		}
		public static function set applicationName(value:String):void
		{
			getInstance()._setPropertyString("applicationName",value);
		}
		/**
		 * Set/get the application bundle id.
		 * <br/> 
		 * This is the application bundle ID, used to retrieve the appStoreID and appStoreGenreID from iTunes. This is set automatically from the app's info.plist, so you shouldn't need to change it except for testing purposes.
		 * @return 
		 * 
		 */
		public static function get applicationBundleID():String
		{
			return getInstance()._getPropertyString("applicationBundleID");
		}
		public static function set applicationBundleID(value:String):void
		{
			getInstance()._setPropertyString("applicationBundleID",value);
		}

		//
		
		/**
		 * Set/get the message title of the rating dialog. 
		 * @return 
		 * @default "Rate {applicationName}"
		 */
		public static function get messageTitle():String
		{
			return getInstance()._getPropertyString("messageTitle");
		}
		public static function set messageTitle(value:String):void
		{
			getInstance()._setPropertyString("messageTitle",value);
		}
		/**
		 * Set/get the message of the rating dialog. 
		 * @return		 
		 */
		public static function get message():String
		{
			return getInstance()._getPropertyString("message");
		}
		public static function set message(value:String):void
		{
			getInstance()._setPropertyString("message",value);
		}
		/**
		 * Set/get the label of cancel button in the rating dialog. 
		 * @return 
		 * @default "No Thanks"
		 */
		public static function get cancelButtonLabel():String
		{
			return getInstance()._getPropertyString("cancelButtonLabel");
		}
		public static function set cancelButtonLabel(value:String):void
		{
			getInstance()._setPropertyString("cancelButtonLabel",value);
		}
		/**
		 * Set/get the label of remind button in the rating dialog. 
		 * @return 
		 * @default "Remind Me Later"
		 */
		public static function get remindButtonLabel():String
		{
			return getInstance()._getPropertyString("remindButtonLabel");
		}
		public static function set remindButtonLabel(value:String):void
		{
			getInstance()._setPropertyString("remindButtonLabel",value);
		}
		/**
		 * Set/get the label of rate button in the rating dialog. 
		 * @return 
		 * @default "Rate It Now"
		 */
		public static function get rateButtonLabel():String
		{
			return getInstance()._getPropertyString("rateButtonLabel");
		}
		public static function set rateButtonLabel(value:String):void
		{
			getInstance()._setPropertyString("rateButtonLabel",value);
		}


// Private Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		/**
		 * @private
		 */		
		protected function _applicationLaunched():void
		{
            if(extensionContext)
			    extensionContext.call("applicationLaunched");
		}
		/**
		 * @private
		 */			
		protected function _logEvent(deferPrompt:Boolean):void
		{
            if(extensionContext)
			    extensionContext.call("logEvent",deferPrompt);
		}
		/**
		 * @private
		 */			
		protected function _shouldPromptForRating():Boolean
		{
            if(extensionContext)
			    return extensionContext.call("shouldPromptForRating");
            else
                return false;
		}
		/**
		 * @private
		 */			
		protected function _promptForRating():void
		{
            if(extensionContext)
			    extensionContext.call("promptForRating");
		}
		/**
		 * @private
		 */			
		protected function _promptIfNetworkAvailable():void
		{
            if(extensionContext)
			    extensionContext.call("promptIfNetworkAvailable");
		}
		/**
		 * @private
		 */			
		protected function _openRatingsPageInAppStore():void
		{
            if(extensionContext)
			    extensionContext.call("openRatingsPageInAppStore");
		}

// Private Functions for Properties
/////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		 * @private
		 */		
		protected function _setPropertyBool(property:String,value:Boolean):void
		{
            if(extensionContext){
                if(isIOS)
                    extensionContext.call("setPropertyBool",property,value);
                else
                    extensionContext.call("setProperty",property,value);
            }
		}
		/**
		 * @private
		 */		
		protected function _setPropertyNumber(property:String,value:Number):void
		{
            if(extensionContext){
                if(isIOS)
                    extensionContext.call("setPropertyNumber",property,value);
                else
                    extensionContext.call("setProperty",property,value);
            }
		}
		/**
		 * @private
		 */		
		protected function _setPropertyString(property:String,value:String):void
		{
            if(extensionContext){
                if(isIOS)
                    extensionContext.call("setPropertyString",property,value);
                else
                    extensionContext.call("setProperty",property,value);
            }
		}
		/**
		 * @private
		 */		
		protected function _getPropertyBool(property:String):Boolean
		{
            if(extensionContext){
                if(isIOS)
                    return extensionContext.call("getPropertyBool",property) as Boolean;
                else
                    return extensionContext.call("getProperty",property) as Boolean;
            }
            return false;
		}
		/**
		 * @private
		 */		
		protected function _getPropertyNumber(property:String):Number
		{
            if(extensionContext){
                if(isIOS)
                    return extensionContext.call("getPropertyNumber",property) as Number;
                else
                    return extensionContext.call("getProperty",property) as Number;
            }
            return 0;
		}
		/**
		 * @private
		 */		
		protected function _getPropertyString(property:String):String
		{
            if(extensionContext){
                if(isIOS)
                    return extensionContext.call("getPropertyString",property) as String;
                else
                    return extensionContext.call("getProperty",property) as String;
            }
            return null;
		}
		
	}
}