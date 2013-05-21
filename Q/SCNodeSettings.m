//
//  SCNodeSettings.m
//  Q
//
//  Created by Bocas on 13-05-20.
//
//

#import "SCNodeSettings.h"

NSInteger const DISMISS_BUTTON = 0;

@implementation SCNodeSettings

-(id) init {
    
    self = [super initWithColor:ccc4(150, 50, 70, 200)];
    
    if (self) {
        [self setScaleX: 0.5];
        [self setScaleY: 0.7];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchDown];
//        button.frame = CGRectMake( 500, 400, 32, 32 );
//        button.tag = DISMISS_BUTTON;
//        [button setImage:[UIImage imageNamed:@"node_up.png"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"node_down.png"] forState:UIControlStateSelected];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(dismiss)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Close" forState:UIControlStateNormal];
        button.frame = CGRectMake(500, 500, 120.0, 30.0);
        
        [self addChild:[CCUIViewWrapper wrapperForUIView:button]];
        
        UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(300, 100, 320, 100)];
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        [self addChild:[CCUIViewWrapper wrapperForUIView:myPickerView]];
    }
    
    return self;
}

// -----------------------------------------------------------------------

-(void) dismiss {
    [self removeAllChildrenWithCleanup:YES];
    [self.parent removeChild:self cleanup:YES];
}

#pragma mark - UIPickerView

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 5;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%d",row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

@end
