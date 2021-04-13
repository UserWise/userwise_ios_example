//
//  AppDelegate.m
//
//  Copyright © 2020 UserWise. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]

    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]

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

    [application registerForRemoteNotifications];
    // [END register_for_notifications]
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification");
    [self.userWise.pushNotificationsModule handleNotificationWithData:userInfo];
}

// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"didReceiveRemoteNotification with completionHandler");
    [self.userWise.pushNotificationsModule handleNotificationWithData:userInfo];

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
    [self.userWise.pushNotificationsModule handleNotificationWithData:userInfo];

    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSLog(@"didReceiveNotificationResponse");

    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [self.userWise.pushNotificationsModule handleNotificationWithData:userInfo];

    completionHandler();
}
// [END ios_10_message_handling]

// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];

    [self.userWise.pushNotificationsModule registerTokenWithToken:fcmToken];
}
// [END refresh_token]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"Unable to register for remote notifications: %@", error);
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
        [self.userWise setHostOverride:[NSURL URLWithString:@"https://staging.userwise.io"]];
        [self.userWise setApiKey:@"f1535363ad9ab340ebc9786337b0"];
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
