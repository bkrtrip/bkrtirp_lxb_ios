//
//  CreateOrderCell_Input.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_Input.h"

const NSInteger Max_Textfield_Input_Length_Limit = 10;

@interface CreateOrderCell_Input() <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *inputTypeLabel;

@property (strong, nonatomic) UIBarButtonItem *prevBarButton;
@property (strong, nonatomic) UIBarButtonItem *nextBarButton;
@property (strong, nonatomic) UIBarButtonItem *doneBarButton;

@property (assign, nonatomic) NSInteger section;
@property (assign, nonatomic) NSInteger row;

@end

@implementation CreateOrderCell_Input

- (void)awakeFromNib {
    // Initialization code
    _inputTextField.inputAccessoryView = [self setUpTextFieldAccessoryView];
    _inputTextField.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_inputTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomTextFieldIsReached) name:@"BottomTextFieldIsReached" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topTextFieldIsReached) name:@"TopTextFieldIsReached" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalTextFieldStatus) name:@"NormalTextFieldStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldResignFirstResponder) name:@"TextFieldIResignFirstResponder" object:nil];
}

- (void)setCellContentWithInputType:(NSString *)type section:(NSInteger)section row:(NSInteger)row
{
    _inputTypeLabel.text = type;
    _section = section;
    _row = row;
}

- (void)bottomTextFieldIsReached
{
    [_nextBarButton setEnabled:NO];
    [_prevBarButton setEnabled:YES];
    [_doneBarButton setEnabled:YES];
}

- (void)topTextFieldIsReached
{
    [_nextBarButton setEnabled:YES];
    [_prevBarButton setEnabled:NO];
    [_doneBarButton setEnabled:YES];
}

- (void)normalTextFieldStatus
{
    [_nextBarButton setEnabled:YES];
    [_prevBarButton setEnabled:YES];
    [_doneBarButton setEnabled:YES];
}

- (void)textFieldResignFirstResponder
{
    [_inputTextField resignFirstResponder];
}

#pragma mark - "确认" toolbar
- (UIToolbar *)setUpTextFieldAccessoryView
{
    // set up textfield's toolbar
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _prevBarButton = [[UIBarButtonItem alloc] initWithTitle:@"上一项" style:UIBarButtonItemStyleBordered target:self action:@selector(prevButtonIsClicked:)];
    _nextBarButton = [[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleBordered target:self action:@selector(nextButtonIsClicked:)];
    
    _doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonIsClicked:)];
    NSArray *barButtonItems = @[_prevBarButton, _nextBarButton, flexBarButton, _doneBarButton];
    toolbar.items = barButtonItems;
    return toolbar;
}

- (void)doneButtonIsClicked:(id)sender
{
    [_inputTextField endEditing:YES];
}

- (void)prevButtonIsClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(supportClickWithPreviousIndexPath:)]) {
        [self.delegate supportClickWithPreviousIndexPath:[NSIndexPath indexPathForRow:_row inSection:_section]];
    }
}

- (void)nextButtonIsClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(supportClickWithNextIndexPath:)]) {
        [self.delegate supportClickWithNextIndexPath:[NSIndexPath indexPathForRow:_row inSection:_section]];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(setEditingCellIndexWithIndexPath:)]) {
        [self.delegate setEditingCellIndexWithIndexPath:[NSIndexPath indexPathForRow:_row inSection:_section]];
    }
}

#pragma mark - notification recall
- (void)textFiledEditChanged:(NSNotification *)note
{
    NSUInteger orgIndex = 0;
    NSUInteger calIndex = 0;
    
    UITextField *textField = (UITextField *)note.object;
    
    for (int i = 0; i < textField.text.length; i++) {
        unichar chi = [textField.text characterAtIndex:i];
        if (chi >=0x4E00 && chi <=0x9FFF)
        {
            orgIndex++;
            
            calIndex++;
            calIndex++;
        } else {
            orgIndex++;
            calIndex++;
        }
    }
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (calIndex >= Max_Textfield_Input_Length_Limit) {
            [textField resignFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能超过10个字" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
            
            for (int i = textField.text.length - 1; i > 0; i--) {
                textField.text = [textField.text substringToIndex:i];
                [self.delegate setEditingCellTextWithText:textField.text];
                
                NSUInteger orgIndex = 0;
                NSUInteger calIndex = 0;
                for (int j = 0; j < textField.text.length; j++) {
                    unichar chi = [textField.text characterAtIndex:j];
                    if (chi >=0x4E00 && chi <=0x9FFF)
                    {
                        orgIndex++;
                        
                        calIndex++;
                        calIndex++;
                    } else {
                        orgIndex++;
                        calIndex++;
                    }
                }
                
                if (calIndex <= Max_Textfield_Input_Length_Limit) {
                    break;
                }
            }
        }
    }// 有高亮选择的字符串，则暂不对文字进行统计和限制
    else{
        
    }
    [self.delegate setEditingCellTextWithText:textField.text];
}

//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
//}


@end
