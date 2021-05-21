#import "ExampleGameEventDelegate.h"

@implementation ExampleGameEventDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleGameEventDelegate *delegate = [[ExampleGameEventDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onEventsLoadedFromCache:(BOOL)fromCache {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"Game events have been loaded.  From cache? %@",
                  fromCache == TRUE ? @"Yes" : @"No"]);
}

- (void)onEventActiveWithEvent:(GameEvent *)gameEvent {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"%@\n|- ID: %@\n|- Name: %@\n|- Data: %@",
                  @"Game Event is available!",
                  gameEvent.id,
                  gameEvent.name,
                  gameEvent.data]);
}

- (void)onEventInactiveWithEvent:(GameEvent *)gameEvent {
    NSLog(@"%@", [NSString
                  stringWithFormat: @"%@\n|- ID: %@\n|- Name: %@\n|- Additional Fields: %@",
                  @"Game Event is unavailable!",
                  gameEvent.id,
                  gameEvent.name,
                  gameEvent.data]);
}

@end
