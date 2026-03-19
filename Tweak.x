#import <UIKit/UIKit.h>

// 1. Diagnostic Popup (Fixed for iOS 13+)
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweak Active" 
                                        message:@"Injection Successful. If episodes are locked, we need new methods." 
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// 2. Core Unlocking Logic
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

%hook NSUserModel
- (BOOL)isVip { return YES; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

%hook NSPlayDetailManager
- (BOOL)checkEpisodeIsLockedWithModel:(id)arg1 { return NO; }
%end

%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }
- (void)setupBottomView { } 
%end
