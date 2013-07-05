//
//  XYZViewController.h
//  DragAndDrop
//
//  Created by Eric Gu on 5/28/13.
//  Copyright (c) 2013 Eric Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYZViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *titleDisplay;
@property (weak, nonatomic) IBOutlet UITextView *difficulty;
- (IBAction)hint:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *score;
@property (weak, nonatomic) IBOutlet UITextView *pageDisplay;
- (IBAction)prevPage:(id)sender;
- (IBAction)nextPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *pageBackground;
- (IBAction)myButton:(UIButton *)sender;
@property (nonatomic, strong) UIImageView *dragObject;
@property (nonatomic, assign) CGPoint touchOffset;
@property (weak, nonatomic) IBOutlet UITextView *myView;

@end
