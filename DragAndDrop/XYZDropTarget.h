//
//  XYZDropTarget.h
//  DragAndDrop
//
//  Created by Eric Gu on 6/10/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZDropTarget : UIImageView

-(NSInteger) getContains;
-(void) setExpected:(NSInteger)idnum;
-(Boolean) isCorrect;

@end
