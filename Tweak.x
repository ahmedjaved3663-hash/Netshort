#import <UIKit/UIKit.h>

// 1. Hooking the User/Account info
// Apps often use "Member" or "User" classes. 
%hook BBUserModel
- (BOOL)isVip {
    return YES;
}
- (BOOL)isPremium {
    return YES;
}
%end

// 2. Hooking the Episode unlock logic
// This is usually where the "Lock" icon is controlled.
%hook BBVideoModel
- (BOOL)isLock {
    return NO;
}
- (BOOL)is_free {
    return YES;
}
- (NSInteger)price {
    return 0;
}
%end

// 3. Hooking the Playback Manager
// This forces the player to start even if the server hasn't "confirmed" payment.
%hook BBPlayerManager
- (BOOL)canPlayVideo:(id)arg1 {
    return YES;
}
%end

// 4. Removing Ads (Optional but helpful)
%hook BUAdSDKManager
+ (BOOL)isReady {
    return NO;
}
%end
