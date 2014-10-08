
//
//  RegistrationViewController.m
//  Venture
//
//  Created by Deepak Tomar on 26/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//


#import "RegistrationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "VerificationViewController.h"

@interface RegistrationViewController ()<CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;


}


@property (strong, nonatomic) IBOutlet UIImageView *nameBGImageView;
@property (strong, nonatomic) IBOutlet UIImageView *phoneBGImageView;
@property (strong, nonatomic) IBOutlet UIImageView *passwordBGImageView;

@end

@implementation RegistrationViewController
@synthesize nameTxtField,numberTxtField,passwordTxtField,countryPhoneCode,regScrollView;

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
    
    //set up the custom apperance
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
    
    
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];


}

-(void)setupCustomAppearance
{
    
    //    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Firstname Lastname" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    //    nameTxtField.attributedPlaceholder = str;
    //
    //    NSAttributedString *numberStr = [[NSAttributedString alloc] initWithString:@"1234567890" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    //    numberTxtField.attributedPlaceholder = numberStr;
    //
    //    NSAttributedString *countryCodeStr = [[NSAttributedString alloc] initWithString:@"+44" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    //    countryPhoneCode.attributedPlaceholder = countryCodeStr;
    //
    //    NSAttributedString *passStr = [[NSAttributedString alloc] initWithString:@"*****" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor] }];
    //    passwordTxtField.attributedPlaceholder = passStr;
    //    

    // keyboard input Accessory View //
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    keyboardView.backgroundColor = [UIColor clearColor];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(19, 2, 47, 40)];
    [loginBtn setTitle:@"Log In" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    loginBtn.titleLabel.textColor = [UIColor whiteColor];
    
    
    UIButton *NextBtn = [[UIButton alloc] initWithFrame:CGRectMake(264, 2, 50, 40)];
    [NextBtn setTitle:@"Next" forState:UIControlStateNormal];
    [NextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    NextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    NextBtn.titleLabel.textColor = [UIColor whiteColor];
    
    
    
    [keyboardView addSubview:NextBtn];
    [keyboardView addSubview:loginBtn];
    
    
    nameTxtField.inputAccessoryView = keyboardView;
    numberTxtField.inputAccessoryView = keyboardView;
    countryPhoneCode.inputAccessoryView = keyboardView;
    passwordTxtField.inputAccessoryView = keyboardView;
 
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"background" withExtension:@"gif"];
    self.backgroundImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    
    
    
}


-(void)keyboardWillShow {
   
//    if (regScrollView.contentOffset.y ==0) {
    
    NSLog(@"%f",regScrollView.contentOffset.y );

    [UIView transitionWithView:_logoImageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        //  Set the new image
                        //  Since its done in animation block, the change will be animated
                        //                        imageView.image = newImage;
                        
                        _logoImageView.frame = CGRectMake(138, _logoImageView.frame.origin.y/3, _logoImageView.frame.size.width, _logoImageView.frame.size.height);
                        
                    } completion:^(BOOL finished) {
                        //  Do whatever when the animation is finished
                    }];
        
//    }

//    [UIView animateWithDuration:0.3f animations:^{
//        
//        _logoImageView.frame = CGRectMake(150, _logoImageView.frame.origin.y/2, _logoImageView.frame.size.width/2, _logoImageView.frame.size.height/2);
//        
//    } completion:^(BOOL finished)
//     {
//         
//     }];
    
}

-(void)keyboardWillHide {
    
    
    NSLog(@"%f",regScrollView.contentOffset.y );

    
//    if (regScrollView.contentOffset.y ==0) {

    [UIView transitionWithView:_logoImageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        //  Set the new image
                        //  Since its done in animation block, the change will be animated
                        //                        imageView.image = newImage;
                        
                        _logoImageView.frame = CGRectMake(138, _logoImageView.frame.origin.y*3, _logoImageView.frame.size.width, _logoImageView.frame.size.height);
                        
                    } completion:^(BOOL finished) {
                        //  Do whatever when the animation is finished
                    }];
        
//    }

//    [UIView animateWithDuration:0.3f animations:^{
//        
//        _logoImageView.frame = CGRectMake(138, _logoImageView.frame.origin.y*2, _logoImageView.frame.size.width*2, _logoImageView.frame.size.height*2);
//        
//    } completion:^(BOOL finished)
//     {
//         
//     }];
//    
    
}


-(void)dismissKeyboard {
    [regScrollView setContentOffset:CGPointZero animated:YES];
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryCode = placemark.ISOcountryCode;
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             NSLog(@"%@",CountryCode);
             
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    int length = [currentString length];
    if (textField == countryPhoneCode) {        
        if (length > 4) {
            return NO;
        }
    }
    else if (textField == numberTxtField)
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
//        if (length > 10) {
//            return NO;
//        }
    
    }

    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==nameTxtField) {
        [countryPhoneCode becomeFirstResponder];
        return YES;
    }
    if (textField == countryPhoneCode) {
        [numberTxtField becomeFirstResponder];
        return YES;
        
    }
    if (textField == numberTxtField) {
        [passwordTxtField becomeFirstResponder];
        return YES;
        
    }
    if (textField ==passwordTxtField) {
        [self nextBtnTapped:nil];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == nameTxtField) {
        _nameBGImageView.image = [UIImage imageNamed:@"registration_BG_green.png"];
    }
    else if (textField == numberTxtField || textField == countryPhoneCode) {
        _phoneBGImageView.image = [UIImage imageNamed:@"registration_BG_green.png"];
    }
    else if (textField == passwordTxtField)
    {
        _passwordBGImageView.image = [UIImage imageNamed:@"registration_BG_green.png"];
    
    }
    
    
//    NSLog(@"regScrollView.contentOffset.x --->%f", regScrollView.frame.origin.y);
//    NSLog(@"regScrollView.contentOffset.y --->%f",textField.frame.origin.y+47+140+regScrollView.frame.origin.y);
//    NSLog(@"regScrollView.contentOffset.y --->%f",result.height-206);
//    
//    if((textField.frame.origin.y+47+40+regScrollView.frame.origin.y) >= result.height-206){
//        scrollPoint = CGPointMake(0, -40);
//        
//    }
//    else
//    {
//        scrollPoint =  CGPointZero;// CGPointMake(0, textField.frame.origin.y-20);
//        
//    }
//    //    if (textField != self.forgotPassTxtField) {
//    [regScrollView setContentOffset:scrollPoint animated:YES];
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    CGPoint scrollPoint;
    
//    if (result.height==568 && textField == passwordTxtField) {
//        scrollPoint = CGPointMake(0, +30);
//        [regScrollView setContentOffset:scrollPoint animated:YES];
//
//    }
    
    
    NSLog(@"%@", NSStringFromCGPoint(regScrollView.contentOffset));
        if (result.height == 480) {
            scrollPoint = CGPointMake(0, 70);
        }
//    if(result.height == 480 && textField !=passwordTxtField){
//        scrollPoint = CGPointMake(0, textField.frame.origin.y-24);
//        
//    }
    else if(result.height == 568 )
    {
        scrollPoint = CGPointMake(0, 36);
        
    }
    [regScrollView setContentOffset:scrollPoint animated:YES];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    _nameBGImageView.image = [UIImage imageNamed:@"registration_txtBG.png"];
    _phoneBGImageView.image = [UIImage imageNamed:@"registration_txtBG.png"];
    _passwordBGImageView.image = [UIImage imageNamed:@"registration_txtBG.png"];
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
//    CGPoint scrollPoint;
   if (result.height == 480 && textField == numberTxtField) {
       
    }
    else
    {
        [regScrollView setContentOffset:CGPointZero animated:YES];
    }
}


#pragma mark - UIAlertView delegate Methods -


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // check the button index if user click on  yes then call delete event API
    if (buttonIndex == 1) {
        [self sendUserDetailsToServer];

    }
}



#pragma mark - self define Methods -


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
            countryPhoneCode.text = [responseObject objectForKey:@"PhoneCode"];
            
        }        
    }
          failure:^(NSURLSessionDataTask *task,NSError *error)
     {
         NSLog(@"%@",[error localizedDescription]);
        
     }];



}

-(void) sendUserDetailsToServer
{
    //    NSString *userNameStr=[nameTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passStr=[passwordTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneStr = [numberTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSArray *nameArray = [nameTxtField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    

    NSString *completePhoneNumber = [NSString stringWithFormat:@"%@-%@",countryPhoneCode.text,phoneStr];
    
    
    NSString *firstName = [nameArray firstObject];
    NSString *lastName = [nameArray lastObject];
    if ([nameArray lastObject] != nil) {
        NSLog(@"true");
        
    }
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        });
    //    });
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSString *latitude;
    NSString *longitude;
    
    if(currentLocation != nil)
    {
        latitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        longitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        
    }
    else
    {
        latitude = @"";
        longitude = @"";
        
    }
    
    NSDictionary *dict=@{
                         @"firstName":firstName,
                         @"lastName" :lastName,
                         @"phone" :completePhoneNumber,
                         @"password":passStr,
                         @"latitude" : latitude,
                         @"longitude" : longitude
                         };
    NSLog(@" fetch event parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"register" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
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
            return ;
            
        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            
            
            VerificationViewController *verificationView = (VerificationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"VerificationViewController"];
            verificationView.completePhoneNumber = completePhoneNumber;
            [self presentViewController:verificationView animated:NO completion:nil];
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

- (IBAction)nextBtnTapped:(id)sender {
    
    if ([nameTxtField isFirstResponder]) {
//        [nameTxtField resignFirstResponder];
        [countryPhoneCode becomeFirstResponder];
        return;
    }
    if ([countryPhoneCode isFirstResponder]) {
//        [countryPhoneCode resignFirstResponder];
        [numberTxtField becomeFirstResponder];
        return;
    }
    if ([numberTxtField isFirstResponder]) {
//        [numberTxtField resignFirstResponder];
        [passwordTxtField becomeFirstResponder];
        return;
    }
    if ([passwordTxtField isFirstResponder]) {
//        [self nextBtnTapped:nil];
    }
  
    [self.view endEditing:YES];

//    NSString *userNameStr=[nameTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passStr=[passwordTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneStr = [numberTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
//    NSArray *nameArray = [nameTxtField.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if([nameTxtField.text length]==0 || [countryPhoneCode.text length]==0 || [passStr length]==0 || [phoneStr length]==0){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter required fields." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
//    else if (nameArray.count<2) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter Last Name in the name field." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        
//        [alert show];
//        return;
//    }
    else if (![self validPhone:phoneStr])
    {
    
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter valid Mobile number." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    else if ([passStr length]<5)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Your password must contain at least 5  characters." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    
    }
    
    
    //show the Alert
    
    UIAlertView *completedAlert = [[UIAlertView alloc] initWithTitle:@"Phone Number Verification" message:[NSString stringWithFormat:@"We will send you an SMS with the verification code to the number:\n%@ %@",countryPhoneCode.text,phoneStr] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"OK", nil];
    completedAlert.tag = 20;
    [completedAlert show];
    
//    NSString *completePhoneNumber = [NSString stringWithFormat:@"%@-%@",countryPhoneCode.text,phoneStr];
//    
//    
//    NSString *firstName = [nameArray firstObject];
//    NSString *lastName = [nameArray lastObject];
//    if ([nameArray lastObject] != nil) {
//        NSLog(@"true");
//        
//    }

//    
//    //Show the loader
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
////        dispatch_async(dispatch_get_main_queue(), ^{
////            [MBProgressHUD hideHUDForView:self.view animated:YES];
////        });
////    });
//    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
//    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
//    
//    NSDictionary *dict=@{
//                         @"firstName":firstName,
//                         @"lastName" :lastName,
//                         @"phone" :completePhoneNumber,
//                         @"password":passStr
//                         };
//    NSLog(@" fetch event parameters ---> %@",dict);
//    
//
////    return;
//  [manager POST:@"register" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
//        
//      
//        
//        NSLog(@"responseObject%@",responseObject);
//      
//      
//      ///-----for key -> "errors" ---- ///
//      if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
//          
//          NSMutableString *strTemp=[NSMutableString string];
//          
//          for (NSString *key in [responseObject objectForKey:@"message"]) {
//              
//              if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//
//                    for (NSString *descStr in [[responseObject objectForKey:@"message"] objectForKey:key]) {
//                      
//                      [strTemp appendFormat:@"%@.\n",[[[responseObject objectForKey:@"message"] objectForKey:key] objectForKey:descStr]];
//                    }
//              }
//              else if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSString class]])
//              {
//                  strTemp = [[responseObject objectForKey:@"message"] objectForKey:key];
//              
//              }
//              
//              
//          }
//          
//            UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//            [errorAlert show];
//          //Hide loader
//          [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//          
//          return ;
//
//      }
//      
//
//        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
//        {
//            
//  
//            VerificationViewController *verificationView = (VerificationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"VerificationViewController"];
//            verificationView.completePhoneNumber = completePhoneNumber;
//            [self presentViewController:verificationView animated:NO completion:nil];
//            
////            [self dismissViewControllerAnimated:NO completion:nil];
//        }
//        else
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please try later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//            
//            [alert show];
//            return ;
//        }
//    }
//        failure:^(NSURLSessionDataTask *task,NSError *error)
//    {
//        
//        //Hide loader
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        
//        //        if ([[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401) {
//        //            [KabiftAppDelegate retriveAccessToken];
//        //            [self fetchEvents];
//        //            return ;
//        //        }
//        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//        [alert show];
//    }];
//    
    
}

- (IBAction)loginBtnTapped:(id)sender {
    
    LoginViewController *loginView = (LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginView animated:NO completion:nil];

}
@end
