
# Copyright (C) 2024-2024 756yang
#
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

# PKG_NAME cannot have the same name as an existing package
PKG_NAME:=oc-ares
PKG_VERSION:=1.27.0
PKG_RELEASE:=1

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE.md
PKG_MAINTAINER:=c-ares

PKG_SOURCE:=c-ares-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://c-ares.org/download
PKG_HASH:=0a72be66959955c43e2af2fbd03418e82a2bd5464604ec9a62147e37aceb420b

PKG_BUILD_DIR:=$(BUILD_DIR)/c-ares-$(PKG_VERSION)
PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A C library for asynchronous DNS requests
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libcares.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
