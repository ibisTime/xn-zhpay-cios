//
//  XNPickerTextField.m
//  MOOM
//
//  Created by 田磊 on 16/6/23.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import "TLPickerTextField.h"

@interface TLPickerTextField ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic,weak) UIPickerView *pickerInput;

@end

@implementation TLPickerTextField


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.tagNames.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   return  self.tagNames[row];

}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_tagNames.count) {
        
        self.text = self.tagNames[row];
        
        if (self.didSelectBlock) {
            self.didSelectBlock(row);
        }
        
    }
}


- (void)setTagNames:(NSArray *)tagNames
{
    _tagNames = [tagNames copy];
    
    if (!self.pickerInput) {
        
        UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _pickerInput = picker;
        _pickerInput.delegate = self;
        _pickerInput.dataSource = self;
        _pickerInput.backgroundColor = [UIColor whiteColor];
        
        self.inputView = _pickerInput;
        self.isSecurity = YES;
        self.delegate = self;
    }
    
    [self.pickerInput reloadAllComponents];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if (_tagNames.count) {
        
//      self.text = _tagNames[0];
        
    }
    
    return YES;
}

@end
