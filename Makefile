TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = autodrop

autodrop_FILES = Tweak.x
autodrop_CFLAGS = -fobjc-arc
autodrop_FRAMEWORKS = UIKit UIKitCore

include $(THEOS_MAKE_PATH)/tweak.mk
