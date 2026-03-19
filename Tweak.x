#import <UIKit/UIKit.h>

// 1. Keep the Popup for Confirmation
%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    window = scene.windows.firstObject; break;
                }
            }
        }
        if (window && window.rootViewController) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ultra Tweak Active" 
                                        message:@"Global Permission & Wallet Bypass Loaded" 
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// 2. Global Wallet/Coin Bypass
// Even if the episode is 'locked', having 99,999 coins makes the app auto-unlock it.
%hook NSWalletModel
- (NSInteger)total_coin { return 99999; }
- (NSInteger)bonus_coin { return 99999; }
- (NSInteger)remained_coin { return 99999; }
%end

// 3. Force Drama Metadata to 'Free'
%hook NSDramaModel
- (BOOL)is_free { return YES; }
- (BOOL)is_vip { return YES; }
- (NSInteger)unlock_type { return 0; } // 0 usually means 'None/Free'
%end

// 4. Force Episode Metadata
%hook NSDramaEpisodeModel
- (BOOL)is_locked { return NO; }
- (BOOL)isLocked { return NO; }
- (NSInteger)price { return 0; }
- (NSInteger)coin_price { return 0; }
- (BOOL)can_watch { return YES; }
%end

// 5. Override the Play Authority
%hook NSPlayManager
- (BOOL)hasAuthorityToPlayDramaWithId:(id)arg1 episodeId:(id)arg2 { return YES; }
- (void)checkAuthorityWithDramaId:(id)arg1 completion:(void (^)(BOOL hasAuthority, id error))completion {
    if (completion) completion(YES, nil);
}
%end

// 6. Universal VIP Status
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)is_vip { return YES; }
- (NSInteger)vip_level { return 10; }
%end
