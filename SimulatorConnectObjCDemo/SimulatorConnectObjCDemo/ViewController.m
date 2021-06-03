//
//  ViewController.m
//  SimulatorConnectObjCDemo
//
//  Created by Chad Godsey on 5/18/21.
//

#import "ViewController.h"
#import "AppData.h"

@interface ViewController () <LMDeviceDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation ViewController{
    FSGConnect* _connect;
    AppData* _appData;
}

// Static array for club names in UIPicker
+ (NSArray *)clubNames
{
    static NSArray *_clubNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _clubNames = @[
            @"Unknown",
            @"Driver",
            @"Wood2",
            @"Wood3",
            @"Wood4",
            @"Wood5",
            @"Iron1",
            @"Iron2",
            @"Iron3",
            @"Iron4",
            @"Iron5",
            @"Iron6",
            @"Iron7",
            @"Iron8",
            @"Iron9",
            @"PitchingWedge",
            @"SandWedge",
            @"LobWedge",
            @"Putter",
            @"Hybrid",
            @"Hybrid1",
            @"Hybrid2",
            @"Hybrid3",
            @"Hybrid4",
            @"Hybrid5",
            @"Hybrid6",
            @"Hybrid7",
            @"Hybrid8",
            @"Hybrid9",
            @"Wood6",
            @"Wood7",
            @"Wood8",
            @"Wood9",
            @"ApproachWedge",
            @"GapWedge",
            @"Wedge46",
            @"Wedge48",
            @"Wedge50",
            @"Wedge52",
            @"Wedge54",
            @"Wedge56",
            @"Wedge58",
            @"Wedge60",
            @"Wedge62",
            @"Wedge64"];
    });
    return _clubNames;
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
        
        [self->_clubSelectLabel setHidden:false];
        [self->_clubSelect setHidden:false];
        
        [self->_carryLabel setHidden:false];
        [self->_totalLabel setHidden:false];
        [self->_spinRateLabel setHidden:false];
        [self->_spinAxisLabel setHidden:false];
        [self->_ballSpeedLabel setHidden:false];
        [self->_clubSpeedLabel setHidden:false];
        [self->_smashLabel setHidden:false];
        [self->_clubPathLabel setHidden:false];
        [self->_faceAngleLabel setHidden:false];
        [self->_faceToPathLabel setHidden:false];
        [self->_attackLabel setHidden:false];
        [self->_apexLabel setHidden:false];
        [self->_launchLabel setHidden:false];
        [self->_hLaunchLabel setHidden:false];
        [self->_sideCarryLabel setHidden:false];
        [self->_sideTotalLabel setHidden:false];
        
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

#pragma mark - LMDeviceDelegate

- (void)shotEvent:(id<ShotEvent>)event
{
    NSLog(@"shot");
    
    // Update UI
    [self->_carryLabel setHidden:false];
    [self->_totalLabel setHidden:false];
    [self->_spinRateLabel setHidden:false];
    [self->_spinAxisLabel setHidden:false];
    [self->_ballSpeedLabel setHidden:false];
    [self->_clubSpeedLabel setHidden:false];
    [self->_smashLabel setHidden:false];
    [self->_clubPathLabel setHidden:false];
    [self->_faceAngleLabel setHidden:false];
    [self->_faceToPathLabel setHidden:false];
    [self->_attackLabel setHidden:false];
    [self->_apexLabel setHidden:false];
    [self->_launchLabel setHidden:false];
    [self->_hLaunchLabel setHidden:false];
    [self->_sideCarryLabel setHidden:false];
    [self->_sideTotalLabel setHidden:false];
    
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
    
    if (event.shot.spinRate != nil) {
        [_spinRateLabel setText:[NSString stringWithFormat:@"Rate: %@", event.shot.spinRate]];
    }else{
        [_spinRateLabel setText:[NSString stringWithFormat:@"Rate: ---"]];
    }
    if (event.shot.spinAxis != nil) {
        [_spinAxisLabel setText:[NSString stringWithFormat:@"Axis: %@", event.shot.spinAxis] ];
    }else{
        [_spinAxisLabel setText:[NSString stringWithFormat:@"Axis: ---"]];
    }
    
    if (event.shot.ballSpeed != nil) {
        [_ballSpeedLabel setText:[NSString stringWithFormat:@"Ball: %@", event.shot.ballSpeed]];
    }else{
        [_ballSpeedLabel setText:[NSString stringWithFormat:@"Ball: ---"]];
    }
    if (event.shot.clubSpeed != nil) {
        [_clubSpeedLabel setText:[NSString stringWithFormat:@"Club: %@", event.shot.clubSpeed]];
    }else{
        [_clubSpeedLabel setText:[NSString stringWithFormat:@"Club: ---"]];
    }
    
    if (event.shot.smashFactor != nil) {
        [_smashLabel setText:[NSString stringWithFormat:@"Smash: %@", event.shot.smashFactor]];
    }else{
        [_smashLabel setText:[NSString stringWithFormat:@"Smash: ---"]];
    }
    if (event.shot.clubPath != nil) {
        [_clubPathLabel setText:[NSString stringWithFormat:@"ClubPath: %@", event.shot.clubPath]];
    }else{
        [_clubPathLabel setText:[NSString stringWithFormat:@"ClubPath: ---"]];
    }
    
    if (event.shot.faceAngle != nil) {
        [_faceAngleLabel setText:[NSString stringWithFormat:@"Face: %@", event.shot.faceAngle]];
    }else{
        [_faceAngleLabel setText:[NSString stringWithFormat:@"Face: ---"]];
    }
    if (event.shot.faceAngle != nil) {
        [_faceToPathLabel setText:[NSString stringWithFormat:@"FaceToPath: %@", event.shot.faceAngle]];
    }else{
        [_faceToPathLabel setText:[NSString stringWithFormat:@"FaceToPath: ---"]];
    }
    
    if (event.shot.attackAngle != nil) {
        [_attackLabel setText:[NSString stringWithFormat:@"Attack: %@", event.shot.attackAngle]];
    }else{
        [_attackLabel setText:[NSString stringWithFormat:@"Attack: ---"]];
    }
    if (event.shot.apex != nil) {
        [_apexLabel setText:[NSString stringWithFormat:@"Apex: %@", event.shot.apex]];
    }else{
        [_apexLabel setText:[NSString stringWithFormat:@"Apex: ---"]];
    }
    
    if (event.shot.vertlaunchAngle != nil) {
        [_launchLabel setText:[NSString stringWithFormat:@"Vert: %@", event.shot.vertlaunchAngle]];
    }else{
        [_launchLabel setText:[NSString stringWithFormat:@"Vert: ---"]];
    }
    if (event.shot.horizLaunchAngle != nil) {
        [_hLaunchLabel setText:[NSString stringWithFormat:@"Horiz: %@", event.shot.horizLaunchAngle]];
    }else{
        [_hLaunchLabel setText:[NSString stringWithFormat:@"Horiz: ---"]];
    }
    
    if (event.shot.side != nil) {
        [_sideCarryLabel setText:[NSString stringWithFormat:@"Side: %@", event.shot.side]];
    }else{
        [_sideCarryLabel setText:[NSString stringWithFormat:@"Side: ---"]];
    }
    if (event.shot.sideTotal != nil) {
        [_sideTotalLabel setText:[NSString stringWithFormat:@"SideTotal: %@", event.shot.sideTotal]];
    }else{
        [_sideTotalLabel setText:[NSString stringWithFormat:@"SideTotal: ---"]];
    }
}

- (void)stateChangedEvent:(id<StateChangedEvent>)event
{
    switch (event.state) {
        case LMStateDisconnected:
            // UI updates
            [self setTitle:@""];
            
            [self->_statusLabel setText:@"Disconnected"];
            [self->_statusActivity setHidden:true];
            
            [self->_clubSelectLabel setHidden:true];
            [self->_clubSelect setHidden:true];
            
            [self->_carryLabel setHidden:true];
            [self->_totalLabel setHidden:true];
            [self->_spinRateLabel setHidden:true];
            [self->_spinAxisLabel setHidden:true];
            [self->_ballSpeedLabel setHidden:true];
            [self->_clubSpeedLabel setHidden:true];
            [self->_smashLabel setHidden:true];
            [self->_clubPathLabel setHidden:true];
            [self->_faceAngleLabel setHidden:true];
            [self->_faceToPathLabel setHidden:true];
            [self->_attackLabel setHidden:true];
            [self->_apexLabel setHidden:true];
            [self->_launchLabel setHidden:true];
            [self->_hLaunchLabel setHidden:true];
            [self->_sideCarryLabel setHidden:true];
            [self->_sideTotalLabel setHidden:true];
            
            [[self navigationController] popViewControllerAnimated:true];
            break;
        default:
            break;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self class] clubNames].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self class] clubNames][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LMClubType clubType = row;
    NSLog(@"PickerView Selected %ld", (long)clubType);
    unsigned char bytes[] = {clubType};
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdClub value:data completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Club Updated");
    }];
}

@end
