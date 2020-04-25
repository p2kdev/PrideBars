#define kOriginalBarCount 4

static NSArray<UIColor *> *colours;

@interface _UIStatusBarSignalView : UIView
@property (nonatomic, assign) NSInteger pridebars_maxBarStrength;
@property (assign,nonatomic) NSInteger numberOfBars;
@property (assign,nonatomic) NSInteger numberOfActiveBars;
- (void)pridebars_setPrideColors;
@end

@interface _UIStatusBarCellularSignalView : _UIStatusBarSignalView
// Sublayers are CALayers
// Set the color by modifying the sublayer's backgroundColor
@end

%hook _UIStatusBarCellularSignalView

- (void)_updateActiveBars {
	%orig;
	[self pridebars_setPrideColors];
}

- (void)_colorsDidChange {
	%orig;
	[self pridebars_setPrideColors];
}

%new
- (void)pridebars_setPrideColors {
	for (int i = 0; i < self.numberOfBars; i++) {
		self.layer.sublayers[i].backgroundColor = [colours[i] colorWithAlphaComponent:i <= self.numberOfActiveBars ? 1 : 0.15].CGColor;
	}
}

// // iOS 11 bar width
// - (CGFloat)_barWidth {
// 	return %orig / colours.count * self.pridebars_maxBarStrength;
// }
//
// - (CGFloat)_interspace {
// 	return %orig / colours.count * self.pridebars_maxBarStrength / 2;
// }
//
// // iOS 12+ bar width
// + (CGFloat)_barWidthForIconSize:(NSInteger)iconSize {
// 	return %orig / colours.count * kOriginalBarCount;
// }
//
// + (CGFloat)_interspaceForIconSize:(NSInteger)iconSize {
// 	return %orig / colours.count * kOriginalBarCount / 2;
// }

%end

%ctor {
	colours = @[UIColor.systemRedColor, UIColor.systemOrangeColor, UIColor.systemBlueColor, UIColor.systemGreenColor];
	%init;

}
