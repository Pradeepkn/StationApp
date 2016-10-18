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
}

- (IBAction)informationButtonClicked:(UIButton *)sender {
    self.whatsNewContainerView.hidden = YES;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.whatsNewButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.whatsNewButton setImage:[UIImage imageNamed:@"whats-news-unactive"] forState:UIControlStateNormal];
    [self.informationButton setImage:[UIImage imageNamed:@"information-active"] forState:UIControlStateNormal];
    [self.homeTopTableView reloadData];
}

- (IBAction)whatsNewButtonClicked:(UIButton *)sender {
    self.whatsNewContainerView.hidden = NO;
    [sender setTitleColor:selectedButtonColor forState:UIControlStateNormal];
    [self.informationButton setTitleColor:unselectedButtonColor forState:UIControlStateNormal];
    [self.informationButton setTintColor:unselectedButtonColor];
    [self.whatsNewButton setImage:[UIImage imageNamed:@"whats-news-active"] forState:UIControlStateNormal];
    [self.informationButton setImage:[UIImage imageNamed:@"information-unactive"] forState:UIControlStateNormal];
}

- (void)getHomeMessages {
    __weak HomeViewController *weakSelf = self;
    GetWallMessagesApi *wallMessagesApiObject = [GetWallMessagesApi new];
    wallMessagesApiObject.email = self.loggedInUser.email;
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
    whatsNewMessageApiObject.email = self.loggedInUser.email;
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
    postOnWallApiObject.email = self.loggedInUser.email;
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
    postOnWallApiObject.email = self.loggedInUser.email;
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
    NSSortDescriptor *message = [NSSortDescriptor sortDescriptorWithKey:@"addedDate" ascending:NO];
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
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"addedDate" ascending:NO];
    [request setSortDescriptors:@[stations]];
    return request;
}

- (NSFetchRequest *)getWhatsNewMessagesFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"WhatsNewMessages"];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"addedDate" ascending:NO];
    [request setSortDescriptors:@[stations]];
    return request;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kTopTableView) {
        Messages *object = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.message widthOfTextView:self.homeTopTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:16.0f]].height + 80;
    } else if (tableView.tag == kOverallStatusTableView) {
        return 40;
    }else if (tableView.tag == kWhatsNewTableView) {
        WhatsNewMessages *object = [[self whatsNewFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.message widthOfTextView:self.whatsNewTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:16.0f]].height + 40;
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
    if (tableView.tag == kTopTableView) {
        return 60;
    } else if (tableView.tag == kOverallStatusTableView) {
        return 25;
    }else  if (tableView.tag == kWhatsNewTableView) {
        return 100;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag == kOverallStatusTableView) {
        UIView *view = [UIView new];
        UILabel *overAllStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.bounds.size.width - 15, 20)];
        overAllStatusLabel.text = @"Over All Status";
        overAllStatusLabel.font = [UIFont fontWithName:kProximaNovaSemibold size:16.0f];
        overAllStatusLabel.textColor = [UIColor darkGrayColor];
        [view addSubview:overAllStatusLabel];
        view.backgroundColor = self.view.backgroundColor;
        return view;
    }
    if (tableView.tag == kTopTableView) {
        self.leaveAMessageCell = (LeaveMessageCell *)[tableView dequeueReusableCellWithIdentifier:kLeaveMessageCellIdentifier];
        self.leaveAMessageCell.leaveMessageTextField.delegate = self;
        self.leaveAMessageCell.leaveMessageTextView.delegate = self;
        self.leaveAMessageCell.leaveMessageTextView.tag = kLeaveAMessageTag;
        return self.leaveAMessageCell.contentView;
    }
    if (tableView.tag == kWhatsNewTableView) {
        self.writeAnUpdateMessageCell = (LeaveMessageCell *)[tableView dequeueReusableCellWithIdentifier:kLeaveMessageCellIdentifier];
        [self.writeAnUpdateMessageCell.selectStationButton addTarget:self action:@selector(showStationsOrDesignationsList:) forControlEvents:UIControlEventTouchUpInside];
        self.writeAnUpdateMessageCell.leaveMessageTextField.delegate = self;
        self.writeAnUpdateMessageCell.leaveMessageTextView.delegate = self;
        self.writeAnUpdateMessageCell.leaveMessageTextView.tag = kWriteUpdateMessageTag;
        return self.writeAnUpdateMessageCell.contentView;
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
    messagesCell.messageDescriptionLabel.text = object.message;
    messagesCell.headerLabel.text = object.designation;
    messagesCell.messageDateLabel.text = object.createDate;
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
    whatsNewCell.dateLabel.text = object.createDate;
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
    if ([tableView isEqual:self.homeTopTableView] || [tableView isEqual:self.whatsNewTableView]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Messages *messageObject = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
    [[CoreDataManager sharedManager] deleteWallMessage:messageObject];
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
//    [self launchImage];
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

- (void)showStationsOrDesignationsList:(UIButton *)sender {
    StationsListViewController *stationsListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StationsListViewController"];
    stationsListVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        stationsListVC.isStationSelected = YES;
    stationsListVC.delegate = self;
    [self presentViewController:stationsListVC animated:YES completion:^{
        ;
    }];
}

- (void)userSelectedState:(Stations *)selectedStation{
    [self.writeAnUpdateMessageCell.selectStationButton setTitle:selectedStation.stationName forState:UIControlStateNormal];
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
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        LeaveMessageCell *messageCell;
        NSString *placeHolderText = @"";
        
        if (textView.tag == kLeaveAMessageTag) {
            messageCell = self.leaveAMessageCell;
            placeHolderText = kLeaveAMessageKey;
            if (textView.text.length) {
                [self postMessagesOnWall:textView.text];
            }
            textView.text = @"";
        }else {
            messageCell = self.writeAnUpdateMessageCell;
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
        messageCell.leaveMessageTextField.placeholder = placeHolderText;
        [textView resignFirstResponder];
        [self reloadTableViews];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    LeaveMessageCell *messageCell;
    NSString *placeHolderText = @"";

    if (textView.tag == kLeaveAMessageTag) {
        messageCell = self.leaveAMessageCell;
        placeHolderText = kLeaveAMessageKey;
    }else {
        messageCell = self.writeAnUpdateMessageCell;
        placeHolderText = kWriteAnUpdate;
    }

    if (textView.text.length > 0) {
        messageCell.leaveMessageTextField.placeholder = @"";
    }else {
        messageCell.leaveMessageTextField.placeholder = placeHolderText;
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
