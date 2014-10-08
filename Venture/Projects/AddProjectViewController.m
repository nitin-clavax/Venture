//
//  AddProjectViewController.m
//  Venture
//
//  Created by Deepak Tomar on 17/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "AddProjectViewController.h"
#import "UIViewController+CustomBackButton.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+AFNetworking.h"

@interface AddProjectViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

{
    UIView *placehoalderView;
    NSMutableArray *collectionImageDataArray;
    NSString *tempProjectId;
    

}
@property (strong, nonatomic) IBOutlet UITextField *projectNameTxtField;

@property (strong, nonatomic) IBOutlet UITextView *projectTxtView;

@property (strong, nonatomic) IBOutlet UIButton *postBtn;
@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;


@property (strong, nonatomic) IBOutlet UISwitch *lockProjectBtn;
@property (strong, nonatomic) IBOutlet UISwitch *privateBtn;


@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;


- (IBAction)postBtnTapped:(id)sender;
- (IBAction)uploadbtnTapped:(id)sender;
-(IBAction)removeImageBtnTapped:(id)sender;

@end

@implementation AddProjectViewController

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
    
    self.title = @"Create";
    tempProjectId = @"first";
    [self setupCustomAppearance];
    [self setUpImageBackButton];


}

-(void)setupCustomAppearance
{
    collectionImageDataArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
    
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self  action:@selector(saveBtnTapped:)];
    [buttons addObject:addButtonItem];
    
    
    self.navigationItem.rightBarButtonItems = buttons;
    
    [_projectNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 05, 22, 12)];
    paddingView.image = [UIImage imageNamed:@"search.png"];
    
    _projectNameTxtField.leftView= paddingView;
    _projectTxtView.layer.borderWidth = 1.f;
    _projectTxtView.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
    _projectTxtView.layer.cornerRadius = 4.0;
    [_projectTxtView setTintColor:[UIColor lightGrayColor]];
    
    _projectNameTxtField.layer.borderWidth = 1.f;
    _projectNameTxtField.layer.borderColor = UIColorFromRGB(0xd9d9d9).CGColor;
    _projectNameTxtField.layer.cornerRadius = 4.0;
    [_projectNameTxtField setTintColor:[UIColor lightGrayColor]];
    
    _postBtn.layer.cornerRadius = 4;
    _uploadBtn.layer.cornerRadius = 4;
    
    
    _lockProjectBtn.transform = CGAffineTransformMakeScale(0.80, 0.80);
    _privateBtn.transform = CGAffineTransformMakeScale(0.80, 0.80);
    
    
    placehoalderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 5.0, _projectTxtView.frame.size.width-50, 16.0)];
    
    UILabel  *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.0, 0.0, _projectTxtView.frame.size.width - 50.0, 16.0)];
    [placeholderLabel setText:@"Decribes your project or activity"];
    [placeholderLabel setBackgroundColor:[UIColor clearColor]];
    [placeholderLabel setFont:[UIFont systemFontOfSize:14]];
    [placeholderLabel setTextColor:[UIColor lightGrayColor]];

//    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 22, 12)];
//    searchImageView.image = [UIImage imageNamed:@"search.png"];
    [placehoalderView addSubview:placeholderLabel];
//    [placehoalderView addSubview:searchImageView];
    [_projectTxtView addSubview: placehoalderView];
    
    UITapGestureRecognizer *placeHoldertap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showKeyBoardForTxtView)];
    
    [placehoalderView addGestureRecognizer:placeHoldertap];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 22, 12)];
    searchImageView.image = [UIImage imageNamed:@"search.png"];
    [_projectTxtView addSubview:searchImageView];
    _projectTxtView.textContainerInset =    UIEdgeInsetsMake(5,19,5,5);


}
#pragma mark -  UITextFieldDelegate Methods -



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - UITextViewDelegate delegate Methods -


- (void) textViewDidChange:(UITextView *)textView
{
    if(![textView hasText]) {
        [textView addSubview:placehoalderView];
    } else if ([[textView subviews] containsObject:placehoalderView]) {
        [placehoalderView removeFromSuperview];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView hasText]) {
        [textView addSubview:placehoalderView];
    }
}


- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [txtView resignFirstResponder];
    return NO;
}



#pragma mark -  UICollectionViewDelegate Methods -


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    NSLog(@"%@",[[resultsArr objectAtIndex:indexPath.row] valueForKey:@"ASIN"]);
//    ItemdetailWebViewController *itemDetailWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemdetailWebView"];
//    
//    itemDetailWebView.itemURL = [[resultsArr objectAtIndex:indexPath.row] valueForKey:@"DetailPageURL"];
//    [self.navigationController pushViewController:itemDetailWebView animated:NO];
    
}


#pragma mark -  UICollectionViewDataSource  Methods -

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [collectionImageDataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell;
    if(cell==nil)
    {
        
        cell= [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
    }

    
//    NSURL *url;
//    if ([[[resultsArr objectAtIndex:indexPath.row] valueForKey:@"MediumImage"] isKindOfClass:[NSString class]]) {
//        url=[NSURL URLWithString:[[resultsArr objectAtIndex:indexPath.row] valueForKey:@"MediumImage"]];
//    }
//    else{
//        url=[NSURL URLWithString:@""];
//    }
    UIImageView *imgView=(UIImageView *)[cell viewWithTag:10];
//    [imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"questionMark.png"]];
//    NSData *data = [NSData dataWithContentsOfURL:[collectionImageDataArray objectAtIndex:indexPath.row]];
//    NSLog(@"length %d",[data length]);
    
    
//    NSString *temp = [[collectionImageDataArray objectAtIndex:indexPath.row] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *referenceURL =[NSURL URLWithString:[temp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    
////    NSURL *referenceURL = [NSURL URLWithString:[collectionImageDataArray objectAtIndex:indexPath.row]];
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////    __block UIImage *returnValue = nil;
//    [library assetForURL:referenceURL resultBlock:^(ALAsset *asset) {
//        
//        UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:0.8 orientation:UIImageOrientationUp];
//        imgView.image = copyOfOriginalImage;
//    
//    } failureBlock:^(NSError *error) {
//        // error handling
//            
//    }];
    
    
    NSURL *url;
    if ([[collectionImageDataArray objectAtIndex:indexPath.row] valueForKey:@"url"]) {
//        NSLog(@"%@",[[collectionImageDataArray objectAtIndex:indexPath.row] valueForKey:@"url"]);
        url=[NSURL URLWithString:[[collectionImageDataArray objectAtIndex:indexPath.row] valueForKey:@"url"]];
    }
    else{
        url=[NSURL URLWithString:@""];
    }
    [imgView setImageWithURL:url];
//    [imgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"questionMark.png"]];

    
    return cell;
}

#pragma mark -  UIActionSheetDelegate define Methods -


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    UIImagePickerController *imagePicker =    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate=self;
    
    imagePicker.mediaTypes =@[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = YES;
    
    
    if  ([buttonTitle isEqualToString:@"Photo Gallery"]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
    else if([buttonTitle isEqualToString:@"Camera"]){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker
                               animated:YES
                             completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                           message:@"Unable to find a camera on your device."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}


////to scale images without changing aspect ratio
//+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
//
//    float width = newSize.width;
//    float height = newSize.height;
//
//    UIGraphicsBeginImageContext(newSize);
//    CGRect rect = CGRectMake(0, 0, width, height);
//
//    float widthRatio = image.size.width / width;
//    float heightRatio = image.size.height / height;
//    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
//
//    width = image.size.width / divisor;
//    height = image.size.height / divisor;
//
//    rect.size.width  = width;
//    rect.size.height = height;
//
//    //indent in case of width or height difference
//    float offset = (width - height) / 2;
//    if (offset > 0) {
//        rect.origin.y = offset;
//    }
//    else {
//        rect.origin.x = -offset;
//    }
//
//    [image drawInRect: rect];
//
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    return smallImage;
//
//}

#pragma mark -  UIImagePickerControllerDelegate define Methods -

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        // Code here to work with media
        NSLog(@"%d",picker.sourceType);
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

//        if (picker.sourceType) {
//            
//            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//
//            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
//                if (error) {
//                    NSLog(@"error");
//                } else {
//                    NSLog(@"url %@", assetURL);
//                    [collectionImageDataArray addObject:[NSString stringWithFormat:@"%@",assetURL]];
//                    [_photoCollectionView reloadData];
//                }
//                
//            }];
//            
//        }
//        else
//        {
//            if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
//            {
//                // Media is an image
//                [collectionImageDataArray addObject:[NSString stringWithFormat:@"%@",[info objectForKey:@"UIImagePickerControllerReferenceURL"]]];
//            }
//        }
    
    [self dismissViewControllerAnimated:YES completion:nil];

    NSData *imageData = UIImageJPEGRepresentation(image,0.5);
    
    if (collectionImageDataArray.count >0) {
        tempProjectId = [[collectionImageDataArray objectAtIndex:0] objectForKey:@"tempProjectId"];
        
    }
    else{
        tempProjectId = @"first";
    }
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
    NSString *passwordToken = [appDefaults valueForKey:@"password_token"];
    NSString *user_name = [appDefaults valueForKey:@"userName"];

    NSDictionary *dict=@{
                         @"user_name":user_name,
                         @"password_token" :passwordToken,
                         @"tempProjectId" :tempProjectId
                         };
    NSLog(@" createproject parameters ---> %@",dict);

    
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:URL];
    
    [manager POST:@"tempProjectPic" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(imageData){
            [formData appendPartWithFileData:imageData name:@"imageName" fileName:@"test.png" mimeType:@"image/png"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"Success: %@", responseObject);
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        
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
            collectionImageDataArray = [[responseObject objectForKey:@"data"] mutableCopy];
            [_photoCollectionView reloadData];


        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please try later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            
            [alert show];
            return ;
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  self define Methods -

-(void)dismissKeyboard {

    [self.view endEditing:YES];
}

-(void) showKeyBoardForTxtView
{

    [_projectTxtView becomeFirstResponder];
}


/*
 * Function Name: saveBtnTapped
 * Function :
 */

-(void) saveBtnTapped :(id)sender
{
    NSString *projectName = _projectNameTxtField.text;
    NSString *projectDecStr = _projectTxtView.text;
    
    if([projectName length]==0 || [projectDecStr length]==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please enter required fields." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    NSString *lockProjectValue = _lockProjectBtn.on?@"0":@"1";
    NSString *projectVisibility = _privateBtn.on?@"3":@"4";
    
    
    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
    NSString *passwordToken = [appDefaults valueForKey:@"password_token"];
    NSString *user_name = [appDefaults valueForKey:@"userName"];
    
    
    if (collectionImageDataArray.count >0) {
        tempProjectId = [[collectionImageDataArray objectAtIndex:0] objectForKey:@"tempProjectId"];
        
    }
    else{
        tempProjectId = @"";
    }
    

    NSDictionary *dict=@{
                         @"user_name":user_name,
                         @"password_token" :passwordToken,
                         @"request_type" :@"create",
                         @"projectName":projectName,
                         @"projectDetail":projectDecStr,
                         @"projectVisibility":projectVisibility,
                         @"lockProjectDetail":lockProjectValue,
                         @"tempProjectId" :tempProjectId
                         };
    NSLog(@" createproject parameters ---> %@",dict);
    

    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    [manager POST:@"project" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Show the loader
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
            [self.navigationController popViewControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postBtnTapped:(id)sender {
}

-(IBAction)removeImageBtnTapped:(id)sender
{
    
    UICollectionViewCell *selectedCell = (UICollectionViewCell *)[[sender superview] superview];
    NSIndexPath *seletedindexPath = [_photoCollectionView indexPathForCell:selectedCell];
    
    NSString *deleteItemID = [NSString stringWithFormat:@"tempProjectPic/%@",[[collectionImageDataArray objectAtIndex:seletedindexPath.row] objectForKey:@"tempId"]];
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    
    [manager DELETE:deleteItemID parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Hide the loader
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
            
            [collectionImageDataArray removeObjectAtIndex:seletedindexPath.row];
            [_photoCollectionView reloadData];
        
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
- (IBAction)uploadbtnTapped:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Source Type"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Photo Gallery", @"Camera", nil];
    
    [actionSheet showInView:self.view];


}
@end
