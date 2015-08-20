//
//  ImageUtil.c
//  WDProgressionImageLoader
//
//  Created by zhangyuchen on 15-8-20.
//  Copyright (c) 2015年 zhangyuchen. All rights reserved.
//


#include "ImageUtil.h"


WDPJpegType
WDP_detectJpegType(char * jpegBytes, size_t fileSize)
{
    
    size_t offset = 0;
    char *ptr = NULL;
    
    while (offset < fileSize) {
        
        if ((offset) > fileSize) {
            break;
        }
        
        ptr = (jpegBytes + offset);
        
        char pairVal[2];
        pairVal[0] = (int)*ptr;
        pairVal[1] = (int)*(ptr + 1);
        
        if (pairVal[0] == PG_FLAG[0]) {
            
            if (pairVal[1] == PG_FLAG[1])
            {
                return WDPJpegTypeProgessive;
            }
            else if (pairVal[1] == BL_FLAG[1])
            {
                return WDPJpegTypeBaseline;
            }        }
        
        offset += 2;
    }
    
    return WDPJpegTypeUnknow;
}