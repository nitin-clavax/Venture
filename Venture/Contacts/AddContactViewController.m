//
//  AddContactViewController.m
//  Venture
//
//  Created by Deepak Tomar on 30/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "AddContactViewController.h"
#import "UIImageView+AFNetworking.h"


@interface AddContactViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

{
    NSMutableArray *addedUserIdArray;
    
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSMutableArray *filteredArray;

//@property (assign, nonatomic) BOOL isSearchPressed;

@end

@implementation AddContactViewController

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
    
//    self.filteredArray = [self.mainArray  mutableCopy];
//    self.isSearchPressed = NO;
    
    // search bar customization  search.png
    self.navigationController.navigationBarHidden = YES;
    [self.searchBar setTintColor:[UIColor whiteColor]];
    self.searchBar.backgroundColor = UIColorFromRGB(0x00b863);
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:UIColorFromRGB(0x00b863)];
    
    
    [self.searchBar setImage:[UIImage imageNamed: @"search_icon.png"]
                forSearchBarIcon:UISearchBarIconSearch
                           state:UIControlStateNormal];
    
    
    //tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapGestureOnTableView:)];
    
    [self.searchTableView addGestureRecognizer:tap];
    
    addedUserIdArray = [[NSMutableArray alloc] init];

}

- (void)tapGestureOnTableView:(UITapGestureRecognizer*)sender {
    
    CGPoint tabLocation = [sender locationInView:self.searchTableView];
    NSIndexPath *tapIndexPath = [self.searchTableView indexPathForRowAtPoint:tabLocation];

    //check the tap gesture location
    if (tapIndexPath== nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath      *)indexPath;
{
    return 70.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.filteredArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
//    static NSString *simpleTableIdentifier = @"searchContactTblCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchContactTblCell"];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"searchContactTblCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"searchContactTblCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //userImage
    UIImageView *contactImageView=(UIImageView *)[cell viewWithTag:10];
    
    NSURL *imageUrl;
    if ([[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"]) {
        //        NSLog(@"%@",[[collectionImageDataArray objectAtIndex:indexPath.row] valueForKey:@"url"]);
        imageUrl=[NSURL URLWithString:[[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"]];
    }
    else{
        imageUrl=[NSURL URLWithString:@""];
    }
    
    
    [contactImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    
    //Name label
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:20];
    
    NSMutableString *name;
    
    if ([[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"firstName"] != nil && [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"firstName"] != [NSNull null]) {
        name = [[[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"firstName"] mutableCopy];
        
        if ([[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"lastName"] != nil && [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"lastName"] != [NSNull null]){
            [name appendString:@" "];
            [name appendString:[[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"lastName"]];
        }

    }
    else{
        
        name = [@"Not Available" mutableCopy];
        
    }
    
    [nameLabel setText:name];


    
    //Occupation label
    UILabel *occupation=(UILabel *)[cell viewWithTag:30];
    
    if ([[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"occupation"] != nil && [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"occupation"] != [NSNull null]) {
        [occupation setText:[[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"occupation"]];
    }
    else
    {
        [occupation setText:@"Not Available"];
        
    }


    
    //location label
    UILabel *locationLabel=(UILabel *)[cell viewWithTag:40];
    
    
    NSMutableString *locationTxt;
    
    if ([[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"state"] != nil && [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"state"] != [NSNull null]) {
        locationTxt = [[[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"state"] mutableCopy];
        
        if ([[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"country"] != nil && [[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"country"] != [NSNull null]){
            [locationTxt appendString:@", "];
            [locationTxt appendString:[[self.filteredArray objectAtIndex:indexPath.row] valueForKey:@"country"]];
        }
        
    }
    else{
        
        locationTxt = [@"Not Available" mutableCopy];
        
    }
    
    [locationLabel setText:locationTxt];

    
    UIButton *addButton = (UIButton *) [cell viewWithTag:50];
    addButton.layer.cornerRadius = 3.0;
	[addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([addedUserIdArray containsObject:[[self.filteredArray objectAtIndex:indexPath.row] objectForKey:@"userId"]]) {
        [addButton setHidden:YES];
    }
    else
    {
        [addButton setHidden:NO];
    }

    
//    cell.nameLabel.text = [tableData objectAtIndex:indexPath.row];
//    cell.thumbnailImageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
//    cell.prepTimeLabel.text = [prepTime objectAtIndex:indexPath.row];
//    
    return cell;
    
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
//    }
//    
//    cell.textLabel.text = [self.filteredArray objectAtIndex:indexPath.row];
//    
//    return cell;
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[c] %@",searchBar.text];
//    self.filteredArray = [[self.mainArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
//    if ([searchText length]==0) {
//        self.filteredArray = [self.mainArray  mutableCopy];
//
//    }
//    self.isSearchPressed = NO;
    
    [self getContactListFromServerForSearchTxt: searchBar.text];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
//    if (self.isSearchPressed ) {
//        return;
//    }
//    self.searchBar.hidden = YES;
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[c] %@",searchBar.text];
//    self.filteredArray = [[self.mainArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
    [self.searchBar resignFirstResponder];
//    self.isSearchPressed = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:NO];
//    self.isSearchPressed = NO;
}



#pragma mark -  self define Methods -





-(void)addButtonTapped :(id) sender
{
    
    
    UITableViewCell *tempCell = (UITableViewCell *) [[[sender superview] superview] superview];
    NSIndexPath *tempindexpath = [_searchTableView indexPathForCell:tempCell];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
    NSString *passwordToken = [appDefaults valueForKey:@"password_token"];
    NSString *user_name = [appDefaults valueForKey:@"userName"];
    
    NSString *usrId = [[self.filteredArray objectAtIndex:tempindexpath.row] objectForKey:@"userId"];

    NSDictionary *dict=@{
                         @"user_name":user_name,
                         @"password_token" :passwordToken,
                         @"request_type" :@"add",
                         @"userIds" : usrId
                         //                         @"latitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         //                         @"longitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         };
    NSLog(@" contact parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"contact" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
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
            [addedUserIdArray addObject:usrId];
            [self.searchTableView reloadData];
//            self.filteredArray = [[NSMutableArray alloc]init];
//            self.filteredArray = [[responseObject objectForKey:@"users"] mutableCopy];
//            [self.searchTableView reloadData];
            
            
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


/*
 * Function Name: getContactListFromServer
 * Function : get the user Contacts data from the server
 */


-(void) getContactListFromServerForSearchTxt :(NSString *) searchTxt
{
    
    //Show the loader
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
    NSString *passwordToken = [appDefaults valueForKey:@"password_token"];
    NSString *user_name = [appDefaults valueForKey:@"userName"];

    
    NSDictionary *dict=@{
                         @"user_name":user_name,
                         @"password_token" :passwordToken,
                         @"request_type" :@"search",
                         @"search_txt" : searchTxt
                         //                         @"latitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         //                         @"longitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         };
    NSLog(@" contact parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"contact" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Hide loader
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject%@",responseObject);
        
        
        ///-----for key -> "errors" ---- ///
//        if([[responseObject objectForKey:@"status"] isEqualToString:@"error"]){
//            
//            NSMutableString *strTemp=[NSMutableString string];
//            
//            for (NSString *key in [responseObject objectForKey:@"message"]) {
//                
//                if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//                    
//                    for (NSString *descStr in [[responseObject objectForKey:@"message"] objectForKey:key]) {
//                        
//                        [strTemp appendFormat:@"%@.\n",[[[responseObject objectForKey:@"message"] objectForKey:key] objectForKey:descStr]];
//                    }
//                }
//                else if ([[[responseObject objectForKey:@"message"] objectForKey:key] isKindOfClass:[NSString class]])
//                {
//                    strTemp = [[responseObject objectForKey:@"message"] objectForKey:key];
//                    
//                }
//                
//                
//            }
//            
//            UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:strTemp delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
//            [errorAlert show];
//            
//            
//            
//            return ;
//            
//        }
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            addedUserIdArray = [[NSMutableArray alloc] init];
            self.filteredArray = [[NSMutableArray alloc]init];
            self.filteredArray = [[responseObject objectForKey:@"users"] mutableCopy];
            [self.searchTableView reloadData];

            
        }
    }
          failure:^(NSURLSessionDataTask *task,NSError *error)
     {
         
         //Hide loader
//         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
         [alert show];
     }];
    
    
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
