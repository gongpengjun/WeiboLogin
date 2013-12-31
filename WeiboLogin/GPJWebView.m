//
//  GPJWebView.m
//  WeiboLogin
//
//  Created by 巩 鹏军 on 13-12-30.
//  Copyright (c) 2013年 Gong Pengjun. All rights reserved.
//

#import "GPJWebView.h"

@implementation GPJWebView

// from .xib or .storyboard
- (id)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
//#ifdef DEBUG
        [self createJavascriptLogger];
//#endif
    }
    return self;
}

- (void) createJavascriptLogger
{
    NSLog(@"Adding javascript logger to webview %@", self);
    NSString *createLoggerJS = @"console = { msgs: new Array(), log: function(msg) { console.msgs.push(msg); }, shift: function() { return console.msgs.shift(); } };";
    [self stringByEvaluatingJavaScriptFromString:createLoggerJS];
    [self readJavascriptLogger];
}

- (void) readJavascriptLogger
{
    NSString *msg = NULL;
    while( (msg = [self stringByEvaluatingJavaScriptFromString:@"console.shift();"]) != NULL && [msg length] != 0)
    {
        NSLog(@"JS: %@", msg);
    }
    [self performSelector:@selector(readJavascriptLogger) withObject:nil afterDelay:0.1];
}

@end
