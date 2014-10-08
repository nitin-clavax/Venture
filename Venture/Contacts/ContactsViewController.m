//
//  ContactsViewController.m
//  Venture
//
//  Created by Deepak Tomar on 10/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "ContactsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize dictIndexed;

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
    
}
-(void)viewWillAppear:(BOOL)animated
{

    [self getContactListFromServer];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  UITableViewDataSource Methods -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indices count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dictIndexed objectForKey:[indices objectAtIndex:section]] count];
    
}
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
	return [indices objectAtIndex:section];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [content valueForKey:@"headerTitle"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactTblCell"];
    
    NSDictionary *tempDict = [[dictIndexed objectForKey:[indices objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    
    
    //userImage
    UIImageView *contactImageView=(UIImageView *)[cell viewWithTag:10];
    contactImageView.layer.cornerRadius = contactImageView.frame.size.height/2;
    contactImageView.layer.masksToBounds = NO;
    contactImageView.clipsToBounds = YES;
    
    NSURL *imageUrl;
    if ([tempDict objectForKey:@"profilePic"]) {
        //        NSLog(@"%@",[[collectionImageDataArray objectAtIndex:indexPath.row] valueForKey:@"url"]);
        imageUrl=[NSURL URLWithString:[tempDict objectForKey:@"profilePic"]];
    }
    else{
        imageUrl=[NSURL URLWithString:@""];
    }
    
    
    [contactImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    
    //Name label
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:20];
    NSMutableString *name;
    
    if ([tempDict objectForKey:@"firstName"] != nil && [tempDict objectForKey:@"firstName"] != [NSNull null]) {
        
        name = [[tempDict objectForKey:@"firstName"] mutableCopy];
        
        if ([tempDict objectForKey:@"lastName"] != nil && [tempDict objectForKey:@"lastName"] != [NSNull null]){
            [name appendString:@" "];
            [name appendString:[tempDict  objectForKey:@"lastName"]];
        }
    }
    else{
    
        name = [@"Not Available" mutableCopy];

    }
    
    [nameLabel setText:name];



//    NSLog(@"%@",[[[dictIndexed objectForKey:[indices objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row] objectForKey:@"firstName"]);
    //Name label
    UILabel *occupationLabel=(UILabel *)[cell viewWithTag:30];
    
    if ([tempDict objectForKey:@"occupation"] != nil && [tempDict objectForKey:@"occupation"] != [NSNull null]){
        [occupationLabel setText:[tempDict objectForKey:@"occupation"]];
    }
    else
    {
        [occupationLabel setText:@"Occupation not Available"];
        
    }
	return cell;
}

#pragma mark -  UITableViewDelegate Methods -
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(20.0f, headerView.frame.size.height-9.0f, headerView.frame.size.width-20, 1.0f);
    bottomBorder.backgroundColor = UIColorFromRGB(0xe1e1e1).CGColor;
    [headerView.layer addSublayer:bottomBorder];
    
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,2,300,18)];
    tempLabel.backgroundColor=[UIColor clearColor];
    tempLabel.textColor = UIColorFromRGB(0x00B863); //here you can change the text color of header.
    tempLabel.font = [UIFont boldSystemFontOfSize:16];
    tempLabel.text=[indices objectAtIndex:section];
    [headerView addSubview:tempLabel];
    

    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self getCategoriesFromServerForTermID:[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"term_id"] Slug:[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"slug"] PageNumber:@"0"];
    
}




#pragma mark -  self define Methods -
/*
 * Function Name: getContactListFromServer
 * Function : get the user Contacts data from the server
 */


-(void) getContactListFromServer
{
    
    //Show the loader
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *URL = [NSURL URLWithString:k_BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    NSUserDefaults *appDefaults=[NSUserDefaults standardUserDefaults];
    NSString *passwordToken = [appDefaults valueForKey:@"password_token"];
    NSString *user_name = [appDefaults valueForKey:@"userName"];
    
    NSDictionary *dict=@{
                         @"user_name":user_name,
                         @"password_token" :passwordToken,
                         @"request_type" :@"list",
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
            NSArray *tempArray = [responseObject objectForKey:@"contacts"];
//            NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES selector:@selector(caseInsensitiveCompare:)] ;
//            NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
//            NSArray *sortedArray = [tempArray sortedArrayUsingDescriptors:sortDescriptors];
            
            
            NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"firstName"
                                                 
                                                                           ascending:YES selector:@selector(caseInsensitiveCompare:)];
            
            tempArray = [tempArray sortedArrayUsingDescriptors:[NSArray  arrayWithObject:sortDescriptor]];
            
            content = [DataGenerator wordsFromLetters];
            indices = [content valueForKey:@"headerTitle"];
            indices = [[NSMutableArray alloc]initWithArray:[content valueForKey:@"headerTitle"]];
            dictIndexed=[[NSMutableDictionary alloc]init];
            
            NSArray *tempArray2 = [[NSArray alloc] initWithArray:indices];
//            NSMutableArray *tempindices = [[NSMutableArray alloc] init];
            for(int i=0;i<[tempArray2 count];i++)
            {
                
                NSMutableArray *array=[[NSMutableArray alloc]init];
                for(int j=0;j<[tempArray count];j++)
                {
                    NSString *tempFirstName = [[tempArray objectAtIndex:j] objectForKey:@"firstName"];
                    
                    if([[tempFirstName substringToIndex:1] caseInsensitiveCompare:[tempArray2 objectAtIndex:i]] == NSOrderedSame)

//                    if([[tempFirstName substringToIndex:1]isEqualToString:[indices objectAtIndex:i]])
                    {
                        [array addObject:[tempArray objectAtIndex:j]];
                    }
                }
                if (array.count >0) {
                    [dictIndexed setObject:array forKey:[tempArray2 objectAtIndex:i]];
                }
                else{
                    [indices removeObject:[tempArray2 objectAtIndex:i]];
                }
            }
            
           [_contactTableView reloadData];
            
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
@end
