
# Copyright (C) 2024-2024 756yang
#
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

# PKG_NAME cannot have the same name as an existing package
PKG_NAME:=grpc
PKG_VERSION:=1.51.1
PKG_RELEASE:=1

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=grpc.io

PKG_SOURCE:=v$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/grpc/grpc/archive/refs/tags
PKG_HASH:=b55696fb249669744de3e71acc54a9382bea0dce7cd5ba379b356b12b82d4229

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL:=1
CMAKE_INSTALL:=1
PKG_BUILD_DEPENDS:=grpc/host abseil-cpp
PKG_BUILD_PARALLEL:=1
HOST_BUILD_DEPENDS:=abseil-cpp/host protobuf/host
HOST_BUILD_PARALLEL:=1

PKG_CONFIG_DEPENDS:= CONFIG_GRPC_PROTO_FULL

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# executing host tools requires linking libraries
export LD_LIBRARY_PATH += :$(HOST_BUILD_PREFIX)/lib

GRPC_CFLAGS:=$(TARGET_CFLAGS)
GRPC_CXXFLAGS:=$(TARGET_CXXFLAGS)

GRPC_CFLAGS += -DGPR_DISABLE_WRAPPED_MEMCPY
GRPC_CXXFLAGS += -DGPR_DISABLE_WRAPPED_MEMCPY

ifndef CONFIG_GRPC_PROTO_FULL
  CMAKE_OPTIONS += -DgRPC_USE_PROTO_LITE:BOOL=ON
endif

# compile static library, you can change it to compile dynamic library
CMAKE_OPTIONS += -DBUILD_SHARED_LIBS=OFF

# link library: atomic math
TARGET_LDFLAGS += -latomic $(if $(CONFIG_USE_GLIBC),-lm)

# openwrt libopenssl configure without NPN, which is required to compile GRPC
# use the ssl module referenced by GRPC
CMAKE_OPTIONS += \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
	-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
	-DgRPC_ABSL_PROVIDER=package \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_RE2_PROVIDER=package \
	-DgRPC_SSL_PROVIDER=module \
	-DgRPC_ZLIB_PROVIDER=package \
	-DgRPC_BUILD_GRPC_CPP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF \
	-DCMAKE_C_FLAGS="$(GRPC_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(GRPC_CXXFLAGS)"

CMAKE_HOST_OPTIONS += \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_ABSL_PROVIDER=none \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_RE2_PROVIDER=none \
	-DgRPC_SSL_PROVIDER=none \
	-DgRPC_ZLIB_PROVIDER=none \
	-DgRPC_BUILD_CODEGEN=OFF \
	-DgRPC_BUILD_CSHARP_EXT=OFF \
	-DgRPC_BUILD_PLUGIN_SUPPORT_ONLY=ON \
	-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF

# BoringSSL is a modified OpenSSL library from Google
BORINGSSL_COMMIT:=b8a2bffc598f230484ff48a247526a9820facfc2
BORINGSSL_SOURCE:=$(BORINGSSL_COMMIT).tar.gz
BORINGSSL_URL:=https://github.com/google/boringssl/archive

# compile GRPC requires downloading the boringssl module
define Build/Prepare
	$(call Build/Prepare/Default)
	wget -qO- $(BORINGSSL_URL)/$(BORINGSSL_SOURCE) | $(TAR) -xzf - -C $(PKG_BUILD_DIR)
	rm -rf $(PKG_BUILD_DIR)/third_party/boringssl-with-bazel
	mv $(PKG_BUILD_DIR)/boringssl-$(BORINGSSL_COMMIT) $(PKG_BUILD_DIR)/third_party/boringssl-with-bazel
endef

define Package/libgrpc-dev/config
	source "$(SOURCE)/Config.in"
endef

define Package/libgrpc-dev
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=gRPC is an RPC library and framework
  DEPENDS:=+libstdcpp +libatomic +libpthread +re2 +zlib +libcares +protobuf$(if $(CONFIG_GRPC_PROTO_FULL),,-lite)
  URL:=https://github.com/grpc/grpc
endef

define Package/libgrpc-dev/description
The C based gRPC, a modern, open source, high-performance remote procedure call (RPC) framework that can run anywhere.
endef

define Package/libgrpc-dev/install
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

$(eval $(call BuildPackage,libgrpc-dev))
$(eval $(call HostBuild))
