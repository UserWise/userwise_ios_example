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

    self.userWise = [UserWise sharedInstance];
    
    [self.userWise setDebugMode:YES];
    [self.userWise setSurveyDelegate:self];
    NSLog(@"UserWise Delegate Set");

    // The appuser will be initialized once we've received both your API Key
    // and user id.
    [self.userWise setApiKey:@"6b6552ebc324a570262deb6bdd4e"];
    [self.userWise setUserId:@"user123"];
    NSLog(@"API Key and User ID Set");

    return YES;
}

-(void)onSurveysAvailable {
    NSLog(@"Surveys are available!");
}

-(void)onSurveyEntered {
    NSLog(@"Survey is being entered into");
}

-(void)onSurveyClosed {
    NSLog(@"Survey is being exited by the appuser");
}

-(void)onSurveyCompleted {
    NSLog(@"Survey was completed successfully!");
}

-(void)onSurveyEnterFailed {
    NSLog(@"Survey failed to load");
}
     
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
