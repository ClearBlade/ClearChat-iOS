//
//  CBConstants.h
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Tyler Dodge. All rights reserved.
//

#ifndef Chat_CBConstants_h
#define Chat_CBConstants_h

#ifdef USE_DEV
#define PLATFORM_URL @"http://ec2-23-23-31-115.compute-1.amazonaws.com:8080"
#define MESSAGE_PLATFORM_URL @"tcp://ec2-23-23-31-115.compute-1.amazonaws.com:1883"
#define API_PATH @"api/%@"
#else
#define PLATFORM_URL @"http://platform.clearblade.com"
#define MESSAGE_PLATFORM_URL @"tcp://platform.clearblade.com:1883"
#define API_PATH @"apidev/%@"
#endif

#define CALL_IF_EXISTS(method, ...) if ((method) != nil) (method)(__VA_ARGS__)
#define ITEM_ID @"itemId"

#endif
