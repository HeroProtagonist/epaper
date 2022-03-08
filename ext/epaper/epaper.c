#include "epaper.h"

VALUE rb_mEpaper;

void
Init_epaper(void)
{
  rb_mEpaper = rb_define_module("Epaper");
}
