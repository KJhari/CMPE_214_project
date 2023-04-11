CC=nvcc
ARCH=-arch=sm_52
SOURCES=main.cu
OBJECTS=$(SOURCES:.cpp=.o)
LDFLAGS= -L/home/nvidia/Documents/libxlsxwriter/lib -lxlsxwriter
EXECUTABLE=vecadd
all: $(SOURCES) $(EXECUTABLE)
    
$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(ARCH) $(OBJECTS) -o $@ $(LDFLAGS)
.PHONY : clean
clean :
	-rm $(EXECUTABLE)

