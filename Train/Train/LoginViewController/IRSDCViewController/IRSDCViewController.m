//
//  IRSDCViewController.m
//  Train
//
//  Created by pradeep on 4/5/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "IRSDCViewController.h"
#import "AppConstants.h"
#import "UIColor+AppColor.h"
#import "IRSDCTableViewCell.h"
#import "AppUtilityClass.h"

static NSString *kIRSDCCellIdentifier = @"IRSDCCellIdentifier";

@interface IRSDCViewController () {
    NSInteger selectedSection;
}

@property (weak, nonatomic) IBOutlet UITableView *irsdcTableView;
@property (strong, nonatomic) NSMutableArray *irsdcProjectArray;
@property (strong, nonatomic) NSMutableArray *irsdcStreamsArray;
@property (strong, nonatomic) NSMutableArray *irsdcsubStreamsArray;

@end

@implementation IRSDCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedSection = -1;
    self.irsdcStreamsArray = [NSMutableArray arrayWithObjects:@"Streams1", @"Streams2", nil];
    self.irsdcsubStreamsArray = [NSMutableArray arrayWithObjects:@"sub stream1", nil];
    // Do any additional setup after loading the view.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.irsdcStreamsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == selectedSection) {
        return self.irsdcStreamsArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableSectionCellHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    IRSDCTableViewCell *cell = (IRSDCTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"IRSDCTableViewCell" owner:nil options:nil][0];
    [cell.streamName setTitle:@"Stream" forState:UIControlStateNormal];
    cell.streamName.tag = section;
    [cell.streamName addTarget:self action:@selector(streamSectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AppUtilityClass shapeTopCell:cell withRadius:6.0];
        });
    }
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = @"sub stream";
    if (self.irsdcStreamsArray.count == indexPath.section && self.irsdcsubStreamsArray.count == indexPath.row - 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [AppUtilityClass shapeBottomCell:cell.contentView withRadius:6.0];
        });
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

- (void)streamSectionClicked:(UIButton *)sender {
    selectedSection = sender.tag;
    [self.irsdcTableView reloadData];
    NSLog(@"Sender Section = %ld", sender.tag);
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
