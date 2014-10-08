//
//  VerificationViewController.h
//  Venture
//
//  Created by Deepak Tomar on 05/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"

@interface VerificationViewController : UIViewController<UIActionSheetDelegate>


@property (nonatomic, strong) NSString *completePhoneNumber;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)nextBtnTapped:(id)sender;
- (IBAction)ResendBtnTapped:(id)sender;
- (IBAction)cancelBtnTapped:(id)sender;
@end
