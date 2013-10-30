//
//  chatConversationViewController.m
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import "chatConversationViewController.h"
#import "MQTTClient.h"
#import <QuartzCore/QuartzCore.h>

@interface chatConversationViewController () <MQTTClientDelegate, UITextViewDelegate>
@property (strong, nonatomic) MQTTClient * client;
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
-(MQTTClient *)client {
    if (!_client) {
        _client = [[MQTTClient alloc] initWithClientId:self.userName];
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
    [self.client connectToHost:@"platform.clearblade.com:1883/"];
    [self textViewDidChange:self.messageField];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
-(void)didConnect:(NSUInteger)code {
    [self.client subscribe:self.groupName];
}
-(void)didUnsubscribe:(NSUInteger)messageId {
    
}
-(void)didReceiveMessage:(MQTTMessage *)mqtt_msg {
    [self addMessage:mqtt_msg.payload];
}
-(void)didPublish:(NSUInteger)messageId {
    
}
-(void)didDisconnect {
    
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
    rect.origin.y = lastMessageRect.origin.y + lastMessageRect.size.height + 1;
    rect.size.height = 30;
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor blueColor];
    label.text = message;
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
- (void)didSubscribe:(NSUInteger)messageId grantedQos:(NSArray *)qos {
    [self.messages removeAllObjects];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    NSString * text = self.messageField.text;
    MQTTMessage * message = [[MQTTMessage alloc] init];
    message.payload = text;
    self.messageField.text = @"";
    [self didReceiveMessage:message];
}
-(void)setMessageField:(UITextView *)messageField {
    _messageField = messageField;
    _messageField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _messageField.layer.borderWidth = 1;
    _messageField.layer.cornerRadius = 5;
    _messageField.delegate = self;
}
-(void)textViewDidChange:(UITextView *)textView {
    CGFloat height = [textView.text boundingRectWithSize:(CGSize){textView.frame.size.width - 5,CGFLOAT_MAX}
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
    
}
@end
