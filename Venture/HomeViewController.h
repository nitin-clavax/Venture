//
//  HomeViewController.h
//  Venture
//
//  Created by Deepak Tomar on 08/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UIActionSheetDelegate>


@property (nonatomic, weak) UIViewController *currentViewController;
@property (strong, nonatomic) IBOutlet UIView *container;

@property (strong, nonatomic) IBOutlet UILabel *chatCountLbl;



- (IBAction)chatBtnTapped:(id)sender;
- (IBAction)exploreBtnTapped:(id)sender;
- (IBAction)projectsBtnTapped:(id)sender;
- (IBAction)contactsBtnTapped:(id)sender;
@end
