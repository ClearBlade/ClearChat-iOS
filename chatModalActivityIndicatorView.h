//
//  chatModalActivityIndicatorView.h
//  Chat
//
//  Created by Tyler Dodge on 10/29/13.
//  Copyright (c) 2013 Clearblade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatModalActivityIndicatorView : UIActivityIndicatorView
@property (weak, nonatomic) UIView * targetParentView;
-(id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style withTargetParentView:(UIView *)view;
@end
