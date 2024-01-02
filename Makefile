TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = autodrop

autodropy_FILES = Tweak.x
autodropy_CFLAGS = -fobjc-arc
autodropy_FRAMEWORKS = UIKit UIKitCore

include $(THEOS_MAKE_PATH)/tweak.mk
