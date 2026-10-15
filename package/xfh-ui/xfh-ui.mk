################################################################################
# XFH framebuffer storage selector
################################################################################
XFH_UI_SITE = $(BR2_EXTERNAL_XFHRECOVERY_PATH)/package/xfh-ui
XFH_UI_SITE_METHOD = local

define XFH_UI_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) -std=c99 -Wall -Wextra -Os -o $(@D)/xfh-ui $(@D)/xfh-ui.c
endef

define XFH_UI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/xfh-ui $(TARGET_DIR)/usr/sbin/xfh-ui
endef

$(eval $(generic-package))
