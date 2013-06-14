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

@synthesize touchOffset;
@synthesize homePosition;
CGPoint _priorPoint;
NSMutableArray *homeList;
NSMutableArray *dragList;
NSInteger dropTargets = 0;
NSInteger dragObjects = 0;
NSMutableArray *currentCorrect;


-(void)touchMe:(UITapGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    NSInteger tagInt= view.tag;
    
    NSValue *homePoint = [homeList objectAtIndex:tagInt];
    CGPoint p = [homePoint CGPointValue];
    view.frame = CGRectMake(p.x, p.y,
                            view.frame.size.width,
                            view.frame.size.height);
    
}

-(void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"SETUP");
        UIView *view = recognizer.view;
        CGPoint point = [recognizer locationInView:view.superview];
        _priorPoint=point;
        //_homePoint =  CGPointMake(view.frame.origin.x, view.frame.origin.y);

        //if needed do some initial setup or init of views here
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"PROCESS");
        //move your views here.
        //[yourView setFrame:];
        UIView *view = recognizer.view;
        CGPoint point = [recognizer locationInView:view.superview];
        CGPoint center = view.center;
        center.x += point.x - _priorPoint.x;
        center.y += point.y - _priorPoint.y;
        view.center = center;
    
    _priorPoint = point;
    

    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        UIView *view = recognizer.view;
        CGPoint point = [recognizer locationInView:view.superview];
        int dropID = -1;
        Boolean wasDropped = false;
        for (int i =0; i < dropTargets; i++) {
            dropID=10+i;
            XYZDropTarget *drop = (XYZDropTarget *)[view.superview viewWithTag:dropID];
            NSInteger containID = [drop getContains];
            if (point.x > drop.frame.origin.x &&
                point.x < drop.frame.origin.x + drop.frame.size.width &&
                point.y > drop.frame.origin.y &&
                point.y < drop.frame.origin.y + drop.frame.size.height && containID == -1 && ![drop isCorrect])
            {
                NSDictionary* idDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:view.tag], @"object", [NSNumber numberWithInt: dropID], @"target", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName: @"dropped" object: nil userInfo:idDict];
                
                view.frame = CGRectMake(drop.frame.origin.x, drop.frame.origin.y,
                                       view.frame.size.width,
                                        view.frame.size.height);
                wasDropped = true;
                break;
            }
        }
        NSDictionary* dropDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:view.tag], @"object", [NSNumber numberWithInt: dropID], @"target", nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"emptyAll" object: nil userInfo:dropDict];
        NSLog(@"Looking at dragObj: %d onto target: %d", view.tag, dropID);
        if (!wasDropped) {
            NSInteger tagInt= view.tag;
            NSValue *homePoint = [homeList objectAtIndex:tagInt];
            CGPoint p = [homePoint CGPointValue];
            view.frame = CGRectMake(p.x, p.y,
                                view.frame.size.width,
                                view.frame.size.height);
            [[NSNotificationCenter defaultCenter] postNotificationName: @"empty" object: nil userInfo:dropDict];
        }
        

        
        
        NSLog(@"CLEANUP");
        //else do cleanup
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    dropTargets = 2;
    dragObjects = 4;
    homeList = [[NSMutableArray alloc] init];
    /*
     Create the drop targets
     */
    currentCorrect = [[NSMutableArray alloc] init];
    for (int i = 0;i<dropTargets;i++){
        
        XYZDropTarget *DT = [[XYZDropTarget alloc] initWithFrame:CGRectMake(151, 98+i*140, 188, 41)];
        [DT setExpected:i+1];
        [self.view addSubview:DT];
        
        DT.tag=10+i;
        DT.backgroundColor = [UIColor greenColor];
        [currentCorrect insertObject:[NSNumber numberWithInt:0] atIndex:i];
    }
    
    
    dragList = [[NSMutableArray alloc] init];
    for (int i=0; i<dragObjects; i++) {
        
        // creates the boxes
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(780, 150+i*60, 188, 41)];
        [dragList insertObject: dragObject atIndex:i];
        
        [homeList insertObject:[NSValue valueWithCGPoint:CGPointMake(780,150+i*60) ] atIndex:i];
        if (i==0) {
            [dragObject setImage:([UIImage imageNamed:@"b0.jpg"])];
        } else if (i==1) {
            [dragObject setImage:([UIImage imageNamed:@"b1.jpg"])];
        } else if (i==2) {
            [dragObject setImage:([UIImage imageNamed:@"b2.jpg"])];
        } else {
            [dragObject setImage:([UIImage imageNamed:@"b3.jpg"])];
        }
        
        //UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMe:)];
        //tapped.numberOfTapsRequired = 1;
        //[dragObject addGestureRecognizer:tapped];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.01;
        //[longPress requireGestureRecognizerToFail:tapped];
        [dragObject addGestureRecognizer:longPress];
        dragObject.tag=i;
        dragObject.userInteractionEnabled=YES;
        [self.view addSubview:dragObject];
    }
    
    _myView.userInteractionEnabled = 0;
    
    NSString *storyText = @"To                   the crime, Heracles was required to carry out ten labors set by his archenemy. If    he                  , he would be purified of his sin and, as myth says, he would be granted immortality.";
    _myView.text=storyText;
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)myButton:(UIButton *)sender {
    
    UIAlertView *alertwrong = [[UIAlertView alloc] initWithTitle:@"check"
                                                         message:@"Wrong answer! Try again!"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    UIAlertView *alertprogress = [[UIAlertView alloc] initWithTitle:@"Keep trying!"
                                                            message:@"You got some correct!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    UIAlertView *alertright = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                         message:@"That's the correct answer!"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    

    NSString *storyText = @"To                   the crime, Heracles was required to carry out ten labors set by his archenemy. If    he                  , he would be purified of his sin and, as myth says, he would be granted immortality.";
    
    
    int oldCount =0;
    for (int i = 0; i < dropTargets; i++){
        if ([[currentCorrect objectAtIndex:i]intValue] == 1) {
            oldCount++;
        }
    }
    
    if (oldCount != dropTargets) {
        for (int i =0; i < dropTargets; i++) {
            XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
            
            if (![drop isCorrect]) {
                //[alertwrong show];
            } else {
                if ([[currentCorrect objectAtIndex:i]intValue] != 1) {
                    [currentCorrect insertObject:[NSNumber numberWithInt:1] atIndex:i];
                }
                
            }
        }
        
        int countCorrect =0;
        for (int i = 0; i < dropTargets; i++){
            if ([[currentCorrect objectAtIndex:i]intValue] == 1) {
                countCorrect++;
            }
        }
        if (countCorrect == dropTargets) {
            [alertright show];
            storyText = @"To expiate the crime, Heracles was required to carry out ten labors set by his archenemy. If he succeeded, he would be purified of his sin and, as myth says, he would be granted immortality.";
            _myView.text=storyText;
        } else if (countCorrect > 0 && countCorrect-oldCount!=0) {
            XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10];
            if ([[currentCorrect objectAtIndex:1]intValue] == 1) {
                storyText = @"To                   the crime, Heracles was required to carry out ten labors set by his archenemy. If he succeeded, he would be purified of his sin and, as myth says, he would be granted immortality.";
            } else {
                storyText = @"To expiate the crime, Heracles was required to carry out ten labors set by his archenemy. If    he                  , he would be purified of his sin and, as myth says, he would be granted immortality.";
            }
            _myView.text=storyText;
            [alertprogress show];
        } else {
            [alertwrong show];
        }
        
        
        for (int i =0; i < dropTargets; i++) {
            int dropID = 10+i;
            XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:dropID];
            NSLog(@"contains: %d", drop.contains);
            if ([drop isCorrect]) {
                drop.backgroundColor = [UIColor clearColor];
                int correctIndex = [drop getContains];
                
                UIImageView *drag = [dragList objectAtIndex:correctIndex];
                
                [drag setImage:([UIImage imageNamed:@"blank.png"])];
                [drag setUserInteractionEnabled:false];
            } else {
                NSDictionary* dropDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:dropID] forKey: @"target"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName: @"empty" object: nil userInfo:dropDict];
            }
            
            
        }
        for (int i =0; i < dragObjects; i++) {
            UIImageView *drag = [dragList objectAtIndex:i];
            
            NSInteger tagInt= drag.tag;
            NSValue *homePoint = [homeList objectAtIndex:tagInt];
            CGPoint p = [homePoint CGPointValue];
            drag.frame = CGRectMake(p.x, p.y,
                                    drag.frame.size.width,
                                    drag.frame.size.height);
            
        }
    }
    
    
    
    
}
@end
