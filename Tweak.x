#import <UIKit/UIKit.h>

// Hooking the User Model to force VIP status
%hook NSUserModel 
- (BOOL)isVip {
    return YES; // Always returns true for VIP checks
}

- (BOOL)isPremium {
    return YES;
}

- (long long)coinBalance {
    return 999999; // Set a visual high balance
}
%end

// Hooking the Episode Manager to bypass "Lock" status
%hook NSEpisodeModel
- (BOOL)isLocked {
    return NO; // Force every episode to report as 'unlocked'
}

- (NSInteger)unlockPrice {
    return 0; // Set price to 0 coins
}
%end

// Optional: Bypass Ad-checkers if they interfere
%hook PAGAdSDK
- (BOOL)isAdReady {
    return NO; 
}
%end
