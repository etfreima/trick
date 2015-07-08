
INSTALL = /bin/install

# options for partial linking
LD_PARTIAL = -Ur
LD_FILELIST = @

# if we are on a Rehat system, the lib directory is lib64 on 64 bit machines
ifneq ("$(wildcard /etc/redhat-release)","")
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
TRICK_LIB_DIR  := ${TRICK_HOME}/lib64
else
TRICK_LIB_DIR  := ${TRICK_HOME}/lib
endif
else
TRICK_LIB_DIR  := ${TRICK_HOME}/lib
endif

SHARED_LIB_OPT := -shared
RPATH = -Wl,-rpath=${TRICK_LIB_DIR}

ifeq ($(MAKELEVEL),0)
export TRICK_LDFLAGS += -Wl,--export-dynamic
TRICK_EXEC_LINK_LIBS += -lm -lrt -ldl -lz
endif

LD_WHOLE_ARCHIVE := -Wl,-whole-archive
LD_NO_WHOLE_ARCHIVE := -Wl,-no-whole-archive

ifneq ($(DMTCP),)
TRICK_EXEC_LINK_LIBS += -L$(DMTCP)/dmtcpaware -ldmtcpaware
endif

ifneq ($(TPROCTE),)
TRICK_ADDITIONAL_CXXFLAGS += -D_TPRO_CTE -I$(TPROCTE)/h
TRICK_EXEC_LINK_LIBS += $(TPROCTE)/lib/libtpro.a
endif

ifneq ($(BC635),)
# BC635 driver ver 118 and earlier do not have proper include and lib dirs.
TRICK_ADDITIONAL_CXXFLAGS += -D_BC635 -DLINUX -I$(BC635)/sample
TRICK_EXEC_LINK_LIBS += $(BC635)/sample/bcsdklib.a
endif

ifeq ($(HAVE_ZEROCONF),1)
TRICK_EXEC_LINK_LIBS += -lavahi-client
endif

# Check BFD library version
ifneq ($(BFD_HOME),)
HAVE_BFD := 1
TRICK_EXEC_LINK_LIBS += -lbfd
endif

# determine if -std=c++0x or -std=c++11 compile flags are desired
ifeq "" "c++0x"
TRICK_ADDITIONAL_CXXFLAGS += -std=c++0x -D_HAVE_TR1_RANDOM
endif

ifeq "" "c++11"
TRICK_ADDITIONAL_CXXFLAGS += -std=c++11 -D_HAVE_STL_RANDOM
endif

