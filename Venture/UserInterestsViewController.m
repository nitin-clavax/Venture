//
//  UserInterestsViewController.m
//  Venture
//
//  Created by Deepak Tomar on 27/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "UserInterestsViewController.h"
#import "HomeViewController.h"

@interface UserInterestsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *FirstInterestBGImageView;
@property (strong, nonatomic) IBOutlet UIImageView *secondBGImageView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdBGImageVIew;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (IBAction)skipBtnTapped:(id)sender;
@end

@implementation UserInterestsViewController
@synthesize firstTxtField,secoundTxtField,thirdTxtField;

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
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"background" withExtension:@"gif"];
    self.backgroundImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];

//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];

    
    
    // keyboard input Accessory View //
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    keyboardView.backgroundColor = [UIColor clearColor];
    
    UIButton *leftArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 1, 12, 21)];
    [leftArrowBtn setImage:[UIImage imageNamed:@"previous_icon.png"] forState:UIControlStateNormal];
    [leftArrowBtn addTarget:self action:@selector(previousBtnTapped) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rightArrowBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 1, 12, 21)];
    [rightArrowBtn setImage:[UIImage imageNamed:@"next_icon.png"] forState:UIControlStateNormal];
    [rightArrowBtn addTarget:self action:@selector(nextBtnTapped) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(255, 1, 53, 22)];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    doneBtn.titleLabel.textColor = [UIColor whiteColor];
    
    
    [keyboardView addSubview:leftArrowBtn];
    [keyboardView addSubview:rightArrowBtn];
    [keyboardView addSubview:doneBtn];

    
//    UIToolbar* keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    keyboardToolbar.tintColor = UIColorFromRGB(0x00b863);
//    keyboardToolbar.backgroundColor = [UIColor clearColor];
//    
//
//    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]
//                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                   target:nil
//                                   action:nil];
//    [fixedSpace setWidth:20];
//    keyboardToolbar.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Left_arrow.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(previousBtnTapped)],
//                             fixedSpace,
//                             [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Right_arrow.png"] style:UIBarButtonItemStylePlain target:nil action:@selector(nextBtnTapped)],
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnTapped)],
//                           nil];
//    [keyboardToolbar sizeToFit];

    firstTxtField.inputAccessoryView = keyboardView;
    secoundTxtField.inputAccessoryView = keyboardView;
    thirdTxtField.inputAccessoryView = keyboardView;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];


}


-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


-(void) previousBtnTapped
{

    if ([secoundTxtField isFirstResponder]) {
        [firstTxtField becomeFirstResponder];
    }
    else if([thirdTxtField isFirstResponder])
    {
        [secoundTxtField becomeFirstResponder];
        
    }
    


}
-(void) nextBtnTapped
{
    
    if ([firstTxtField isFirstResponder]) {
        [secoundTxtField becomeFirstResponder];
    }
    else if([secoundTxtField isFirstResponder])
    {
        [thirdTxtField becomeFirstResponder];
        
    }
    
}


-(void)doneBtnTapped
{
    [self.view endEditing:YES];
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self dismissViewControllerAnimated:YES completion:nil];

//    NSString *numberFromTheKeyboard = self.firstTxtField.text;
//    [firstTxtField resignFirstResponder];

    NSString *interest1Str = [firstTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *interest2Str = [secoundTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *interest3Str = [thirdTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSString *interests ;
    
    
    if([interest1Str length]==0 && [interest2Str length]==0  && [interest3Str length]==0){
        
        UINavigationController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationView"];
        [self presentViewController:rootView animated:NO completion:nil];
        
        return;
        
    }
    else
    {
        if ([interest1Str length]>0) {
            interests = [NSString stringWithFormat:@"%@,",interest1Str];
        }
        if ([interest2Str length] > 0)
        {
            interests = [interests stringByAppendingString:[NSString stringWithFormat:@"%@,",interest2Str]];
        }
        if ([interest3Str length] > 0)
        {
            interests = [interests stringByAppendingString:[NSString stringWithFormat:@"%@",interest3Str]];
        }
    }
    
    
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
    NSString *passwordToken = [appDefaults valueForKey:@"password_token"];
    NSString *user_name = [appDefaults valueForKey:@"userName"];

    NSURL *URL = [NSURL URLWithString:k_BASE_URL];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];

    NSDictionary *dict=@{
                         @"user_name":user_name,
                         @"password_token":passwordToken,
                         @"interests":interests,
                         @"type":@"add_update",
                         };
    NSLog(@" fetch event parameters ---> %@",dict);


    [manager POST:@"userinterest" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){

        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSLog(@"responseObject%@",responseObject);


        ///-----for key -> "errors" ---- ///
        if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){

            NSMutableString *strTemp=[NSMutableString string];

            for (NSString *key in [responseObject objectForKey:@"message"]) {

                if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {

                    for (NSString *descStr in [[responseObject objectForKey:@"message"] objectForKey:key]) {

                        [strTemp appendFormat:@"%@.\n",[[[responseObject objectForKey:@"message"] objectForKey:key] objectForKey:descStr]];
                    }
                }
                else if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSString class]])
                {
                    strTemp = [[responseObject objectForKey:@"message"] objectForKey:key];

                }


            }
            UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [errorAlert show];
            return;
        }


        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            UINavigationController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationView"];
            [self presentViewController:rootView animated:NO completion:nil];

        }

    }
          failure:^(NSURLSessionDataTask *task,NSError *error)
     {

         //Hide loader
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
         [alert show];
     }];
    
    
   
}

#pragma mark -  UITextFieldDelegate Methods -


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==firstTxtField) {
        [firstTxtField resignFirstResponder];
        [secoundTxtField becomeFirstResponder];
    }
    else if (textField==secoundTxtField)
    {
        [secoundTxtField resignFirstResponder];
        [thirdTxtField becomeFirstResponder];
    }
    else if(textField == thirdTxtField)
    {
        [self doneBtnTapped];
    }
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == firstTxtField) {
        _FirstInterestBGImageView.image = [UIImage imageNamed:@"registration_BG_green.png"];
    }
    else if (textField == secoundTxtField) {
        _secondBGImageView.image = [UIImage imageNamed:@"registration_BG_green.png"];
    }
    else if (textField == thirdTxtField)
    {
        _thirdBGImageVIew.image = [UIImage imageNamed:@"registration_BG_green.png"];
        
    }
    

    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    _FirstInterestBGImageView.image = [UIImage imageNamed:@"resend_txtBG.png"];
    _secondBGImageView.image = [UIImage imageNamed:@"resend_txtBG.png"];
    _thirdBGImageVIew.image = [UIImage imageNamed:@"resend_txtBG.png"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipBtnTapped:(id)sender {
    
    UINavigationController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationView"];
    [self presentViewController:rootView animated:NO completion:nil];
    

}
@end
