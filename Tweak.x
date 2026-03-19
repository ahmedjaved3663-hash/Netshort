#import <UIKit/UIKit.h>

// 1. POPUP CHECK: This runs the second the app opens
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweak Active" 
                                    message:@"The Hook is running. If episodes are locked, the class names are wrong." 
                                    preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// 2. FORCED UNLOCK (The "Aggressive" Hook)
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (void)setIsLocked:(BOOL)arg1 { %orig(NO); }
%end

%hook NSUserModel
- (BOOL)isVip { return YES; }
%end

// 3. TARGETING THE "AD" POPUP
%hook NSPlayDetailManager
- (BOOL)checkEpisodeIsLockedWithModel:(id)arg1 { return NO; }
@end
