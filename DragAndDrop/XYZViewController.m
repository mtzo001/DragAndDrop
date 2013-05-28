//
//  XYZViewController.m
//  DragAndDrop
//
//  Created by Eric Gu on 5/28/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import "XYZViewController.h"

@interface XYZViewController ()

@end

@implementation XYZViewController

@synthesize dropTarget;
//@synthesize dragObject;
@synthesize touchOffset;
@synthesize homePosition;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        for (UIImageView *iView in self.view.subviews) {
            if ([iView isMemberOfClass:[UIImageView class]]) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    self.dragObject = iView;
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                   touchPoint.y - iView.frame.origin.y);
                    self.homePosition = CGPointMake(iView.frame.origin.x,
                                                    iView.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                }
            }
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                           touchPoint.y - touchOffset.y,
                                           self.dragObject.frame.size.width,
                                           self.dragObject.frame.size.height);
    self.dragObject.frame = newDragObjectFrame;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    if (touchPoint.x > self.dropTarget.frame.origin.x &&
        touchPoint.x < self.dropTarget.frame.origin.x + self.dropTarget.frame.size.width &&
        touchPoint.y > self.dropTarget.frame.origin.y &&
        touchPoint.y < self.dropTarget.frame.origin.y + self.dropTarget.frame.size.height )
    {
        if (self.dragObject.tag==1) {
            self.dropTarget.backgroundColor = self.dragObject.backgroundColor;
        }
    }
    self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                       self.dragObject.frame.size.width,
                                       self.dragObject.frame.size.height);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int i=0; i<4; i++) {
        
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(100+i*200, 100, 150, 75)];
        if (i==0) {
            [dragObject setBackgroundColor:[UIColor orangeColor]];
        } else if (i==1) {
            [dragObject setBackgroundColor:[UIColor blueColor]];
        } else if (i==2) {
            [dragObject setBackgroundColor:[UIColor redColor]];
        } else {
            [dragObject setBackgroundColor:[UIColor greenColor]];
        }
        dragObject.tag=i;
        [[self view] addSubview:dragObject];
    }
    
    
    /*
                         
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(475, 302, 200, 100);
    
    [button addTarget:self action:@selector(touched) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(longPress:) forControlEvents:UIControlEventTouchDragInside];
    [button setImage:[UIImage imageNamed:@"DragMeInstead!"] forState:UIControlStateNormal];
    [self.view addSubview:button];*/
	// Do any additional setup after loading the view, typically from a nib.
}
/*
- (void)touched
{
    self.view.backgroundColor = [UIColor redColor];
}

- (void)moved
{
    self.dropTarget.backgroundColor=[UIColor purpleColor];
}

- (IBAction)longPress:(UIGestureRecognizer *)sender
{
    self.view.backgroundColor = [UIColor greenColor];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
