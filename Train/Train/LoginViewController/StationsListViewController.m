//
//  StationsListViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/11/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "StationsListViewController.h"
#import "CoreDataManager.h"
#import "StationsDestinationsCell.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"
#import "UIColor+AppColor.h"
#import "GetStationDesignationApi.h"

static NSString *const kStationsCellIdentifier = @"StationsCell";

static NSInteger kTableCellHeight = 48.0f;

@interface StationsListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *stationsListTableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    if (self.isStationSelected) {
//        if (self.isFromRegistration) {
//            self.array = [[CoreDataManager sharedManager] fetchAllSignUpStations];
//        }else {
//            self.array = [[CoreDataManager sharedManager] fetchAllStations];
//        }
        self.array = [[CoreDataManager sharedManager] fetchAllSignUpStations];

        if (self.array.count == 0) {
            [self getStationsAndDesignations];
        }
    }else {
        self.array = [[CoreDataManager sharedManager] fetchAllDesignation];
    }

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewFromSuperView)];
    [self.stationsListTableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
}


- (void)getStationsAndDesignations {
    GetStationDesignationApi *stationsDesignationsApiObject = [GetStationDesignationApi new];
    [[APIManager sharedInstance]makeAPIRequestWithObject:stationsDesignationsApiObject shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        NSDictionary *errorDict = responseDictionary[@"error"];
        NSArray *dataDict = responseDictionary[@"data"];
        if (dataDict.count > 0) {
            if (self.isFromRegistration) {
                self.array = [[CoreDataManager sharedManager] fetchAllSignUpStations];
            }else {
                self.array = [[CoreDataManager sharedManager] fetchAllStations];
            }
            [self.stationsListTableView reloadData];
        }else{
            if (errorDict.allKeys.count > 0) {
                if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                    [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                    return;
                }
            }
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}


- (void)removeViewFromSuperView {
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableCellHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect headerFrame = CGRectMake(15, 0, self.stationsListTableView.bounds.size.width - 30, kTableCellHeight);
    UIView *view = [[UIView alloc] initWithFrame:headerFrame];
    UILabel *selectEntryLabel = [[UILabel alloc] initWithFrame:headerFrame];
    selectEntryLabel.text = self.isStationSelected?@"Select station":@"Select designation";
    selectEntryLabel.font = [UIFont fontWithName:kProximaNovaSemibold size:18.0f];
    selectEntryLabel.textColor = [UIColor whiteColor];
    selectEntryLabel.backgroundColor = [UIColor appRedColor];
    [view addSubview:selectEntryLabel];
    view.backgroundColor = [UIColor appRedColor];
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, kTableCellHeight - 1, self.stationsListTableView.bounds.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:bottomBorder];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationsDestinationsCell *cell = (StationsDestinationsCell *)[tableView dequeueReusableCellWithIdentifier:kStationsCellIdentifier forIndexPath:indexPath];
    cell.selectedStatusBtn.hidden = YES;
    cell.cellControlActionButton.tag = indexPath.row;
    [cell.cellControlActionButton addTarget:self action:@selector(cellControlActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSInteger selectedIndex;
    if (self.isStationSelected) {
        selectedIndex = [AppUtilityClass getIntValueForKey:kSelectedStationIndex];
        Stations *obj = [self.array objectAtIndex:indexPath.row];
        cell.nameLabel.text = obj.stationName;
    }else {
        selectedIndex = [AppUtilityClass getIntValueForKey:kSelectedDesignationIndex];
        Designation *obj = [self.array objectAtIndex:indexPath.row];
        cell.nameLabel.text = obj.designationName;
    }

    if (indexPath.row == (self.array.count - 1)) {
        [AppUtilityClass shapeBottomCell:cell withRadius:6.0];
    }
    if (selectedIndex == indexPath.row) {
        cell.nameLabel.textColor = [UIColor appRedColor];
        cell.nameLabel.font = [UIFont fontWithName:kProximaNovaSemibold size:cell.nameLabel.font.pointSize];
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
    
}

- (void)cellControlActionButtonClicked:(UIButton*)sender {
    if (self.isStationSelected) {
        [AppUtilityClass storeIntValue:sender.tag forKey:kSelectedStationIndex];
    }else {
        [AppUtilityClass storeIntValue:sender.tag forKey:kSelectedDesignationIndex];
    }
    if (self.isStationSelected) {
        Stations *obj = [self.array objectAtIndex:sender.tag];
        [self.delegate userSelectedState:obj];
    }else {
        Designation *obj = [self.array objectAtIndex:sender.tag];
        [self.delegate userSelectedDesignations:obj];
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
