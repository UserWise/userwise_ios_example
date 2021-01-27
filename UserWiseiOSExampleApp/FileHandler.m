#import "FileHandler.h"

@implementation FileHandler
- (void)onFailure {
    NSLog(@"Header image failed to load");
}

- (void)onSuccessWithMediaInfo:(MediaInfo *)mediaInfo{
    NSLog(@"Header Image Loaded: %@", mediaInfo.url);
    [self.userWise loadBitMapFromUrl:mediaInfo.url ignoreCache:NO handler:self];
}

- (void)onMediaDownloadFailure {
    NSLog(@"Media image failed to download");
}

- (void)onMediaDownloadSuccessWithData:(NSData * _Nonnull)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        ViewController *vc = (ViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [vc.imageView setImage:[[UIImage alloc] initWithData:data]];
    });
}
@end
