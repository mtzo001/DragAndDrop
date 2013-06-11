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
        
        for (int i =0; i < dropTargets; i++) {
            XYZDropTarget *drop = (XYZDropTarget *)[view.superview viewWithTag:10+i];
            NSInteger containID = [drop getContains];
            if (point.x > drop.frame.origin.x &&
                point.x < drop.frame.origin.x + drop.frame.size.width &&
                point.y > drop.frame.origin.y &&
                point.y < drop.frame.origin.y + drop.frame.size.height && containID == -1 && ![drop isCorrect])
            {
                NSDictionary* idDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:view.tag] forKey:@"pass"];
                [[NSNotificationCenter defaultCenter] postNotificationName: @"dropped" object: nil userInfo:idDict];
                
                //view.alpha = 0.0;
                //view.userInteractionEnabled=FALSE;
                view.frame = CGRectMake(drop.frame.origin.x, drop.frame.origin.y,
                                       view.frame.size.width,
                                       view.frame.size.height);
            } else {
                if (containID ==view.tag)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"empty"
                                                                        object: nil];
                }
                UIView *view = recognizer.view;
                NSInteger tagInt= view.tag;
                NSValue *homePoint = [homeList objectAtIndex:tagInt];
                CGPoint p = [homePoint CGPointValue];
                view.frame = CGRectMake(p.x, p.y,
                                        view.frame.size.width,
                                        view.frame.size.height);
            }
        }
        
        
        NSLog(@"CLEANUP");
        //else do cleanup
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
    dropTargets = 1;
    dragObjects = 4;
    homeList = [[NSMutableArray alloc] init];
    for (int i = 0;i<dropTargets;i++){
        
        XYZDropTarget *DT = [[XYZDropTarget alloc] initWithFrame:CGRectMake(312, 257+i*200, 188, 41)];
        [DT setExpected:1];
        [self.view addSubview:DT];
        
        DT.tag=10+i;
        DT.backgroundColor = [UIColor greenColor];
    }
    //[DT setPath:(@"Done!")];
    
    
    dragList = [[NSMutableArray alloc] init];
    for (int i=0; i<dragObjects; i++) {
        
        // creates the boxes
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(100+i*200, 100, 188, 41)];
        [dragList insertObject: dragObject atIndex:i];
        
        [homeList insertObject:[NSValue valueWithCGPoint:CGPointMake(100+i*200,100) ] atIndex:i];
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
    
    
    for (int i =0; i < dropTargets; i++) {
        XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
        if ([drop isCorrect]) {
            drop.backgroundColor = [UIColor clearColor];
            int correctIndex = [drop getContains];
            UIImageView *drag = [dragList objectAtIndex:correctIndex];//(UIImageView *)[self.view viewWithTag:i];
            [drag setImage:([UIImage imageNamed:@"blank.png"])];
            [drag setUserInteractionEnabled:false];
        }
    }
    /*
    for (int i =0; i < dragObjects; i++) {
        UIImageView *drag = (UIImageView *)[self.view viewWithTag:i];
        NSValue *homePoint = [homeList objectAtIndex:i];
        CGPoint p = [homePoint CGPointValue];
        drag.frame = CGRectMake(p.x, p.y, drag.frame.size.width, drag.frame.size.height);

    }*/
    for (int i =0; i < dropTargets; i++) {
        XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
        if (![drop isCorrect]) {
            UIAlertView *alertwrong = [[UIAlertView alloc] initWithTitle:@"check"
                                                                 message:@"Wrong answer! Try again!"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertwrong show];
            break;
        }
        if (i==dropTargets-1) {
            UIAlertView *alertright = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                                 message:@"That's the correct answer!"
                                                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertright show];
            NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
            _myView.text=storyText;

        }
    }
    
    for (int i =0; i < dragObjects; i++) {
        UIImageView *drag = [dragList objectAtIndex:i];//(UIImageView *)[self.view viewWithTag:i];
        
        NSInteger tagInt= drag.tag;
        NSValue *homePoint = [homeList objectAtIndex:tagInt];
        CGPoint p = [homePoint CGPointValue];
        drag.frame = CGRectMake(p.x, p.y,
                                drag.frame.size.width,
                                drag.frame.size.height);

    }
    
}
- (IBAction)resetButton:(UIButton *)sender {
    UIAlertView *alertright = [[UIAlertView alloc] initWithTitle:@"OI"
                                                         message:@"This button is deprecated!"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertright show];
    NSDictionary* incorrect = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"pass"];
    NSString *storyText = @"Lorem ipsum dolor sit amet, consectetur                  elit. Suspendisse at nibh odio. Praesent dictum accumsan dui at lobortis. Nam eget nibh eget arcu elementum vulputate ut a dui.";
    _myView.text=storyText;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"check" object: nil userInfo:incorrect];
    for (int i =0; i < dragObjects; i++) {
        UIImageView *dragObject = (UIImageView *)[self.view viewWithTag:i];
            dragObject.alpha = 1.0;
            //view.userInteractionEnabled=FALSE;
    }

    
}
@end
