//
//  chatLoginViewController.h
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatNavigationViewController.h"
@interface chatLoginViewController : UIViewController <chatNavigationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIView *userNameFieldGroup;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageField;
@property (weak, nonatomic) NSString * userName;

@end
