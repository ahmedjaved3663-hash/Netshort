#import <UIKit/UIKit.h>

// 1. Force User to VIP
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipLevel { return 10; }
- (long long)coinBalance { return 999999; }
%end

// 2. Force Episode to be Unlocked
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
- (BOOL)isFree { return YES; }
- (NSInteger)price { return 0; }
%end

// 3. Prevent the "Unlock" Popup from staying on screen
%hook NSUnlockEpisodePopView
- (void)didMoveToWindow {
    %orig;
    // Hide the view as soon as it is added to the screen
    self.hidden = YES;
    [self removeFromSuperview];
}
%end

// 4. Force Playback Logic
%hook NSPlayDetailManager
- (BOOL)canPlayEpisode:(id)arg1 {
    return YES;
}
%end
