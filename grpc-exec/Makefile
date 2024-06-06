# Copyright (C) 2024-2024 756yang
#
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=grpc-exec
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=756yang

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DEPENDS:=grpc
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# executing host tools requires linking libraries
export LD_LIBRARY_PATH += :$(STAGING_DIR_HOSTPKG)/lib

# link library: atomic math
TARGET_LDFLAGS += -latomic $(if $(CONFIG_USE_GLIBC),-lm)

CMAKE_OPTIONS += -DBUILD_SHARED_LIBS=OFF

define Package/$(PKG_NAME)
  SECTION:=base
  CATEGORY:=Packages
  TITLE:=A daemon for executing programs through GRPC
  DEPENDS:=+libstdcpp +libatomic +libpthread +re2 +zlib +libcares +protobuf$(if $(CONFIG_GRPC_PROTO_FULL),,-lite)
endef

define Package/$(PKG_NAME)/description
GRPC utility, provide remote execution of programs.
endef

define Package/$(PKG_NAME)/conffiles
xxx
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libgrpc++.so.1 $(1)/usr/lib/libgrpc++.so.1
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libgrpc.so.4 $(1)/usr/lib/libgrpc.so.4
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/grpcService $(1)/usr/bin/grpcService
 	$(INSTALL_DIR) $(1)/etc/init.d
 	$(INSTALL_BIN) files/grpcservice.initd $(1)/etc/init.d/grpcservice
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
