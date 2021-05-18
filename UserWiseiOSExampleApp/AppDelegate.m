//
//  AppDelegate.m
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");
    
    self.userWise = [UserWise sharedInstance];
    [self.userWise initializeUserWise];
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
        }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    // [END register_for_notifications]
    
    UNNotificationAction* enter = [UNNotificationAction
                                   actionWithIdentifier:@"EnterAction"
                                   title:@"Enter"
                                   options:UNNotificationActionOptionForeground];
    UNNotificationAction* snooze = [UNNotificationAction
                                    actionWithIdentifier:@"SnoozeAction"
                                    title:@"Snooze"
                                    options:UNNotificationActionOptionForeground];
    UNNotificationAction* dismiss = [UNNotificationAction
                                     actionWithIdentifier:@"DismissAction"
                                     title:@"Dismiss"
                                     options:UNNotificationActionOptionDestructive];
    UNNotificationCategory* category = [UNNotificationCategory
                                        categoryWithIdentifier:@"CustomCategory"
                                        actions:@[snooze, enter, dismiss]
                                        intentIdentifiers:@[@""]
                                        options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:[NSSet setWithObjects:category, nil]];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification");
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // [END_EXCLUDE]
    
    // Print full message.
    NSLog(@"%@", userInfo);
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification with completionHandler");
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // [END_EXCLUDE]
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Only increment badge if in background.
    if(application.applicationState == UIApplicationStateBackground) {
        NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: badge + 1];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}
// [END receive_message]

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"willPresentNotification");
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    // [END_EXCLUDE]
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse");
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    if([[response actionIdentifier] isEqual:@"SnoozeAction"] || [[response actionIdentifier] isEqual:@"EnterAction"] ||
       [[response actionIdentifier] isEqual:@"DismissAction"]) {
        NSLog(@"Message ID: %@", [response actionIdentifier]);
    }
    
    completionHandler();
}
// [END ios_10_message_handling]

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self initializeUserWiseSDK];
    
    // Clear app badge on start or resume.
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([self.userWise isRunning]) {
        [self.userWise onStop];
    }
}

- (void)initializeUserWiseSDK {
    if (![self.userWise isRunning]) {
        [self.userWise setDebugMode:YES];
        [self.userWise setHostOverride:[NSURL URLWithString:@"http://lvh.me:3000"]];
        [self.userWise setApiKey:@"e57656c13e8eb14e190203f92d75"];
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
