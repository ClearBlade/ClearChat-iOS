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
#import "chatModalActivityIndicatorView.h"
#import "chatConstants.h"
#define TABLE_ROW @"GroupRow"
#define TABLE_CREATE_ROW @"CreateRow"
#define TABLE_DEFAULT_ROW_HEIGHT 44
#define TABLE_CREATE_ROW_HEIGHT 60

@interface chatGroupsViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) CBCollection * collection;
@property (strong, nonatomic) NSMutableArray * data;
@property (strong, nonatomic) NSMutableArray * searchResults;
@property (strong, nonatomic) NSString * createNewGroupName;
@property (strong, nonatomic) UIActivityIndicatorView * spinner;
-(NSMutableArray *)dataForTableView:(UITableView *)tableView;
-(bool)shouldShowCreateNewGroup:(UITableView *)tableView;
@end

@implementation chatGroupsCreateRowTableViewCell

@end

@implementation chatGroupsViewController
-(bool)shouldShowCreateNewGroup:(UITableView *)tableView {
    return self.createNewGroupName && tableView == self.searchDisplayController.searchResultsTableView;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterSearchResults:searchText];
}
-(NSMutableArray *)searchResults {
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}
-(void)filterSearchResults:(NSString *)text {
    [self.searchResults removeAllObjects];
    BOOL isTextUnique = YES;
    NSString * searchText = [text lowercaseString];
    for (CBItem * result in self.data) {
        NSString * resultName = [[result objectForKey:CHAT_GROUP_NAME_FIELD] lowercaseString];
        if ([resultName hasPrefix:searchText]) {
            [self.searchResults addObject:result];
            if ([resultName isEqualToString:searchText]) {
                isTextUnique = NO;
            }
        }
    }
    if (isTextUnique) {
        self.createNewGroupName = text;
    } else {
        self.createNewGroupName = nil;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIActivityIndicatorView *)spinner {
    if (!_spinner) {
        _spinner = [[chatModalActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge withTargetParentView:self.view];
    }
    return _spinner;
}
-(CBCollection *)collection {
    if (!_collection) {
        _collection = [[CBCollection alloc] initWithCollectionID:CHAT_GROUPS_COLLECTION];
    }
    return _collection;
}
-(NSMutableArray *)dataForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults;
    }
    return self.data;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.navigationController isKindOfClass:[chatNavigationViewController class]]) {
        chatNavigationViewController * controller = (chatNavigationViewController *)self.navigationController;
        self.userName = controller.userName;
    }
    [self.spinner startAnimating];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //Reloads transparently if there has already been something loaded
    [self.collection fetchWithSuccessCallback:^(NSMutableArray *data) {
        [self.spinner stopAnimating];
        [self reload:data];
#ifdef CHAT_SKIP_GROUPS
        [self selectFirstGroup];
#endif
    } withErrorCallback:^(NSError * error, id extra) {
        [self.spinner stopAnimating];
    }];
    
}
-(void)selectFirstGroup {
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
- (void)reload:(NSMutableArray *)data {
    self.data = data;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self shouldShowCreateNewGroup:tableView]) {
        return 2;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldShowCreateNewGroup:tableView] && [indexPath indexAtPosition:0] == 0) {
        return TABLE_CREATE_ROW_HEIGHT;
    }
    return TABLE_DEFAULT_ROW_HEIGHT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self shouldShowCreateNewGroup:tableView] && section == 0) {
        return 1;
    } else {
        return [self dataForTableView:tableView].count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if ([self shouldShowCreateNewGroup:tableView] && [indexPath indexAtPosition:0] == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_CREATE_ROW];
        ((chatGroupsCreateRowTableViewCell *)cell).groupName.text = self.createNewGroupName;
    } else {
        cell = [self.tableView dequeueReusableCellWithIdentifier:TABLE_ROW];
        int index = [indexPath indexAtPosition:1];
    
        CBItem * itemAtIndex = [[self dataForTableView:tableView] objectAtIndex:index];
        cell.textLabel.text = [itemAtIndex objectForKey:CHAT_GROUP_NAME_FIELD];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBItem * item;
    if ([self shouldShowCreateNewGroup:tableView] && [indexPath indexAtPosition:0] == 0) {
        item = [CBItem itemWithData:@{CHAT_GROUP_NAME_FIELD:self.createNewGroupName}
                        withCollectionID:CHAT_GROUPS_COLLECTION];
        [item saveWithSuccessCallback:nil withErrorCallback:nil];
    } else {
        item = [[self dataForTableView:tableView] objectAtIndex:[indexPath indexAtPosition:1]];
    }
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
        controller.groupName = [group objectForKey:CHAT_GROUP_NAME_FIELD];
        controller.userName = self.userName;
    }
    [(UISearchDisplayController *)self.searchDisplayController  setActive:NO animated:YES];
    
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
