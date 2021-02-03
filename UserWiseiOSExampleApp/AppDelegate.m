//
//  AppDelegate.m
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}
     
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self initializeUserWiseSDK];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.userWise onStop];
}

- (void)initializeUserWiseSDK {
    self.userWise = [UserWise sharedInstance];
    
    if (![self.userWise isSessionInitialized]) {
        [self.userWise setDebugMode:YES];
        [self.userWise setHostOverride:[NSURL URLWithString:@"http://localhost:3000"]];
        [self.userWise setApiKey:@"1ce8092b0732d711e7c22108b2cd"];
        [self.userWise setUserId:@"userwise-demo-ios-user"];
        
        // or: [self.userWise initializeWithApiKey:(NSString* _Nonnull) userId:(NSString* _Nonnull)];
    }
    
    // VariablesModule Configuration *must* be configured prior to calling onStart
    self.maxLevelVar = [[IntegerVariable alloc] initWithName:@"maxLevel" defaultValue:0];
    self.enableThingAVar = [[BooleanVariable alloc] initWithName:@"enableThingA" defaultValue:false];
    self.startThisThingAtVar = [[DatetimeVariable alloc] initWithName:@"startThisThingAt" defaultValue:nil];
    self.titleVar = [[StringVariable alloc] initWithName:@"title" defaultValue:@"title"];
    self.descriptionVar = [[StringVariable alloc] initWithName:@"description" defaultValue:@"My default description"];
    self.exchangeRateVar = [[FloatVariable alloc] initWithName:@"exchangeRate" defaultValue:0.0f];
    self.headerImageVar = [[FileVariable alloc] initWithName:@"headerImage"];

    [self.userWise.variablesModule defineWithVariables:@[self.maxLevelVar, self.enableThingAVar, self.startThisThingAtVar, self.titleVar, self.descriptionVar, self.exchangeRateVar, self.headerImageVar] error:nil];
    
    self.userWise.variablesModule.variablesDelegate = self;
    [self.userWise onStart];

    // SurveysModule Configuration
    [self.userWise.surveysModule setSurveyDelegate:[ExampleSurveyDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];
    // [self.userWise.surveysModule setColorsWithPrimaryColor:UIColor.purpleColor splashScreenBackgroundColor:UIColor.whiteColor];
    // [self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];
    
    // OffersModule Configuration
    [self.userWise.offersModule setOfferDelegate:[ExampleOfferDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];
    
    // MessagesModule Configuration
    [self.userWise.messagesModule setMessageDelegate:[ExampleMessageDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];

    // Finally, you can assign your app user attributes and events directly within the SDK!
    //NSDictionary *attributes = @{@"current_coins": @10000, @"current_diamonds": @20};
    //[self.userWise setAttributes:attributes];
    //[self.userWise assignEvent:@"completed_tutorial" attributes:@{@"was_repeat_play": @NO}];
}

- (void)onVariablesLoadedFromCache:(BOOL)fromCache {
    NSLog(@"Variables loaded!");
    
    NSLog(@"Variables Defined:");
    NSLog(@"maxLevel: %ld", [self.maxLevelVar getValue]);
    NSLog(@"enableThingA: %s", [self.enableThingAVar getValue] == YES ? "true" : "false");
    NSLog(@"startThisThingAt: %@", [self.startThisThingAtVar getValue]);
    NSLog(@"title: %@", [self.titleVar getValue]);
    NSLog(@"exchangeRate: %f", [self.exchangeRateVar getValue]);
    NSLog(@"headerImage: %@", [self.headerImageVar getValue]);
    
    FileHandler *handler = [[FileHandler alloc] init];
    handler.userWise = self.userWise;
    
    [self.userWise getMediaWithMediaId:[self.headerImageVar getValue] handler:handler];
}

@end
