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
CGPoint _priorPoint;
NSMutableArray *homeList;
NSMutableArray *dragList;
NSInteger dropTargets = 0;
NSInteger dragObjects = 0;
NSInteger textViewOffsetX = 0;
NSInteger textViewOffsetY = 4;
NSMutableArray *currentCorrect;
NSMutableArray *pageList;
NSInteger pageNumber = 0;
NSString *unitString = @"!!FiLLSTRiN!!";
NSString *storyText = @"";
NSInteger currentScore = 0;
NSInteger totalPages = 0;
NSInteger totalCorrect = 0;


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
        UIView *view = recognizer.view;
        CGPoint point = [recognizer locationInView:view.superview];
        _priorPoint=point;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
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
        
        if (!wasDropped) {
            NSInteger tagInt= view.tag;
            NSValue *homePoint = [homeList objectAtIndex:tagInt];
            CGPoint p = [homePoint CGPointValue];
            view.frame = CGRectMake(p.x, p.y,
                                view.frame.size.width,
                                view.frame.size.height);
            [[NSNotificationCenter defaultCenter] postNotificationName: @"empty" object: nil userInfo:dropDict];
        }
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageList = [[NSMutableArray alloc] init];
    storyText = @"To ##expiate## the crime, Heracles was required to carry out ten labors set by his archenemy. If he ##succeeded##, he would be purified of his sin and, as myth says, he would be granted immortality. @@expiate@@ @@expate@@ @@commit@@ @@expatriat@@ @@succeeded@@ @@suceeded@@ @@succeedded@@ @@failed@@ ";
    
    [pageList insertObject:storyText atIndex:0];
    
    storyText = @"Heracles ##accomplished## these tasks, but Eurystheus did not ##accept## the cleansing of the Augean stables because Heracles was going to accept pay for the labor. @@accomplished@@ @@acomplished@@ @@passed@@ @@complete@@ @@accept@@ @@except@@ @@okay@@ @@see@@ ";
    
    [pageList insertObject:storyText atIndex:1];
    
    storyText = @"##Neither## did he accept the killing of the Lernaean Hydra as Heracles' nephew, Iolaus, had helped him burn the stumps of the heads. Eurysteus set two more tasks, which Heracles performed successfully, bringing the total number of tasks up to ##twelve##. @@Neither@@ @@Nor@@ @@Never@@ @@Nevertheless@@ @@twelve@@ @@two@@ @@ten@@ @@fourteen@@ ";
    
    [pageList insertObject:storyText atIndex:2];
    _titleDisplay.text=@"Heracles encyclopedia entry";
    pageNumber = 0;
    totalPages = 3;
    
    [self loadPage:[pageList objectAtIndex:pageNumber]];
    
    
    _myView.userInteractionEnabled = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)loadPage:(NSString *)inputText {
    
    NSMutableArray *rectList = [[NSMutableArray alloc]init];
    NSMutableArray *wordList = [[NSMutableArray alloc]init];
    
    currentCorrect = [[NSMutableArray alloc] init];
    NSString *storyText = @"";
    NSString *chara;
    NSString *word = @"";
    unichar ch;
    int flag = 0;
    int count = 0;
    
    for (int i = 0; i<inputText.length; i++) {
        ch = [inputText characterAtIndex:i];
        chara = [NSString stringWithCharacters:&ch length:1];
        
        if (ch == '#') {
            ch = [inputText characterAtIndex:i+1];
            if (ch == '#') {
                chara = unitString;
                i+=2;
                ch = [inputText characterAtIndex:i];
                while (ch != '#') {
                    i++;
                    ch = [inputText characterAtIndex:i];
                }
                i++;
            }
        } else if(ch == '@') {
            ch = [inputText characterAtIndex:i+1];
            if (ch == '@') {
                if (flag==0) {
                    flag=1;
                }
                i+=2;
                ch = [inputText characterAtIndex:i];
                while (ch != '@') {
                    chara=[NSString stringWithCharacters:&ch length:1];
                    word=[word stringByAppendingString:chara];
                    i++;
                    ch = [inputText characterAtIndex:i];
                }
                [wordList insertObject:word atIndex:count];
                word=@"";
                count++;
                i++;
            }
        }
        if (flag==0){
            storyText = [storyText stringByAppendingString:chara];
        }
    }
    dropTargets=count/4;
    dragObjects=count;
    _myView.text=storyText;
    //Now process storytext to get positions to put into reclist
    count=0;
    for (int i = 0; i<storyText.length; i++) {
        ch = [storyText characterAtIndex:i];
        
        if (ch == '!') {
            ch = [storyText characterAtIndex:i+1];
            if (ch == '!') {
                UITextPosition *Pos2 = [_myView positionFromPosition: _myView.beginningOfDocument offset: i];
                UITextPosition *Pos1 = [_myView positionFromPosition: _myView.endOfDocument offset: nil];
                CGRect res = [_myView firstRectForRange:(UITextRange *)[_myView textRangeFromPosition:Pos1 toPosition:Pos2] ];
                [rectList insertObject:[NSValue valueWithCGRect:res] atIndex:count];
                count++;
                i+=2;
                ch = [storyText characterAtIndex:i];
                while (ch != '!') {
                    i++;
                    ch = [storyText characterAtIndex:i];
                }
                //?
                i++;
            }
        }
    }

        
    /*
    NSRange textRange = [storyText rangeOfString:unitString];
    NSString *substring = [storyText substringToIndex:textRange.location];
    NSUInteger charCount = substring.length;
    
    UITextPosition *Pos2 = [_myView positionFromPosition: _myView.beginningOfDocument offset: charCount];
    UITextPosition *Pos1 = [_myView positionFromPosition: _myView.endOfDocument offset: nil];
    
    UITextRange *range = [_myView textRangeFromPosition:Pos1 toPosition:Pos2];
    CGRect result = [_myView firstRectForRange:(UITextRange *)range ];
    */
    
    
    /*
     CGSize stringSize = [unitString sizeWithFont:_myView.font forWidth:600 lineBreakMode:NSLineBreakByCharWrapping];
     CGFloat width = stringSize.width;
     NSString *sWd = [NSString stringWithFormat: @"%.2f", width];
     NSLog(sWd);
     */
    
    for (int i = 0;i<dropTargets;i++){
        CGRect result = [[rectList objectAtIndex:i]CGRectValue];
        
        XYZDropTarget *DT = [[XYZDropTarget alloc] initWithFrame:CGRectMake(result.origin.x+_myView.frame.origin.x+textViewOffsetX, result.origin.y+_myView.frame.origin.y+textViewOffsetY, 240, 44)];
        [DT setExpected:i*4];
        [self.view addSubview:DT];
        DT.tag=10+i;
        DT.backgroundColor = [UIColor greenColor];
        [currentCorrect insertObject:[NSNumber numberWithInt:0] atIndex:i];
        
    }
    
    dragList = [[NSMutableArray alloc] init];
    
    homeList = [[NSMutableArray alloc] init];
    for (int i=0; i<dragObjects; i++) {
        
        // creates the boxes
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(750, 100+i*54, 240, 44)];
        [dragList insertObject: dragObject atIndex:i];
        
        [homeList insertObject:[NSValue valueWithCGPoint:CGPointMake(750,100+i*54) ] atIndex:i];
        if ([[wordList objectAtIndex:i] isEqual: @"expiate"]) {
            [dragObject setImage:([UIImage imageNamed:@"b1.jpg"])];
        } else if (i==1) {
            [dragObject setImage:([UIImage imageNamed:@"b0.jpg"])];
        } else if (i==2) {
            [dragObject setImage:([UIImage imageNamed:@"b3.jpg"])];
        } else if (i==3) {
            [dragObject setImage:([UIImage imageNamed:@"b3.jpg"])];
        } else if ([[wordList objectAtIndex:i] isEqual: @"succeeded"]) {
            [dragObject setImage:([UIImage imageNamed:@"b2.jpg"])];
        } else if (i==5) {
            [dragObject setImage:([UIImage imageNamed:@"b0.jpg"])];
        } else if (i==6) {
            [dragObject setImage:([UIImage imageNamed:@"b3.jpg"])];
        } else if (i==7) {
            [dragObject setImage:([UIImage imageNamed:@"b3.jpg"])];
        } else if ([[wordList objectAtIndex:i] isEqual: @"accomplished"]) {
            [dragObject setImage:([UIImage imageNamed:@"b1.jpg"])];
        } else if ([[wordList objectAtIndex:i] isEqual: @"accept"]) {
            [dragObject setImage:([UIImage imageNamed:@"b2.jpg"])];
        } else if ([[wordList objectAtIndex:i] isEqual: @"Neither"]) {
            [dragObject setImage:([UIImage imageNamed:@"b1.jpg"])];
        } else if ([[wordList objectAtIndex:i] isEqual: @"twelve"]) {
            [dragObject setImage:([UIImage imageNamed:@"b2.jpg"])];
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cleanPage
{
    for (int i =0; i < dropTargets; i++) {
        int dropID = 10+i;
        XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:dropID];
        //NSLog(@"contains: %d", drop.contains);
        /*
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
         */
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [drop removeFromSuperview];
        [drop die];
        
    }
    for (int i =0; i < dragObjects; i++) {
        UIImageView *drag = [dragList objectAtIndex:i];
        /*
         NSInteger tagInt= drag.tag;
         NSValue *homePoint = [homeList objectAtIndex:tagInt];
         CGPoint p = [homePoint CGPointValue];
         drag.frame = CGRectMake(p.x, p.y,
         drag.frame.size.width,
         drag.frame.size.height);
         */
        [drag removeFromSuperview];
        /*
         while (drag.gestureRecognizers.count) {
         [drag removeGestureRecognizer:[drag.gestureRecognizers objectAtIndex:0]];
         }
         */
    }
}

- (IBAction)myButton:(UIButton *)sender {
    /*
    UIAlertView *alertwrong = [[UIAlertView alloc] initWithTitle:@"check"
                                                         message:@"Wrong answer! Try again!"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    UIAlertView *alertprogress = [[UIAlertView alloc] initWithTitle:@"Keep trying!"
                                                            message:@"You got some correct!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    */
    UIAlertView *alertfinish = [[UIAlertView alloc] initWithTitle:@"Congratulations"
                                                         message:@"You've finished the book! This is a placeholder! I'm not sure what should happen now!"
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
     
    NSString *storyText = [pageList objectAtIndex:pageNumber];
    
    int valid = 0;
    for (int i = 0; i < dropTargets; i++){
        XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
        int cont = drop.getContains;
        if (cont !=-1) {
            valid=1;
        }
    }
    
    if (valid==1) {
        NSLog(@"Points!");
        for (int i =0; i < dropTargets; i++) {
            XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
            
            if (![drop isCorrect]) {
                //[alertwrong show];
            } else {
                if ([[currentCorrect objectAtIndex:i]intValue] != 1) {
                    [currentCorrect insertObject:[NSNumber numberWithInt:1] atIndex:i];
                    totalCorrect++;
                    currentScore++;
                    NSString *point = [NSString stringWithFormat:@"Score: %d",currentScore];
                    _score.text=point;
                }
                
            }
        }
        
        
        NSString *tempText=@"";
        NSString *chara;
        unichar ch;
        int count = 0;
        int count2 = 0;
        int count3 = 0;
        
        for (int i = 0; i<storyText.length; i++) {
            ch = [storyText characterAtIndex:i];
            chara = [NSString stringWithCharacters:&ch length:1];
            if (ch == '#') {
                ch = [storyText characterAtIndex:i+1];
                if (ch == '#') {
                    
                    if((([[currentCorrect objectAtIndex:0]intValue] == 1)&&(count==0)) ||
                    (([[currentCorrect objectAtIndex:1]intValue] == 1)&&(count==1))){
                        //get rid of '##' and the later one
                        i+=2;
                        ch = [storyText characterAtIndex:i];
                        while (ch != '#') {
                            
                            chara = [NSString stringWithCharacters:&ch length:1];
                            tempText = [tempText stringByAppendingString:chara];
                            i++;
                            ch = [storyText characterAtIndex:i];
                        }
                        i++;
                        
                    } else {
                        tempText = [tempText stringByAppendingString:chara];
                        while (true) {
                            i++;
                            ch = [storyText characterAtIndex:i];
                            chara = [NSString stringWithCharacters:&ch length:1];
                            if (ch == '#') {
                                ch = [storyText characterAtIndex:i+1];
                                if (ch == '#') {
                                    tempText = [tempText stringByAppendingString:chara];
                                    i++;
                                    ch = [storyText characterAtIndex:i];
                                    chara = [NSString stringWithCharacters:&ch length:1];
                                    tempText = [tempText stringByAppendingString:chara];
                                    break;
                                } else {
                                    tempText = [tempText stringByAppendingString:chara];
                                }
                            } else {
                                tempText = [tempText stringByAppendingString:chara];
                            }
                            
                        }
                        
                    }
                    count++;
                } else {
                    tempText = [tempText stringByAppendingString:chara];
                }
            } else if(ch == '@') {
                ch = [storyText characterAtIndex:i+1];
                if (ch == '@') {
                    
                    if(([[currentCorrect objectAtIndex:0]intValue] == 1)&&([[currentCorrect objectAtIndex:1]intValue] == 1)){
                        break;
                        
                    } else if(([[currentCorrect objectAtIndex:0]intValue] == 1)&&(count2==0)) {
                        //get rid of 4 sets of words
                        
                        while (count2 <16) {
                            ch = [storyText characterAtIndex:i];
                            if (ch == '@') {
                                count2++;
                            }
                            i++;
                        }
                    }else if(([[currentCorrect objectAtIndex:1]intValue] == 1)&&(count2==1)){
                        break;
                        
                    } else {
                        //read in 4 sets of words
                        tempText = [tempText stringByAppendingString:chara];
                        count3=0;
                        while (count3<15) {
                            i++;
                            ch = [storyText characterAtIndex:i];
                            chara = [NSString stringWithCharacters:&ch length:1];
                            if (ch == '@') {
                                count3++;
                            }
                            tempText = [tempText stringByAppendingString:chara];
                        }
                    }
                    count2+=1;
                } else {
                    tempText = [tempText stringByAppendingString:chara];
                }
                 
            } else {
                tempText = [tempText stringByAppendingString:chara];
            }
        }
        
        [pageList replaceObjectAtIndex:pageNumber withObject:tempText];
        storyText=tempText;
        
        
        
        /*
        
        if (countCorrect == dropTargets) {
            [alertright show];
            storyText = @"To expiate the crime, Heracles was required to carry out ten labors set by his archenemy. If he succeeded, he would be purified of his sin and, as myth says, he would be granted immortality.";
            _myView.text=storyText;
        } else if (countCorrect > 0 && countCorrect-oldCount!=0) {
            XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10];
            if ([[currentCorrect objectAtIndex:1]intValue] == 1) {
                storyText = @"To !!FiLLSTRiN!! the crime, Heracles was required to carry out ten labors set by his archenemy. If he succeeded, he would be purified of his sin and, as myth says, he would be granted immortality.";
            } else {
                storyText = @"To expiate the crime, Heracles was required to carry out ten labors set by his archenemy. If he !!FiLLSTRiN!!, he would be purified of his sin and, as myth says, he would be granted immortality.";
            }
            _myView.text=storyText;
            [alertprogress show];
        } else {
            [alertwrong show];
        }
        */
        
        [self cleanPage];
        
        int countCorrect =0;
        for (int i = 0; i < dropTargets; i++){
            if ([[currentCorrect objectAtIndex:i]intValue] == 1) {
                countCorrect++;
            }
        }
        if ((countCorrect == dropTargets)&&(pageNumber+1<totalPages)) {
            sleep(2);
            pageNumber++;
            [self updatePage];
            [self loadPage:[pageList objectAtIndex:pageNumber]];
        } else {
            [self loadPage:storyText];
        }
        
    }
    if (totalCorrect == totalPages*2) {
        [alertfinish show];
    }


}
- (IBAction)prevPage:(id)sender {
    if (pageNumber > 0) {
        pageNumber--;
        [self cleanPage];
        [self loadPage:[pageList objectAtIndex:pageNumber]];
        [self updatePage];
    }
}

- (IBAction)nextPage:(id)sender {
    if (pageNumber < pageList.count-1) {
        pageNumber++;
        [self cleanPage];
        [self loadPage:[pageList objectAtIndex:pageNumber]];
        [self updatePage];
    }
    
}

- (void)updatePage {
    NSString *pageString = [NSString stringWithFormat:@"%d",pageNumber+1];
    _pageDisplay.text=pageString;
}
- (IBAction)hint:(id)sender {
    if (dropTargets !=0) {
        NSInteger r = arc4random()%10;
        NSInteger s = 10/dropTargets;
        NSInteger t;
        if (r<s) {
            t=0;
        } else {
            t=4;
        }
        for (int i =0; i < dragObjects; i++) {
            UIImageView *drag = [dragList objectAtIndex:i];
            
            if (drag.tag == t) {
                [drag setAlpha:(0.5)];
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(flash:) userInfo:nil repeats:NO];
                break;
            }
            
        }
    }
    

}

- (void)flash:(id)sender
{
    for (int i =0; i < dragObjects; i++) {
        UIImageView *drag = [dragList objectAtIndex:i];
        
        if (drag.alpha == 0.5) {
            [drag setAlpha:(1.0)];
            break;
        }
    }
}
@end
