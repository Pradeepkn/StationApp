//
//  HomeViewController.m
//  Train
//
//  Created by Pradeep Narendra on 9/29/16.
//  Copyright © 2016 Pradeep. All rights reserved.
//

#import "HomeViewController.h"
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
#import "StationsListViewController.h"
#import "CoreDataManager.h"
#import "PostOnWallApi.h"
#import "GetWallMessagesApi.h"
#import "WhatsNewMessagesApi.h"
#import "SendWhatsNewMessage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "StationGalleryInfoViewController.h"
#import "UIColor+AppColor.h"
#import "ImagesGalleryViewController.h"

static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";
static NSString *const kLeaveMessageCellIdentifier = @"LeaveMessageCellIdentifier";
static NSString *const kHomeMessagesCellIdentifier = @"GlobalMessageCellIdentifier";
static NSString *const kOverallStatusCellIdentifier = @"OverallStatusCellIdentifier";
static NSString *const kWhatsNewCellIdentifier = @"WhatsNewCellIdentifier";

static NSString *const kSendMessageSegueIdentifier = @"SendMessageSegue";
static NSString *const kStationInfoSegueIdentifier = @"StationInfoSegue";
static NSString *const kSationGalleryInfoSegueIdentifier = @"SationGalleryInfoSegue";

static NSString *const kLeaveAMessageKey = @"Leave a message";
static NSString *const kWriteAnUpdate = @"Write an update";

const int kTopTableView = 1000;
const int kOverallStatusTableView = 2000;
const int kWhatsNewTableView = 3000;

const int kLeaveAMessageTag = 101;
const int kWriteUpdateMessageTag = 201;

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, StationDesignationDelegate, NSFetchedResultsControllerDelegate> {
    UIColor *unselectedButtonColor;
    UIColor *selectedButtonColor;
    NSMutableArray *messagesArray;
    NSIndexPath *informationIndexPath;
    NSIndexPath *whatsNewIndexPath;
    NSInteger messagesCount;
    NSInteger stationsCount;
    NSInteger whatsNewMessagesCount;
}
@property (weak, nonatomic) IBOutlet UIButton *selectStationButton;

@property (weak, nonatomic) IBOutlet UIView *topInputContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectStationHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImage;
@property (weak, nonatomic) IBOutlet UIButton *profileNameButton;
@property (weak, nonatomic) IBOutlet UITextField *placeHolderTextField;
@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topInputViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;


@property (weak, nonatomic) IBOutlet UITableView *homeTopTableView;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *homeGalleryCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomTabContainerView;
@property (weak, nonatomic) IBOutlet UIButton *informationButton;
@property (weak, nonatomic) IBOutlet UIButton *whatsNewButton;
@property (weak, nonatomic) IBOutlet UIView *whatsNewContainerView;
@property (weak, nonatomic) IBOutlet UITableView *whatsNewTableView;

@property (strong, nonatomic) LeaveMessageCell *leaveAMessageCell;
@property (strong, nonatomic) LeaveMessageCell *writeAnUpdateMessageCell;

@property (strong, nonatomic) User *loggedInUser;
@property (strong, nonatomic) Stations *selectedStation;
@property (strong, nonatomic) Stations *stationInfoSelectedStation;

@property (nonatomic, strong) NSFetchedResultsController *messagesFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *stationsFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *imagesFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *whatsNewFetchedResultsController;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedButtonColor = self.informationButton.titleLabel.textColor;
    unselectedButtonColor = self.whatsNewButton.titleLabel.textColor;
    self.loggedInUser = [[CoreDataManager sharedManager] fetchLogedInUser];
    [self initializeMessagesFetchedResultsController];
    [self informationButtonClicked:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getHomeMessages];
    [self getWhatsNewMessages];
    self.homeTopTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.homeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.whatsNewTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.profileNameButton setImage:nil forState:UIControlStateNormal];
    [self.profileNameButton setTitle:[AppUtilityClass getProfileIconNameForProfileName:self.loggedInUser.email] forState:UIControlStateNormal];
    [self addStatusBar];
    self.homeTableView.scrollEnabled = NO;
}

- (void)addStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor  =  [UIColor appRedColor];
    [self.view addSubview:statusBarView];
}

- (IBAction)informationButtonClicked:(UIButton *)sender {
    self.whatsNewContainerView.hidden = YES;
    self.downArrowImage.hidden = YES;
    self.selectStationButton.hidden = YES;
    self.clearButton.hidden = YES;
    self.topInputViewHeightConstraint.constant -= 40.0f;
    self.selectStationHeightConstraint.constant = 0.0f;
    self.messageInputTextView.tag = kLeaveAMessageTag;
    self.placeHolderTextField.placeholder = kLeaveAMessageKey;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.whatsNewButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.whatsNewButton setImage:[UIImage imageNamed:@"whats-news-unactive"] forState:UIControlStateNormal];
    [self.informationButton setImage:[UIImage imageNamed:@"information-active"] forState:UIControlStateNormal];
    [self.homeTopTableView reloadData];
}

- (IBAction)whatsNewButtonClicked:(UIButton *)sender {
    self.whatsNewContainerView.hidden = NO;
    self.downArrowImage.hidden = NO;
    self.selectStationButton.hidden = NO;
    self.clearButton.hidden = YES;
    self.topInputViewHeightConstraint.constant += 40.0f;
    self.selectStationHeightConstraint.constant = 40.0f;
    self.messageInputTextView.tag = kWriteUpdateMessageTag;
    self.placeHolderTextField.placeholder = kWriteAnUpdate;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.informationButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.informationButton setTintColor:unselectedButtonColor];
    [self.whatsNewButton setImage:[UIImage imageNamed:@"whats-news-active"] forState:UIControlStateNormal];
    [self.informationButton setImage:[UIImage imageNamed:@"information-unactive"] forState:UIControlStateNormal];
}

- (IBAction)selectStationButtonAction:(UIButton *)sender {
    StationsListViewController *stationsListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StationsListViewController"];
    stationsListVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    stationsListVC.isStationSelected = YES;
    stationsListVC.delegate = self;
    [self presentViewController:stationsListVC animated:YES completion:^{
        ;
    }];
}

- (IBAction)clearButtonSelected:(UIButton *)sender {
    sender.hidden = YES;
    [self resetPlaceHolderText];
    [self.view endEditing:YES];
}

- (void)resetPlaceHolderText {
    self.messageInputTextView.text = @"";
    self.placeHolderTextField.text = @"";
    NSString *placeHolderText = @"";
    
    if (self.messageInputTextView.tag == kLeaveAMessageTag) {
        placeHolderText = kLeaveAMessageKey;
    }else {
        placeHolderText = kWriteAnUpdate;
    }
    self.placeHolderTextField.placeholder = placeHolderText;
}

- (void)getHomeMessages {
    __weak HomeViewController *weakSelf = self;
    GetWallMessagesApi *wallMessagesApiObject = [GetWallMessagesApi new];
    wallMessagesApiObject.email = [AppUtilityClass getUserEmail];
    [[APIManager sharedInstance]makeAPIRequestWithObject:wallMessagesApiObject shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        if (!error) {
            [weakSelf.homeGalleryCollectionView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)getWhatsNewMessages {
    WhatsNewMessagesApi *whatsNewMessageApiObject = [WhatsNewMessagesApi new];
    whatsNewMessageApiObject.email = [AppUtilityClass getUserEmail];
    [[APIManager sharedInstance]makeAPIRequestWithObject:whatsNewMessageApiObject shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response = %@", responseDictionary);
        if (!error) {
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)postMessagesOnWall:(NSString *)message {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak HomeViewController *weakSelf = self;
    PostOnWallApi *postOnWallApiObject = [PostOnWallApi new];
    postOnWallApiObject.email = [AppUtilityClass getUserEmail];
    postOnWallApiObject.designation = self.loggedInUser.designation;
    postOnWallApiObject.message = message;
    
    [[APIManager sharedInstance]makePostAPIRequestWithObject:postOnWallApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self getHomeMessages];
                                              }else{
                                                  if (errorDict.allKeys.count > 0) {
                                                      if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                                                          [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                                                      }else {
                                                          [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                                      }
                                                  };
                                              }
                                          }];
}

- (void)postWhatsNewMessage:(NSString *)message {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak HomeViewController *weakSelf = self;
    SendWhatsNewMessage *postOnWallApiObject = [SendWhatsNewMessage new];
    postOnWallApiObject.email = [AppUtilityClass getUserEmail];
    postOnWallApiObject.stationId = self.selectedStation.stationId;
    postOnWallApiObject.message = message;
    
    [[APIManager sharedInstance]makePostAPIRequestWithObject:postOnWallApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self getWhatsNewMessages];
                                              }else{
                                                  if (errorDict.allKeys.count > 0) {
                                                      if ([AppUtilityClass getErrorMessageFor:errorDict]) {
                                                          [AppUtilityClass showErrorMessage:[AppUtilityClass getErrorMessageFor:errorDict]];
                                                      }else {
                                                          [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
                                                      }
                                                  }
                                              }
                                          }];
}

- (void)initializeMessagesFetchedResultsController
{
    NSManagedObjectContext *moc = [[CoreDataManager sharedManager] managedObjectContext];
    
    [self setMessagesFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getMessagesFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self messagesFetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self messagesFetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    [self setStationsFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getStationsFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self stationsFetchedResultsController] setDelegate:self];
    
    if (![[self stationsFetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    [self setImagesFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getHomeImagesFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self imagesFetchedResultsController] setDelegate:self];
    
    if (![[self imagesFetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    [self setWhatsNewFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getWhatsNewMessagesFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self whatsNewFetchedResultsController] setDelegate:self];
    
    if (![[self whatsNewFetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (NSFetchRequest *)getMessagesFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Messages"];
    NSSortDescriptor *message = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    [request setSortDescriptors:@[message]];
    return request;
}

- (NSFetchRequest *)getStationsFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Stations"];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"stationName" ascending:YES];
    [request setSortDescriptors:@[stations]];
    return request;
}

- (NSFetchRequest *)getHomeImagesFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeImages"];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"insertDate" ascending:YES];
    [request setSortDescriptors:@[stations]];
    return request;
}

- (NSFetchRequest *)getWhatsNewMessagesFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WhatsNewMessages"];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    [request setSortDescriptors:@[stations]];
    return request;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kTopTableView) {
        Messages *object = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.message widthOfTextView:self.homeTopTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:18.0f]].height + 80;
    } else if (tableView.tag == kOverallStatusTableView) {
        return 40;
    }else if (tableView.tag == kWhatsNewTableView) {
        WhatsNewMessages *object = [[self whatsNewFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.message widthOfTextView:self.whatsNewTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:18.0f]].height + 60;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == kTopTableView) {
        id< NSFetchedResultsSectionInfo> sectionInfo = [[self messagesFetchedResultsController] sections][section];
        messagesCount = [sectionInfo numberOfObjects];
        return messagesCount ;
    } else if (tableView.tag == kOverallStatusTableView) {
        id< NSFetchedResultsSectionInfo> sectionInfo = [[self stationsFetchedResultsController] sections][section];
        return stationsCount = [sectionInfo numberOfObjects];
    }
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self whatsNewFetchedResultsController] sections][section];
    return whatsNewMessagesCount = [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == kOverallStatusTableView) {
        return 25;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == kOverallStatusTableView) {
        UIView *view = [UIView new];
        UILabel *overAllStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width - 15, 20)];
        overAllStatusLabel.text = @"Overall Status";
        overAllStatusLabel.font = [UIFont fontWithName:kProximaNovaSemibold size:16.0f];
        overAllStatusLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:overAllStatusLabel];
        view.backgroundColor = self.view.backgroundColor;
        return view;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kTopTableView) {
        HomeMessagesCell *messagesCell = (HomeMessagesCell *)[tableView dequeueReusableCellWithIdentifier:kHomeMessagesCellIdentifier forIndexPath:indexPath];
        [self configureMessagesCell:messagesCell atIndexPath:indexPath];
        return messagesCell;
    } else if (tableView.tag == kOverallStatusTableView){
        StationsStatusCell *overallStatusCell = (StationsStatusCell *)[tableView dequeueReusableCellWithIdentifier:kOverallStatusCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [AppUtilityClass shapeTopCell:overallStatusCell withRadius:kBubbleRadius];
        }
        if (indexPath.row == stationsCount - 1) {
            [AppUtilityClass shapeBottomCell:overallStatusCell withRadius:kBubbleRadius];
            tableView.separatorColor = [UIColor clearColor];
        }
        overallStatusCell.messageButton.tag = indexPath.row;
        [overallStatusCell.messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        overallStatusCell.infoButton.tag = indexPath.row;
        [overallStatusCell.infoButton addTarget:self action:@selector(infoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        overallStatusCell.stationStatusActionButton.tag = indexPath.row;
        [overallStatusCell.stationStatusActionButton addTarget:self action:@selector(stationStatusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self configureStationsCell:overallStatusCell atIndexPath:indexPath];
        return overallStatusCell;
    }else if (tableView.tag == kWhatsNewTableView) {
        WhatsNewCell *whatsNewCell = (WhatsNewCell *)[tableView dequeueReusableCellWithIdentifier:kWhatsNewCellIdentifier forIndexPath:indexPath];
        [self configureWhatsNewCell:whatsNewCell atIndexPath:indexPath];
        return whatsNewCell;
    }
    return [UITableViewCell new];
}

- (void)configureMessagesCell:(HomeMessagesCell *)messagesCell atIndexPath:(NSIndexPath*)indexPath
{
    Messages *object = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
    messagesCell.userNameLabel.text = object.username?:object.messageId;
    messagesCell.messageDescriptionLabel.text = object.message;
    messagesCell.headerLabel.text = object.designation;
    messagesCell.messageDateLabel.text = [AppUtilityClass getHomeMessageDate:object.createDate];
    if (object.deleteMessage) {
        messagesCell.swipeButton.hidden = NO;
    }else {
        messagesCell.swipeButton.hidden = YES;
    }
}

- (void)configureStationsCell:(StationsStatusCell *)stationsCell atIndexPath:(NSIndexPath*)indexPath
{
    Stations *object = [[self stationsFetchedResultsController] objectAtIndexPath:indexPath];
    stationsCell.stationLabel.text = object.stationName;
    switch (object.statusColor) {
        case kNotCompleted:
            stationsCell.statusColor.backgroundColor = [UIColor redColor];
            break;
        case kCompleted:
            stationsCell.statusColor.backgroundColor = [UIColor greenColor];
            break;
            
        default:
            break;
    }
}

- (void)configureWhatsNewCell:(WhatsNewCell *)whatsNewCell atIndexPath:(NSIndexPath*)indexPath
{
    WhatsNewMessages *object = [[self whatsNewFetchedResultsController] objectAtIndexPath:indexPath];
    whatsNewCell.stationLabel.text = object.stationName;
    whatsNewCell.newsTextLabel.text = object.message;
    whatsNewCell.dateLabel.text = [AppUtilityClass getWhatsNewMessageDate:object.createDate];
    whatsNewCell.userNameLabel.text = object.username;
    if (object.deleteMessage) {
        whatsNewCell.swipeButton.hidden = NO;
    }else {
        whatsNewCell.swipeButton.hidden = YES;
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    if ([tableView isEqual:self.homeTopTableView]) {
        Messages *messageObject = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        if (messageObject.deleteMessage) {
            return YES;
        }
        return NO;
    }else if ([tableView isEqual:self.whatsNewTableView]) {
        WhatsNewMessages *whatsNewMessageObject = [[self whatsNewFetchedResultsController] objectAtIndexPath:indexPath];
        if (whatsNewMessageObject.deleteMessage) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.homeTopTableView]) {
        Messages *messageObject = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        [[CoreDataManager sharedManager] deleteWallMessage:messageObject];
    }
    else if ([tableView isEqual:self.whatsNewTableView]) {
        WhatsNewMessages *whatsNewMessageObject = [[self whatsNewFetchedResultsController] objectAtIndexPath:indexPath];
        [[CoreDataManager sharedManager] deleteWhatsNewMessage:whatsNewMessageObject];
    }
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        [[self homeTopTableView] beginUpdates];
    }else if ([controller isEqual:_whatsNewFetchedResultsController]) {
        [[self whatsNewTableView] beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self homeTopTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self homeTopTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeMove:
            case NSFetchedResultsChangeUpdate:
                break;
        }
    }else if ([controller isEqual:_whatsNewFetchedResultsController]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self whatsNewTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self whatsNewTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeMove:
            case NSFetchedResultsChangeUpdate:
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self homeTopTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self homeTopTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureMessagesCell:[[self homeTopTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeMove:
                [[self homeTopTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [[self homeTopTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }else if ([controller isEqual:_whatsNewFetchedResultsController]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self whatsNewTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self whatsNewTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureWhatsNewCell:[[self whatsNewTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeMove:
                [[self whatsNewTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [[self whatsNewTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        [[self homeTopTableView] endUpdates];
    }else if ([controller isEqual:_whatsNewFetchedResultsController]) {
        [[self whatsNewTableView] endUpdates];
    }
}

#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self imagesFetchedResultsController] sections][section];
    return  [sectionInfo numberOfObjects];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell atIndexPath:indexPath];
//    [AppUtilityClass addOverlayOnView:cell.collectionImageView];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)imagesCell atIndexPath:(NSIndexPath *)indexPath{
    HomeImages *object = [[self imagesFetchedResultsController] objectAtIndexPath:indexPath];
    imagesCell.imageTitleLabel.text = object.imageName;
    imagesCell.imageDescription.text = object.stationName;
    [imagesCell.collectionImageView sd_setImageWithURL:[NSURL URLWithString:object.imagePath] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imagesCell.collectionImageView setImage:image];
    }];
}

#pragma mark -
#pragma mark - Collection View deleagete

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *galleryArray = [[CoreDataManager sharedManager] fetchHomeImages];
    ImagesGalleryViewController *imageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesGalleryViewController"];
    imageGalleryVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    imageGalleryVC.galleryInfoArray = galleryArray;
    imageGalleryVC.isFromDashBoard = YES;
    imageGalleryVC.selectedImageIndex = indexPath.row;
    [self presentViewController:imageGalleryVC animated:YES completion:^{
        ;
    }];
}

- (void)messageButtonClicked:(UIButton*)sender {
    [self performSegueWithIdentifier:kSendMessageSegueIdentifier sender:self];
}

- (void)infoButtonClicked:(UIButton*)sender {
    NSArray *stations = [[self stationsFetchedResultsController] fetchedObjects];
    self.stationInfoSelectedStation = (Stations *)[stations objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:kSationGalleryInfoSegueIdentifier sender:self];
}

- (void)stationStatusButtonClicked:(UIButton *)sender {
    NSArray *stations = [[self stationsFetchedResultsController] fetchedObjects];
    self.stationInfoSelectedStation = (Stations *)[stations objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:kStationInfoSegueIdentifier sender:self];
}

- (void)showImageGalleryList:(UIButton *)sender {
    ImagesGalleryViewController *imageGalleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesGalleryViewController"];
    imageGalleryVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:imageGalleryVC animated:YES completion:^{
        ;
    }];
}

- (void)userSelectedState:(Stations *)selectedStation{
    [self.selectStationButton setTitle:selectedStation.stationName forState:UIControlStateNormal];
    self.selectedStation = selectedStation;
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
    self.clearButton.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        self.clearButton.hidden = YES;
        NSString *placeHolderText = @"";
        
        if (textView.tag == kLeaveAMessageTag) {
            placeHolderText = kLeaveAMessageKey;
            if (textView.text.length) {
                [self postMessagesOnWall:textView.text];
            }
            textView.text = @"";
        }else {
            if (self.selectedStation) {
                placeHolderText = kWriteAnUpdate;
                if (textView.text.length) {
                    [self postWhatsNewMessage:textView.text];
                }
                textView.text = @"";
            }else {
                [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please select station", nil)];
            }
        }
        self.placeHolderTextField.placeholder = placeHolderText;
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *placeHolderText = @"";

    if (textView.tag == kLeaveAMessageTag) {
        placeHolderText = kLeaveAMessageKey;
    }else {
        placeHolderText = kWriteAnUpdate;
    }

    if (textView.text.length > 0) {
        self.placeHolderTextField.placeholder = @"";
    }else {
        self.placeHolderTextField.placeholder = placeHolderText;
    }
}

- (void)reloadTableViews {
    [self.homeTopTableView reloadData];
    [self.homeTableView reloadData];
    [self.whatsNewTableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self reloadTableViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kStationInfoSegueIdentifier]) {
        StationInfoViewController *stationInfoVC = (StationInfoViewController *)[segue destinationViewController];
        stationInfoVC.selectedStation = self.stationInfoSelectedStation;
    }
    if ([segue.identifier isEqualToString:kSationGalleryInfoSegueIdentifier]) {
        StationGalleryInfoViewController *stationInfoVC = (StationGalleryInfoViewController *)[segue destinationViewController];
        stationInfoVC.selectedStation = self.stationInfoSelectedStation;
    }
}


@end
