//
//  DeviceTableViewController.m
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/25/21.
//

#import "DeviceTableViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "Authentication/AuthenticationPresenter.h"
#import "AppData.h"

@interface DeviceTableViewController () <ASWebAuthenticationPresentationContextProviding, AuthenticationDelegate>

@end

@implementation DeviceTableViewController {
    AuthenticationPresenter *presenter;
    FSGConnect* _connect;
    AppData* _appData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the shared instances for FSGConnect and our app data.
    _connect = FSGConnect.shared;
    _appData = AppData.sharedManager;
}

- (void)viewWillAppear:(BOOL)animated
{
    _appData.devices = [[NSArray alloc] init];
    [[self tableView] reloadData];
    
    // Uncomment the following to show the web login and allow users to sign in
    //presenter = [[AuthenticationPresenter alloc] init];
    //[presenter showSignin: self];
    
    // Uncomment the following to authorize with an app key and start scanning for nearby devices
    NSError __autoreleasing *error = nil;
    [_connect initializeWithAcountId:@"ACCOUNT_ID_HERE" accountKey:@"ACCOUNT_KEY_HERE" error:&error];
    [_connect findDevicesAsyncAndReturnError:&error completion:^(NSArray<id<LMDevice>> * devices, NSError * error) {
        [self findDevicesComplete:devices error:error];
    }];
}

- (void)findDevicesComplete:(NSArray<id<LMDevice>>*)devices error:(NSError*)error {
    _appData.devices = devices;
    [[self tableView] reloadData];
}

#pragma mark - ASWebAuthenticationPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForWebAuthenticationSession:(ASWebAuthenticationSession *)session {
   return UIApplication.sharedApplication.keyWindow;
}

#pragma mark - AuthenticationDelegate
- (void)authFailure:(NSError *)error
{
    // TODO: Handle error
}

- (void)authSuccess:(NSString *)code
{
    NSError __autoreleasing *error = nil;
    
    // Initialize with user token and scan for devices
    [_connect initializeWithAccessToken:code];
    [_connect findDevicesAsyncAndReturnError:&error completion:^(NSArray<id<LMDevice>> * devices, NSError * error) {
        [self findDevicesComplete:devices error:error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _appData.devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    // Configure the cell...
    id<LMDevice> device = [_appData.devices objectAtIndex:indexPath.row];
    cell.textLabel.text = device.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Devices";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _appData.device = [_appData.devices objectAtIndex:indexPath.row];
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
