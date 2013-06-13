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
NSInteger currentCorrect = 0;


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
  
    currentCorrect = 0;
    dropTargets = 2;
    dragObjects = 4;
    homeList = [[NSMutableArray alloc] init];
    /*
     Create the drop targets
     */
    for (int i = 0;i<dropTargets;i++){
        
        XYZDropTarget *DT = [[XYZDropTarget alloc] initWithFrame:CGRectMake(312, 147+i*200, 188, 41)];
        [DT setExpected:i+1];
        [self.view addSubview:DT];
        
        DT.tag=10+i;
        DT.backgroundColor = [UIColor greenColor];
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
    
    NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur                   elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum                   ut a dui.";
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
    
    int correctCount = 0;
    NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur                   elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum                   ut a dui.";
    for (int i =0; i < dropTargets; i++) {
        XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
                
        if (![drop isCorrect]) {
            //[alertwrong show];
        } else {
            correctCount++;
        }
    }
    
    //TODO currentCorrect
    
    if (correctCount == dropTargets) {
        [alertright show];
        storyText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
    } else if (correctCount != 0) {
        XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10];
        if (![drop isCorrect]) {
            storyText = @"Lorem ipsum dolor sit amet, consectetur                   elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
        } else {
            storyText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum                   ut a dui.";
        }
        [alertprogress show];
    } else {
        [alertwrong show];
    }
    _myView.text=storyText;
    
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
@end
