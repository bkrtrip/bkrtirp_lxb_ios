//
//  CreateOrderCell_Input.m
//  LXBtrip
//
//  Created by Yang Xiaozhu on 15/6/7.
//  Copyright (c) 2015年 LXB. All rights reserved.
//

#import "CreateOrderCell_Input.h"

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
    _inputTextField.placeholder = nil;
    _inputTextField.text = nil;
    _inputTextField.keyboardType = UIKeyboardTypeDefault;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_inputTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomTextFieldIsReached) name:@"BottomTextFieldIsReached" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topTextFieldIsReached) name:@"TopTextFieldIsReached" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalTextFieldStatus) name:@"NormalTextFieldStatus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldResignFirstResponder) name:@"TextFieldIResignFirstResponder" object:nil];
}

- (void)setCellContentWithInputType:(NSString *)type section:(NSInteger)section row:(NSInteger)row placeHolder:(NSString *)placeHolder text:(NSString *)text
{
    _inputTypeLabel.text = type;
    _section = section;
    _row = row;
    
    if (placeHolder) {
        _inputTextField.placeholder = placeHolder;
    } else {
        _inputTextField.placeholder = @"";
    }
    
    if (text) {
        _inputTextField.text = text;
    } else {
        _inputTextField.text = @"";
    }
    
    if (section == 2 && row == 1) {
        _inputTextField.keyboardType = UIKeyboardTypePhonePad;
    } else {
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
    }
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
    UITextField *textField = (UITextField *)note.object;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (_section == 2 && _row == 1) {
            if (textField.text.length > MAX_PHONE_NUMBER_LENGTH) {
//                [textField resignFirstResponder];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"手机号码长度不正确" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//                [alert show];
                textField.text = [textField.text substringToIndex:MAX_PHONE_NUMBER_LENGTH];
            }
        } else if (_section == 3 && _row%2 == 1) {
            if (textField.text.length > MAX_IDENTITY_NUMBER_LENGTH) {
//                [textField resignFirstResponder];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"身份证号码长度不正确" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
//                [alert show];
                textField.text = [textField.text substringToIndex:MAX_IDENTITY_NUMBER_LENGTH];
            }
        }
    } else {
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
    }
    
    [self.delegate setEditingCellTextWithText:textField.text];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}

@end
