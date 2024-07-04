# Copyright (C) 2024-2024 756yang
#
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=grpc-exec
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=756yang

PKG_SOURCE:=main.tar.gz
PKG_SOURCE_URL:=https://github.com/756yang/grpc_exec/archive/refs/heads
PKG_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-main
PKG_BUILD_DEPENDS:=grpc
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# executing host tools requires linking libraries
export LD_LIBRARY_PATH += :$(STAGING_DIR_HOSTPKG)/lib

# link library: atomic math
TARGET_LDFLAGS += -latomic $(if $(CONFIG_USE_GLIBC),-lm)

CMAKE_OPTIONS += -DBUILD_SHARED_LIBS=OFF \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
	-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY \
	-DCMAKE_CROSSCOMPILING=ON

# disable the default `make install`
define Build/Install
endef

define Package/$(PKG_NAME)
  SECTION:=base
  CATEGORY:=Packages
  TITLE:=A daemon for executing programs through GRPC
  DEPENDS:=+libstdcpp +libatomic +libpthread +re2 +zlib +libcares +protobuf-lite
endef

define Package/$(PKG_NAME)/description
GRPC utility, provide remote execution of programs.
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/grpc_exec
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) "$(PKG_BUILD_DIR)/grpc-exec $(1)/usr/bin/grpc-exec
	$(INSTALL_BIN) "$(PKG_BUILD_DIR)/grpc-shell $(1)/usr/bin/grpc-shell
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/grpc_exec $(1)/etc/config/grpc_exec
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/grpc-exec $(1)/etc/init.d/grpc-exec
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
