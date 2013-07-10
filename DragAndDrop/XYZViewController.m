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
NSInteger textViewOffsetY = 3;
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
    NSString *fileTitle = @"Heracles";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileTitle
                                                         ofType:@"txt"];
    NSString *fileString = [NSString stringWithContentsOfFile:filePath];
    NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
    pageList = [[NSMutableArray alloc] init];
    totalPages = lines.count;
    for (int i = 0; i < totalPages; i++) {
        NSString *line = [lines objectAtIndex:i];
        line = [line stringByAppendingString:@" "];
        [pageList insertObject:line atIndex:i];
    }
    pageNumber = 0;
    _titleDisplay.text=fileTitle;
    
    
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
        
        XYZDropTarget *DT = [[XYZDropTarget alloc] initWithFrame:CGRectMake(result.origin.x+_myView.frame.origin.x+textViewOffsetX, result.origin.y+_myView.frame.origin.y+textViewOffsetY, 240, 46)];
        [DT setExpected:i*4];
        [self.view addSubview:DT];
        DT.tag=10+i;
        DT.backgroundColor = [UIColor greenColor];
        [currentCorrect insertObject:[NSNumber numberWithInt:0] atIndex:i];
        
    }
    
    dragList = [[NSMutableArray alloc] init];
    
    homeList = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<dragObjects; i++) {
        UIImage *dragImage = [self burnTextIntoImage:[wordList objectAtIndex:i]];
        // creates the boxes
        UIImageView *dragObject = [[UIImageView alloc] initWithFrame:CGRectMake(750, 100+i*56, 240, 46)];
        [dragList insertObject: dragObject atIndex:i];
        
        [homeList insertObject:[NSValue valueWithCGPoint:CGPointMake(750,100+i*56) ] atIndex:i];
        [dragObject setImage:dragImage];
                
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
    }
}

- (IBAction)myButton:(UIButton *)sender {
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
        for (int i =0; i < dropTargets; i++) {
            XYZDropTarget *drop = (XYZDropTarget *)[self.view viewWithTag:10+i];
            if (![drop isCorrect]) {
                if ([drop contains] != -1) {
                    NSLog(@"Minus points!");
                }
                //[alertwrong show];
            } else {
                if ([[currentCorrect objectAtIndex:i]intValue] != 1) {
                    NSLog(@"Points!");
                    [currentCorrect replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
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
        int count4 = 0;
        
        for (int i = 0; i<storyText.length; i++) {
            ch = [storyText characterAtIndex:i];
            chara = [NSString stringWithCharacters:&ch length:1];
            if (ch == '#') {
                ch = [storyText characterAtIndex:i+1];
                if (ch == '#') {
                    //if((([[currentCorrect objectAtIndex:0]intValue] == 1)&&(count==0)) ||
                    //(([[currentCorrect objectAtIndex:1]intValue] == 1)&&(count==1))){
                    if([[currentCorrect objectAtIndex:count]intValue] == 1){
                        //get rid of '##' and the later one
                        //BROKEN AGAIN ^^^^
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
                    count4=0;
                    for (int k = 0; k < currentCorrect.count; k++) {
                        if ([[currentCorrect objectAtIndex:k] intValue] ==1) {
                            count4++;
                        }
                    }
                    
                    if(count4==2){
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
                    }else if(([[currentCorrect objectAtIndex:count2]intValue] == 1)&&(count2==1)){
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
                    count2=1;
                } else {
                    tempText = [tempText stringByAppendingString:chara];
                }
                 
            } else {
                tempText = [tempText stringByAppendingString:chara];
            }
        }
        [pageList replaceObjectAtIndex:pageNumber withObject:tempText];
        tempText = [tempText stringByAppendingString:@" "];
        storyText=tempText;
        
        
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

/* Creates an image with a home-grown graphics context, burns the supplied string into it. */
- (UIImage *)burnTextIntoImage:(NSString *)text{
    UIImage *img = [UIImage imageNamed:@"dragObj.png"];
    UIGraphicsBeginImageContext(img.size);
    
    [[UIColor blackColor] set];           // set text color
    NSInteger fontSize = 40;
    
    CGSize lineSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    while (lineSize.width>img.size.width){
        fontSize-=2;
        lineSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize]];
    }
    
    
    UIFont *font = [UIFont systemFontOfSize: fontSize];     // set text font
    
    CGFloat fontHeight = font.pointSize;
    CGFloat yOffset = (img.size.height - fontHeight) / 2.0;
    
    
    CGRect aRectangle = CGRectMake(0,-yOffset, img.size.width, img.size.height+yOffset * 2);
    [img drawInRect:aRectangle];
    
    [ text drawInRect : aRectangle                      // render the text
             withFont : font
        lineBreakMode : NSLineBreakByTruncatingTail  // clip overflow from end of last line
            alignment : NSTextAlignmentCenter ];
    
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();   // extract the image
    UIGraphicsEndImageContext();     // clean  up the context.
    return theImage;
}
@end


