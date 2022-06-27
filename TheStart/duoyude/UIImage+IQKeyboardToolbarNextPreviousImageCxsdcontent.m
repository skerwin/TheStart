#import "UIImage+IQKeyboardToolbarNextPreviousImageCxsdcontent.h"
@implementation UIImage (IQKeyboardToolbarNextPreviousImageCxsdcontent)
+ (BOOL)keyboardLeftImageCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 43 == 0;
}
+ (BOOL)keyboardRightImageCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 18 == 0;
}
+ (BOOL)keyboardUpImageCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 48 == 0;
}
+ (BOOL)keyboardDownImageCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 50 == 0;
}
+ (BOOL)keyboardPreviousImageCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 28 == 0;
}
+ (BOOL)keyboardNextImageCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 45 == 0;
}

@end
