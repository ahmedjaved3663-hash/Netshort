#import <UIKit/UIKit.h>

// 1. Keep the popup so we know it's still loading
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject;
                    break;
                }
            }
        }
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweak V2 Running" 
                                        message:@"Checking new Permission methods..." 
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// 2. The "Authority" Bypass - This is the most likely culprit
%hook NSPlayManager
- (BOOL)hasAuthorityToPlayDramaWithId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}

- (BOOL)checkEpisodeIsUnlockedWithDramaId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}
%end

// 3. Unlocking the Episode Model directly
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)canWatch { return YES; }
- (BOOL)isFree { return YES; }
%end

// 4. Forcing VIP Level
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (NSInteger)vipLevel { return 10; }
- (NSString *)vip_expire_time { return @"2099-12-31"; }
%end

// 5. Hiding the "Pay" buttons from the UI
%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }
%end
