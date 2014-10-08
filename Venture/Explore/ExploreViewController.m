//
//  ExploreViewController.m
//  Venture
//
//  Created by Deepak Tomar on 10/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "ExploreViewController.h"
#import "UIImageView+AFNetworking.h"

#define METERS_PER_MILE 1609.344
@interface ExploreViewController ()
{

    CLLocationManager *locationManager;
    CLLocation *currentLocation;

}

@end

@implementation ExploreViewController
@synthesize nearByUserDataArray;

@synthesize exploreSearchBar;
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
    
    
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate=self.locationMapView.centerCoordinate;
    [self.locationMapView addAnnotation:annotation];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //1
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 19.946922;
//    zoomLocation.longitude= 73.765434;
//
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    [self.locationMapView setRegion:viewRegion animated:YES];
//    
//    // Add an annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = zoomLocation;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
    
//    [self.locationMapView addAnnotation:point];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [self.locationMapView setRegion:viewRegion animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = currentLocation.coordinate;
    
    [self.locationMapView addAnnotation:point];
//    [self getSearchDataFromServer];
//    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
//    annotation.coordinate=self.locationMapView.centerCoordinate;
//    [self.locationMapView addAnnotation:annotation];

   
}



#pragma mark -  MKMapViewDelegate define Methods -

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //7
    static NSString *identifier = @"myAnnotation";
    MKAnnotationView * annotationView = (MKAnnotationView *)[self.locationMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        //10
        annotationView.image = [UIImage imageNamed:@"map_marker.png"];
    }else {
        annotationView.annotation = annotation;
    }
     annotationView.draggable = YES;
    return annotationView;
}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.locationMapView setRegion:[self.locationMapView regionThatFits:region] animated:YES];
//}





#pragma mark -  UITableViewDataSource Methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [nearByUserDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exploreTblCell"];
    
    //userImage
    UIImageView *contactImageView=(UIImageView *)[cell viewWithTag:10];
    
    NSURL *imageUrl;
    if ([[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"]) {
        //        NSLog(@"%@",[[collectionImageDataArray objectAtIndex:indexPath.row] valueForKey:@"url"]);
        imageUrl=[NSURL URLWithString:[[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"profilePic"]];
    }
    else{
        imageUrl=[NSURL URLWithString:@""];
    }
    
    
    [contactImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    
    //Name label
    UILabel *nameLabel=(UILabel *)[cell viewWithTag:20];
    
    NSMutableString *name;
    
    if ([[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"firstName"] != nil && [[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"firstName"] != [NSNull null]) {
        name = [[[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"firstName"] mutableCopy];
        
        if ([[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"lastName"] != nil && [[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"lastName"] != [NSNull null]){
            [name appendString:@" "];
            [name appendString:[[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"lastName"]];
        }
        
    }
    else{
        
        name = [@"Not Available" mutableCopy];
        
    }
    
    [nameLabel setText:name];
    
    
    
    //Occupation label
    UILabel *occupation=(UILabel *)[cell viewWithTag:30];
    
    if ([[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"occupation"] != nil && [[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"occupation"] != [NSNull null]) {
        [occupation setText:[[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"occupation"]];
    }
    else
    {
        [occupation setText:@"Not Available"];
        
    }
    
    
    
    //location label
    UILabel *locationLabel=(UILabel *)[cell viewWithTag:40];
    
    
    NSMutableString *locationTxt;
    
    if ([[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"state"] != nil && [[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"state"] != [NSNull null]) {
        locationTxt = [[[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"state"] mutableCopy];
        
        if ([[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"country"] != nil && [[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"country"] != [NSNull null]){
            [locationTxt appendString:@", "];
            [locationTxt appendString:[[nearByUserDataArray objectAtIndex:indexPath.row] valueForKey:@"country"]];
        }
        
    }
    else{
        
        locationTxt = [@"Not Available" mutableCopy];
        
    }
    
    [locationLabel setText:locationTxt];
    
    
    
	return cell;
}

#pragma mark -  UITableViewDelegate Methods -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    [self getCategoriesFromServerForTermID:[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"term_id"] Slug:[[categoryDataArray objectAtIndex:indexPath.row] objectForKey:@"slug"] PageNumber:@"0"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginsWith[c] %@",exploreSearchBar.text];
    //    self.filteredArray = [[self.mainArray filteredArrayUsingPredicate:predicate] mutableCopy];
    
    //    if ([searchText length]==0) {
    //        self.filteredArray = [self.mainArray  mutableCopy];
    //
    //    }
    //    self.isSearchPressed = NO;
    
//    [self getContactListFromServerForSearchTxt: searchBar.text];
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
    
    [self.exploreSearchBar resignFirstResponder];
    //    self.isSearchPressed = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    exploreSearchBar.hidden = YES;
//    [self.navigationController popViewControllerAnimated:NO];
    //    self.isSearchPressed = NO;
}



#pragma mark -  self define Methods -
/*
 * Function Name: switchViewController
 * Function :
 */


-(void) getSearchDataFromServer
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
                         @"search_txt" :@"text",
                         @"latitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         @"longitude":[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         };
    NSLog(@" search parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"search" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
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
