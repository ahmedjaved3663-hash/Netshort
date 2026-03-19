#import <UIKit/UIKit.h>

// 1. Hooking the Data Entry Point
// This is where the app takes the "Locked" status from the internet.
%hook NSDramaEpisodeModel
- (id)initWithDictionary:(NSDictionary *)dict {
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    
    // Force the data to be "Unlocked" before the object is even created
    [mutableDict setObject:@(0) forKey:@"is_locked"];
    [mutableDict setObject:@(1) forKey:@"is_free"];
    [mutableDict setObject:@(0) forKey:@"price"];
    [mutableDict setObject:@(0) forKey:@"coin_price"];
    
    return %orig(mutableDict);
}

- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (NSInteger)price { return 0; }
%end

// 2. Hooking the User Response
%hook NSUserModel
- (id)initWithDictionary:(NSDictionary *)dict {
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    
    [mutableDict setObject:@(YES) forKey:@"is_vip"];
    [mutableDict setObject:@(10) forKey:@"vip_level"];
    [mutableDict setObject:@"2099-12-31" forKey:@"vip_expire_time"];
    
    return %orig(mutableDict);
}

- (BOOL)isVip { return YES; }
%end

// 3. The "Loading Screen" Killer
%hook NSPayManager
- (BOOL)checkEpisodeIsBoughtWithDramaId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}

// Bypassing the actual server call for a play token
- (void)requestPlayTokenWithEpisodeId:(id)arg1 completion:(void (^)(NSString *token, id error))completion {
    if (completion) {
        // We provide a fake token to satisfy the player
        completion(@"unlocked_token_bypass", nil);
    }
}
%end
