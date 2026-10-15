#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <linux/input.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <unistd.h>

/* 5x7 glyphs for the deliberately small recovery interface. */
static const struct { char c; unsigned char row[7]; } font[] = {
 {' ',{0,0,0,0,0,0,0}}, {'A',{14,17,17,31,17,17,17}},
 {'B',{30,17,17,30,17,17,30}}, {'C',{14,17,16,16,16,17,14}},
 {'D',{30,17,17,17,17,17,30}}, {'E',{31,16,16,30,16,16,31}},
 {'F',{31,16,16,30,16,16,16}}, {'G',{14,17,16,23,17,17,15}},
 {'H',{17,17,17,31,17,17,17}}, {'I',{31,4,4,4,4,4,31}},
 {'J',{7,2,2,2,18,18,12}}, {'K',{17,18,20,24,20,18,17}},
 {'L',{16,16,16,16,16,16,31}}, {'M',{17,27,21,21,17,17,17}},
 {'N',{17,25,21,19,17,17,17}}, {'O',{14,17,17,17,17,17,14}},
 {'P',{30,17,17,30,16,16,16}}, {'Q',{14,17,17,17,21,18,13}},
 {'R',{30,17,17,30,20,18,17}}, {'S',{15,16,16,14,1,1,30}},
 {'T',{31,4,4,4,4,4,4}}, {'U',{17,17,17,17,17,17,14}},
 {'V',{17,17,17,17,17,10,4}}, {'W',{17,17,17,21,21,21,10}},
 {'X',{17,17,10,4,10,17,17}}, {'Y',{17,17,10,4,4,4,4}},
 {'Z',{31,1,2,4,8,16,31}}, {'0',{14,17,19,21,25,17,14}},
 {'1',{4,12,4,4,4,4,14}}, {'2',{14,17,1,2,4,8,31}},
 {'3',{30,1,1,14,1,1,30}}, {'4',{2,6,10,18,31,2,2}},
 {'5',{31,16,30,1,1,17,14}}, {'6',{6,8,16,30,17,17,14}},
 {'7',{31,1,2,4,8,8,8}}, {'8',{14,17,17,14,17,17,14}},
 {'9',{14,17,17,15,1,2,12}}, {':',{0,4,4,0,4,4,0}},
 {'-',{0,0,0,31,0,0,0}}, {'/',{1,1,2,4,8,16,16}}
};
static unsigned char *fb;
static size_t fbsize;
static struct fb_var_screeninfo v;
static struct fb_fix_screeninfo fix;
static int selected;
static int available[3];
static const char *names[]={"SD CARD", "USB", "SPI READ ONLY"};

static void dot(int x,int y,unsigned r,unsigned g,unsigned b) {
 if(x<0||y<0||x>=(int)v.xres||y>=(int)v.yres)return;
 size_t off=(size_t)(y+v.yoffset)*fix.line_length + (size_t)(x+v.xoffset)*(v.bits_per_pixel/8);
 if(off+v.bits_per_pixel/8>fbsize)return;
 uint32_t color=(((uint32_t)r*((1u<<v.red.length)-1)/255)<<v.red.offset)|
  (((uint32_t)g*((1u<<v.green.length)-1)/255)<<v.green.offset)|
  (((uint32_t)b*((1u<<v.blue.length)-1)/255)<<v.blue.offset);
 if(v.bits_per_pixel==16) { uint16_t c=(uint16_t)color;memcpy(fb+off,&c,2); }
 else if(v.bits_per_pixel==32)memcpy(fb+off,&color,4);
}
static void rect(int x,int y,int w,int h,int r,int g,int b){
 for(int j=y;j<y+h;j++)for(int i=x;i<x+w;i++)dot(i,j,r,g,b);
}
static void label(int x,int y,const char *s,int scale,int r,int g,int b){
 for(;*s;s++,x+=6*scale){
  char c=*s;if(c>='a'&&c<='z')c-=32;
  const unsigned char *p=NULL;
  for(size_t i=0;i<sizeof(font)/sizeof(font[0]);i++)if(font[i].c==c){p=font[i].row;break;}
  if(!p)continue;
  for(int j=0;j<7;j++)for(int i=0;i<5;i++)if(p[j]&(1<<(4-i)))rect(x+i*scale,y+j*scale,scale,scale,r,g,b);
 }
}
static int have_prefix(const char *base, const char *prefix) {
 FILE *f=fopen(base,"r");if(!f)return 0;char s[256];int found=0;
 while(fgets(s,sizeof s,f))if(strstr(s,prefix)){found=1;break;}
 fclose(f);return found;
}
static void rescan(void){
 available[0]=have_prefix("/proc/partitions","mmcblk");
 available[1]=have_prefix("/proc/partitions"," sd")||have_prefix("/proc/partitions"," sda");
 available[2]=have_prefix("/proc/mtd","mtd");
}
static void draw(void){
 int w=v.xres,h=v.yres;rect(0,0,w,h,12,25,42);
 label(w/2-12*6*2/2,25,"XFH RECOVERY",2,238,243,249);
 label(20,72,"SELECT STORAGE",2,135,170,212);
 int top=120,button_h=(h-150)/3;if(button_h<50)button_h=50;
 for(int n=0;n<3;n++){
  int y=top+n*button_h;
  rect(16,y,w-32,button_h-8,selected==n?35:27,selected==n?91:52,selected==n?148:78);
  label(34,y+16,names[n],2,available[n]?245:120,available[n]?245:140,available[n]?255:160);
  label(w-115,y+16,available[n]?"READY":"NONE",1,available[n]?110:178,available[n]?235:178,available[n]?148:178);
 }
}
static void record(int n){
 FILE *f=fopen("/mnt/boot/XFH_SELECTED.TXT","w");
 if(f){fprintf(f,"XFH storage selection: %s\nAvailable: %d\nRead-only diagnostic selection; no storage mounted or modified.\n",names[n],available[n]);fclose(f);sync();}
 fprintf(stderr,"XFH selection %s (available=%d)\n",names[n],available[n]);
}
int main(void){
 rescan();int fd=open("/dev/fb0",O_RDWR);if(fd<0){perror("/dev/fb0");return 2;}
 if(ioctl(fd,FBIOGET_VSCREENINFO,&v)||ioctl(fd,FBIOGET_FSCREENINFO,&fix)){perror("fb ioctl");close(fd);return 2;}
 if(v.bits_per_pixel!=16&&v.bits_per_pixel!=32){fprintf(stderr,"Unsupported framebuffer bpp %u\n",v.bits_per_pixel);close(fd);return 2;}
 fbsize=fix.smem_len;fb=mmap(NULL,fbsize,PROT_READ|PROT_WRITE,MAP_SHARED,fd,0);
 if(fb==MAP_FAILED){perror("mmap");close(fd);return 2;}
 draw();
 int in=-1;char device[64];for(int i=0;i<8;i++){
  snprintf(device,sizeof(device),"/dev/input/event%d",i);
  int t=open(device,O_RDONLY|O_NONBLOCK);if(t>=0){in=t;break;}
 }
 int py=0,pressed=0;
 /* A usable touch/keyboard selector; selections never execute write operations. */
 while(1){
  fd_set set;FD_ZERO(&set);if(in>=0)FD_SET(in,&set);FD_SET(STDIN_FILENO,&set);
  struct timeval timeout={1,0};int max=(in>STDIN_FILENO?in:STDIN_FILENO);
  int ret=select(max+1,&set,NULL,NULL,&timeout);
  if(ret<0&&errno!=EINTR)break;
  if(ret>0&&FD_ISSET(STDIN_FILENO,&set)){
   char c;if(read(STDIN_FILENO,&c,1)==1){
    if(c=='q')break;
    if(c=='j'||c=='s')selected=(selected+1)%3;
    if(c=='k'||c=='w')selected=(selected+2)%3;
    if(c=='\n'||c==' ')record(selected);
    draw();
   }
  }
  if(in>=0&&ret>0&&FD_ISSET(in,&set)){
   struct input_event e;
   while(read(in,&e,sizeof e)==sizeof e){
    if(e.type==EV_ABS){
     /* Touch X not needed: buttons fill panel width. */
     if(e.code==ABS_Y||e.code==ABS_MT_POSITION_Y)py=e.value;
    }
    if(e.type==EV_KEY&&(e.code==BTN_TOUCH||e.code==BTN_LEFT)){
     if(e.value==1)pressed=1;
     else if(e.value==0&&pressed){
      pressed=0;int row=(py-120)/((int)(v.yres-150)/3);
      if(py>=120&&row>=0&&row<3){selected=row;record(selected);draw();}
     }
    }
   }
  }
 }
 if(in>=0)close(in);
 munmap(fb,fbsize);
 close(fd);
 return 0;
}
