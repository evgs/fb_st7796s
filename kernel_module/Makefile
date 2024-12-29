obj-m := fb_st7796s.o

PWD := $(shell pwd)

KERNELVER ?= $(shell uname -r)

all: default

default:
	make -C /lib/modules/$(KERNELVER)/build M=$(PWD) modules

install:
	make -C /lib/modules/$(KERNELVER)/build M=$(PWD) modules_install

clean:
	make -C /lib/modules/$(KERNELVER)/build M=$(PWD) clean
