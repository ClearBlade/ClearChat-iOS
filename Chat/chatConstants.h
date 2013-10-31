//
//  chatConstants.h
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#ifndef Chat_chatConstants_h
#define Chat_chatConstants_h

#define CHAT_USER_FIELD @"username"
#define CHAT_GROUP_NAME_FIELD @"groupName"
#define CHAT_CONVERSATION_SEGUE @"segueConversation"
//#define CHAT_SKIP_START
//#define CHAT_SKIP_GROUPS
#ifdef USE_DEV
#define CHAT_APP_KEY @"d6d48aa70aaa98d9ccf8defedf48" 
#define CHAT_APP_SECRET @"D6D48AA70A96CAB8E89AFBB394F601"
#define CHAT_USERS_COLLECTION @"fad78aa70a90b8d5d5d2fa93ec45"
#define CHAT_GROUPS_COLLECTION @"aed88aa70a96bbb3d8a5e6a8db1c"
#else
#define CHAT_APP_KEY @"525542228ab3a3212a06bd81"
#define CHAT_APP_SECRET @"MNDDJ0POOIC98VTS9ZQZQ5JBQB0FKI"
#define CHAT_USERS_COLLECTION @"525542308ab3a3212a06bd82"
#define CHAT_GROUPS_COLLECTION @"525bf8e48ab3a3212a06bd83"
#endif
#endif
