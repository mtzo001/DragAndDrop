//
//  XYZViewController.h
//  DragAndDrop
//
//  Created by Eric Gu on 5/28/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *dropTargetImage;
- (IBAction)myButton:(UIButton *)sender;
@property (nonatomic, strong) IBOutlet UIView *dropTarget;
@property (nonatomic, strong) UIImageView *dragObject;
@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;
@property (weak, nonatomic) IBOutlet UITextView *myView;
@property (weak,nonatomic) IBOutlet UIImageView *dropTargetImage1;
- (IBAction)resetButton:(UIButton *)sender;

@end
