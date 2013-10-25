//
//  chatLoginViewController.m
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import "chatLoginViewController.h"
#import "CBAPI.h"
#import "chatConstants.h"
#import "chatGroupsViewController.h"
#define POST_LOGIN_CONTROLLER @"MainNavigationController"

@interface chatLoginViewController ()
@property (strong, nonatomic) NSNumber * userNameGroupPosition;
-(void)userDoesNotExist;
-(void)userExists;
@end

@implementation chatLoginViewController
@synthesize userNameGroupPosition = _userNameGroupPosition;
@synthesize userNameField = _userNameField;
@synthesize userNameFieldGroup = _userNameFieldGroup;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClicked:(id)sender {
    [self.userNameField resignFirstResponder];
    CBQuery * usersQuery = [[CBQuery alloc] initWithCollectionID:CHAT_USERS_COLLECTION];
    [usersQuery equalTo:self.userName for:CHAT_USER_FIELD];
    [usersQuery fetchWithSuccessCallback:^(NSMutableArray * data) {
        if (data.count > 0) {
            [self userExists];
        } else {
            [self userDoesNotExist];
        }
    } ErrorCallback:^(NSError * error, id object) {
        printf("%@", error);
    }];
}
-(void)userDoesNotExist {
    UIStoryboard * storyboard = self.storyboard;
    chatNavigationViewController * controller =[storyboard instantiateViewControllerWithIdentifier:POST_LOGIN_CONTROLLER];
    controller.logoutDelegate = self;
    [self presentViewController:controller animated:YES completion:^{}];
}
-(void)userExists {
    self.errorMessageField.text = @"Username already exists";
}
- (IBAction)userNameGetFocus:(id)sender {
    self.userNameGroupPosition = @([self.userNameFieldGroup center].y);
    CGRect frame = self.userNameFieldGroup.frame;
    frame.origin.y = frame.size.height;
    [self.userNameFieldGroup setFrame:frame];
}
-(void)logOut {
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)userNameLoseFocus:(id)sender {
    [self.userNameFieldGroup setCenter:CGPointMake(self.userNameFieldGroup.center.x, [self.userNameGroupPosition intValue])];
}

-(NSString *)userName {
    return self.userNameField.text;
}
-(void)setUserName:(NSString *)userName {
    self.userNameField.text = userName;
}

@end
