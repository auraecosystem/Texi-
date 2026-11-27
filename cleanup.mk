# cleanup.mk
#
# You can simply copy the last line of this file into your Makefile to make use of it.
#
# Optionally, you can include this file in your project, and import it using `-include cleanup.mk`
#
# Usage:
#   $(call run-with-cleanup, my-foo-func-that-could-fail, my-cleanup-func)
#
run-with-cleanup = $(1) && $(2) || (ret=$$?; $(2) && exit $$ret)
