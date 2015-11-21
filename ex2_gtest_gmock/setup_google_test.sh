#!/usr/bin/env bash

SHARED_LIB_ON_OFF=ON    # OFF


#################################
### DEFINITIONS ... GLOBAL
#################################
THE_PWD=$(readlink -f "$(pwd)")

LOCAL_DIR=~/local
DESKTOP_ROOTFILESYS=${LOCAL_DIR}/desktop_rootfilesystem

mkdir -p ${DESKTOP_ROOTFILESYS}
cd       ${DESKTOP_ROOTFILESYS}

REPODIR=$(readlink -f googletest)
    
git clone https://github.com/google/googletest.git



## Note: googletest is compiled as part of googletest!!

## compile     googlemock         DEBUG
mkdir $REPODIR/googlemock/mybuild_debug
cd    $REPODIR/googlemock/mybuild_debug
cmake -DBUILD_SHARED_LIBS=$SHARED_LIB_ON_OFF -DCMAKE_CXX_FLAGS="-D_GLIBCXX_DEBUG" -DCMAKE_BUILD_TYPE=Debug ..
make VERBOSE=1 -j3

## compile     googlemock         RELEASE
mkdir $REPODIR/googlemock/mybuild
cd    $REPODIR/googlemock/mybuild
cmake -DBUILD_SHARED_LIBS=$SHARED_LIB_ON_OFF -DCMAKE_BUILD_TYPE=Release ..
make VERBOSE=1 -j3




## create link                                    googlemock/gtest
#ln -s $(readlink -f $REPODIR/googletest) $REPODIR/googlemock/gtest 



## create a load-script testing.sh
SCRIPT_NAME=load_testing.sh
LOAD_SCRIPT=$THE_PWD/$SCRIPT_NAME



cat <<EOF > $LOAD_SCRIPT
# "Run" this script with:    . $SCRIPT_NAME
# (this is called "sourcing" the script)

export GMOCK_INCLUDE=$REPODIR/googlemock/include
export GMOCK_LIB_REL=$REPODIR/googlemock/mybuild
export GMOCK_LIB_DBG=$REPODIR/googlemock/mybuild_debug


export GTEST_INCLUDE=$REPODIR/googletest/include
export GTEST_LIB_REL=$REPODIR/googlemock/mybuild/gtest
export GTEST_LIB_DBG=$REPODIR/googlemock/mybuild_debug/gtest


EOF

chmod +x    $LOAD_SCRIPT






CMAKE_TOOLCHAIN_FILE=~/toolchain_desktop.cmake


# escaping:
# note in the HEREDOC below, \\ means \ in the output!!
#                            \$ means $ in the output!!
#                            \` means ` in the output!!
cat <<EOF    >> $CMAKE_TOOLCHAIN_FILE



###
### GoogleMock
###

if (NOT EXISTS \$ENV{GMOCK_INCLUDE})
   set(ENV{GMOCK_INCLUDE} "$REPODIR/googlemock/include")
endif()

if (NOT EXISTS \$ENV{GMOCK_LIB_REL})
   set(ENV{GMOCK_LIB_REL} "$REPODIR/googlemock/mybuild")
endif()

if (NOT EXISTS \$ENV{GMOCK_LIB_DBG})
   set(ENV{GMOCK_LIB_DBG} "$REPODIR/googlemock/mybuild_debug")
endif()

if (CMAKE_BUILD_TYPE STREQUAL Debug)
   set(GMOCK_LIB \$ENV{GMOCK_LIB_DBG})
else()
   set(GMOCK_LIB \$ENV{GMOCK_LIB_REL})
endif()


###
### GoogleTest
###

if (NOT EXISTS \$ENV{GTEST_INCLUDE})
   set(ENV{GTEST_INCLUDE} "$REPODIR/googletest/include")
endif()

if (NOT EXISTS \$ENV{GTEST_LIB_REL})
   set(ENV{GTEST_LIB_REL} "$REPODIR/googlemock/mybuild/gtest")
endif()

if (NOT EXISTS \$ENV{GTEST_LIB_DBG})
   set(ENV{GTEST_LIB_DBG} "$REPODIR/googlemock/mybuild_debug/gtest")
endif()

if (CMAKE_BUILD_TYPE STREQUAL Debug)
   set(GTEST_LIB \$ENV{GTEST_LIB_DBG})
else()
   set(GTEST_LIB \$ENV{GTEST_LIB_REL})
endif()
EOF


echo
echo "FINISHED"
echo
echo "Also generated file $SCRIPT_NAME"
echo "Recommendation:"
echo "Copy the script     $SCRIPT_NAME   ... to ~/bin"
echo "Run the script with:    . $SCRIPT_NAME"
echo "(this is called \"sourcing\" the script.    thereafter the cmake scripts should work nicely)"
