//
//  ForgotPasswordViewController.m
//  Venture
//
//  Created by Deepak Tomar on 28/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ForgotPasswordViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>

{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    
    
}


//forgot password view

@property (strong, nonatomic) IBOutlet UIImageView *phoneBGImageView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTxtField;
@property (strong, nonatomic) IBOutlet UITextField *countryPhoneCode;


//reset view
@property (strong, nonatomic) IBOutlet UIView *resetPassView;
@property (strong, nonatomic) IBOutlet UITextField *userNewPassTxtField;
@property (strong , nonatomic) IBOutlet UIImageView *userNewPassBGImageView;
@property (strong, nonatomic) IBOutlet UITextField *confirmTxtField;
@property (strong, nonatomic) IBOutlet UIImageView *confirmBGImageView;

//SMS code view
@property (strong, nonatomic) IBOutlet UIView *smsCodeView;
@property (strong, nonatomic) IBOutlet UIImageView *smsCodeBGImageView;
@property (strong, nonatomic) IBOutlet UITextField *smsCodeTxtField;




@end

@implementation ForgotPasswordViewController

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
   
    
    [self setupCustomAppearance];
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                             message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
        }
    }
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    
}



-(void)setupCustomAppearance
{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x00B863)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"Forgot Password?";
    
    
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"background" withExtension:@"gif"];
    //    self.backgroundImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIColor whiteColor],NSForegroundColorAttributeName,
                                               [UIFont systemFontOfSize:17.0],
                                               NSFontAttributeName,
                                               nil];
    [self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 12, 20.0f)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetBtnTapped:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    keyboardView.backgroundColor = UIColorFromRGB(0xd9d9d9);
    
    _smsCodeTxtField.inputAccessoryView = keyboardView;
    _countryPhoneCode.inputAccessoryView = keyboardView;
    _phoneNumberTxtField.inputAccessoryView = keyboardView;
    
    
    //    [_userNewPassTxtField setTintColor:UIColorFromRGB(0xd9d9d9)];
   
    
}

- (void)popCurrentViewController
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  CLLocationManagerDelegate Methods -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryCode = placemark.ISOcountryCode;
             NSLog(@"Country -----> %@\nCountryCode ----->%@",Country,CountryCode);
             //get the dialling code from the country code
             [self getDiallingCodeForCountryCode:CountryCode];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }
     }];
}

#pragma mark -  UITextFieldDelegate Methods -


-(void)dismissKeyboard {
    [self.view endEditing:YES];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int length = [currentString length];
    if (textField == _countryPhoneCode) {
        if (length > 4) {
            return NO;
        }
    }
    else if (textField == _phoneNumberTxtField)
    {
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([0-9]+)?$";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
        
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == _phoneNumberTxtField || textField == _countryPhoneCode) {
        [_phoneBGImageView setBackgroundColor:UIColorFromRGB(0x00b863)];
    }
    else if (textField == _smsCodeTxtField ) {
        [_smsCodeBGImageView setBackgroundColor:UIColorFromRGB(0x00b863)];
    }else if (textField == _userNewPassTxtField)
    {
        [_userNewPassBGImageView setBackgroundColor:UIColorFromRGB(0x00b863)];

    }else if (textField == _confirmTxtField)
    {
        [_confirmBGImageView setBackgroundColor:UIColorFromRGB(0x00b863)];
        
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [_phoneBGImageView setBackgroundColor:UIColorFromRGB(0xd9d9d9)];
    [_smsCodeBGImageView setBackgroundColor:UIColorFromRGB(0xd9d9d9)];
    [_userNewPassBGImageView setBackgroundColor:UIColorFromRGB(0xd9d9d9)];
    [_confirmBGImageView setBackgroundColor:UIColorFromRGB(0xd9d9d9)];
}


#pragma mark - UIAlertView delegate Methods -


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // check the button index if user click on  yes then call delete event API
    if (buttonIndex == 1)
    {
        [self sendForgotPassDetailsToServer];
        
    }
}


#pragma mark -  self define Methods -



- (BOOL) validPhone:(NSString*) phoneString {
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:&error];
    
    NSRange inputRange = NSMakeRange(0, [phoneString length]);
    NSArray *matches = [detector matchesInString:phoneString options:0 range:inputRange];
    
    // no match at all
    if ([matches count] == 0) {
        return NO;
    }
    
    // found match but we need to check if it matched the whole string
    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
    
    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length) {
        // it matched the whole string
        return YES;
    }
    else {
        // it only matched partial string
        return NO;
    }
}


-(void) getDiallingCodeForCountryCode : (NSString *) ISOcountryCode
{
    
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSString *getPath = [NSString stringWithFormat:@"phonecode/%@",ISOcountryCode];
    
    [manager GET:getPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
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
            
            return ;
        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            _countryPhoneCode.text = [responseObject objectForKey:@"PhoneCode"];
            
        }
    }
         failure:^(NSURLSessionDataTask *task,NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
         
     }];
    
    
    
}


-(void) sendForgotPassDetailsToServer
{
    
//    
//    [_smsCodeView setHidden:NO];
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"● ● ● ●" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
//    _smsCodeTxtField.attributedPlaceholder = str;
//
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnTapped:)];
//    return;

    NSString *phoneStr = [_phoneNumberTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *completePhoneNumber = [NSString stringWithFormat:@"%@-%@",_countryPhoneCode.text,phoneStr];

    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    NSDictionary *dict=@{
                         @"phone":completePhoneNumber,
                         @"send_mail" :@"yes",
                         @"send_sms" :@"yes"
                         };
    NSLog(@" fetch event parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"forgotpassword" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject)
    {

        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject%@",responseObject);
        
        
        ///-----for key -> "errors" ---- ///
        if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
            
            
            NSMutableString *strTemp=[NSMutableString string];
            
            
            if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSString class]])
            {
                strTemp = [responseObject objectForKey:@"message"];
                UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
                [errorAlert show];
                return ;

                
            }
            
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
            
            
            return ;
            
        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            [_smsCodeView setHidden:NO];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"● ● ● ●" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
            _smsCodeTxtField.attributedPlaceholder = str;
            
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnTapped:)];

        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please try later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            
            [alert show];
            return ;
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

- (IBAction)backBtnTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBtnTapped:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *securityCodeStr = [_smsCodeTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneStr = [_phoneNumberTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *completePhoneNumber = [NSString stringWithFormat:@"%@-%@",_countryPhoneCode.text,phoneStr];
    NSString *passStr=[_userNewPassTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirmPassStr=[_confirmTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([passStr length]==0 || [confirmPassStr length]==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter required fields." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    if (![passStr isEqualToString:confirmPassStr]) {
        
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Password does not match with confirm password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [errorAlert show];
        
        return;
    }
    
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSDictionary *dict=@{
                         @"phone":completePhoneNumber,
                         @"security_code" :securityCodeStr,
                         @"new_password" : passStr,
                         @"confirm_password" : confirmPassStr
                         };
   NSLog(@"resetforgotpassword parameters ---> %@",dict);
    
    
    
    [manager POST:@"resetforgotpassword" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject%@",responseObject);
        
        ///-----for key -> "errors" ---- ///
        if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
            
            NSMutableString *strTemp=[NSMutableString string];
            
            
            if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSDictionary class]]) {
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
            }
            else if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSString class]])
            {
                strTemp = [responseObject objectForKey:@"message"];
                
            }
            UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [errorAlert show];
            return;
        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
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

-(IBAction)nextBtnTapped : (id)sender
{
    
    [self.view endEditing:YES];
    
//    [_resetPassView setHidden: NO];
//    self.title = @"Password";
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnTapped:)];
//    return;
    
    
    
    NSString *securityCodeStr = [_smsCodeTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneStr = [_phoneNumberTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *completePhoneNumber = [NSString stringWithFormat:@"%@-%@",_countryPhoneCode.text,phoneStr];

    
    if([securityCodeStr length]==0){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter code." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSDictionary *dict=@{
                         @"phone":completePhoneNumber,
                         @"security_code" :securityCodeStr
                         };
    //    NSLog(@" fetch event parameters ---> %@",dict);
    
    
    
    [manager POST:@"checksecuritycode" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject%@",responseObject);
        
        
        ///-----for key -> "errors" ---- ///
        if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
            
            NSMutableString *strTemp=[NSMutableString string];
            
            
            if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSDictionary class]]) {
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
            }
            else if ([[responseObject objectForKey:@"message"] isKindOfClass:[NSString class]])
            {
                strTemp = [responseObject objectForKey:@"message"];
                
            }
            UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [errorAlert show];
            return;
        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            
            [_resetPassView setHidden: NO];
            self.title = @"Password";
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveBtnTapped:)];
            
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

- (IBAction)resetBtnTapped:(id)sender {
    [self.view endEditing:YES];

    NSString *phoneStr = [_phoneNumberTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([_countryPhoneCode.text length]==0 || [phoneStr length]==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter Phone number fields." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (![self validPhone:phoneStr])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter valid Mobile number." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    
    //show the Alert
    
    UIAlertView *completedAlert = [[UIAlertView alloc] initWithTitle:@"Phone Number Verification Code" message:[NSString stringWithFormat:@"We will send you an SMS with the code to the number:\n%@ %@",_countryPhoneCode.text,phoneStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"OK", nil];
    completedAlert.tag = 20;
    [completedAlert show];
    

}
@end
