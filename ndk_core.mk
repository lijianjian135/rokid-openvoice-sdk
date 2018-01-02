include $(CLEAR_VARS)
PB_DIR := $(speech_pb.outdir)

LOCAL_MODULE := libspeech
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_CPP_EXTENSION := .cc
LOCAL_C_INCLUDES := \
	$(PB_DIR) \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/src/common

COMMON_SRC := \
	src/common/log.cc \
	src/common/speech_connection.cc

TTS_SRC := \
	src/tts/tts_impl.cc

SPEECH_SRC := \
	src/speech/speech_impl.cc

PB_SRC := \
	$(PB_DIR)/auth.pb.cc \
	$(PB_DIR)/speech_types.pb.cc \
	$(PB_DIR)/speech.pb.cc \
	$(PB_DIR)/tts.pb.cc

LOCAL_SRC_FILES := \
	$(COMMON_SRC) \
	$(TTS_SRC) \
	$(SPEECH_SRC) \
	$(PB_SRC)

LOCAL_CPP_FEATURES := rtti exceptions
LOCAL_CFLAGS := $(COMMON_CFLAGS)
LOCAL_CPPFLAGS := -std=c++11
LOCAL_SHARED_LIBRARIES := libuWS libprotobuf-ndk
LOCAL_LDLIBS := -llog -lz
ifeq ($(PLATFORM_SDK_VERSION), 23)
LOCAL_C_INCLUDES += $(DEPS_DIR)/boringssl/include
LOCAL_LDLIBS += -L$(DEPS_DIR)/boringssl/libs -lcrypto
else
LOCAL_C_INCLUDES += $(DEPS_DIR)/openssl/$(PLATFORM_SDK_VERSION)/include
LOCAL_LDLIBS += -L$(DEPS_DIR)/openssl/$(PLATFORM_SDK_VERSION)/libs -lcrypto
LOCAL_CFLAGS += -D__STDC_FORMAT_MACROS
endif

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := librkcodec
LOCAL_MODULE_TAGS := optional
LOCAL_CPP_EXTENSION := .cc
LOCAL_SRC_FILES := \
	src/codec/rkcodec.cc \
	include/rkcodec.h \
	src/common/log.cc \
	src/common/log.h
LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/src/common \
	$(DEPS_DIR)/opus/include
ifeq ($(PLATFORM_SDK_VERSION), 23)
LOCAL_LDLIBS := -L$(DEPS_DIR)/opus/libs/23 -lopus
else
LOCAL_LDLIBS := -L$(DEPS_DIR)/opus/libs/19 -lopus
endif
LOCAL_CPPFLAGS := -std=c++11
include $(BUILD_SHARED_LIBRARY)
