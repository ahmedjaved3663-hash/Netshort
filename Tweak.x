#import <UIKit/UIKit.h>

// 1. Diagnostic Popup - Shows if the tweak is actually loaded
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (root) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweak Loaded" 
                                        message:@"If episodes are still locked, we need new class names." 
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [root presentViewController:alert animated:YES completion:nil];
        }
    });
}

// 2. Unlocking Episodes
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

// 3. Unlocking VIP status
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (void)setIsVip:(BOOL)arg1 { %orig(YES); }
%end

// 4. Bypassing the Ad/Lock Manager
%hook NSPlayDetailManager
- (BOOL)checkEpisodeIsLockedWithModel:(id)arg1 { return NO; }
%end

// 5. Hiding the "Unlock" UI buttons
%hook NSDramaDetailViewController
- (BOOL)shouldShowPayPopup { return NO; }
- (void)setupBottomView { } 
%end
