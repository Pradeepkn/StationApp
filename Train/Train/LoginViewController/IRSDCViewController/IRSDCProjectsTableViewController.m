//
//  IRSDCProjectsTableViewController.m
//  Train
//
//  Created by pradeep on 4/13/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "IRSDCProjectsTableViewController.h"
#import "AppConstants.h"
#import "AppUtilityClass.h"
#import "IRSDCApi.h"
#import "CoreDataManager.h"

@interface IRSDCProjectsTableViewController ()

@property (nonatomic, strong) NSArray *projectsArray;

@end

@implementation IRSDCProjectsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"IRSDC Projects";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(backButtonClicked)];
    [leftButton setImage:[UIImage imageNamed:@"left-arrow"]];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.projectsArray = [[CoreDataManager sharedManager] fetchIRSDCAllStations];
    [self getIRSDCStations];
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getIRSDCStations {
    [AppUtilityClass setToFirstPhaseFlow:YES];
    IRSDCStationsDashboard *irsdcStationsDashboardApi = [IRSDCStationsDashboard new];
    [[APIManager sharedInstance]makeAPIRequestWithObject:irsdcStationsDashboardApi shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        if (!error) {
            self.projectsArray = [[CoreDataManager sharedManager] fetchIRSDCAllStations];
            [self.tableView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.projectsArray.count == 0) {
        tableView.separatorColor = [UIColor clearColor];
    }
    return self.projectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Stations *obj = [self.projectsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = obj.stationName;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.font = [UIFont fontWithName:kProximaNovaRegular size:14];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Stations *obj = [self.projectsArray objectAtIndex:indexPath.row];
    [self.delegate userSelectedIRSDCProjects:obj];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
