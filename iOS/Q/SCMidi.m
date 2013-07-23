//
//  SCMidi.m
//  Q
//
//  Created by Bocas on 13-05-20.
//
//

#import "SCMidi.h"

int RandomNoteNumber() { return rand() / (RAND_MAX / 127); }

@implementation SCMidi

-(id) init {
    self = [super init];
    
    if (self) {
        IF_IOS_HAS_COREMIDI
        (
         // We only create a MidiInput object on iOS versions that support CoreMIDI
         midi = [[PGMidi alloc] init];
         midi.networkEnabled = YES;
         )
    }
    return self;
}

// -----------------------------------------------------------------------

#pragma mark - PGMidi

//NSString *ToString(PGMidiConnection *connection)
//{
//    return [NSString stringWithFormat:@"< PGMidiConnection: name=%@ isNetwork=%@ >",
//            connection.name, ToString(connection.isNetworkSession)];
//}

// -----------------------------------------------------------------------

//- (IBAction) listAllInterfaces
//{
//    IF_IOS_HAS_COREMIDI
//    ({
//        [self addString:@"\n\nInterface list:"];
//        for (PGMidiSource *source in midi.sources)
//        {
////            NSString *description = [NSString stringWithFormat:@"Source: %@", ToString(source)];
////            [self addString:description];
//        }
//        [self addString:@""];
//        for (PGMidiDestination *destination in midi.destinations)
//        {
////            NSString *description = [NSString stringWithFormat:@"Destination: %@", ToString(destination)];
////            [self addString:description];
//        }
//    })
//}

// -----------------------------------------------------------------------

//- (IBAction) sendMidiData
//{
//    [self performSelectorInBackground:@selector(sendMidiDataInBackground) withObject:nil];
//}

// -----------------------------------------------------------------------

#pragma mark - Shenanigans

- (void) attachToAllExistingSources
{
    for (PGMidiSource *source in midi.sources)
    {
        [source addDelegate:self];
    }
}

// -----------------------------------------------------------------------

- (void) setMidi:(PGMidi*)m
{
    midi.delegate = nil;
    midi = m;
    midi.delegate = self;
    
    [self attachToAllExistingSources];
}

// -----------------------------------------------------------------------

- (void) addString:(NSString*)string
{
    NSLog(@"addString: %@", string);
}

// -----------------------------------------------------------------------

- (void) updateCountLabel
{
    NSLog(@"sources=%u destinations=%u", midi.sources.count, midi.destinations.count);
}

// -----------------------------------------------------------------------

- (void) midi:(PGMidi*)midi sourceAdded:(PGMidiSource *)source
{
    [source addDelegate:self];
    [self updateCountLabel];
    //    [self addString:[NSString stringWithFormat:@"Source added: %@", ToString(source)]];
}

// -----------------------------------------------------------------------

- (void) midi:(PGMidi*)midi sourceRemoved:(PGMidiSource *)source
{
    [self updateCountLabel];
    //    [self addString:[NSString stringWithFormat:@"Source removed: %@", ToString(source)]];
}

// -----------------------------------------------------------------------

- (void) midi:(PGMidi*)midi destinationAdded:(PGMidiDestination *)destination
{
    [self updateCountLabel];
    //    [self addString:[NSString stringWithFormat:@"Desintation added: %@", ToString(destination)]];
}

// -----------------------------------------------------------------------

- (void) midi:(PGMidi*)midi destinationRemoved:(PGMidiDestination *)destination
{
    [self updateCountLabel];
    //    [self addString:[NSString stringWithFormat:@"Desintation removed: %@", ToString(destination)]];
}

// -----------------------------------------------------------------------

NSString *StringFromPacket(const MIDIPacket *packet)
{
    // Note - this is not an example of MIDI parsing. I'm just dumping
    // some bytes for diagnostics.
    // See comments in PGMidiSourceDelegate for an example of how to
    // interpret the MIDIPacket structure.
    return [NSString stringWithFormat:@"  %u bytes: [%02x,%02x,%02x]",
            packet->length,
            (packet->length > 0) ? packet->data[0] : 0,
            (packet->length > 1) ? packet->data[1] : 0,
            (packet->length > 2) ? packet->data[2] : 0
            ];
}

// -----------------------------------------------------------------------

- (void) midiSource:(PGMidiSource*)midi midiReceived:(const MIDIPacketList *)packetList
{
    [self performSelectorOnMainThread:@selector(addString:)
                           withObject:@"MIDI received:"
                        waitUntilDone:NO];
    
    const MIDIPacket *packet = &packetList->packet[0];
    for (int i = 0; i < packetList->numPackets; ++i)
    {
        [self performSelectorOnMainThread:@selector(addString:)
                               withObject:StringFromPacket(packet)
                            waitUntilDone:NO];
        packet = MIDIPacketNext(packet);
    }
}

// -----------------------------------------------------------------------

- (void) sendMidiDataInBackground
{
    for (int n = 0; n < 20; ++n)
    {
        const UInt8 note      = RandomNoteNumber();
        const UInt8 noteOn[]  = { 0x90, note, 127 };
        const UInt8 noteOff[] = { 0x80, note, 0   };
        
        [midi sendBytes:noteOn size:sizeof(noteOn)];
        [NSThread sleepForTimeInterval:0.1];
        [midi sendBytes:noteOff size:sizeof(noteOff)];
    }
}

@end
