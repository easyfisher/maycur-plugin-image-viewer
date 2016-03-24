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
    self.containerController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidClick)];
    
    [self.webView.superview addSubview:self.navigationController.view];
    [UIView  animateWithDuration:0.35 animations:^(){
        self.scrollView.frame = CGRectMake(0, 0, width, height);
    }];
}

- (void)doneDidClick {
    CGFloat width = self.webView.bounds.size.width;
    CGFloat height = self.webView.bounds.size.height;
    [UIView animateWithDuration:0.35 animations:^(){
        self.scrollView.frame = CGRectMake(width/2, height/2, 0, 0);
    } completion:^(BOOL finished){
        [self.navigationController.view removeFromSuperview];
        self.navigationController = nil;
        self.containerController = nil;
        self.scrollView = nil;
    }];
}

@end