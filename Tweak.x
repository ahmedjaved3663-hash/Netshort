#import <UIKit/UIKit.h>

// This targets the specific "Logic Controller" rather than the whole app
%hook NSUserModel
- (BOOL)isVip { return YES; }
- (BOOL)is_vip { return YES; }
%end

%hook NSDramaEpisodeModel
- (BOOL)isLocked { return NO; }
- (BOOL)is_locked { return NO; }
- (BOOL)is_free { return YES; }
%end

// This forces the "Unlock" button to do nothing and just play
%hook NSPlayDetailManager
- (void)checkEpisodePlayAuthorityWithDramaId:(id)arg1 
                                   episodeId:(id)arg2 
                                  completion:(void (^)(BOOL hasAuthority, id error))completion {
    if (completion) {
        completion(YES, nil); 
    }
}
%end
