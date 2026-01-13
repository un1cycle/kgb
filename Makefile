SRCC = build/build.c
ENDC = build/build
COMPC = gcc

SRC = src/*.asm
END = build/kgb.iso
COMP = build/build
SIZE = 5000

all: $(END)

$(END): $(SRC)
	$(COMPC) $(SRCC) -o $(ENDC) -lm
	$(COMP) -o $(END) -s $(SIZE) $(SRC)

clean:
	rm $(END) $(ENDC)

.PHONY: all clean
