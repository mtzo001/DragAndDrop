//
//  XYZDropTarget.m
//  DragAndDrop
//
//  Created by Eric Gu on 6/10/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import "XYZDropTarget.h"
NSString *pathname=@"AAA";
@implementation XYZDropTarget

-(void)dropNotification1:(NSNotification *)sender{
    //NSLog(pathname);
    [self setImage:([UIImage imageNamed:@"b0.jpg"])];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"flag0" object: nil];
}

-(void)dropNotification2:(NSNotification *)sender{
    //NSLog(pathname);
    [self setImage:([UIImage imageNamed:@"b1.jpg"])];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"flag1" object: nil];
}

-(void)dropNotification3:(NSNotification *)sender{
    //NSLog(pathname);
    [self setImage:([UIImage imageNamed:@"b2.jpg"])];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"flag0" object: nil];
}

-(void)dropNotification4:(NSNotification *)sender{
    //NSLog(@"BOOM");
    [self setImage:([UIImage imageNamed:@"b3.jpg"])];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"flag0" object: nil];
}

-(void)checker:(NSNotification *)sender{
    int check = [[[sender userInfo] valueForKey:@"pass"] intValue];
    if (check==0 ) {
        [self setImage:([UIImage imageNamed:@"blank.png"])];
        [self setBackgroundColor:[UIColor greenColor]];
        [self setAlpha:(1.0)];
    } else {
        [self setAlpha:(0.0)];
    }
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dropNotification1:)
													 name: @"0"
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dropNotification2:)
													 name: @"1"
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dropNotification3:)
													 name: @"2"
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dropNotification4:)
													 name: @"3"
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(checker:)
													 name: @"check"
												   object:nil];
    }
    return self;
}

-(void)setPath:(NSString *)name
{
    pathname=name;
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
