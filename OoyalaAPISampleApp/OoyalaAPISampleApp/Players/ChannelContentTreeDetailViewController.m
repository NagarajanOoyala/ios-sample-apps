/**
 * @class      ChannelContentTreeDetailViewController ChannelContentTreeDetailViewController.m "ChannelContentTreeDetailViewController.m"
 * @brief      A view that plays video after selecting from the channel list
 * @date       12/12/14
 * @copyright  Copyright (c) 2014 Ooyala, Inc. All rights reserved.
 */

#import "ChannelContentTreeDetailViewController.h"
#import <OoyalaSDK/OoyalaSDK.h>

@interface ChannelContentTreeDetailViewController () {
  NSString *embedCode;
  NSString *nib;
  NSString *pcode;
  NSString *playerDomain;

  OOOoyalaPlayerViewController *ooyalaPlayerViewController;
}

@end

@implementation ChannelContentTreeDetailViewController

- (instancetype)initWithPlayerSelectionOption:(PlayerSelectionOption *)playerSelectionOption {
  if (self = [super initWithPlayerSelectionOption:playerSelectionOption]) {
    nib = @"PlayerSimple";

    if (self.playerSelectionOption) {
      embedCode = self.playerSelectionOption.embedCode;
      self.title = self.playerSelectionOption.title;
      pcode = self.playerSelectionOption.pcode;
      playerDomain = self.playerSelectionOption.domain;
    } else {
      NSLog(@"There was no PlayerSelectionOption!");
      return nil;
    }
  }
  return self;
}

- (void)loadView {
  [super loadView];
  [[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  // Create Ooyala ViewController
  OOOoyalaPlayer *player = [[OOOoyalaPlayer alloc] initWithPcode:pcode domain:[[OOPlayerDomain alloc] initWithString:playerDomain]];
  ooyalaPlayerViewController = [[OOOoyalaPlayerViewController alloc] initWithPlayer:player];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(notificationHandler:)
                                               name:nil
                                             object:ooyalaPlayerViewController.player];

  // Attach it to current view
  [self addChildViewController:ooyalaPlayerViewController];
  [self.playerView addSubview:ooyalaPlayerViewController.view];
  [ooyalaPlayerViewController.view setFrame:self.playerView.bounds];

  // Load the video
  [ooyalaPlayerViewController.player setEmbedCode:embedCode];
  [ooyalaPlayerViewController.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) notificationHandler:(NSNotification*) notification {

  // Ignore TimeChangedNotificiations for shorter logs
  if ([notification.name isEqualToString:OOOoyalaPlayerTimeChangedNotification]) {
    return;
  }

  LOG(@"Notification Received: %@. state: %@. playhead: %f",
        [notification name],
        [OOOoyalaPlayer playerStateToString:[ooyalaPlayerViewController.player state]],
        [ooyalaPlayerViewController.player playheadTime]);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
