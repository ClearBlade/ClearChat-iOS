//
//  chatConversationViewController.h
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatConversationViewController : UIViewController
@property (strong, nonatomic) NSString * groupName;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITextView *messageInput;
@end
