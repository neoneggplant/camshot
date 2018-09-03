include $(THEOS)/makefiles/common.mk
export TARGET_CODESIGN_FLAGS="-Ssign.plist"
TOOL_NAME = camshot
camshot_FILES = main.mm capture.m
camshot_FRAMEWORKS = AVFoundation
include $(THEOS_MAKE_PATH)/tool.mk
