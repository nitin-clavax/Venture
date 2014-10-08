//
//  MyProfileViewController.m
//  Venture
//
//  Created by Deepak Tomar on 06/10/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "MyProfileViewController.h"

@interface MyProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;

@end

@implementation MyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _userImageView.layer.borderWidth = 1.0f;
    _userImageView.layer.cornerRadius = _userImageView.frame.size.height/2;
    _userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
//    CALayer *customDrawn = [CALayer layer];
//    customDrawn.delegate = self;
//    customDrawn.backgroundColor = [UIColor greenColor].CGColor;
//    customDrawn.frame = CGRectMake(30, 250, 128, 40);
//    customDrawn.shadowOffset = CGSizeMake(0, 3);
//    customDrawn.shadowRadius = 5.0;
//    customDrawn.shadowColor = [UIColor blueColor].CGColor;
//    customDrawn.shadowOpacity = 0.8;
//    customDrawn.cornerRadius = 10.0;
//    customDrawn.borderColor = [UIColor blueColor].CGColor;
//    customDrawn.borderWidth = 2.0;
//    customDrawn.masksToBounds = YES;
//    
////    [self.userImageView.layer addSublayer:customDrawn];
//[_userImageView.layer insertSublayer:customDrawn atIndex:0];

    _userImageView.layer.masksToBounds = NO;
    _userImageView.clipsToBounds = YES;
    
    _uploadBtn.layer.cornerRadius = 3.0;
    
    
    self.title = @"My Profile";
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
    
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnTapped:)];
    [buttons addObject:addButtonItem];
    
    
    self.navigationItem.rightBarButtonItems = buttons;

    
    
}

-(void) saveBtnTapped : (id)sender
{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
