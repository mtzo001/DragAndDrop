//
//  XYZDropTarget.m
//  DragAndDrop
//
//  Created by Eric Gu on 6/10/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import "XYZDropTarget.h"

@implementation XYZDropTarget
@synthesize contains;
@synthesize correct;
@synthesize expected;

-(void)dropNotification:(NSNotification *)sender{
    //NSLog(pathname);
    //[self setImage:([UIImage imageNamed:@"b0.jpg"])];
    int checkID = [[[sender userInfo] valueForKey:@"target"] intValue];
    
    if (checkID == self.tag) {
        int check = [[[sender userInfo] valueForKey:@"object"] intValue];
        self.contains=check;
    }
    
    
}

-(void)emptyAll:(NSNotification *)sender{
    int checkID = [[[sender userInfo] valueForKey:@"target"] intValue];
    int checkTag = [[[sender userInfo] valueForKey:@"object"] intValue];
    if (contains == checkTag) {
        if (checkID!=self.tag) {
            self.contains=-1;
        }
    }
}

-(void)empty:(NSNotification *)sender{
    int checkID = [[[sender userInfo] valueForKey:@"target"] intValue];
    if (checkID==self.tag) {
        self.contains=-1;
    }
}

-(Boolean)isCorrect
{
    
    self.correct=(self.contains==self.expected);
        
    
    return self.correct;
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
												 selector:@selector(emptyAll:)
													 name: @"emptyAll"
												   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(empty:)
													 name: @"empty"
												   object:nil];
        self.contains=-1;
        self.correct=false;
    }
    return self;
}


-(NSInteger)getContains
{
    return self.contains;
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
