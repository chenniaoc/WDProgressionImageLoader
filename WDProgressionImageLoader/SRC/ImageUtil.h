//
//  ImageUtil.h
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 15-8-20.
//  Copyright (c) 2015年 zhangyuchen. All rights reserved.
//

#ifndef __WDProgressionImageLoader__ImageUtil__
#define __WDProgressionImageLoader__ImageUtil__

#include <stdio.h>

#endif /* defined(__WDProgressionImageLoader__ImageUtil__) */

static char PG_FLAG[2] = {0xff,0xc2};
static char BL_FLAG[2] = {0xff,0xc0};


typedef enum _WDPJpegType{
    WDPJpegTypeProgessive,
    WDPJpegTypeBaseline,
    WDPJpegTypeUnknow,
}WDPJpegType;



WDPJpegType
WDP_detectJpegType(char * jpegBytes, size_t fileSize);


void
WDP_decodeProgressiveJpeg(char *jpegBytes);


