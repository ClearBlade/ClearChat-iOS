//
//  chatGroupsViewController.m
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import "chatGroupsViewController.h"
#import "chatNavigationViewController.h"
#import "chatConversationViewController.h"
#import "CBAPI.h"
#import "chatConstants.h"
#define TABLE_ROW @"GroupRow"

@interface chatGroupsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CBCollection * collection;
@property (strong, nonatomic) NSMutableArray * data;

@end

@implementation chatGroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(CBCollection *)collection {
    if (!_collection) {
        _collection = [[CBCollection alloc] initWithCollectionID:CHAT_GROUPS_COLLECTION];
    }
    return _collection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collection fetchWithSuccessCallback:^(NSMutableArray *data) {
        [self reload:data];
    } ErrorCallback:^(NSError * error, id extra) {
        
    }];
}
- (void)reload:(NSMutableArray *)data {
    self.data = data;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TABLE_ROW];
    
    CBItem * itemAtIndex = [self.data objectAtIndex:[indexPath indexAtPosition:1]];
    cell.textLabel.text = [itemAtIndex getValueFor:CHAT_GROUP_NAME_FIELD];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBItem * item = [self.data objectAtIndex:[indexPath indexAtPosition:1]];
    [self performSegueWithIdentifier:CHAT_CONVERSATION_SEGUE sender:item];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    chatConversationViewController * controller = (chatConversationViewController *)segue.destinationViewController;
    CBItem * group = (CBItem *)sender;
    if (![group isKindOfClass:[CBItem class]]) {
        NSLog(@"Unexpected type for sender in prepare for segue");
        return;
    }
    else if (![controller isKindOfClass:[chatConversationViewController class]]) {
        NSLog(@"Unexpected type for destination view controller");
        return;
    }
    else {
        controller.groupName = [group getValueFor:CHAT_GROUP_NAME_FIELD];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOut:(id)sender {
    [(chatNavigationViewController *)self.navigationController logOut];
}

@end
