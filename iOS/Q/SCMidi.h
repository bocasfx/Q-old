//
//  SCMidi.h
//  Q
//
//  Created by Bocas on 13-05-20.
//
//

#import <Foundation/Foundation.h>
#import "PGMidi.h"
#import "iOSVersionDetection.h"
#import "PGArc.h"
#import <CoreMIDI/CoreMIDI.h>

@class PGMidi;

@interface SCMidi : NSObject <PGMidiDelegate, PGMidiSourceDelegate> {
    PGMidi          *midi;
}

- (void) updateCountLabel;
- (void) addString:(NSString*)string;
- (void) sendMidiDataInBackground;

@end
