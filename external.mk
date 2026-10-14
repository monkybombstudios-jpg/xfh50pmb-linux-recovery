# Deterministic, fail-closed source edits to the exact extracted release trees.
define XFHRECOVERY_LINUX_PATCH
	python3 $(BR2_EXTERNAL_XFHRECOVERY_PATH)/board/xfh/patch-source.py linux $(@D)
endef
LINUX_POST_PATCH_HOOKS += XFHRECOVERY_LINUX_PATCH

define XFHRECOVERY_UBOOT_PATCH
	python3 $(BR2_EXTERNAL_XFHRECOVERY_PATH)/board/xfh/patch-source.py uboot $(@D)
endef
UBOOT_POST_PATCH_HOOKS += XFHRECOVERY_UBOOT_PATCH
