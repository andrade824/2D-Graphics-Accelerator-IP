SOURCES = sprite_engine.cpp nesctrl.cpp snake.cpp game.cpp main.cpp
CPPFLAGS = -std=gnu++11
EXECUTABLE = snake_game

.PHONY: default all clean

default: $(EXECUTABLE)
all: default

$(EXECUTABLE):
	$(CXX) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $(SOURCES) -o $@

clean:
	-rm -f *.o
	-rm -f $(EXECUTABLE)