#import "AppDelegate+threedeetouch.h"
#import "ThreeDeeTouch.h"
#import <objc/runtime.h>
#import "MainViewController.h"

@implementation AppDelegate (threedeetouch)

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
  if ([shortcutItem.type isEqualToString:@"forumch"]){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://forum.celsiusheroes.com"]];
  } else {
    /*NSString* jsFunction = @"ThreeDeeTouch.onHomeIconPressed";
    NSString *params = [NSString stringWithFormat:@"{'type':'%@', 'title': '%@'}", shortcutItem.type, shortcutItem.localizedTitle];
    NSString* result = [NSString stringWithFormat:@"%@(%@)", jsFunction, params];
    [self callJavascriptFunctionWhenAvailable:result];*/
  }
}

// check every x seconds for the phone  app to be ready, or stop from glance.didDeactivate
- (void) callJavascriptFunctionWhenAvailable:(NSString*)function {
  ThreeDeeTouch *threeDeeTouch = [self.viewController getCommandInstance:@"ThreeDeeTouch"];
  if (threeDeeTouch.initDone) {
      [threeDeeTouch.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:function waitUntilDone:NO];
  } else {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 25 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
      [self callJavascriptFunctionWhenAvailable:function];
    });
  }
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end