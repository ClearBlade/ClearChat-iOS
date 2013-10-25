//
//  chatNavigationViewController.m
//  Chat
//
//  Created by Tyler Dodge on 10/25/13.
//  Copyright (c) 2013 Tyler Dodge. All rights reserved.
//

#import "chatNavigationViewController.h"

@interface chatNavigationViewController ()

@end

@implementation chatNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
-(void)logOut {
    id<chatNavigationViewControllerDelegate> delegate = self.logoutDelegate;
    [delegate logOut];
}
@end
