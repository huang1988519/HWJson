//
//  ViewController.h
//  HWJson
//
//  Created by huanwh on 2016/12/19.
//  Copyright © 2016年 huanwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *secondQueryTextField;

- (IBAction)cul:(id)sender;
@end

