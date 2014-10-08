//
//  ContactsViewController.h
//  Venture
//
//  Created by Deepak Tomar on 10/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataGenerator.h"

@interface ContactsViewController : UIViewController

{

    NSMutableArray *arrayCountry;
    NSArray *content;
    NSMutableArray *indices;
}


@property (nonatomic,retain)NSMutableDictionary *dictIndexed;
@property(nonatomic,retain)NSDictionary *nameArray;
@property (strong, nonatomic) IBOutlet UITableView *contactTableView;

@end
