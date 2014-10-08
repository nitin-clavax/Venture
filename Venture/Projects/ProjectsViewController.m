//
//  ProjectsViewController.m
//  Venture
//
//  Created by Deepak Tomar on 10/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "ProjectsViewController.h"

@interface ProjectsViewController ()
{
    
    NSArray *projectsDetailsArray;

}

@end

@implementation ProjectsViewController
@synthesize projectsTbl;


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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{

    [self getProjectsListFromServer];

}

#pragma mark -  UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [projectsDetailsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectTblCell"];
    
    
//    UISegmentedControl *segmentedControl=(UISegmentedControl *)[cell viewWithTag:30];
//
////    segmentedControl.ControlStyle = (UISegmentedControlStyle)7;
//    segmentedControl.layer.cornerRadius = 0.0;
//    segmentedControl.layer.masksToBounds = YES;
    
//    segmentedControl.layer.borderColor = UIColorFromRGB(0x00B863).CGColor;
//    segmentedControl.layer.borderWidth = 1.0;
//    [segmentedControl setupFlat];


    UILabel *viewNameLbl=(UILabel *)[cell viewWithTag:30];
    viewNameLbl.layer.borderColor = UIColorFromRGB(0x00B863).CGColor;
    viewNameLbl.layer.borderWidth = 1.0;
    
    UILabel *photoLbl=(UILabel *)[cell viewWithTag:40];
    photoLbl.layer.borderColor = UIColorFromRGB(0x00B863).CGColor;
    photoLbl.layer.borderWidth = 1.0;
    UILabel *privacyLbl=(UILabel *)[cell viewWithTag:50];
    privacyLbl.layer.borderColor = UIColorFromRGB(0x00B863).CGColor;
    privacyLbl.layer.borderWidth = 1.0;
    
    viewNameLbl.text = [[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:@"views"];
    photoLbl.text = [[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:@"photos"];

    
    UILabel *projectNameLbl=(UILabel *)[cell viewWithTag:10];
    [projectNameLbl setText:[[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:@"projectName"]];
    
    UILabel *dateLabel=(UILabel *)[cell viewWithTag:20];
    NSString *dateKeyStr = [[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:@"userAction"];
    if ([dateKeyStr isEqualToString:@"createdDate"]) {
        
        [dateLabel setText:[NSString stringWithFormat:@"Created: %@",[[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:dateKeyStr]]];

    }
    else
    {
        [dateLabel setText:[NSString stringWithFormat:@"Last update: %@",[[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:dateKeyStr]]];
    }

    
    
    
    UIImageView *privacyImage = (UIImageView *) [cell viewWithTag:60];
    if ([[[projectsDetailsArray objectAtIndex:indexPath.row] objectForKey:@"visibility"] isEqualToString:@"3"])
    {
        privacyImage.image = [UIImage imageNamed:@"private.png"];
    }
    else
    {
        privacyImage.image = [UIImage imageNamed:@"public.png"];
    }

    
    
	return cell;
}

#pragma mark -  UITableViewDelegate Methods -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //    [self getCategoriesFromServerForTermID:[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"term_id"] Slug:[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"slug"] PageNumber:@"0"];
    
}




#pragma mark -  self define Methods -
/*
 * Function Name: getProjectsListFromServer
 * Function : get the user projects data from the server
 */


-(void) getProjectsListFromServer
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
                         @"request_type" :@"list"
                         };
    NSLog(@" contact parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"project" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
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
            projectsDetailsArray = [responseObject objectForKey:@"projects"];
            [projectsTbl reloadData];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Venture Error!" message:@"Please try later" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            
            [alert show];
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
