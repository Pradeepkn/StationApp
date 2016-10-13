//
//  HomeViewController.m
//  Train
//
//  Created by Pradeep Narendra on 9/29/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "HomeViewController.h"
#import <JTSActionSheet/JTSActionSheet.h>
#import "GalleryCollectionViewCell.h"
#import "HomeMessagesCell.h"
#import "LeaveMessageCell.h"
#import "OverallStatusCell.h"
#import "WhatsNewCell.h"
#import "LocalizationKeys.h"
#import "SendMessageViewController.h"
#import "AppUtilityClass.h"
#import "StationsStatusCell.h"
#import "StationInfoViewController.h"
#import "AppConstants.h"

static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";
static NSString *const kLeaveMessageCellIdentifier = @"LeaveMessageCellIdentifier";
static NSString *const kHomeMessagesCellIdentifier = @"GlobalMessageCellIdentifier";
static NSString *const kOverallStatusCellIdentifier = @"OverallStatusCellIdentifier";
static NSString *const kWhatsNewCellIdentifier = @"WhatsNewCellIdentifier";

static NSString *const kSendMessageSegueIdentifier = @"SendMessageSegue";
static NSString *const kStationInfoSegueIdentifier = @"StationInfoSegue";
static NSString *const kSationGalleryInfoSegueIdentifier = @"SationGalleryInfoSegue";

const int kTopTableView = 1000;
const int kOverallStatusTableView = 2000;
const int kWhatsNewTableView = 3000;

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate> {
    UIColor *unselectedButtonColor;
    UIColor *selectedButtonColor;
    NSMutableArray *messagesArray;
    NSIndexPath *informationIndexPath;
    NSIndexPath *whatsNewIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *homeTopTableView;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *homeGalleryCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomTabContainerView;
@property (weak, nonatomic) IBOutlet UIButton *informationButton;
@property (weak, nonatomic) IBOutlet UIButton *whatsNewButton;
@property (weak, nonatomic) IBOutlet UIView *whatsNewContainerView;
@property (weak, nonatomic) IBOutlet UITableView *whatsNewTableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedButtonColor = self.informationButton.titleLabel.textColor;
    unselectedButtonColor = self.whatsNewButton.titleLabel.textColor;
    messagesArray = [NSMutableArray arrayWithObjects:@"",@"I congratulate to all DRM's and thier teams for thier efforts to make this project successful and we would like to thank for each and everyone for thier contribution.I congratulate to all DRM's and thier teams for thier efforts to make this project successful and we would like to thank for each and everyone for thier contribution.", @"Tommorrow we will be starting new project", @"Bengaluru station work started", nil];
    [self informationButtonClicked:nil];
}

- (IBAction)informationButtonClicked:(UIButton *)sender {
    whatsNewIndexPath = nil;
    self.whatsNewContainerView.hidden = YES;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.whatsNewButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.homeTopTableView reloadData];
}

- (IBAction)whatsNewButtonClicked:(UIButton *)sender {
    informationIndexPath = nil;
    self.whatsNewContainerView.hidden = NO;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.informationButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.whatsNewTableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kTopTableView) {
        if (indexPath.row == 0) {
            return 60;
        }
        return [AppUtilityClass sizeOfText:[messagesArray objectAtIndex:indexPath.row] widthOfTextView:self.homeTopTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:16.0f]].height + 80;
    } else if (tableView.tag == kOverallStatusTableView) {
        return 40;
    }else if (tableView.tag == kWhatsNewTableView) {
        if (indexPath.row == 0) {
            return 100;
        }
        return 70;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == kTopTableView) {
        return messagesArray.count;
    } else if (tableView.tag == kOverallStatusTableView) {
        return 4;
    }
    return (1+3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == kTopTableView) {
        return 0;
    } else if (tableView.tag == kOverallStatusTableView) {
        return 25;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag != kTopTableView) {
        UIView *view = [UIView new];
        UILabel *overAllStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width - 15, 20)];
        overAllStatusLabel.text = @"Over All Status";
        overAllStatusLabel.font = [UIFont fontWithName:@"Verdana" size:15.0f];
        overAllStatusLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:overAllStatusLabel];
        view.backgroundColor = self.view.backgroundColor;
        return view;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kTopTableView) {
        if (indexPath.row == 0) {
            LeaveMessageCell *leaveAMessageCell = (LeaveMessageCell *)[tableView dequeueReusableCellWithIdentifier:kLeaveMessageCellIdentifier forIndexPath:indexPath];
            tableView.separatorColor = [UIColor clearColor];
            leaveAMessageCell.leaveMessageTextField.delegate = self;
            leaveAMessageCell.leaveMessageTextView.delegate = self;
            informationIndexPath = indexPath;
            return leaveAMessageCell;
        }
            HomeMessagesCell *messagesCell = (HomeMessagesCell *)[tableView dequeueReusableCellWithIdentifier:kHomeMessagesCellIdentifier forIndexPath:indexPath];
            if (indexPath.row == 1) {
                [AppUtilityClass shapeTopCell:messagesCell withRadius:kBubbleRadius];
            }else if(indexPath.row == (messagesArray.count - 1)){
                [AppUtilityClass shapeBottomCell:messagesCell withRadius:kBubbleRadius];
            }
            messagesCell.messageDescriptionLabel.text = [messagesArray objectAtIndex:indexPath.row];
            return messagesCell;
        } else if (tableView.tag == kOverallStatusTableView){
        StationsStatusCell *overallStatusCell = (StationsStatusCell *)[tableView dequeueReusableCellWithIdentifier:kOverallStatusCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [AppUtilityClass shapeTopCell:overallStatusCell withRadius:kBubbleRadius];
            overallStatusCell.statusColor.backgroundColor = [UIColor redColor];
        }else if (indexPath.row == 3) {
            [AppUtilityClass shapeBottomCell:overallStatusCell withRadius:kBubbleRadius];
            tableView.separatorColor = [UIColor clearColor];
        }
        overallStatusCell.messageButton.tag = indexPath.row;
        [overallStatusCell.messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        overallStatusCell.infoButton.tag = indexPath.row;
        [overallStatusCell.infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        overallStatusCell.stationStatusActionButton.tag = indexPath.row;
        [overallStatusCell.stationStatusActionButton addTarget:self action:@selector(stationStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return overallStatusCell;
    }else if (tableView.tag == kWhatsNewTableView) {
        if (indexPath.row == 0) {
            LeaveMessageCell *leaveAMessageCell = (LeaveMessageCell *)[tableView dequeueReusableCellWithIdentifier:kLeaveMessageCellIdentifier forIndexPath:indexPath];
            whatsNewIndexPath = indexPath;
            tableView.separatorColor = [UIColor clearColor];
            return leaveAMessageCell;
        }
        WhatsNewCell *whatsNewCell = (WhatsNewCell *)[tableView dequeueReusableCellWithIdentifier:kWhatsNewCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 1) {
            [AppUtilityClass shapeTopCell:whatsNewCell withRadius:kBubbleRadius];
        }else if(indexPath.row == 3){
            [AppUtilityClass shapeBottomCell:whatsNewCell withRadius:kBubbleRadius];
        }
        return whatsNewCell;
    }
    return [UITableViewCell new];
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

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger count = 4;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)cell {
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self launchImage];
}

- (void)launchImage {
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePickerController.delegate = self;
        
        JTSActionSheetTheme *theme = [JTSActionSheetTheme defaultTheme];
        theme.normalButtonColor = [UIColor redColor];
        theme.destructiveButtonColor = [UIColor blackColor];
        
        NSMutableArray *actionSheetItemsArray = [NSMutableArray new];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            JTSActionSheetItem *camera = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kUploadImageActionSheetButtonCamera, nil) action:^{
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } isDestructive:YES];
            
            JTSActionSheetItem *gallery = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kUploadImageActionSheetButtonGallery, nil) action:^{
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } isDestructive:YES];
            
            [actionSheetItemsArray addObjectsFromArray:@[camera,gallery]];
        } else {
            JTSActionSheetItem *gallery = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kUploadImageActionSheetButtonGallery, nil) action:^{
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            } isDestructive:YES];
            
            [actionSheetItemsArray addObjectsFromArray:@[gallery]];
        }
        
        JTSActionSheetItem *cancel = [JTSActionSheetItem itemWithTitle:NSLocalizedString(kGlobalButtonCancel, nil) action:nil isDestructive:NO];
        
        // Create & Show an Action Sheet
        JTSActionSheet *sheet = [[JTSActionSheet alloc] initWithTheme:theme title:nil actionItems:actionSheetItemsArray cancelItem:cancel];
        [sheet showInView:self.view];
    }
}

- (void)messageButtonClicked:(UIButton*)sender {
    [self performSegueWithIdentifier:kSendMessageSegueIdentifier sender:self];
}

- (void)infoButtonClicked:(UIButton*)sender {
    [self performSegueWithIdentifier:kSationGalleryInfoSegueIdentifier sender:self];
}

- (void)stationStatusButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:kStationInfoSegueIdentifier sender:self];
}

#pragma mark - Image picker delegates
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    LeaveMessageCell *messageCell;
    NSString *placeHolderText = @"";
    if (informationIndexPath) {
        messageCell = (LeaveMessageCell *)[self.homeTopTableView cellForRowAtIndexPath:informationIndexPath];
        placeHolderText = @"Leave a message";
    }else {
        messageCell = (LeaveMessageCell *)[self.whatsNewTableView cellForRowAtIndexPath:whatsNewIndexPath];
        placeHolderText = @"Write an update";
    }
    if (textView.text.length > 0) {
        messageCell.leaveMessageTextField.placeholder = @"";
    }else {
        messageCell.leaveMessageTextField.placeholder = placeHolderText;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
