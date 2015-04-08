//
//  HackerTyperView.m
//  HackerTyper
//
//  Created by Simon Fransson on 2015-04-07.
//  Copyright (c) 2015 Simon Fransson. All rights reserved.
//

#import "HackerTyperView.h"
#import <WebKit/WebKit.h>

@implementation HackerTyperView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
        self.webView = [[WebView alloc] initWithFrame:frame];

        NSString *bundleIdentifier = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSURL *url = [[[[NSBundle bundleWithIdentifier:bundleIdentifier] resourceURL] URLByAppendingPathComponent:@"index"] URLByAppendingPathExtension:@"html"];
        
        NSLog(@"URL (%@): %@", [url absoluteString], bundleIdentifier);
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView.mainFrame loadRequest:urlRequest];
        
        [self.webView setFrameLoadDelegate:self];
        [self.webView.mainFrame.frameView setAllowsScrolling:NO];
        self.webView.alphaValue = 0.0;
        
        [self addSubview:self.webView];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    DOMDocument *doc = self.webView.mainFrameDocument;
    DOMAbstractView *window = [doc defaultView];
    DOMUIEvent *evt = (DOMUIEvent *)[doc createEvent:@"UIEvents"];
    [evt initUIEvent:@"keydown" canBubble:YES cancelable:YES view:window detail:1];
    [doc dispatchEvent:evt];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

#pragma mark WebFrameLoadDelegate

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    self.webView.alphaValue = 1.0;
}

@end
