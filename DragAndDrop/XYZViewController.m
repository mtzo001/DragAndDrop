//
//  XYZViewController.m
//  DragAndDrop
//
//  Created by Eric Gu on 5/28/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import "XYZViewController.h"

#import "XYZDropTarget.h"

@interface XYZViewController ()

@end

@implementation XYZViewController

@synthesize dropTarget;
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
        NSString *intStr = [NSString stringWithFormat: @"%d", self.dragObject.tag];
        if (self.dragObject.tag==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName: intStr
                                                                object: nil];
        } else if (self.dragObject.tag==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName: intStr
                                                                object: nil];
        } else if (self.dragObject.tag==2) {
            [[NSNotificationCenter defaultCenter] postNotificationName: intStr
                                                                object: nil];
        } else if (self.dragObject.tag==3) {
            [[NSNotificationCenter defaultCenter] postNotificationName: intStr
                                                                object: nil];
        }
    }
    
        
    self.dragObject.frame = CGRectMake(self.homePosition.x, self.homePosition.y,
                                       self.dragObject.frame.size.width,
                                       self.dragObject.frame.size.height);
}


-(void)setTrue:(NSNotification*)notification
{
    flag=1;
}

-(void)setFalse:(NSNotification*)notification
{
    flag=0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setFalse:)
                                                 name: @"flag0"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTrue:)
                                                 name: @"flag1"
                                               object:nil];
    
    
    for (int i = 0;i<2;i++){
        
        XYZDropTarget *DT = [[XYZDropTarget alloc] initWithFrame:CGRectMake(312, 257+i*200, 189, 41)];
        [self.view addSubview:DT];
        DT.tag=i;
        DT.backgroundColor = [UIColor greenColor];
    }
    //[DT setPath:(@"Done!")];
    
    
    for (int i=0; i<4; i++) {
        
        
        // creates the boxes
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(100+i*200, 100, 188, 41)];
        if (i==0) {
            [dragObject setImage:([UIImage imageNamed:@"b0.jpg"])];
        } else if (i==1) {
            [dragObject setImage:([UIImage imageNamed:@"b1.jpg"])];
        } else if (i==2) {
            [dragObject setImage:([UIImage imageNamed:@"b2.jpg"])];
        } else {
            [dragObject setImage:([UIImage imageNamed:@"b3.jpg"])];
        }
        dragObject.tag=i;
        [[self view] addSubview:dragObject];
    }
    
    _myView.userInteractionEnabled = 0;
    
    NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur                  elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
    _myView.text=storyText;
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)myButton:(UIButton *)sender {
    
    NSDictionary* correct = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"pass"];
    NSDictionary* incorrect = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"pass"];
    
    if (flag==1) {
        
        UIAlertView *alertright = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                             message:@"That's the correct answer!"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertright show];
        NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
        _myView.text=storyText;
        [dropTargetImage setUserInteractionEnabled:FALSE];
        [dropTarget setAlpha:(0.0)];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"check" object: nil userInfo:correct];
    }else if (flag==0) {
        
        UIAlertView *alertwrong = [[UIAlertView alloc] initWithTitle:@"check"
                                                             message:@"Wrong answer! Try again!"
                                                            delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertwrong show];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"check" object: nil userInfo:incorrect];
        
    }
    
}
- (IBAction)resetButton:(UIButton *)sender {
    NSDictionary* incorrect = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"pass"];
    NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur                  elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
    _myView.text=storyText;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"check" object: nil userInfo:incorrect];
    flag=0;
    
}
@end
