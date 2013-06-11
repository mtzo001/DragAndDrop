//
//  XYZDropTarget.m
//  DragAndDrop
//
//  Created by Eric Gu on 6/10/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import "XYZDropTarget.h"
NSInteger contains = -1;
Boolean correct = false;
NSInteger expected = -11;

@implementation XYZDropTarget

-(void)dropNotification:(NSNotification *)sender{
    //NSLog(pathname);
    //[self setImage:([UIImage imageNamed:@"b0.jpg"])];
    
    int check = [[[sender userInfo] valueForKey:@"pass"] intValue];
    NSLog([NSString stringWithFormat: @"%d", check]);
    if (check==expected) {
        correct=true;
        //[[NSNotificationCenter defaultCenter] postNotificationName: @"flag1" object: nil];
    } else {
        correct=false;
        //[[NSNotificationCenter defaultCenter] postNotificationName: @"flag0" object: nil];
    }
    contains=check;
    
}

-(void)empty:(NSNotification *)sender{
    //NSLog(@"BOOM");
    //[self setImage:([UIImage imageNamed:@"b3.jpg"])];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"flag0" object: nil];
    contains=-1;
    NSLog(@"Emptied");
}

-(Boolean)isCorrect
{
    return correct;
} 



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(dropNotification:)
													 name: @"dropped"
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(empty:)
													 name: @"empty"
												   object:nil];
    }
    return self;
}


-(NSInteger)getContains
{
    return contains;
}

-(void)setExpected:(NSInteger)idnum
{
    expected=idnum;
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
