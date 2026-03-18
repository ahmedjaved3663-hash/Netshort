TARGET := iphone:clang:latest:15.0
ARCHS = arm64
# This line below fixes the "UIKit/UIKit.h not found" error
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NetShortUnlock
NetShortUnlock_FILES = Tweak.x
NetShortUnlock_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
