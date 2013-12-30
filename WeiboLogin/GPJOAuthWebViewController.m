//
//  GPJOAuthWebViewController.m
//  WeiboLogin
//
//  Created by 巩 鹏军 on 12/29/13.
//  Copyright (c) 2013 Gong Pengjun. All rights reserved.
//

#import "GPJOAuthWebViewController.h"

@interface GPJOAuthWebViewController () <UIWebViewDelegate>
{
    NSInteger _loadRef;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation GPJOAuthWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadRef = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *urlString = @"https://api.weibo.com/oauth2/authorize?client_id=4281529580&response_type=code&redirect_uri=http%3A//www.gongpengjun.com/binding-sina";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlstr = [request.mainDocumentURL absoluteString];
    NSLog(@"%s,%d %@",__FUNCTION__,__LINE__,urlstr);
    if([urlstr hasPrefix:@"http://www.gongpengjun.com/binding-sina"])
    {
        NSString* query = [request.mainDocumentURL query];
        NSArray *components = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        for (NSString *component in components)
        {
            NSArray *subcomponents = [component componentsSeparatedByString:@"="];
            NSString *key   = [[subcomponents objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [[subcomponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if(key)
                parameters[key] = value;
        }
        NSLog(@"%s,%d authorize code: %@",__FUNCTION__,__LINE__,parameters[@"code"]);
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _loadRef ++;
    NSLog(@"%s,%d #%d",__FUNCTION__,__LINE__,_loadRef);
    if (_loadRef == 1) {
        // show loading progress HUD
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _loadRef --;
    if (_loadRef == 0) {
        // finished. hide loading progress HUD
        NSLog(@"%s,%d finished successfully",__FUNCTION__,__LINE__);
        
        NSString* script = @"alert('Load Successfully');";
        [self injectJavascriptFromString:script];
        
        NSString *jqueryCDN = @"http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js";
        [self injectJavascriptFromURL:[NSURL URLWithString:jqueryCDN]];
        
        [self injectJavascriptFromFile:@"hook"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadRef --;
    if (_loadRef == 0) {
        // finished. hide loading progress HUD
        NSLog(@"%s,%d finished with error: %@",__FUNCTION__,__LINE__,[error localizedDescription]);
        NSString* script = [NSString stringWithFormat:@"alert('Load Failed: %@');",[error localizedDescription]];
        [self injectJavascriptFromString:script];
    }
}

#pragma mark - Helper

- (void)injectJavascriptFromString:(NSString*)script {
    [self.webView stringByEvaluatingJavaScriptFromString:script];
}

- (void)injectJavascriptFromFile:(NSString*)resource {
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)injectJavascriptFromURL:(NSURL*)url {
    NSData *jsData = [NSData dataWithContentsOfURL:url];
    NSString *js = [[NSMutableString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

@end
