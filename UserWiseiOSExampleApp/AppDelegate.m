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
    if ([self.userWise isRunning]) {
        [self.userWise onStop];
    }
}

- (void)initializeUserWiseSDK {
    self.userWise = [UserWise sharedInstance];
    
    if (![self.userWise isRunning]) {
        [self.userWise setDebugMode:YES];
        [self.userWise setHostOverride:[NSURL URLWithString:@"http://lvh.me:3000"]];
        [self.userWise setApiKey:@"8b04e77363e49cba7d0a44a969a8"];
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

    // SurveysModule Configuration
    [self.userWise.surveysModule setSurveyDelegate:[ExampleSurveyDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];
    // [self.userWise.surveysModule setColorsWithPrimaryColor:UIColor.purpleColor splashScreenBackgroundColor:UIColor.whiteColor];
    // [self.userWise setSplashScreenLogo:[UIImage imageNamed:@"herowars-logo"]];

    // OffersModule Configuration
    [self.userWise.offersModule setOfferDelegate:[ExampleOfferDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];

    // MessagesModule Configuration
    [self.userWise.messagesModule setMessageDelegate:[ExampleMessageDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];
    
    // EventsModule Configuration
    [self.userWise.eventsModule setEventDelegate:[ExampleGameEventDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];
    
    // RemoteConfigsModule Configuration
    [self.userWise.remoteConfigsModule setRemoteConfigDelegate:[ExampleRemoteConfigDelegate initWithController:[UIApplication sharedApplication].keyWindow.rootViewController andUserWise:self.userWise]];
    
    [self.userWise onStart];
    
    // Finally, you can assign your app user attributes and events, directly within the SDK!
    [self performSelector:@selector(assignUserLoginData) withObject:nil afterDelay:5.0];
}

- (void)assignUserLoginData {
    // You can assign PlayerEvents (w/ optional attributes)...
    NSArray<PlayerEventAttribute *> *eventAttributes = @[
        [[PlayerEventAttribute alloc] initWithName:@"new_player" dataType:AttributableDataTypeBoolean value:@NO]
    ];
    PlayerEvent *event = [[PlayerEvent alloc] initWithEventId:@"event_logged_in" attributes:eventAttributes];
    [self.userWise assignEvent:event callback:nil];
    
    // ...And, you can assign PlayerAttributes
    NSArray<PlayerAttribute *> *attributes = @[
        [[PlayerAttribute alloc] initWithName:@"coins" dataType:AttributableDataTypeInteger value:@1000],
        [[PlayerAttribute alloc] initWithName:@"ltv" dataType:AttributableDataTypeFloat value:@100.24],
        [[PlayerAttribute alloc] initWithName:@"season_spring_2021_passholder" dataType:AttributableDataTypeBoolean value:@NO]
    ];
    [self.userWise setAttributes:attributes callback:nil];

    // ...Also, you can transition to various in-app regions
    NSArray<RegionMetadata *> *regionMetadata = @[
        [[RegionMetadata alloc] initWithName:@"team_one_power" dataType:AttributableDataTypeInteger value:@150],
        [[RegionMetadata alloc] initWithName:@"team_two_power" dataType:AttributableDataTypeInteger value:@9001]
    ];
    Region *region = [[Region alloc] initWithName:@"team_battle" metadata:regionMetadata];
    [self.userWise transitionToRegion:region callback:nil];
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
