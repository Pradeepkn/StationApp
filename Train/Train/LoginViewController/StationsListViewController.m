//
//  StationsListViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StationsListViewController.h"
#import "CoreDataManager.h"
#import "Stations+CoreDataClass.h"
#import "StationsDestinationsCell.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"

static NSString *const kStationsCellIdentifier = @"StationsCell";

@interface StationsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *stationsListTableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    if (self.isStationSelected) {
        self.array = [[CoreDataManager sharedManager] fetchAllStations];
    }else {
        self.array = [[CoreDataManager sharedManager] fetchAllDesignation];
    }
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewFromSuperView)];
    [self.stationsListTableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}

- (void)removeViewFromSuperView {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count +1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationsDestinationsCell *cell = (StationsDestinationsCell *)[tableView dequeueReusableCellWithIdentifier:kStationsCellIdentifier forIndexPath:indexPath];
    cell.selectedStatusBtn.hidden = YES;
    if (indexPath.row == 0) {
        cell.nameLabel.text = self.isStationSelected?@"Select station":@"Select designation";
        tableView.separatorColor = [UIColor darkGrayColor];
        return cell;
    }
    NSInteger selectedIndex;
    if (self.isStationSelected) {
        selectedIndex = [AppUtilityClass getIntValueForKey:kSelectedStationIndex];
        Stations *obj = [self.array objectAtIndex:indexPath.row - 1];
        cell.nameLabel.text = obj.stationName;
    }else {
        selectedIndex = [AppUtilityClass getIntValueForKey:kSelectedDesignationIndex];
        Designation *obj = [self.array objectAtIndex:indexPath.row - 1];
        cell.nameLabel.text = obj.designationName;
    }

    if (selectedIndex == indexPath.row) {
        cell.nameLabel.textColor = RGBACOLOR(79, 141, 233, 1.0);
        cell.selectedStatusBtn.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //For iOS 8, we need the following code to set the cell separator line stretching to both left and right edge of the view.
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isStationSelected) {
        [AppUtilityClass storeIntValue:indexPath.row forKey:kSelectedStationIndex];
    }else {
        [AppUtilityClass storeIntValue:indexPath.row forKey:kSelectedDesignationIndex];
    }
    [self removeViewFromSuperView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
