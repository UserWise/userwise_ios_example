#import "ExampleOfferDelegate.h"

@implementation ExampleOfferDelegate

+ (id)initWithController:(UIViewController *)controller andUserWise:(UserWise *)userWise {
    ExampleOfferDelegate *delegate = [[ExampleOfferDelegate alloc] init];
    delegate.controller = controller;
    delegate.userWise = userWise;
    return delegate;
}

- (void)onOffersLoaded {
    NSLog(@"Offer have been loaded from the server");
}

- (void)onOfferAvailableWithOffer:(Offer *)offer {
    NSLog(@"Offer available. offer_id=%@", offer.id);
    [self.userWise.offersModule initializeOfferImpressionWithOffer:offer];
}

- (void)onOfferUnavailable { NSLog(@"No offers available"); }

- (void)onOfferImpressionInitializationFailedWithOffer:(Offer *)offer {
    NSLog(@"Offer impression initialized failed. offer_id=%@", offer.id);
}

- (void)onOfferImpressionInitialized:(OfferImpression *)offerImpression {
    NSLog(@"Offer impression successfully initialized. offer_impression_id=%@", offerImpression.id);
    
    NSLog(@"Offer Title: %@", offerImpression.offer.title);
    NSLog(@"Offer Body: %@", offerImpression.offer.body);
    NSLog(@"Offer Portrait Image ID: %@", offerImpression.offer.portraitImageId);
    NSLog(@"Offer Landscape Image ID: %@", offerImpression.offer.landscapeImageId);
    NSLog(@"Offer Product ID: %@", offerImpression.offer.iOSProductId);
    NSLog(@"Offer Cost: %.02f", offerImpression.offer.cost);
    NSLog(@"Bundled Currencies: \n %@", offerImpression.offer.currencies);
    NSLog(@"Bundled Items: \n %@", offerImpression.offer.items);

    // Once an offer has been accepted the itself impression will stay in a state of "accepted"
    // on the UserWise servers.  There are currently two possible states beyond "accepted":
    //   - PURCHASED
    //   - PURCHASE_FAILED
    //
    // You can update to these states through the OfferImpression#updateState() method.
    //
    // Examples:

    // 1. You display the buy screen. User purchases. You call:
    [self.userWise.offersModule updateOfferImpressionStateWithOfferImpression:offerImpression newState:OfferImpressionStatePurchased];
    
    // 2. The purchase process fails in any form. You'd call:
    //    [self.userWise.offersModule updateOfferImpressionStateWithOfferImpression:offerImpression newState:OfferImpressionStateFailed];
}


// These signatures should be ignored, for now.
- (void)onOfferViewAttemptFailedWithOfferImpression:(OfferImpression *)offerImpression
                                             reason:(enum OfferViewAttemptFailedReason)reason {}
- (void)onOfferViewedWithOfferImpression:(OfferImpression *)offerImpression {}
- (void)onOfferDismissedWithOfferImpression:(OfferImpression *)offerImpression {}
- (void)onOfferAcceptedWithOfferImpression:(OfferImpression *)offerImpression {}

@end
