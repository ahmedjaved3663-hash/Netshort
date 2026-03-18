TARGET := iphone:clang:latest:15.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NetShortUnlock
NetShortUnlock_FILES = Tweak.x
NetShortUnlock_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
