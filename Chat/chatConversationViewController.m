//
//  chatConversationViewController.m
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import "chatConversationViewController.h"
#import "CBMessageClient.h"
#import "CBConstants.h"
#import <QuartzCore/QuartzCore.h>
#define MESSAGE_MARGIN 10

@interface chatConversationViewController () <CBMessageClientDelegate, UITextViewDelegate>
@property (strong, nonatomic) CBMessageClient * client;
@property (strong, nonatomic) NSMutableArray * messages;
@end

@implementation chatConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(CBMessageClient *)client {
    if (!_client) {
        _client = [[CBMessageClient alloc] init];
        _client.delegate = self;
    }
    return _client;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
    [self.client connectToHost:[NSURL URLWithString:MESSAGE_PLATFORM_URL]];
    [self textViewDidChange:self.messageField];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
-(void)keyboardWillShow:(NSNotification *)notification {
    NSNumber * duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber * curve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[duration doubleValue] delay:0 options:[curve intValue] animations:^{
        self.bottomBarDistanceFromBottom.constant = keyboardFrame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL didComplete) {
        
    }];
}
-(void)keyboardWillHide:(NSNotification *)notification {
    [self.view addSubview:self.bottomBar];
}
-(void)addMessage:(NSString *)message {
    CGRect rect = self.view.frame;
    CGRect lastMessageRect = [[self.messages lastObject] frame];
    rect.origin.y = lastMessageRect.origin.y + lastMessageRect.size.height + 10;
    UITextView * label = [[UITextView alloc] init];
    rect.size.width -= (MESSAGE_MARGIN * 2);
    rect.origin.x += MESSAGE_MARGIN;
    rect.size.height = [message boundingRectWithSize:(CGSize){rect.size.width,CGFLOAT_MAX}
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: self.messageField.font} //UITextView does not have a default font
                                             context:nil].size.height + 10;
    label.frame = rect;
    label.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    label.text = message;
    label.scrollEnabled = NO;
    label.editable = NO;
    [self.scrollView addSubview:label];
    self.scrollView.contentSize = CGSizeMake(rect.size.width, rect.origin.y + rect.size.height);
    [self.messages addObject:label];
}
-(NSMutableArray *)messages {
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    NSString * text = [NSString stringWithFormat:@"%@: %@", self.userName, self.messageField.text];
    [self.client publishMessage:text toTopic:self.groupName];
    self.messageField.text = @"";
}
-(void)setMessageField:(UITextView *)messageField {
    _messageField = messageField;
    _messageField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _messageField.layer.borderWidth = 1;
    _messageField.layer.cornerRadius = 5;
    _messageField.delegate = self;
}
-(void)textViewDidChange:(UITextView *)textView {

    CGFloat height = [[textView.text stringByAppendingString:@"A"] //A is appended just so it will catch a ending newline
                      boundingRectWithSize:(CGSize){textView.frame.size.width - 5,CGFLOAT_MAX}
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName: textView.font}
                      context:nil].size.height + 15;
    CGFloat heightDiff = ceil(height) - ceil(textView.frame.size.height);
    if (fabsf(heightDiff) > 3.0) {
        self.bottomBarHeight.constant += heightDiff;
        if (self.bottomBarHeight.constant > 120) {
            self.bottomBarHeight.constant = 120;
        }
    }
    if (textView.text.length == 0) {
        self.sendMessageButton.enabled = NO;
    } else {
        self.sendMessageButton.enabled = YES;
    }
    
}
-(void)messageClient:(CBMessageClient *)client didConnect:(CBMessageClientConnectStatus)status {
    [client subscribeToTopic:self.groupName];
}
-(void)messageClient:(CBMessageClient *)client didReceiveMessage:(CBMessage *)message {
    [self addMessage:[message payloadText]];
}
@end
