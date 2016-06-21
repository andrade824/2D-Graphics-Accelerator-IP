SOURCES = sprite_engine.cpp nesctrl.cpp test_game.cpp
CPPFLAGS = -std=gnu++11
EXECUTABLE = test_game

.PHONY: default all clean

default: $(EXECUTABLE)
all: default

$(EXECUTABLE):
	$(CXX) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $(SOURCES) -o $@

clean:
	-rm -f *.o
	-rm -f $(EXECUTABLE)