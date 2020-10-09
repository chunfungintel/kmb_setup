L_CC_FLAGS = -c -fPIC -O3 -g -Wall -Werror
CC := gcc
MAJOR := 1
MINOR := 0
NAME := hddl_reset
SRC_DIR := src
OBJ_DIR := obj
VERSION := $(MAJOR).$(MINOR)
#VERSION:=


SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(SRC:$(SRC_DIR)/%.c=$(SRC_DIR)/%.o)

.PHONY: default
default: install

lib: lib$(NAME).so.$(VERSION)

%.o:%.c
	$(CC) $(L_CC_FLAGS) $^ -o $@

lib$(NAME).so.$(VERSION): $(OBJ)
	$(CC) -shared -Wl,-soname,lib$(NAME).so.$(VERSION) $^ -o $@

install: lib
	cp lib$(NAME).so.$(VERSION) /usr/lib
	ln -f -s lib$(NAME).so.$(VERSION) /usr/lib/lib$(NAME).so
	cp inc/* /usr/include

clean:
	$(RM) $(SRC_DIR)/*.o *.so*
