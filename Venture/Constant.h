//
//  Constant.h
//  Venture
//
//  Created by Deepak Tomar on 28/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#ifndef Venture_Constant_h
#define Venture_Constant_h


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


///...... url string ......... ////

#define k_BASE_URL @"http://dev.clavax.us/ventureapp/public/api/"

#endif
