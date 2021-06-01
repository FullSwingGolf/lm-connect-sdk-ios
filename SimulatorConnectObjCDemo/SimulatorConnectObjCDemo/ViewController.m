//
//  ViewController.m
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/18/21.
//

#import "ViewController.h"
#import "AppData.h"

@interface ViewController () <LMDeviceDelegate>

@end

@implementation ViewController{
    FSGConnect* _connect;
    AppData* _appData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // UI
    [[self navigationItem] setBackButtonTitle:@"Disconnect"];
    
    // Get our shared application data
    _appData = AppData.sharedManager;
    
    // Connect to selected device
    [self->_statusActivity setHidden:false];
    [_appData.device connectWithCompletion:^(BOOL connected, NSError * error) {
        NSLog(@"Connected: %@", self->_appData.device.name);
        
        // UI updates
        [self setTitle:self->_appData.device.name];
        
        [self->_statusLabel setText:@"Connected"];
        [self->_statusActivity setHidden:true];
        
        [self->_clubSelect setHidden:false];
        
        [self->_carryLabel setHidden:false];
        [self->_totalLabel setHidden:false];
        [self->_launchLabel setHidden:false];
        [self->_backspinLabel setHidden:false];
        [self->_attackLabel setHidden:false];
        [self->_axisLabel setHidden:false];
        
        // Set LMDevice delegate to self and begin arm process
        [self->_appData.device setDelegate:self];
        [self->_appData.device armWithCompletion:^(BOOL armed, NSError * error) {
            
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_appData.device disconnectWithCompletion:^(BOOL disconnected, NSError * error) {
        NSLog(@"Disconnected: %@", self->_appData.device.name);
    }];
}

- (void)clubSelectAction
{
    LMClubType clubType = LMClubTypeDriver;
    switch (_clubSelect.selectedSegmentIndex) {
        case 0:
            clubType = LMClubTypeDriver;
            break;
        case 1:
            clubType = LMClubTypeUnknown;
        default:
            break;
    }
    unsigned char bytes[] = {clubType};
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdClub value:data completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Club Updated");
    }];
}

#pragma mark - LMDeviceDelegate

- (void)shotEvent:(id<ShotEvent>)event
{
    NSLog(@"shot");
    
    // Update UI
    [_carryLabel setHidden:false];
    [_totalLabel setHidden:false];
    [_launchLabel setHidden:false];
    [_backspinLabel setHidden:false];
    [_attackLabel setHidden:false];
    [_axisLabel setHidden:false];
    
    // Print shot information to screen
    if (event.shot.carryDistance != nil) {
        [_carryLabel setText:[NSString stringWithFormat:@"Carry: %@", event.shot.carryDistance]];
    }else{
        [_carryLabel setText:[NSString stringWithFormat:@"Carry: ---"]];
    }
    if (event.shot.totalDistance != nil) {
        [_totalLabel setText:[NSString stringWithFormat:@"Total: %@", event.shot.totalDistance]];
    }else{
        [_totalLabel setText:[NSString stringWithFormat:@"Total: ---"]];
    }
    if (event.shot.vertlaunchAngle != nil) {
        [_launchLabel setText:[NSString stringWithFormat:@"Launch: %@", event.shot.vertlaunchAngle]];
    }else{
        [_launchLabel setText:[NSString stringWithFormat:@"Launch: ---"]];
    }
    if (event.shot.spinRate != nil) {
        [_backspinLabel setText:[NSString stringWithFormat:@"Backspin: %@", event.shot.spinRate]];
    }else{
        [_backspinLabel setText:[NSString stringWithFormat:@"Backspin: ---"]];
    }
    if (event.shot.attackAngle != nil) {
        [_attackLabel setText:[NSString stringWithFormat:@"Attack: %@", event.shot.attackAngle]];
    }else{
        [_attackLabel setText:[NSString stringWithFormat:@"Attack: ---"]];
    }
    if (event.shot.spinAxis != nil) {
        [_axisLabel setText:[NSString stringWithFormat:@"Axis: %@", event.shot.spinAxis] ];
    }else{
        [_axisLabel setText:[NSString stringWithFormat:@"Axis: ---"]];
    }
}

- (void)stateChangedEvent:(id<StateChangedEvent>)event
{
    //TODO
}

@end
