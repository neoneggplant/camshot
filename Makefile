include theos/makefiles/common.mk

TOOL_NAME = camshot
camshot_FILES = main.mm capture.m
camshot_FRAMEWORKS = AVFoundation
include $(THEOS_MAKE_PATH)/tool.mk
