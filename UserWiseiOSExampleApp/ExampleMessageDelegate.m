#import "ExampleMessageDelegate.h"

@implementation ExampleMessageDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleMessageDelegate *delegate = [[ExampleMessageDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onMessagesLoaded {
    NSLog(@"Messages have been loaded from the server");
}

- (void)onMessageAvailableWithMessage:(Message *)message {
    NSLog([NSString stringWithFormat: @"%@%@", @"Message is available! Initializing message with id ", message.id]);
    
    [self.controller.view makeToast:[NSString stringWithFormat: @"%@%@%@%@%@%@%@%@", @"Title: ", message.title, @" - Body: ", message.body, @" - Portrait image: ", message.portraitImageId, @" - Landscape image: ", message.landscapeImageId]];
    
    [self.userWise.messagesModule setMessageAsViewedWithMessage:message];
}

@end
