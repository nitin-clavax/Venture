//
//  ExploreViewController.h
//  Venture
//
//  Created by Deepak Tomar on 10/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ExploreViewController : UIViewController<CLLocationManagerDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *locationMapView;
@property (strong, nonatomic) IBOutlet UITableView *exploreTableView;

@property (strong, nonatomic) IBOutlet UISearchBar *exploreSearchBar;


@property(strong,nonatomic) NSMutableArray *nearByUserDataArray;

@end
