
C_SRC := appl.c

#CFLAGS -g -Wall  -I $ C:/altera/13.1/embedded/ip/altera/hps/altera_hps/hwlib/include
CFLAGS := -g -O0 -Werror -Wall

CROSS_COMPILE := arm-linux-gnueabihf-

#LDFLAGS =  -g -Wall
#ARCH= arm

CC := $(CROSS_COMPILE)gcc
NM := $(CROSS_COMPILE)nm

ifeq ($(or $(COMSPEC),$(ComSpec)),)
RM := rm -rf
else
RM := cs-rm -rf
endif

ELF ?= $(basename $(firstword $(C_SRC)))
OBJ := $(patsubst %.c,%.o,$(C_SRC))

.PHONY: all
all: $(ELF)
	
.PHONY:
clean:
	$(RM) $(ELF) $(OBJ) *.objdump *.map

$(OBJ): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(ELF): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)
	$(NM) $@ > $@.map
	
	
#CFLAGS=-Wno-unused-but-set-variable

##
#TARGET = appl
#
##
#CROSS_COMPILE = arm-linux-gnueabihf-
#CFLAGS = -g -Wall  -I ${SOCEDS_DEST_ROOT}/ip/altera/hps/altera_hps/hwlib/include
#LDFLAGS =  -g -Wall 
#CC = $(CROSS_COMPILE)gcc
#ARCH= arm
#
#build: $(TARGET)
#
#$(TARGET): main.o 
#	$(CC) $(LDFLAGS)   $^ -o $@ 
#
#%.o : %.c
#	$(CC) $(CFLAGS) -c $< -o $@
#
#.PHONY: clean
#clean:
#	rm -f $(TARGET) *.a *.o *~