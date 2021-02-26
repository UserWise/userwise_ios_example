#import "ExampleMessageDelegate.h"

@implementation ExampleMessageDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleMessageDelegate *delegate = [[ExampleMessageDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onMessagesLoadedFromCache:(BOOL)fromCache {
    NSLog([NSString stringWithFormat: @"Messages have been loaded.  From cache? %@", fromCache == TRUE ? @"Yes" : @"No"]);
}

- (void)onMessageAvailableWithMessage:(Message *)message {
    NSLog([NSString stringWithFormat: @"%@%@", @"Message is available! Initializing message with id ", message.id]);
    
    [self.controller.view makeToast:[NSString stringWithFormat: @"%@%@%@%@%@%@%@%@", @"Title: ", message.title, @" - Body: ", message.body, @" - Portrait image: ", message.portraitImageId, @" - Landscape image: ", message.landscapeImageId]];
    
    [self.userWise.messagesModule setMessageAsViewedWithMessage:message];
}

@end
