//
//  CCHLinkTextView.m
//  CCHLinkTextView Example
//
//  Created by Claus Höfele on 28.02.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

// Based on http://stackoverflow.com/questions/19332283/detecting-taps-on-attributed-text-in-a-uitextview-on-ios-7

#import "CCHLinkTextView.h"

#import "CCHLinkTextViewDelegate.h"

@interface CCHLinkTextView ()

@property (nonatomic, strong) NSMutableArray *linkRanges;

@end

@implementation CCHLinkTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    self.linkRanges = [NSMutableArray array];
    
    // http://stackoverflow.com/questions/15628133/uitapgesturerecognizer-make-it-work-on-touch-down-not-touch-up
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [recognizer locationInView:self];
        location.x -= self.textContainerInset.left;
        location.y -= self.textContainerInset.top;
        
        NSUInteger characterIndex = [self.layoutManager characterIndexForPoint:location inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
        for (NSValue *value in self.linkRanges) {
            NSRange range = value.rangeValue;
            if (NSLocationInRange(characterIndex, range)) {
                [self linkTappedAtCharacterIndex:characterIndex range:range];
            }
        }
    }
}

- (void)linkTappedAtCharacterIndex:(NSUInteger)characterIndex range:(NSRange)range
{
//    NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.redColor};
//    [self updateWithAttributes:attributes range:range];

    if ([self.linkDelegate respondsToSelector:@selector(linkTextView:didTapLinkAtCharacterIndex:)]) {
        [self.linkDelegate linkTextView:self didTapLinkAtCharacterIndex:characterIndex];
    }
}

- (void)addLinkForRange:(NSRange)range
{
    [self.linkRanges addObject:[NSValue valueWithRange:range]];

    NSDictionary *attributes = @{NSBackgroundColorAttributeName : UIColor.greenColor};
    [self updateWithAttributes:attributes range:range];
}

- (void)updateWithAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    NSMutableAttributedString *attributedText = [self.attributedText mutableCopy];
    [attributedText addAttributes:attributes range:range];
    self.attributedText = attributedText;
}

@end