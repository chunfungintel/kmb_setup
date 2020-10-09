gcc -fPIC -O3 -g -Wall -Werror   -c -o src/hddl_reset.o src/hddl_reset.c
gcc -shared -Wl,-soname,libhddl_reset.so.1.0 src/hddl_reset.o -o libhddl_reset.so.1.0

