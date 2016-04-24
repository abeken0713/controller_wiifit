#import "AppController.h"

@implementation AppController
#pragma mark Window

- (id)init
{
    self = [super init];
    if (self) {
		
		weightSampleIndex = 0;
        
        // Load TextStrings.plist
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"TextStrings" ofType:@"plist"];
        //strings = [[NSDictionary dictionaryWithContentsOfFile:plistPath] copy];
		
		if(!discovery) {
			[self performSelector:@selector(doDiscovery:) withObject:self afterDelay:0.0f];
		}
    
		
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];
}
// It won't show the weight if you delete this method!!!!!  _ABE_
- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(expansionPortChanged:)
												 name:@"WiiRemoteExpansionPortChangedNotification"
											   object:nil];
}

#pragma mark NSApplication

- (void)applicationWillTerminate:(NSNotification *)notification
{
	[wii closeConnection];
}

#pragma mark Profiles


#pragma mark Wii Balance Board

- (IBAction)doDiscovery:(id)sender {
	
	if(!discovery) {
		discovery = [[WiiRemoteDiscovery alloc] init];
		[discovery setDelegate:self];
		[discovery start];
		
		[bbstatus setStringValue:@"Searching..."];
		[fileConnect setTitle:@"Stop Searching for Balance Board"];
		[status setStringValue:@"Press the red 'sync' button..."];
	} else {
		[discovery stop];
		[discovery release];
		discovery = nil;
		
		if(wii) {
			[wii closeConnection];
			[wii release];
			wii = nil;
		}
		
		[bbstatus setStringValue:@"Disconnected"];
		[fileConnect setTitle:@"Connect to Balance Board"];
		[status setStringValue:@""];
	}
}

- (IBAction)doTare:(id)sender {
	tare = 0.0 - lastWeight;
}

#pragma mark Magic?

- (void)expansionPortChanged:(NSNotification *)nc{

	WiiRemote* tmpWii = (WiiRemote*)[nc object];
	
	// Check that the Wiimote reporting is the one we're connected to.
	if (![[tmpWii address] isEqualToString:[wii address]]){
		return;
	}
	
	if ([wii isExpansionPortAttached]){
		[wii setExpansionPortEnabled:YES];
	}	
}

#pragma mark WiiRemoteDelegate methods

- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed
{	
	[self doTare:self];
}

- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device
{
	[bbstatus setStringValue:@"Disconnected"];
	
	[device closeConnection];
}

#pragma mark WiiRemoteDelegate methods (optional)

// cooked values from the Balance Beam
- (void) balanceBeamKilogramsChangedTopRight:(float)topRight
                                 bottomRight:(float)bottomRight
                                     topLeft:(float)topLeft
                                  bottomLeft:(float)bottomLeft {
	
	lastWeight = topRight + bottomRight + topLeft + bottomLeft;
	
	if(!tare) {
		[self doTare:self];
	}
	
	float trueWeight = lastWeight + tare;
	[weightIndicator setDoubleValue:trueWeight];
	
	if(trueWeight > 10.0) {
		weightSamples[weightSampleIndex] = trueWeight;
		weightSampleIndex = (weightSampleIndex + 1) % 100;
		
		float sum = 0;
		float sum_sqrs = 0;
		
		for (int i = 0; i < 100; i++)
		{
			sum += weightSamples[i];
			sum_sqrs += weightSamples[i] * weightSamples[i];
		}
		
		avgWeight = sum / 100.0;
		float var = sum_sqrs / 100.0 - (avgWeight * avgWeight);
		float std_dev = sqrt(var);

		if(!sent)
			[status setStringValue:@"Please hold still..."];
		else
			[status setStringValue:[NSString stringWithFormat:@"Sent weight of %4.1fkg.  Thanks!", avgWeight]];

		
		if(std_dev < 0.1 && !sent)
		{
			sent = YES;
		}
		
	} else {
		sent = NO;
		[status setStringValue:@"Tap the button to tare, then step on..."];
	}

	[weight setStringValue:[NSString stringWithFormat:@"%4.1fkg  %4.1flbs", MAX(0.0, trueWeight), MAX(0.0, (trueWeight) * 2.20462262)]];
}

#pragma mark WiiRemoteDiscoveryDelegate methods

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	
	[wii release];
	wii = [wiimote retain];
	[wii setDelegate:self];

	[bbstatus setStringValue:@"Connected"];
	
	[status setStringValue:@"Tap the button to tare, then step on..."];
}

- (void) WiiRemoteDiscoveryError:(int)code {
	
	NSLog(@"Error: %u", code);
		
	// Keep trying...
	[discovery stop];
	sleep(1);
	[discovery start];
}

- (void) willStartWiimoteConnections {

}
@end
