# Makefile for Shallow Waters 2D
# 2020-05-15
#
# Useage:
# make 			- compile all binaries
# make clean		- clean all binaries 
# make memtest		- test for memory leaks with valgrind

EXE = shallow_water

#SRC = ../datastructures-v1.0.8.2/src/stack/stack.c
#OBJ = $(SRC:.c=.o)

CC = gcc
CFLAGS = -std=c99 -Wall -g -lm	#-I../datastructures-v1.0.8.2/include

all:	$(EXE)

# Object file for library
obj:	$(OBJ)

# Clean up
clean:
	-rm -f $(EXE) $(OBJ)
	
shallow_water: shallow_water.c
	gcc $^ -o $@ $(CFLAGS) 

memtest: shallow_water
	valgrind --leak-check=full --show-reachable=yes ./$<

