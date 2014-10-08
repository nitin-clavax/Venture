//
//  HomeViewController.m
//  Venture
//
//  Created by Deepak Tomar on 08/09/14.
//  Copyright (c) 2014 Deepak Tomar. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ChatsViewController.h"
#import "ExploreViewController.h"
#import "ProjectsViewController.h"
#import "ContactsViewController.h"
#import "MyProfileViewController.h"

#import "AddProjectViewController.h"
#import "AddContactViewController.h"


@interface HomeViewController (){

}

@property (strong, nonatomic) IBOutlet UIImageView *chatBtnBG;
@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UIImageView *exploreBtnBG;
@property (strong, nonatomic) IBOutlet UIButton *exploreBtn;
@property (strong, nonatomic) IBOutlet UIImageView *projectsBtnBG;
@property (strong, nonatomic) IBOutlet UIButton *projectBtn;
@property (strong, nonatomic) IBOutlet UIImageView *contactsBtnBG;
@property (strong, nonatomic) IBOutlet UIButton *contactBtn;


@property (strong, nonatomic) IBOutlet UIView *searchView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabViewtopSpaceConstraint;
@end

@implementation HomeViewController
@synthesize currentViewController,chatCountLbl;

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
//    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    //chatcount
    
    chatCountLbl.layer.cornerRadius = chatCountLbl.frame.size.height/2;
    
    
    //user image view
    
//    UIImageView *itemImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 35, 35.0f)];
//    itemImageView.layer.borderWidth = 1.0f;
//    itemImageView.layer.cornerRadius = itemImageView.frame.size.height/2;
//    itemImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    itemImageView.layer.masksToBounds = NO;
//    itemImageView.clipsToBounds = YES;
//    itemImageView.image = [UIImage imageNamed:@"profile_pic.png"];
//    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemImageView];
//    [barBackButtonItem action:@selector(showMyProfileView:)];
    
    
    UIButton *userImageButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35.0f)];
    
    userImageButton.layer.borderWidth = 1.0f;
    userImageButton.layer.cornerRadius = userImageButton.frame.size.height/2;
    userImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    userImageButton.layer.masksToBounds = NO;
    userImageButton.clipsToBounds = YES;
	[userImageButton setImage:[UIImage imageNamed:@"profile_pic.png"] forState:UIControlStateNormal];
	[userImageButton addTarget:self action:@selector(showMyProfileView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userImageButton];
    self.navigationItem.leftBarButtonItem = sortingBarButtonItem;
    self.navigationItem.hidesBackButton = YES;

    
//    UIButton *filterButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 4, 18)];
//	[filterButton setImage:[UIImage imageNamed:@"search_dots.png"] forState:UIControlStateNormal];
//	[filterButton addTarget:self action:@selector(showFilterActionSheet:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *sortingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
//    [buttons addObject:sortingBarButtonItem];
//    
//	UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar:)];
//    [buttons addObject:searchButtonItem];
//    
//    
//    self.navigationItem.rightBarButtonItems = buttons;
    //initially show the chat view
    [self showChatViewComponents];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillDisappear:(BOOL)animated
{
    self.title = @"";
}


-(void)viewDidAppear:(BOOL)animated
{
    self.title = @"Venture";
}

#pragma mark -  UIActionSheetDelegate define Methods -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSLog(@"%d",buttonIndex);
    NSLog(@"%@",buttonTitle);

    if  ([buttonTitle isEqualToString:@"Facebook"]) {
        NSLog(@"Facebook");
    
        
    }
    if ([buttonTitle isEqualToString:@"Contacts"]) {
        NSLog(@"Contacts");
      
    }
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            if ([button.titleLabel.text isEqualToString:@"Male Only"]) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}


#pragma mark -  UISearchBarDelegate define Methods -


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleSearch:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    [self handleSearch:searchBar];
}

- (void)handleSearch:(UISearchBar *)searchBar {
    NSLog(@"User searched for %@", searchBar.text);
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    
    [self getNearByUserFromServerForSearchTxt : searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
    
    [self.searchView setHidden:YES];
    self.navigationController.navigationBarHidden = NO;
    
    _tabViewtopSpaceConstraint.constant = 0;
    [_exploreBtn setTitle:@"Explore" forState:UIControlStateNormal];


}

#pragma mark -  self define Methods -
/*
 * Function Name: switchViewController
 * Function :
 */



-(void)switchViewController:(UIViewController*) destinationViewController

{
    
    [_chatBtnBG setBackgroundColor:[UIColor clearColor]];
    [_exploreBtnBG setBackgroundColor:[UIColor clearColor]];
    [_projectsBtnBG setBackgroundColor:[UIColor clearColor]];
    [_contactsBtnBG setBackgroundColor:[UIColor clearColor]];
    [_chatBtn setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];
    [_exploreBtn setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];
    [_projectBtn setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];
    [_contactBtn setTitleColor:UIColorFromRGB(0x4F4F4F) forState:UIControlStateNormal];


    if (currentViewController)

    {
        [currentViewController willMoveToParentViewController:nil];
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
    }



    destinationViewController.view.frame = self.container.bounds;

    [self addChildViewController:destinationViewController];

    [self.container addSubview:destinationViewController.view];

    [destinationViewController didMoveToParentViewController:self];

    currentViewController = destinationViewController;

}


/*
 * Function Name: showChatViewComponents
 * Function : to show the chat view Components
 */


-(void) showChatViewComponents
{
    [_chatBtnBG setBackgroundColor:UIColorFromRGB(0x00b863)];
    [_chatBtn setTitleColor:UIColorFromRGB(0x00b863) forState:UIControlStateNormal];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    [buttons addObject:addButtonItem];
    
    self.navigationItem.rightBarButtonItems = buttons;

//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];

}

/*
 * Function Name: showExploreViewComponents
 * Function : to show the Explore view Components
 */


-(void) showExploreViewComponents
{
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    UIButton *filterButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 4, 18)];
	[filterButton setImage:[UIImage imageNamed:@"search_dots.png"] forState:UIControlStateNormal];
	[filterButton addTarget:self action:@selector(showFilterActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortingBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:filterButton];
    [buttons addObject:sortingBarButtonItem];
    
	UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchBar:)];
    [buttons addObject:searchButtonItem];
    
    
    self.navigationItem.rightBarButtonItems = buttons;
    
}


-(void) showMyProfileView :(id) sender{
    
    
    MyProfileViewController *myProfileView = (MyProfileViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
    [self.navigationController pushViewController:myProfileView animated:YES];

}

-(void) showSearchBar :(id) sender{
    
    
    [self.searchView setHidden:NO];
    self.navigationController.navigationBarHidden = YES;
    
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.showsCancelButton = YES;
    searchBar.translucent = NO;
    [searchBar setTintColor:[UIColor whiteColor]];
    searchBar.backgroundColor = UIColorFromRGB(0x00b863);
    
    
    _tabViewtopSpaceConstraint.constant = 44;
    [_exploreBtn setTitle:@"Search" forState:UIControlStateNormal];

    
    
    
//   [self.navigationController.navigationBar   addSubview:searchBar];
    // create the Search Display Controller with the above Search Bar
//    self.controller = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
//    self.controller.searchResultsDataSource = self;
//    self.controller.searchResultsDelegate = self;
}

/*
 * Function Name: showFilterActionSheet
 * Function : to show the Action sheet view
 */


-(void)showFilterActionSheet :(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"View All"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Male Only", @"Female Only",
                                  nil];
    
//     [actionSheet showFromBarButtonItem:[sender superview] animated:NO];

    [actionSheet showInView:self.view];
    
}


/*
 * Function Name: showProjectsViewComponents
 * Function : to show the project view Components
 */

-(void) showProjectsViewComponents
{
    
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
    
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showAddProjectView:)];
    [buttons addObject:addButtonItem];
    
    
    self.navigationItem.rightBarButtonItems = buttons;
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
    
    
    
}

/*
 * Function Name: showContactViewComponents
 * Function : to show the Contact view Components
 */

-(void) showContactViewComponents
{
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
    
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(showAddContactView:)];
    [buttons addObject:addButtonItem];
    
    
    self.navigationItem.rightBarButtonItems = buttons;
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    
    
}

-(void)showAddProjectView:(id)sender
{

    
//    return;
    
    AddProjectViewController *addProjectView = (AddProjectViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddProjectViewController"];
    [self.navigationController pushViewController:addProjectView animated:YES];
    
}


-(void) showAddContactView : (id)sender
{

    
    AddContactViewController *addProjectView = (AddContactViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddContactViewController"];
    [self presentViewController:addProjectView animated:NO completion:nil];

//    [self.navigationController pushViewController:addProjectView animated:YES];

}




/*
 * Function Name: getContactListFromServer
 * Function : get the user Contacts data from the server
 */


-(void) getNearByUserFromServerForSearchTxt :(NSString *) searchTxt
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
                         @"request_type" :@"search",
                         @"search_txt" : searchTxt,
                         @"latitude":@"22.27467400",//[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         @"longitude":@"114.15370300"//[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude],
                         };
    NSLog(@" search parameters ---> %@",dict);
    
    
    //    return;
    [manager POST:@"search" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject){
        
        //Hide loader
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject%@",responseObject);
        
        
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"])
        {
            [self.searchView setHidden:YES];
            self.navigationController.navigationBarHidden = NO;
            _tabViewtopSpaceConstraint.constant = 0;
            [_exploreBtn setTitle:@"Explore" forState:UIControlStateNormal];
            ExploreViewController *exploreView = (ExploreViewController *)currentViewController;
            exploreView.nearByUserDataArray = [[responseObject objectForKey:@"users"] mutableCopy];
            [exploreView.exploreTableView reloadData];
            
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



- (IBAction)chatBtnTapped:(id)sender {
    
//    UIButton *btn = (UIButton *) sender;
    NSLog(@"%@",currentViewController);
    [self showChatViewComponents];
    if (![currentViewController isKindOfClass:[ChatsViewController class]]) {

        ChatsViewController *chatView = (ChatsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChatsViewController"];
//    UIBezierPath *bezierPath;
    // Draw bottom line
//    bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
//    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame)-10)];
//    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
//    [bezierPath setLineWidth:1.0];
//    [bezierPath stroke];

        [self switchViewController:chatView];
        
        [_chatBtnBG setBackgroundColor:UIColorFromRGB(0x00b863)];
        [_chatBtn setTitleColor:UIColorFromRGB(0x00b863) forState:UIControlStateNormal];

        
    }
    

}

- (IBAction)exploreBtnTapped:(id)sender {

    [self showExploreViewComponents];
    if (![currentViewController isKindOfClass:[ExploreViewController class]]) {
       
        ExploreViewController *exploreView = (ExploreViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ExploreViewController"];
        [self switchViewController:exploreView];
        
        [_exploreBtnBG setBackgroundColor:UIColorFromRGB(0x00b863)];
        [_exploreBtn setTitleColor:UIColorFromRGB(0x00b863) forState:UIControlStateNormal];

    }

}

- (IBAction)projectsBtnTapped:(id)sender {
    
    [self showProjectsViewComponents];
    
    if (![currentViewController isKindOfClass:[ProjectsViewController class]]) {
        
        

        ProjectsViewController *projectView = (ProjectsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ProjectsViewController"];
        [self switchViewController:projectView];
        
        [_projectsBtnBG setBackgroundColor:UIColorFromRGB(0x00b863)];
        [_projectBtn setTitleColor:UIColorFromRGB(0x00b863) forState:UIControlStateNormal];
    }
}

- (IBAction)contactsBtnTapped:(id)sender {
    
    [self showContactViewComponents];
    if (![currentViewController isKindOfClass:[ContactsViewController class]]) {

        ContactsViewController *contactView = (ContactsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ContactsViewController"];
        [self switchViewController:contactView];
        
        [_contactsBtnBG setBackgroundColor:UIColorFromRGB(0x00b863)];
        [_contactBtn setTitleColor:UIColorFromRGB(0x00b863) forState:UIControlStateNormal];

    }
}
@end
