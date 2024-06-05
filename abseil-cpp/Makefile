
# Copyright (C) 2024-2024 756yang
#
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

# PKG_NAME cannot have the same name as an existing package
PKG_NAME:=abseil-cpp
PKG_VERSION:=20230802.2
PKG_RELEASE:=1

PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=abseil.io

PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/abseil/abseil-cpp/archive/refs/tags
PKG_HASH:=7c11539617af1f332f0854a6fb21e296a1b29c27d03f23c7b49d4adefcd102cc

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_INSTALL:=1
CMAKE_INSTALL:=1
PKG_BUILD_PARALLEL:=1
HOST_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

# compile static library, you can change it to compile dynamic library
CMAKE_OPTIONS += -DBUILD_SHARED_LIBS=OFF

CMAKE_OPTIONS += \
	-DCMAKE_CXX_STANDARD=14 \
	-DABSL_ENABLE_INSTALL=ON \
	-DABSL_USE_GOOGLETEST_HEAD=OFF

CMAKE_HOST_OPTIONS += \
	-DCMAKE_CXX_STANDARD=14 \
	-DABSL_ENABLE_INSTALL=ON \
	-DABSL_USE_GOOGLETEST_HEAD=OFF

define Package/libabseil-cpp-dev
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=Abseil Common Libraries (C++)
  DEPENDS:=+libstdcpp +libpthread
  URL:=https://github.com/abseil/abseil-cpp
endef

define Package/libabseil-cpp-dev/description
The repository contains the Abseil C++ library code. Abseil is an open-source collection of C++ code (compliant to C++14) designed to augment the C++ standard library.
endef

define Package/libabseil-cpp-dev/install
	$(CP) $(PKG_INSTALL_DIR)/* $(1)/
endef

$(eval $(call BuildPackage,libabseil-cpp-dev))
$(eval $(call HostBuild))
