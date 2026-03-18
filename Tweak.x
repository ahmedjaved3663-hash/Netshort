#import <UIKit/UIKit.h>

// This targets the specific internal variables often used in 2.1.5
%hook NSDramaEpisodeModel
- (NSInteger)is_locked { return 0; } 
- (NSInteger)unlock_type { return 0; }
- (BOOL)is_free { return YES; }
- (void)setIs_locked:(NSInteger)arg1 { %orig(0); }
%end

%hook NSUserModel
- (NSInteger)is_vip { return 1; }
- (NSInteger)vip_level { return 10; }
%end

// This targets the "Coin" check directly
%hook NSCoinManager
- (BOOL)checkCanPlayWithDramaId:(id)arg1 episodeId:(id)arg2 {
    return YES;
}
%end
