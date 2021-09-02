#import "ExampleRemoteConfigDelegate.h"

@implementation ExampleRemoteConfigDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleRemoteConfigDelegate *delegate = [[ExampleRemoteConfigDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onRemoteConfigsLoaded {
    NSLog(@"Remote configs have been loaded.");
}

- (void)onRemoteConfigActiveWithRemoteConfig:(RemoteConfig *)remoteConfig {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"%@\n|- ID: %@\n|- Name: %@\n|- External ID: %@\n|- JSON: %@",
                  @"Remote Config is available!",
                  remoteConfig.id,
                  remoteConfig.name,
                  remoteConfig.externalId,
                  remoteConfig.json]);
}

- (void)onRemoteConfigInactiveWithRemoteConfig:(RemoteConfig *)remoteConfig {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"%@\n|- ID: %@\n|- Name: %@\n|- External ID: %@\n|- JSON: %@",
                  @"RemoteConfig is unavailable!",
                  remoteConfig.id,
                  remoteConfig.name,
                  remoteConfig.externalId,
                  remoteConfig.json]);
}

@end

