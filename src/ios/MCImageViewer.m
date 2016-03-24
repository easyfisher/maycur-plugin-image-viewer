#import "MCImageViewer.h"
#import <Cordova/CDVPlugin.h>

@interface MCImageViewer()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIViewController *containerController;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MCImageViewer

- (void)show:(CDVInvokedUrlCommand*)command
{
    NSDictionary *params = [command.arguments objectAtIndex:0];
    NSString *message = [params objectForKey:@"message"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"666" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor redColor];
    CGFloat width = self.webView.bounds.size.width;
    CGFloat height = self.webView.bounds.size.height;
    self.scrollView.frame = CGRectMake(width/2, height/2, 0, 0);
    
    for (int i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width * i + 10, 0, width - 20, height)];
        view.backgroundColor = [UIColor blueColor];
        [self.scrollView addSubview:view];
    }
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(3 * width, height);
    
    self.containerController = [[UIViewController alloc] init];
    self.containerController.view = self.scrollView;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.containerController];
    
    [self.webView.superview addSubview:self.navigationController.view];
    [UIView  animateWithDuration:0.35 animations:^(){
        self.scrollView.frame = CGRectMake(0, 0, width, height);
    }];
}

@end