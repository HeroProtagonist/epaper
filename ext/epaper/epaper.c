#include "epaper.h"
#include "EPD_7in5_V2.h"
#include "GUI_Paint.h"
#include <signal.h>

VALUE rb_mEpaper;

void Handler(int signo)
{
  //System Exit
  printf("\r\nHandler:exit\r\n");
  DEV_Module_Exit();

  exit(0);
}

VALUE rb_epd_init() {
  signal(SIGINT, Handler);

  printf("EPD_7IN5_V2_test Demo\r\n");
  if(DEV_Module_Init()!=0){
      return -1;
  }

  printf("e-Paper Init and Clear...\r\n");
  EPD_7IN5_V2_Init();

  EPD_7IN5_V2_Clear();
  DEV_Delay_ms(500);

  return Qnil;
}

VALUE rb_epd_exit() {
  printf("Clear...\r\n");
  EPD_7IN5_V2_Clear();

  printf("Goto Sleep...\r\n");
  EPD_7IN5_V2_Sleep();

  DEV_Delay_ms(2000);//important, at least 2s

  DEV_Module_Exit();

  return Qnil;
}

VALUE rb_epd_render_image(VALUE self, VALUE img)
{
  //Create a new image cache
  UBYTE *BlackImage;
  /* you have to edit the startup_stm32fxxx.s file and set a big enough heap size */
  UWORD Imagesize = ((EPD_7IN5_V2_WIDTH % 8 == 0)? (EPD_7IN5_V2_WIDTH / 8 ): (EPD_7IN5_V2_WIDTH / 8 + 1)) * EPD_7IN5_V2_HEIGHT;
  if((BlackImage = (UBYTE *)malloc(Imagesize)) == NULL) {
      printf("Failed to apply for black memory...\r\n");
      return -1;
  }

  printf("Paint_NewImage\r\n");
  Paint_NewImage(BlackImage, EPD_7IN5_V2_WIDTH, EPD_7IN5_V2_HEIGHT, 0, WHITE);

  printf("show image for array\r\n");
  Paint_SelectImage(BlackImage);
  Paint_Clear(WHITE);

  Paint_DrawBitMap(StringValuePtr(img));

  EPD_7IN5_V2_Display(BlackImage);
  DEV_Delay_ms(2000);

  free(BlackImage);
  BlackImage = NULL;
}

void Init_epaper(void) {
  rb_mEpaper = rb_define_module("Epaper");

  rb_define_singleton_method(rb_mEpaper, "init", rb_epd_init, 0);
  rb_define_singleton_method(rb_mEpaper, "exit", rb_epd_exit, 0);
  rb_define_singleton_method(rb_mEpaper, "render_image", rb_epd_render_image, 1);
}
