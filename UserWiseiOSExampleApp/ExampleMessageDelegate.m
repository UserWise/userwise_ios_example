#import "ExampleMessageDelegate.h"

@implementation ExampleMessageDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleMessageDelegate *delegate = [[ExampleMessageDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onMessagesLoadedFromCache:(BOOL)fromCache {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"Messages have been loaded.  From cache? %@",
                  fromCache == TRUE ? @"Yes" : @"No"]);
}

- (void)onMessageAvailableWithMessage:(Message *)message {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"%@\n|- ID: %@\n|- Name: %@\n|- Additional Fields: %@",
                  @"Message is available!",
                  message.id,
                  message.name,
                  message.additionalFields]);
    
    [self.userWise.messagesModule setMessageAsViewedWithMessage:message];
}

- (void)onMessageUnavailableWithMessage:(Message *)message {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"%@\n|- ID: %@\n|- Name: %@\n|- Additional Fields: %@",
                  @"Message is unavailable!",
                  message.id,
                  message.name,
                  message.additionalFields]);
}

@end
