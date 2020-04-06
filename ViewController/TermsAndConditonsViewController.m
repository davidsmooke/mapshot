//
//  TermsAndConditonsViewController.m
//  ArtMap
//
//

#import "TermsAndConditonsViewController.h"

@interface TermsAndConditonsViewController ()

@end

@implementation TermsAndConditonsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{

    //http://54.200.29.107/mapshot/terms.html
    //http://artmap.innoppldesigns.com/uploads/terms.html
  
 NSURLRequest *termsAndConUrlRequest=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://54.200.29.107/mapshot/terms.html"]];
    termsAndConditionWebView.scrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
       [termsAndConditionWebView loadRequest:termsAndConUrlRequest];
    [self.view addSubview:termsAndConditionWebView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{

}

-(void)viewDidAppear:(BOOL)animated
{
    if (IS_DEVICE_RUNNING_IOS_7_AND_ABOVE()) {
       // RHViewControllerDown();
    }
    
}
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
