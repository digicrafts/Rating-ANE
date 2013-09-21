/*
 
 Copyright (c) 2012, DIVIJ KUMAR
 All rights reserved.
 
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

/*
 * Rate.m
 * Rate
 *
 * Created by Tsang Wai Lam on 28/10/12.
 * Copyright (c) 2012 __MyCompanyName__. All rights reserved.
 */

#import "Rating.h"

#import "iRate.h"


/* RateExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void DCRatingExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &DCRatingContextInitializer;
    *ctxFinalizerToSet = &DCRatingContextFinalizer;
}

/* RateExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void DCRatingExtFinalizer(void* extData)
{
//    NSLog(@"Entering RateExtFinalizer()");
    // Nothing to clean up.
//    NSLog(@"Exiting RateExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void DCRatingContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    
    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     */
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(shouldPromptForRating, NULL),
        MAP_FUNCTION(applicationLaunched, NULL),        
        MAP_FUNCTION(logEvent, NULL),        
        MAP_FUNCTION(promptForRating, NULL),
        MAP_FUNCTION(promptIfNetworkAvailable, NULL),
        MAP_FUNCTION(openRatingsPageInAppStore, NULL),
        
        // Properties
        MAP_FUNCTION(setPropertyBool, NULL),
        MAP_FUNCTION(getPropertyBool, NULL),
        MAP_FUNCTION(setPropertyNumber, NULL),
        MAP_FUNCTION(getPropertyNumber, NULL),
        MAP_FUNCTION(setPropertyString, NULL),
        MAP_FUNCTION(getPropertyString, NULL),
        
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;    

}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void DCRatingContextFinalizer(FREContext ctx)
{
//    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
//    NSLog(@"Exiting ContextFinalizer()");
    return;
}


ANE_FUNCTION(shouldPromptForRating)
{
    FREObject fo;    
    FREResult aResult = FRENewObjectFromBool([[iRate sharedInstance] shouldPromptForRating], &fo);
	return fo;
}

ANE_FUNCTION(applicationLaunched)
{
    if ([[iRate sharedInstance] shouldPromptForRating])
    {
        [[iRate sharedInstance] promptIfNetworkAvailable];
    }
	return nil;    
}

ANE_FUNCTION(logEvent)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    
    [[iRate sharedInstance] logEvent:(value>0)];

	return nil;    
}

ANE_FUNCTION(promptForRating)
{
    [[iRate sharedInstance] promptForRating];
	return nil;
}

ANE_FUNCTION(promptIfNetworkAvailable)
{
    [[iRate sharedInstance] promptIfNetworkAvailable];
	return nil;
}

ANE_FUNCTION(openRatingsPageInAppStore)
{
    [[iRate sharedInstance] openRatingsPageInAppStore];
	return nil;
}

// Get property name marco
#define GET_PROPERTY_NAME() \
uint32_t length = 0;\
const uint8_t *property = NULL;\
FREGetObjectAsUTF8( argv[0], &length, &property);\
NSString *propertyName=[NSString stringWithUTF8String:(char *)property];


// Properties

ANE_FUNCTION(setPropertyNumber)
{
    GET_PROPERTY_NAME()

    // Check if property exisit

    // Set the value
    int32_t numberValue;
    FREGetObjectAsInt32(argv[1], &numberValue);
    [[iRate sharedInstance] setValue:[NSNumber numberWithFloat:numberValue] forKey:propertyName];
    
	return nil;
}

ANE_FUNCTION(setPropertyString)
{
    GET_PROPERTY_NAME()
    // Set the value
    const uint8_t *stringValue = NULL;
    FREGetObjectAsUTF8(argv[1], &length, &stringValue);
    [[iRate sharedInstance] setValue:[NSString stringWithUTF8String:(char *)stringValue] forKey:propertyName];
    
	return nil;
}

ANE_FUNCTION(setPropertyBool)
{
    GET_PROPERTY_NAME()
    // Set the value
    uint32_t boolValue=0;
    FREGetObjectAsBool(argv[1], &boolValue);    
    [[iRate sharedInstance] setValue:[NSNumber numberWithFloat:boolValue] forKey:propertyName];
    
	return nil;
}

ANE_FUNCTION(getPropertyNumber)
{
    
    // Get property name
    GET_PROPERTY_NAME()
    // Set the value
    FREObject fo;
    NSNumber *number=[[iRate sharedInstance] valueForKey:propertyName];
    FRENewObjectFromDouble([number doubleValue], &fo);
    
	return fo;
}

ANE_FUNCTION(getPropertyString)
{
    
    // Get property name
    GET_PROPERTY_NAME()
    // Set the value
    if([propertyName isEqualToString:@"packageName"]) return nil;
    
    FREObject fo;
    NSString *str=[[iRate sharedInstance] valueForKey:propertyName];
    FRENewObjectFromUTF8([str length], (uint8_t *)[str UTF8String], &fo);
	return fo;
}

ANE_FUNCTION(getPropertyBool)
{
    
    // Get property name
    GET_PROPERTY_NAME()
    // Set the value
    FREObject fo;
    NSNumber *number=[[iRate sharedInstance] valueForKey:propertyName];
    FRENewObjectFromBool([number unsignedIntValue], &fo);
	return fo;
}
