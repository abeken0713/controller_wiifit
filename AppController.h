#import <Cocoa/Cocoa.h>

//#import "PrefsController.h"
#import "WiiRemote.h"
#import "WiiRemoteDiscovery.h"
#import "FPLevelIndicator.h"

@interface AppController : NSWindowController<WiiRemoteDelegate, WiiRemoteDiscoveryDelegate> {
    
	IBOutlet NSTextField* weight;
	IBOutlet NSTextField* status;
	IBOutlet NSTextField* bbstatus;
	IBOutlet FPLevelIndicator* weightIndicator;
	IBOutlet NSMenuItem* fileConnect;
	IBOutlet NSMenuItem* fileTare;
	IBOutlet NSWindow* prefs;
	//IBOutlet PrefsController *prefsController;
    
    NSMutableArray *profiles;
    NSDictionary *strings;

	WiiRemoteDiscovery* discovery;
	WiiRemote* wii;
	
	float tare;
	float avgWeight;
	float sentWeight;
	float lastWeight;
	float weightSamples[100];
	int weightSampleIndex;
	BOOL sent;
	float height_cm;
}

- (NSString*)stringForKey:(NSString *)key;
- (NSArray*)getFromStorage;
- (void)setToStorage:(NSArray *)storeArray;

- (IBAction)doDiscovery:(id)sender;
- (IBAction)doTare:(id)sender;



@end
