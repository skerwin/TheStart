#import <UIKit/UIView.h>
#import <UIKit/UIViewController.h>
#import "IQKeyboardManagerConstants.h"
#import "IQUIView+Hierarchy.h"
#import "IQUITextFieldView+Additions.h"
#import "IQUIViewController+Additions.h"
#import <UIKit/UICollectionView.h>
#import <UIKit/UIAlertController.h>
#import <UIKit/UITableView.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>
#import <UIKit/UISearchBar.h>
#import <UIKit/UINavigationController.h>
#import <UIKit/UITabBarController.h>
#import <UIKit/UISplitViewController.h>
#import <UIKit/UIWindow.h>
#import <objc/runtime.h>

@interface UIView (IQ_UIView_HierarchyCxsdcontent)
+ (BOOL)viewContainingControllerCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)topMostControllerCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)parentContainerViewControllerCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)superviewOfClassTypeCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)superviewOfClassTypeBelowviewCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)_IQcanBecomeFirstResponderCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)responderSiblingsCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)deepResponderViewsCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)convertTransformToViewCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)depthCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)subHierarchyCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)superHierarchyCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)debugHierarchyCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)textFieldSearchBarCxsdcontent:(NSInteger)CXSDContent;
+ (BOOL)isAlertViewTextFieldCxsdcontent:(NSInteger)CXSDContent;

@end
