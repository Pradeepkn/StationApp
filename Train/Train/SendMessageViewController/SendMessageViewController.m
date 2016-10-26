//
//  SendMessageViewController.m
//  Train
//
//  Created by Pradeep Narendra on 10/2/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "SendMessageViewController.h"
#import "HomeMessagesCell.h"
#import "AppUtilityClass.h"
#import "AppConstants.h"

static NSString *const kHomeMessagesCellIdentifier = @"MessageCellIdentifier";

static NSString *const kFirstMessage = @"Congratulations to you and your team for the good performance. Wish you success in this endeavor. \n\nRegards,";
static NSString *const kSecondMessage = @"Kindly intervene into the current status of your redevelopment initiatives and resolve all pending delays. \n\nRegards,";
static NSString *const kThirdMessage = @"Custom";

@interface SendMessageViewController (){
    NSArray *prePopulatedArray;
}

@property (weak, nonatomic) IBOutlet UITableView *sendMessagesTableView;

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    prePopulatedArray = [NSArray arrayWithObjects:kFirstMessage,kSecondMessage, kThirdMessage, nil];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)backButtocClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = [AppUtilityClass sizeOfText:[prePopulatedArray objectAtIndex:indexPath.row] widthOfTextView:self.sendMessagesTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:18.0f]].height;
    return rowHeight>40?rowHeight:40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return prePopulatedArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        HomeMessagesCell *messagesCell = (HomeMessagesCell *)[tableView dequeueReusableCellWithIdentifier:kHomeMessagesCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [AppUtilityClass shapeTopCell:messagesCell withRadius:kBubbleRadius];
        }else if (indexPath.row == (prePopulatedArray.count - 1)) {
            [AppUtilityClass shapeBottomCell:messagesCell withRadius:kBubbleRadius];
        }
        messagesCell.messageDescriptionLabel.text = [prePopulatedArray objectAtIndex:indexPath.row];
        messagesCell.messageDescriptionLabel.numberOfLines = 0;
        messagesCell.messageDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        return messagesCell;
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
    NSString *messageBody;
    messageBody = [prePopulatedArray objectAtIndex:indexPath.row];
    if (indexPath.row == (prePopulatedArray.count - 1)) {
        messageBody = @" ";
    }
    NSString *sms = [NSString stringWithFormat:@"sms:&body=%@", messageBody];
    NSString *url = [sms stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
