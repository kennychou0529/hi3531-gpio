#SlickEdit generated file.  Do not edit this file except in designated areas.
# -----Begin user-editable area-----

# -----End user-editable area-----

# Make command to use for dependencies

TARGET=ARM

CPU_TYPE=ARM

CROSS=$(OSDRV_CROSS)

PRODUCT=BVT
#CONFIG_GPIO_I2C =Y

MAKE=$(CROSS)-make
CC  = $(CROSS)-gcc
STRIP=$(CROSS)-strip
#
# Configuration: Debug
#



INCDIR=include
SRCDIR=source

OUTDIR=$(SRCDIR)

DRIVERDIR=driver


#!!!!!!!!!!!!!!! 1 添加生成的可执行文件
OUTFILE=btools 

ifndef SRC_ROOT
export SRC_ROOT := $(PWD)/../../..
endif

CFG_INC +=-I$(INCDIR)  \
	-I$(INCDIR)/api\
        -I$(INCDIR)/common \
        -I$(INCDIR)/driver \
        -I$(INCDIR)/message\
        -I$(INCDIR)/mmf\
        -I$(INCDIR)/os/linux \
        -I$(INCDIR)/tools/zsptools \
        -I$(INCDIR)/utils \
        -I$(DRIVERDIR)/include \


CFG_LIB = -lpthread -lrt

CFG_LIB_X86=
CFG_LIB_ARM=

CFG_OBJ= 

HICOMMON_OBJ=$(OUTDIR)/hi_message.o \
             $(OUTDIR)/hi_thread.o  \
             $(OUTDIR)/hi_dbg.o \
             $(OUTDIR)/cmdshell.o \
             $(OUTDIR)/argparser.o

BASE_OBJ=$(OUTDIR)/strfunc.o \
         $(OUTDIR)/memmap.o 

OBJ=$(CFG_OBJ) \
    $(HICOMMON_OBJ) \
    $(BASE_OBJ) 

# below not add to lib
ifeq ($(PRODUCT),BVT)
TOOLS_OBJ=
else
TOOLS_OBJ=$(OUTDIR)/mpi_log.o \
	$(OUTDIR)/hi_unf_i2c.o 
endif
TOOLS_OBJ+=$(OUTDIR)/himd.o \
          $(OUTDIR)/himm.o \
          $(OUTDIR)/himc.o \
          $(OUTDIR)/hivd.o \
          $(OUTDIR)/hiddrs.o \
          $(OUTDIR)/hil2s.o \
          $(OUTDIR)/hii2c.o
          
#!!!!!!!!!!!!! 2 添加obj

BTOOLS_OBJ = $(OUTDIR)/btools.o $(TOOLS_OBJ) 

ALL_OBJ = $(OBJ) \
  $(TOOLS_OBJ) \
  $(BTOOLS_OBJ) \
  $(HIMD_OBJ) \
  $(HIMM_OBJ) \
  $(HIMC_OBJ) \
  $(HIVD_OBJ)
        
#CFG_DEFS=-D$(CPU_TYPE)_CPU -DPC_EMULATOR -DOS_LINUX -DDEBUG  -DLOGQUEUE -DAZ_STAT
CFG_DEFS=-D$(CPU_TYPE)_CPU
ifeq ($(PRODUCT),BVT)
CFG_DEFS +=-D$(CPU_TYPE)_CPU -DBVT_I2C
endif

ifeq ($(CONFIG_GPIO_I2C),Y)
CFG_DEFS +=-DHI_GPIO_I2C
endif
COMPIER_FLAGS= -c 
#COMPIER_FLAGS= -c -save-temps 


CFG_DEBUG = -g3
#CFG_DEBUG = -O

CFG_CFLAGS=-Wall -Wunused 



ifeq ($(TARGET),X86)
CFG_LIB +=$(CFG_LIB_X86)
CFG_DEFS += -DTARGET_X86
else
CFG_LIB  +=$(CFG_LIB_ARM)
CFG_DEFS +=-D__LINUX_ARM_ARCH__=7 
CFG_DEFS +=-mtune=arm9tdmi 
CFG_DEFS += -DTARGET_ARM
CFG_CFLAGS +=-mlittle-endian
endif

CFG_CFLAGS += $(USER_CFLAGS)

CFG_FLAGS = $(CFG_CFLAGS) $(CFG_DEBUG) $(CFG_INC) $(CFG_DEFS) 
LINK_FLAGS = $(CFG_DEFS) $(CFG_DEBUG) 

COMPILE=$(CC) $(CFG_FLAGS) $(COMPIER_FLAGS) -o "$(OUTDIR)/$(*F).o" "$<"
LINK=$(CC) -o "$@" $(OBJ) $(CFG_LIB)

LINK_A=$(CC)   -o "$@" $(OBJ) $(CFG_LIB) $(CFG_FLAGS)

# Pattern rules
$(OUTDIR)/%.o : $(SRCDIR)/utils/%.c
	$(COMPILE)

$(OUTDIR)/%.o : $(SRCDIR)/common/%.c
	$(COMPILE)

$(OUTDIR)/%.o :  $(DRIVERDIR)/%.c
	$(COMPILE)


$(OUTDIR)/%.o :  $(DRIVERDIR)/memmap/%.c
	$(COMPILE)

$(OUTDIR)/%.o : $(SRCDIR)/tools/%.c
	$(COMPILE)

#!!!!!!!!!!!!!!! 3 添加生成可执行文件的编译方法
all: $(OUTDIR)  $(ALL_OBJ)  $(OUTFILE) 

btools:$(OUTDIR) $(OBJ) $(BTOOLS_OBJ) 
	$(LINK)   $(BTOOLS_OBJ)
	$(STRIP) btools
	ln -s btools himd
	ln -s btools himd.l
	ln -s btools himm
	ln -s btools himc
	ln -s btools hiddrs
	ln -s btools hil2s
	ln -s btools hier
	ln -s btools hiew

install: all strip cp
strip:$(OUTFILE)
	$(STRIP) $(OUTFILE)
cp:strip
	cp -f $(OUTFILE) ../bin/
	
# Rebuild this project
rebuild: cleanall all

# Clean this project
clean:
	rm -f $(OUTFILE)
	rm -f $(OBJ)
	rm -f $(OUTDIR)/*.o
	rm -f himd himm himc himd.l hier hiew
	rm -f hiddrs hil2s

# Clean this project and all dependencies
cleanall: clean

