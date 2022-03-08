# frozen_string_literal: true

require "mkmf"

$CPPFLAGS += " -D RPI -D USE_BCM2835_LIB "
$LDFLAGS += " -lbcm2835 -lm "

create_makefile("epaper/epaper")
