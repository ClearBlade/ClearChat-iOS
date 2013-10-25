//
//  chatConversationViewController.m
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import "chatConversationViewController.h"
#import "MQTTClient.h"

@interface chatConversationViewController () <MQTTClientDelegate>
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
    [self.messageField setInputAccessoryView:self.bottomBar];
	// Do any additional setup after loading the view.
}
-(void)didConnect:(NSUInteger)code {
    [self.client subscribe:self.groupName];
}
-(void)didUnsubscribe:(NSUInteger)messageId {
    
}
-(void)didReceiveMessage:(MQTTMessage *)mqtt_msg {
    
}
-(void)didPublish:(NSUInteger)messageId {
    
}
-(void)didDisconnect {
    
}
-(void)keyboardWillShow:(NSNotification *)notification {
    [self.bottomBar removeFromSuperview];
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
    [self.scrollView addSubview:label];
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

@end
