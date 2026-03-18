#import <UIKit/UIKit.h>

// 1. Hooking the User Model
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)isPremium { return YES; }
- (NSInteger)vipLevel { return 10; }
%end

// 2. Hooking the Episode Data
%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)isUnlocked { return YES; }
- (BOOL)isFree { return YES; }
%end

// 3. The "Infinite Loading" / Popup Fix
// We use a different method to hide the popup that doesn't cause compiler errors
%hook NSUnlockEpisodePopView
- (void)setHidden:(BOOL)hidden {
    %orig(YES); // Force it to always stay hidden
}
%end

// 4. Force the Player to start regardless of server status
%hook NSVideoPlayerController
- (BOOL)canPlayNow { return YES; }
- (void)checkPlayStatus {
    // Doing nothing here prevents the app from stopping the video
}
%end
