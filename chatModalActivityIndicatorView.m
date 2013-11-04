//
//  chatModalActivityIndicatorView.m
//  Chat
//
//  Created by Tyler Dodge on 10/29/13.
//  Copyright (c) 2013 Tyler Dodge. All rights reserved.
//

#import "chatModalActivityIndicatorView.h"

@implementation chatModalActivityIndicatorView

-(id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style withTargetParentView:(UIView *)view {
    self = [super initWithActivityIndicatorStyle:style];
    if (self) {
        self.targetParentView = view;
    }
    return self;
}
-(void)startAnimating {
    self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.opaque = NO;
    UIView * parent = self.targetParentView;
    [parent addSubview:self];
    self.frame = CGRectMake(0,0,parent.frame.size.width, parent.frame.size.height);
    [super startAnimating];
}
-(void)stopAnimating {
    [super stopAnimating];
    [self removeFromSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
