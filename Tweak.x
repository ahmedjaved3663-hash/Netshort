#import <UIKit/UIKit.h>

// 1. Hooking the Base Data Model (Targeting all potential drama models)
%hook NSObject
- (BOOL)is_locked {
    // Many apps use this internal property across different classes
    if ([NSStringFromClass([self class]) containsString:@"Drama"] || 
        [NSStringFromClass([self class]) containsString:@"Video"]) {
        return NO;
    }
    return %orig;
}

- (BOOL)is_vip {
    if ([NSStringFromClass([self class]) containsString:@"User"]) {
        return YES;
    }
    return %orig;
}
%end

// 2. Targeting the specific 'NS' prefix (NetShort's internal prefix)
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (NSInteger)vipLevel { return 10; }
- (long long)coinBalance { return 888888; }
%end

%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
- (BOOL)isFree { return YES; }
- (NSInteger)price { return 0; }
%end

// 3. Force-close the Purchase Popup
// This stops the infinite loading by preventing the view from ever initializing
%hook NSUnlockEpisodePopView
- (void)layoutSubviews {
    %orig;
    [self removeFromSuperview]; // Immediately kill the popup if it tries to show
}
%end

// 4. Hooking the Playback Decision Manager
%hook NSPlayDetailManager
- (BOOL)canPlayEpisode:(id)arg1 {
    return YES;
}
%end
