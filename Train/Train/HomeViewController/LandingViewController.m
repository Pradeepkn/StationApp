//
//  LandingViewController.m
//  Train
//
//  Created by pradeep on 4/4/17.
//  Copyright © 2017 Pradeep. All rights reserved.
//

#import "LandingViewController.h"
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
#import "NSString+AutoCapitalizeString.h"
#import "DeleteMessageApi.h"
#import "GetStationDesignationApi.h"
#import "UIImage+ImageAdditions.h"

static NSString *const kLeaveAMessageKey = @"Leave a message";
static NSString *const kHomeSegueIdentifier = @"HomeSegue";

static NSString *const kGalleryCollectionViewCellIdentifier = @"GalleryCollectionViewCell";
static NSString *const kLeaveMessageCellIdentifier = @"LeaveMessageCellIdentifier";
static NSString *const kSationGalleryInfoSegueIdentifier = @"SationGalleryInfoSegue";
static NSString *const kHomeMessagesCellIdentifier = @"GlobalMessageCellIdentifier";
static NSString *const kIRSDCSegueIdentifier = @"IRSDCSegueIdentifier";

const int kHomeTableView = 1000;

@interface LandingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, StationDesignationDelegate, NSFetchedResultsControllerDelegate> {
    NSInteger messagesCount;
}

@property (weak, nonatomic) IBOutlet UITextView *messageInputTextView;
@property (weak, nonatomic) IBOutlet UITextField *placeHolderTextField;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *profileNameButton;

@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *homeGalleryCollectionView;
@property (nonatomic, strong) NSFetchedResultsController *messagesFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *imagesFetchedResultsController;

@property (strong, nonatomic) LeaveMessageCell *leaveAMessageCell;
@property (strong, nonatomic) User *loggedInUser;

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loggedInUser = [[CoreDataManager sharedManager] fetchLogedInUser];
    [self initializeMessagesFetchedResultsController];
    [self addStatusBar];
    // Do any additional setup after loading the view.
}

- (void)addStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor  =  [UIColor appRedColor];
    [self.view addSubview:statusBarView];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self getHomeMessages];
    self.homeTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.profileNameButton setImage:nil forState:UIControlStateNormal];
    [self.profileNameButton setTitle:[AppUtilityClass getProfileIconNameForProfileName:[AppUtilityClass getUserEmail]] forState:UIControlStateNormal];
}

- (IBAction)phase1ButtonAction:(id)sender {
    [self performSegueWithIdentifier:kHomeSegueIdentifier sender:nil];
}

- (IBAction)nextPhaseButtonAction:(id)sender {
    [self performSegueWithIdentifier:kHomeSegueIdentifier sender:nil];
}

- (IBAction)markEolButtonAction:(id)sender {
}

- (IBAction)iRSDCButtonAction:(id)sender {
    [self performSegueWithIdentifier:kIRSDCSegueIdentifier sender:self];
}

- (IBAction)otherQueriesButtonAction:(id)sender {
}

- (void)getHomeMessages {
    __weak LandingViewController *weakSelf = self;
    GetWallMessagesApi *wallMessagesApiObject = [GetWallMessagesApi new];
    wallMessagesApiObject.email = [AppUtilityClass getUserEmail];
    [[APIManager sharedInstance]makeAPIRequestWithObject:wallMessagesApiObject shouldAddOAuthHeader:NO andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
        //NSLog(@"Response = %@", responseDictionary);
        if (!error) {
            [weakSelf.homeGalleryCollectionView reloadData];
        }else{
            [AppUtilityClass showErrorMessage:NSLocalizedString(@"Please try again later", nil)];
        }
    }];
}

- (void)postMessagesOnWall:(NSString *)message {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak LandingViewController *weakSelf = self;
    PostOnWallApi *postOnWallApiObject = [PostOnWallApi new];
    postOnWallApiObject.email = [AppUtilityClass getUserEmail];
    postOnWallApiObject.designation = self.loggedInUser.designation;
    postOnWallApiObject.message = message;
    
    [[APIManager sharedInstance]makePostAPIRequestWithObject:postOnWallApiObject
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              //NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              if (dataDict.allKeys.count > 0) {
                                                  [self getHomeMessages];
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

- (void)deleteInfoMessage:(BOOL)isInfo withMessageId:(NSString *)messageId {
    [AppUtilityClass showLoaderOnView:self.view];
    
    __weak LandingViewController *weakSelf = self;
    DeleteMessageApi *deleteMessageApi = [DeleteMessageApi new];
    deleteMessageApi.email = [AppUtilityClass getUserEmail];
    deleteMessageApi.messageId = messageId;
    deleteMessageApi.isInfoMessage = isInfo;
    
    [[APIManager sharedInstance]makePostAPIRequestWithObject:deleteMessageApi
                                          andCompletionBlock:^(NSDictionary *responseDictionary, NSError *error) {
                                              //NSLog(@"Response = %@", responseDictionary);
                                              [AppUtilityClass hideLoaderFromView:weakSelf.view];
                                              NSDictionary *dataDict = responseDictionary[@"data"];
                                              NSDictionary *errorDict = responseDictionary[@"error"];
                                              if (dataDict.allKeys.count > 0) {
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


- (void)initializeMessagesFetchedResultsController
{
    NSManagedObjectContext *moc = [[CoreDataManager sharedManager] managedObjectContext];
    
    [self setMessagesFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getMessagesFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self messagesFetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    if (![[self messagesFetchedResultsController] performFetch:&error]) {
        //NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    [self setImagesFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:[self getHomeImagesFetchRequest] managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self imagesFetchedResultsController] setDelegate:self];
    
    if (![[self imagesFetchedResultsController] performFetch:&error]) {
        //NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stationName != %@",@"NA"];
    [request setPredicate:predicate];
    return request;
}

- (NSFetchRequest *)getHomeImagesFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeImages"];
    NSSortDescriptor *stations = [NSSortDescriptor sortDescriptorWithKey:@"insertDate" ascending:NO];
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
    if (tableView.tag == kHomeTableView) {
        Messages *object = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        return [AppUtilityClass sizeOfText:object.message widthOfTextView:self.homeTableView.frame.size.width - 30 withFont:[UIFont systemFontOfSize:18.0f]].height + 80;
    }
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == kHomeTableView) {
        id< NSFetchedResultsSectionInfo> sectionInfo = [[self messagesFetchedResultsController] sections][section];
        messagesCount = [sectionInfo numberOfObjects];
        return messagesCount ;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == kHomeTableView) {
        return 0;
    }
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kHomeTableView) {
        HomeMessagesCell *messagesCell = (HomeMessagesCell *)[tableView dequeueReusableCellWithIdentifier:kHomeMessagesCellIdentifier forIndexPath:indexPath];
        [self configureMessagesCell:messagesCell atIndexPath:indexPath];
        return messagesCell;
    }
    return [UITableViewCell new];
}

- (void)configureMessagesCell:(HomeMessagesCell *)messagesCell atIndexPath:(NSIndexPath*)indexPath
{
    Messages *object = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
    messagesCell.userNameLabel.text = [NSString autoCapitalize:object.username?:object.messageId];
    messagesCell.messageDescriptionLabel.text = [NSString autoCapitalize:object.message?:@"NA"];
    messagesCell.headerLabel.text = object.designation;
    messagesCell.messageDateLabel.text = [AppUtilityClass getHomeMessageDate:object.createDate];
    if (object.deleteMessage) {
        messagesCell.swipeButton.hidden = NO;
    }else {
        messagesCell.swipeButton.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
    if ([tableView isEqual:self.homeTableView]) {
        Messages *messageObject = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        if (messageObject.deleteMessage) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.homeTableView]) {
        Messages *messageObject = [[self messagesFetchedResultsController] objectAtIndexPath:indexPath];
        [self deleteInfoMessage:YES withMessageId:messageObject.messageId];
        [[CoreDataManager sharedManager] deleteWallMessage:messageObject];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        [[self homeTableView] beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [[self homeTableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self homeTableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
                [[self homeTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [[self homeTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:
                [self configureMessagesCell:[[self homeTableView] cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
            case NSFetchedResultsChangeMove:
                [[self homeTableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [[self homeTableView] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([controller isEqual:_messagesFetchedResultsController]) {
        [[self homeTableView] endUpdates];
    }
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
    self.overlayView.hidden = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        self.overlayView.hidden = YES;
        NSString *placeHolderText = @"";
        
        placeHolderText = kLeaveAMessageKey;
        if (textView.text.length) {
            [self postMessagesOnWall:textView.text];
        }
        textView.text = @"";

        self.placeHolderTextField.placeholder = placeHolderText;
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *placeHolderText = kLeaveAMessageKey;
    placeHolderText = kLeaveAMessageKey;
    if (textView.text.length > 0) {
        self.placeHolderTextField.placeholder = @"";
    }else {
        self.placeHolderTextField.placeholder = placeHolderText;
    }
}

- (void)reloadTableViews {
    [self.homeTableView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.overlayView.hidden = YES;
    [self reloadTableViews];
}


#pragma mark -
#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self imagesFetchedResultsController] sections][section];
    return  [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GalleryCollectionViewCell *cell = (GalleryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kGalleryCollectionViewCellIdentifier forIndexPath:indexPath];
    [self customiseCollectionCiewCell:cell atIndexPath:indexPath];
    //    [AppUtilityClass addOverlayOnView:cell.collectionImageView];
    return cell;
}

- (void)customiseCollectionCiewCell:(GalleryCollectionViewCell *)imagesCell atIndexPath:(NSIndexPath *)indexPath{
    HomeImages *object = [[self imagesFetchedResultsController] objectAtIndexPath:indexPath];
    imagesCell.imageTitleLabel.text = [NSString autoCapitalize:object.imageName];
    imagesCell.imageDescription.text = object.stationName;
    NSLog(@"Image Path = %@", object.imagePath);
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
