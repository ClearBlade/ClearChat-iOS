//
//  chatNavigationViewController.h
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol chatNavigationViewControllerDelegate
-(void)logOut;
@end

@interface chatNavigationViewController : UINavigationController
@property (weak, nonatomic) id<chatNavigationViewControllerDelegate> logoutDelegate;
@property (strong, nonatomic) NSString * userName;
-(void)logOut;
@end
