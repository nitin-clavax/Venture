//
//  LoginViewController.m
//  Venture
//
//  Created by Deepak Tomar on 25/08/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//



#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>

#import "RegistrationViewController.h"
#import "UserInterestsViewController.h"
#import "ForgotPasswordViewController.h"
// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface LoginViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CGRect temp;
    BOOL isAnimate;
}

@property (strong, nonatomic) IBOutlet UIImageView *userNameBGImageView;
@property (strong, nonatomic) IBOutlet UIImageView *passwordBGImageView;
@end

@implementation LoginViewController
@synthesize userNameTxtField,passTxtField,logInForgotBtnsView;

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
    
    
    // TODO: need to remove the username and pass text
    userNameTxtField.text = @"1234567890";
    passTxtField.text = @"1234321";

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

 
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"E-mail/Phone" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    userNameTxtField.attributedPlaceholder = str;
    
    NSAttributedString *passStr = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    passTxtField.attributedPlaceholder = passStr;


    
    // keyboard input Accessory View //
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    keyboardView.backgroundColor = [UIColor clearColor];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 2, 47, 40)];
    [loginBtn setTitle:@"Log In" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(signInBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.titleLabel.textColor = [UIColor whiteColor];
    
    
    UIButton *fbSignInBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 2, 150, 40)];
    [fbSignInBtn setTitle:@"Sign in with Facebook" forState:UIControlStateNormal];
    [fbSignInBtn addTarget:self action:@selector(FBSignInBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    fbSignInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    fbSignInBtn.titleLabel.textColor = [UIColor whiteColor];
    
    UIImageView *fblogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(147, 14, 7, 15)];
    fblogoImage.image = [UIImage imageNamed:@"facebook_icon.png"];

    
    

    [keyboardView addSubview:fbSignInBtn];
    [keyboardView addSubview:fblogoImage];
    [keyboardView addSubview:loginBtn];
    
    
    passTxtField.inputAccessoryView = keyboardView;
    userNameTxtField.inputAccessoryView = keyboardView;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    

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
//           NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryCode = placemark.ISOcountryCode;
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             NSLog(@"%@",CountryCode);
             
//             [self getDiallingCodeForCountryCode:CountryCode];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
         }
     }];
}

//- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
//              curve:(int)curve degrees:(CGFloat)degrees
//{
//    // Setup the animation
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationCurve:curve];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    
//    // The transform matrix
//    CGAffineTransform transform =
//    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
//    image.transform = transform;
//    
//    // Commit the changes
//    [UIView commitAnimations];
//}
-(void)keyboardWillShow {
    
//    temp=_logoImageView.frame;
//    temp2 = _logoImageView.frame;
    NSLog(@"Show%@",NSStringFromCGRect(_logoImageView.frame));

    
    
//    [self rotateImage:_logoImageView duration:.30
//                curve:UIViewAnimationCurveEaseIn degrees:-180];
    
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
//    [UIView animateWithDuration:0.3f animations:^{
//        
//        
////        temp.size.height =temp.size.height/2;
////        temp.size.width =temp.size.width/2;
////        temp.origin.x = 150;
//
//        
//    } completion:^(BOOL finished)
//     {
//         
//     }];

}

-(void)keyboardWillHide {
    
    NSLog(@"%@",NSStringFromCGRect(_logoImageView.frame));
    
//    [self rotateImage:_logoImageView duration:.30
//                curve:UIViewAnimationCurveEaseIn degrees:+180];
    
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
//    [UIView animateWithDuration:0.3f animations:^{
//        
//        _logoImageView.frame = CGRectMake(138, _logoImageView.frame.origin.y*2, _logoImageView.frame.size.width*2, _logoImageView.frame.size.height*2);
//
//        
//    } completion:^(BOOL finished)
//     {
//         
//     }];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - facebook Methods -


// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        NSLog(@"permissions::%@",FBSession.activeSession.permissions);
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"Okay"
                      otherButtonTitles:nil] show];
}


// Show the user the logged-out UI
- (void)userLoggedOut
{
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    
    
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"%@",[NSString stringWithFormat:@"user info: %@", result]);
            NSDictionary *info =(NSDictionary *)result;
            
//            NSLog(@"FB user first name:%@",result.first_name);
//            NSLog(@"FB user last name:%@",result.last_name);
//            NSLog(@"FB user birthday:%@",result.birthday);
//            NSLog(@"FB user location:%@",result.location);
//            NSLog(@"FB user username:%@",result.username);
//            NSLog(@"FB user gender:%@",[result objectForKey:@"gender"]);
//            NSLog(@"email id:%@",[result objectForKey:@"email"]);
//            NSLog(@"location:%@", [NSString stringWithFormat:@"Location: %@\n\n",
//                                   result.location[@"name"]]);
            
            
//            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result valueForKey:@"id"]];
            NSString *gender;
            if ([[result valueForKey:@"gender"] isEqualToString:@"male"]) {
                gender = @"m";
            }
            else
            {
                gender = @"f";
                
            }
            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date..
//            [dateFormatter setDateFormat:@"MM/dd/yyyy"]; //// here set format of date which is in your output date (means above str with format)
//            NSDate *date = [dateFormatter dateFromString:[info valueForKey:@"birthday"]]; // here you can fetch date from string with define format
//            dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];// here set format which you want...
//            NSString *dobStr = [dateFormatter stringFromDate:date]; //here convert date in NSString
//
//            NSLog(@"%@",dobStr);
            
            
            
            NSLog(@"%@",currentLocation);
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

            
            //Show the loader
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSURL *URL = [NSURL URLWithString:k_BASE_URL];
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];

            
            NSDictionary *dict = @{
                                     @"email":[[info allKeys] containsObject:@"email"]?[info valueForKey:@"email"]:@"",
                                     @"firstName":[[info allKeys] containsObject:@"first_name"]?[info valueForKey:@"first_name"]:@"",
                                     @"lastName":[[info allKeys] containsObject:@"last_name"]?[info valueForKey:@"last_name"]:@"",
//                                     @"address": [info valueForKey:@"link"],
//                                     @"state" : @"1", // facebook
//                                     @"countryiso" : @"3", //for ios
                                     @"gender" : gender,
                                     @"latitude" : latitude,
                                     @"longitude" : longitude
                                     };
            NSLog(@" fblogin parameters ---> %@",dict);
            
            
            //    return;
            [manager POST:@"fblogin" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
                
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
                    
                    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
                    [appDefaults setValue:[[responseObject valueForKey:@"userDetail"] valueForKey:@"userName"] forKey:@"userName"];
                    [appDefaults setValue:[[responseObject valueForKey:@"userDetail"] valueForKey:@"password_token"] forKey:@"password_token"];
                    [appDefaults synchronize];
                    
                    
                    
                    if ([[responseObject valueForKey:@"new_user"] isEqualToString:@"yes"]) {
                        
                        UserInterestsViewController *userInterestsView = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInterestsViewController"];

                        userInterestsView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [self presentViewController:userInterestsView animated:YES completion:nil];
                        
                    }
                    
                    else
                    {
                        UINavigationController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationView"];
                        [self presentViewController:rootView animated:NO completion:nil];
                    }

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
            

        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"%@",[NSString stringWithFormat:@"error %@", error.description]);
        }
    }];
    
}



#pragma mark - self define Methods -


-(void)dismissKeyboard {
    [_loginScrollView setContentOffset:CGPointZero animated:YES];
    [self.view endEditing:YES];
}

#pragma mark -  UITextFieldDelegate Methods -



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [_loginScrollView setContentOffset:CGPointZero animated:YES];
    if (textField==userNameTxtField) {
//        [textField resignFirstResponder];
        [passTxtField becomeFirstResponder];

        return YES;
    }
    if (textField ==passTxtField) {
        [self signInBtnTapped:nil];
    }
    [textField resignFirstResponder];
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    
    
    if (textField == userNameTxtField) {
        _userNameBGImageView.image = [UIImage imageNamed:@"email_BG_green.png"];
    }
    else if (textField == passTxtField) {
        _passwordBGImageView.image = [UIImage imageNamed:@"password_BG_green.png"];
    }
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
   NSLog(@"%@", NSStringFromCGPoint(_loginScrollView.contentOffset));

//    CGPoint scrollPoint;
    if(result.height == 480 ){//&& textField == userNameTxtField){
//        scrollPoint = CGPointMake(0, textField.frame.origin.y-20);
        [_loginScrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }
    else if(result.height == 568 )//&& textField == userNameTxtField)
    {
//        scrollPoint = CGPointMake(0, textField.frame.origin.y-50);
        [_loginScrollView setContentOffset:CGPointMake(0, 36) animated:YES];
       
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _userNameBGImageView.image = [UIImage imageNamed:@"email_BG.png"];
    _passwordBGImageView.image = [UIImage imageNamed:@"password_BG.png"];
//    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    
    if ( textField == passTxtField) {
        [_loginScrollView setContentOffset:CGPointZero animated:YES];
    }
}

- (IBAction)signInBtnTapped:(id)sender {
    
    [self.view endEditing:YES];

    NSString *userNameStr=[userNameTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *passStr=[passTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    
    if([userNameStr length]==0 || [passStr length]==0 ){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter required fields." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    NSDictionary *dict=@{
                         @"user_name":userNameStr,
                         @"password":passStr
                         };
   NSLog(@" login parameters ---> %@",dict);
    
    
    [manager POST:@"login" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        
        NSLog(@"responseObject%@",responseObject);
        
        
        if (![[responseObject objectForKey:@"status"] isEqualToString:@"error"]) {
            
            //Hide loader
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
            [appDefaults setValue:[[responseObject valueForKey:@"userDetail"] valueForKey:@"userName"] forKey:@"userName"];
            [appDefaults setValue:[[responseObject valueForKey:@"userDetail"] valueForKey:@"password_token"] forKey:@"password_token"];
            [appDefaults synchronize];

            
            
            UINavigationController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeNavigationView"];
            [self presentViewController:rootView animated:NO completion:nil];

            
//            UserInterestsViewController *userInterestsView = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInterestsViewController"];
//            
//            userInterestsView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:userInterestsView animated:YES completion:nil];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[responseObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            
            [alert show];
            
            //Hide loader
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            return ;
        }
        
        
    } failure:^(NSURLSessionDataTask *task,NSError *error){
        
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
    }];
    
   
}

- (IBAction)FBSignInBtnTapped:(id)sender {
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"email",
                                @"user_birthday",
                                nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Call the sessionStateChanged:state:error method to handle session state changes
             [self sessionStateChanged:session state:state error:error];
         }];
    }

}

- (IBAction)forgotPassBtnTapped:(id)sender {
    [self.view endEditing:YES];

    ForgotPasswordViewController *forgotPasswordViewController = (ForgotPasswordViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:forgotPasswordViewController];
    
    
    [self presentViewController:nav animated:NO completion:nil];
////    [self presentViewController:forgotPasswordViewController animated:YES completion:nil];
    

    

}

- (IBAction)signUpBtnTapped:(id)sender {
    
    RegistrationViewController *registrationView = (RegistrationViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self presentViewController:registrationView animated:NO completion:nil];
    
    
}
@end
