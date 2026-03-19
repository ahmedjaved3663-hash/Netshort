#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// This is the "Magic" constructor that runs as soon as the app opens
__attribute__((constructor))
static void initialize_unlocker() {
    NSLog(@"[+] NetShort VIP Injector Active");

    // Logic for VIP: Force 'isVip' and 'is_vip' to always return 1 (YES)
    // Logic for episodes: Force 'isLocked' to always return 0 (NO)
    
    // We use a "Class Method Swap" which is safer for iOS 26 than binary patching
    Class userModel = objc_getClass("NSUserModel");
    if (userModel) {
        Method originalVip = class_getInstanceMethod(userModel, @selector(isVip));
        method_setImplementation(originalVip, (IMP)imp_implementationWithBlock(^(id self) {
            return YES; 
        }));
    }

    Class dramaModel = objc_getClass("NSDramaEpisodeModel");
    if (dramaModel) {
        Method originalLock = class_getInstanceMethod(dramaModel, @selector(isLocked));
        method_setImplementation(originalLock, (IMP)imp_implementationWithBlock(^(id self) {
            return NO; 
        }));
    }
}
