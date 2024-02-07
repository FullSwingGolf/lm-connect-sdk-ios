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
    id<LMShot> _lastShot;
    id<LMShot> _lastShotNormalized;
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
    
    unsigned char locationBytes[] = {LMLocationOutdoorRange};
    NSData *locationData = [NSData dataWithBytes:locationBytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdLocation value:locationData completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Location Updated");
    }];
    unsigned char normalizedBytes[] = {_normalized.on};
    NSData *normalizedData = [NSData dataWithBytes:normalizedBytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdNormalizedEnabled value:normalizedData completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Normalization Updated");
    }];
    [_appData.device connectWithCompletion:^(BOOL connected, NSError * error) {
        NSLog(@"Connected: %@", self->_appData.device.name);
        
        // UI updates
        [self setTitle:self->_appData.device.name];
        
        [self->_statusLabel setText:@"Connected"];
        [self->_statusActivity setHidden:true];
        
        [self->_clubSelectLabel setHidden:false];
        [self->_clubSelect setHidden:false];
        [self->_locationSelect setHidden:false];
        
        [self->_distanceLabel setHidden:false];
        [self->_distanceValueLabel setHidden:false];
        [self->_distanceSelect setHidden:false];
        
        [self->_shortShot setHidden:false];
        [self->_shortShotLabel setHidden:false];
        
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
        
        [self->_normalized setHidden:false];
        [self->_normalizedLabel setHidden:false];
        [self->_normalized setOn:true];
        
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

- (void)normalizedAction
{
    NSLog(@"Normalized Selected %d", _normalized.on);
    unsigned char bytes[] = {_normalized.on};
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdNormalizedEnabled value:data completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Normalized Updated");
    }];
    
    if (self->_normalized.isOn) {
        [self displayShot:_lastShot];
    } else {
        [self displayShot:_lastShotNormalized];
    }
}

- (void)shortShotAction
{
    NSLog(@"Short Shot Selected %d", _shortShot.on);
    unsigned char bytes[] = {_shortShot.on};
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdShortShot value:data completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Short Shot Updated");
    }];
}

- (void)distanceAction
{
    float distance = _distanceSelect.value;
    [_distanceValueLabel setText:[NSString stringWithFormat:@"%d", (int)_distanceSelect.value]];
    
    NSLog(@"Distance To Pin %f", _distanceSelect.value);
    NSMutableData *data = [NSMutableData dataWithCapacity:0];
    [data appendBytes:&distance length:sizeof(float)];
    [_appData.device setConfigurationWithId:LMConfigurationIdDistanceToPin value:data completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Short Shot Updated");
    }];
    
    unsigned char bytes[] = {true};
    NSData *dataAS = [NSData dataWithBytes:bytes length:1];
    [_appData.device setConfigurationWithId:LMConfigurationIdAutoShortShotEnabled value:dataAS completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Short Shot Updated");
    }];
}

- (void)displayShot:(id<LMShot>)shot
{
    // Print shot information to screen
    if (shot.carryDistance != nil) {
        [_carryLabel setText:[NSString stringWithFormat:@"Carry: %@", shot.carryDistance]];
    }else{
        [_carryLabel setText:[NSString stringWithFormat:@"Carry: ---"]];
    }
    if (shot.totalDistance != nil) {
        [_totalLabel setText:[NSString stringWithFormat:@"Total: %@", shot.totalDistance]];
    }else{
        [_totalLabel setText:[NSString stringWithFormat:@"Total: ---"]];
    }
    
    if (shot.spinRate != nil) {
        [_spinRateLabel setText:[NSString stringWithFormat:@"Rate: %@", shot.spinRate]];
    }else{
        [_spinRateLabel setText:[NSString stringWithFormat:@"Rate: ---"]];
    }
    if (shot.spinAxis != nil) {
        [_spinAxisLabel setText:[NSString stringWithFormat:@"Axis: %@", shot.spinAxis] ];
    }else{
        [_spinAxisLabel setText:[NSString stringWithFormat:@"Axis: ---"]];
    }
    
    if (shot.ballSpeed != nil) {
        [_ballSpeedLabel setText:[NSString stringWithFormat:@"Ball: %@", shot.ballSpeed]];
    }else{
        [_ballSpeedLabel setText:[NSString stringWithFormat:@"Ball: ---"]];
    }
    if (shot.clubSpeed != nil) {
        [_clubSpeedLabel setText:[NSString stringWithFormat:@"Club: %@", shot.clubSpeed]];
    }else{
        [_clubSpeedLabel setText:[NSString stringWithFormat:@"Club: ---"]];
    }
    
    if (shot.smashFactor != nil) {
        [_smashLabel setText:[NSString stringWithFormat:@"Smash: %@", shot.smashFactor]];
    }else{
        [_smashLabel setText:[NSString stringWithFormat:@"Smash: ---"]];
    }
    if (shot.clubPath != nil) {
        [_clubPathLabel setText:[NSString stringWithFormat:@"ClubPath: %@", shot.clubPath]];
    }else{
        [_clubPathLabel setText:[NSString stringWithFormat:@"ClubPath: ---"]];
    }
    
    if (shot.faceAngle != nil) {
        [_faceAngleLabel setText:[NSString stringWithFormat:@"Face: %@", shot.faceAngle]];
    }else{
        [_faceAngleLabel setText:[NSString stringWithFormat:@"Face: ---"]];
    }
    if (shot.faceAngle != nil) {
        [_faceToPathLabel setText:[NSString stringWithFormat:@"FaceToPath: %@", shot.faceAngle]];
    }else{
        [_faceToPathLabel setText:[NSString stringWithFormat:@"FaceToPath: ---"]];
    }
    
    if (shot.attackAngle != nil) {
        [_attackLabel setText:[NSString stringWithFormat:@"Attack: %@", shot.attackAngle]];
    }else{
        [_attackLabel setText:[NSString stringWithFormat:@"Attack: ---"]];
    }
    if (shot.apex != nil) {
        [_apexLabel setText:[NSString stringWithFormat:@"Apex: %@", shot.apex]];
    }else{
        [_apexLabel setText:[NSString stringWithFormat:@"Apex: ---"]];
    }
    
    if (shot.vertlaunchAngle != nil) {
        [_launchLabel setText:[NSString stringWithFormat:@"Vert: %@", shot.vertlaunchAngle]];
    }else{
        [_launchLabel setText:[NSString stringWithFormat:@"Vert: ---"]];
    }
    if (shot.horizLaunchAngle != nil) {
        [_hLaunchLabel setText:[NSString stringWithFormat:@"Horiz: %@", shot.horizLaunchAngle]];
    }else{
        [_hLaunchLabel setText:[NSString stringWithFormat:@"Horiz: ---"]];
    }
    
    if (shot.side != nil) {
        [_sideCarryLabel setText:[NSString stringWithFormat:@"Side: %@", shot.side]];
    }else{
        [_sideCarryLabel setText:[NSString stringWithFormat:@"Side: ---"]];
    }
    if (shot.sideTotal != nil) {
        [_sideTotalLabel setText:[NSString stringWithFormat:@"SideTotal: %@", shot.sideTotal]];
    }else{
        [_sideTotalLabel setText:[NSString stringWithFormat:@"SideTotal: ---"]];
    }
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
    
    if (event.type == LMShotTypeLaunch) {
        NSLog(@"Launch Data");
        _lastShot = event.shot;
    }
    if (event.type == LMShotTypeFlight) {
        NSLog(@"Flight Data");
        _lastShot = event.shot;
    }
    if (event.type == LMShotTypeNormalized) {
        NSLog(@"Normalized Data");
        _lastShotNormalized = event.shot;
    }
    
    [self displayShot:event.shot];
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
            [self->_locationSelect setHidden:true];
            
            [self->_distanceLabel setHidden:true];
            [self->_distanceValueLabel setHidden:true];
            [self->_distanceSelect setHidden:true];
            
            [self->_shortShot setHidden:true];
            [self->_shortShotLabel setHidden:true];
            
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
            
            [self->_normalized setHidden:true];
            [self->_normalizedLabel setHidden:true];
            
            [[self navigationController] popViewControllerAnimated:true];
            break;
        case LMStateNotReady:
            [self->_statusLabel setText:@"NotReady"];
            break;
        case LMStateWaitingForArm:
            [self->_statusLabel setText:@"WaitingForArm"];
            break;
        case LMStateReadyBallFound:
            [self->_statusLabel setText:@"ReadyBallFound"];
            break;
        case LMStateTracking:
            [self->_statusLabel setText:@"Tracking"];
            break;
        default:
            break;
    }
}

- (void)configurationChanged:(id<ConfigChangedEvent>)event
{
    NSLog(@"configuration %ld", (long)event.configId);
    int iVal;
    [event.value getBytes:&iVal length:sizeof(iVal)];
    
    bool bVal;
    [event.value getBytes:&bVal length:sizeof(bVal)];
    
    float fVal;
    [event.value getBytes:&fVal length:sizeof(fVal)];
    
    switch (event.configId) {
        case LMConfigurationIdClub:
            NSLog(@"Club %ld", (LMClubType)iVal);
            break;
        case LMConfigurationIdAutoArm:
            NSLog(@"Auto Arm %d", bVal);
            break;
        case LMConfigurationIdDataDisplay:
            NSLog(@"Data Display %ld", (LMDataDisplay)iVal);
            break;
        case LMConfigurationIdDistanceUnits:
            NSLog(@"Distance Units %ld", (LMDistanceUnits)iVal);
            break;
        case LMConfigurationIdApexUnits:
            NSLog(@"Apex Units %ld", (LMApexUnits)iVal);
            break;
        case LMConfigurationIdSpeedUnits:
            NSLog(@"Speed Units %ld", (LMSpeedUnit)iVal);
            break;
        case LMConfigurationIdElevationUnits:
            NSLog(@"Elevation Units %ld", (LMApexUnits)iVal);
            break;
        case LMConfigurationIdTemperatureUnits:
            NSLog(@"Temperature Units %ld", (LMTemperatureUnit)iVal);
            break;
        case LMConfigurationIdLocation:
            NSLog(@"Location %ld", (LMLocation)iVal);
            break;
        case LMConfigurationIdElevation:
            NSLog(@"Elevation %f.2", fVal);
            break;
        case LMConfigurationIdTemperature:
            NSLog(@"Temperature %f.2", fVal);
            break;
        case LMConfigurationIdShortShot:
            NSLog(@"Short Shot %d", bVal);
            break;
        case LMConfigurationIdAutoShortShotEnabled:
            NSLog(@"Short Shot Enabled %d", bVal);
            break;
        case LMConfigurationIdDistanceToPin:
            NSLog(@"Distance To Pin %f.2", fVal);
            break;
        case LMConfigurationIdNormalizedEnabled:
            NSLog(@"Normalized Enabled %d", bVal);
            break;
        case LMConfigurationIdNormalizedElevation:
            NSLog(@"Normalized Elevation %f.2", fVal);
            break;
        case LMConfigurationIdNormalizedTemperature:
            NSLog(@"Normalized Elevation %f.2", fVal);
            break;
        case LMConfigurationIdNormalizedIndoorBallType:
            NSLog(@"Normalized Indoor Ball Type %ld", (LMBallType)iVal);
            break;
        case LMConfigurationIdNormalizedOutdoorBallType:
            NSLog(@"Normalized Outdoor Ball Type %ld", (LMBallType)iVal);
            break;
        case LMConfigurationIdVideoRecordingEnabled:
            NSLog(@"Video Recording Enabled %d", bVal);
            break;
        default:
            break;
    }
}

- (void)batteryLevelChanged:(UInt8)level
{
    NSLog(@"batterylevel %d", level);
}

- (void)shortShotChanged:(BOOL)enabled
{
    NSLog(@"shortShot %@", enabled ? @"YES" : @"NO");
    _shortShot.on = enabled;
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
