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
@synthesize dropTargetImage;
NSInteger flag = 0;
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
        if (self.dragObject.tag==0) {
            [dropTargetImage setImage:([UIImage imageNamed:@"Button1.jpg"])];
            flag=0;
        } else if (self.dragObject.tag==1) {
            [dropTargetImage setImage:([UIImage imageNamed:@"Buttonright.jpg"])];
            flag=1;
        } else if (self.dragObject.tag==2) {
          [dropTargetImage setImage:([UIImage imageNamed:@"Button2.jpg"])];
            flag=0;
        } else if (self.dragObject.tag==3) {
          [dropTargetImage setImage:([UIImage imageNamed:@"Button3.jpg"])];
            flag=0;
        }
    }
    self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                       self.dragObject.frame.size.width,
                                       self.dragObject.frame.size.height);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [dropTarget setBackgroundColor: [UIColor whiteColor]];
    [dropTargetImage setBackgroundColor: [UIColor cyanColor]];
    
    for (int i=0; i<4; i++) {
        
        
        // creates the boxes
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(100+i*200, 100, 188, 41)];
        if (i==0) {
            [dragObject setImage:([UIImage imageNamed:@"Button1.jpg"])];
        } else if (i==1) {
            [dragObject setImage:([UIImage imageNamed:@"Buttonright.jpg"])];
        } else if (i==2) {
            [dragObject setImage:([UIImage imageNamed:@"Button2.jpg"])];
        } else {
            [dragObject setImage:([UIImage imageNamed:@"Button3.jpg"])];
        }
        dragObject.tag=i;
        [[self view] addSubview:dragObject];
    }
    
    _myView.userInteractionEnabled = 0;
    
    NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur                  elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
    _myView.text=storyText;
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



- (IBAction)myButton:(UIButton *)sender {
    if (flag==1) {
        
        UIAlertView *alertright = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                             message:@"That's the correct answer!"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertright show];
        NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
        _myView.text=storyText;
        [dropTargetImage setUserInteractionEnabled:FALSE];
        [dropTargetImage setAlpha:(0.0)];
        [dropTarget setAlpha:(0.0)];
    }else if (flag==0) {
        
        UIAlertView *alertwrong = [[UIAlertView alloc] initWithTitle:@"Incorrect"
                                                             message:@"Wrong answer! Try again!"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertwrong show];
        [dropTargetImage setBackgroundColor: [UIColor cyanColor]];
        
    }
    
}
- (IBAction)resetButton:(UIButton *)sender {
    
    [dropTarget setBackgroundColor: [UIColor whiteColor]];
    [dropTargetImage setBackgroundColor: [UIColor cyanColor]];
    [dropTargetImage setAlpha:(100.100)];
    [dropTarget setAlpha:(100.100)];
    [dropTargetImage setImage:nil];
    
}
@end
