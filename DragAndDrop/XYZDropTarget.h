//
//  XYZDropTarget.h
//  DragAndDrop
//
//  Created by Eric Gu on 6/10/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZDropTarget : UIImageView

@property NSInteger contains;
@property Boolean correct;
@property NSInteger expected;

-(NSInteger) getContains;
-(void) setExpected:(NSInteger)idnum;
-(Boolean) isCorrect;

@end
