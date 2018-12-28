//
//  GlovoAppRootViewController.h
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 24/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlovoAppPresenterProtocol.h"
#import <CoreLocation/CoreLocation.h>



@interface GlovoAppRootViewController : UIViewController

@property (strong, nonatomic) NSObject <GlovoAppPresenterProtocol> *presenter;

- (instancetype)initWithPresenter:(NSObject <GlovoAppPresenterProtocol> *)presenter;

@end
