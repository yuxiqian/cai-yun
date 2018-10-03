//
//  NSProgressIndicator+ESSProgressIndicatorCategory.m
//  Briefly
//
//  Created by Matthias Gansrigler on 06.05.2015.
//  Copyright (c) 2015 Eternal Storms Software. All rights reserved.
//

#import "NSProgressIndicator+ESSProgressIndicatorCategory.h"

@interface ESSProgressBarAnimation : NSAnimation

@property (weak) NSProgressIndicator *progInd;
@property (assign) double initialValue;
@property (assign) double newValue;

- (instancetype)initWithProgressBar:(NSProgressIndicator *)ind
					 newDoubleValue:(double)val;

@end


@implementation NSProgressIndicator (ESSProgressIndicatorCategory)

static ESSProgressBarAnimation *animA = nil;
static ESSProgressBarAnimation *animB = nil;
static ESSProgressBarAnimation *animC = nil;
static ESSProgressBarAnimation *animD = nil;

- (void)animateToDoubleValueA:(double)val
{
	if (animA != nil)
	{
		double oldToValue = animA.newValue;
		[animA stopAnimation];
		animA = nil;
		self.doubleValue = oldToValue;

	}
	
	animA = [[ESSProgressBarAnimation alloc] initWithProgressBar:self
												 newDoubleValue:val];
	[animA startAnimation];

}



- (void)animateToDoubleValueB:(double)val
{
    if (animB != nil)
    {
        double oldToValue = animB.newValue;
        [animB stopAnimation];
        animB = nil;
        self.doubleValue = oldToValue;

    }
    
    animB = [[ESSProgressBarAnimation alloc] initWithProgressBar:self
                                                  newDoubleValue:val];
    [animB startAnimation];

}

- (void)animateToDoubleValueC:(double)val
{
    if (animC != nil)
    {
        double oldToValue = animC.newValue;
        [animC stopAnimation];
        animC = nil;
        self.doubleValue = oldToValue;

    }
    
    animC = [[ESSProgressBarAnimation alloc] initWithProgressBar:self
                                                  newDoubleValue:val];
    [animC startAnimation];
 
}

- (void)animateToDoubleValueD:(double)val
{
    if (animD != nil)
    {
        double oldToValue = animD.newValue;
        [animD stopAnimation];
        animD = nil;
        self.doubleValue = oldToValue;

    }
    
    animD = [[ESSProgressBarAnimation alloc] initWithProgressBar:self
                                                  newDoubleValue:val];
    [animD startAnimation];

}



- (void)animationDealloc
{
    

    [animA stopAnimation];
    animA = nil;
    
    [animB stopAnimation];
    animB = nil;
    
    [animC stopAnimation];
    animC = nil;
    
    [animD stopAnimation];
    animD = nil;
    

}


@end


@implementation ESSProgressBarAnimation

- (instancetype)initWithProgressBar:(NSProgressIndicator *)ind
					 newDoubleValue:(double)val
{
	if (self = [super initWithDuration: 0.5 animationCurve:NSAnimationEaseOut])
	{
		self.progInd = ind;
		self.initialValue = self.progInd.doubleValue;
		self.newValue = val;
		self.animationBlockingMode = NSAnimationNonblocking;
		return self;
	}
	
	return nil;
}

- (void)setCurrentProgress:(NSAnimationProgress)currentProgress
{
	[super setCurrentProgress:currentProgress];
	
	double delta = self.newValue - self.initialValue;
	
	self.progInd.doubleValue = self.initialValue + (delta * self.currentValue);
    
    // changed from currentProgress to currentValue to take into account animationCurves. Thanks, Alan B. for the tip
    
    printf("Now, progInd.doubleValue = %f, min = %f, max = %f)", self.progInd.doubleValue, self.progInd.minValue, self.progInd.maxValue);
    if ((int) self.progInd.doubleValue == (int) self.progInd.minValue) {
        self.progInd.doubleValue = self.progInd.minValue;
    } else if ((int) (self.progInd.doubleValue + 1) >= (int) (self.progInd.maxValue)) {
        self.progInd.doubleValue = self.progInd.maxValue;
    }
	
	if (currentProgress == 1.0 && [self.progInd respondsToSelector:@selector(animationDealloc)])
		[self.progInd animationDealloc];
}

@end


