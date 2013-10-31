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
#import "chatModalActivityIndicatorView.h"
#define POST_LOGIN_CONTROLLER @"MainNavigationController"

@interface chatLoginViewController ()
@property (strong, nonatomic) NSNumber * userNameGroupPosition;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;
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
    self.errorMessageField.hidden = YES;
    
#ifdef CHAT_SKIP_START
    [self loginWithRandomName];
#endif
}
-(void)loginWithRandomName {
    unichar random[10];
    sranddev();
    for (int i = 0; i < 10; i++) {
        random[i] = rand() % 26 + 'A';
    }
    self.userName = [NSString stringWithFormat:@"tyler_test_%@", [NSString stringWithCharacters:random length:10]];
    [self loginClicked:self];
}
-(UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[chatModalActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge
                                                                     withTargetParentView:self.view];
    }
    return _spinner;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginClicked:(id)sender {
    [self.userNameField resignFirstResponder];
    if (self.userName.length == 0) {
        [self userMustNotBeEmpty];
        return;
    }
    [self.spinner startAnimating];
    self.errorMessageField.hidden = YES;
    CBQuery * usersQuery = [[CBQuery alloc] initWithCollectionID:CHAT_USERS_COLLECTION];
    [usersQuery equalTo:self.userName for:CHAT_USER_FIELD];
    [usersQuery fetchWithSuccessCallback:^(NSMutableArray * data) {
        [self.spinner stopAnimating];
        if (data.count > 0) {
            [self userExists];
        } else {
            [self userDoesNotExist];
        }
    } ErrorCallback:^(NSError * error, id object) {
        [self.spinner stopAnimating];
    }];
}
-(void)userDoesNotExist {
    UIStoryboard * storyboard = self.storyboard;
    CBItem * newUser = [[CBItem alloc] initWithData:@{CHAT_USER_FIELD: self.userName} collectionID:CHAT_USERS_COLLECTION];
    [newUser save];
    chatNavigationViewController * controller =[storyboard instantiateViewControllerWithIdentifier:POST_LOGIN_CONTROLLER];
    controller.logoutDelegate = self;
    controller.userName = self.userName;
    [self presentViewController:controller animated:YES completion:^{}];
}
-(void)userMustNotBeEmpty {
    self.errorMessageField.hidden = NO;
    self.errorMessageField.text = @"Username must not be empty";
}
-(void)userExists {
    self.errorMessageField.hidden = NO;
    self.errorMessageField.text = @"Username already exists";
}
- (IBAction)userNameGetFocus:(id)sender {
    self.userNameGroupPosition = @([self.userNameFieldGroup center].y);
    CGRect frame = self.userNameFieldGroup.frame;
    frame.origin.y = frame.size.height;
    [self.userNameFieldGroup setFrame:frame];
}
-(void)logOut {
    CBQuery * query = [[CBQuery alloc] initWithCollectionID:CHAT_USERS_COLLECTION];
    [[query equalTo:self.userName for:CHAT_USER_FIELD] removeWithSuccessCallback:^(NSMutableArray * result) {
        
    } ErrorCallback:^(NSError * error, id extra) {
    
    }];
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
