#import "UITextView+PlaceHolderCxsdcontent.h"
@implementation UITextView (PlaceHolderCxsdcontent)
+ (BOOL)setPlaceHolderCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 21 == 0;
}
+ (BOOL)placeHolderCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 25 == 0;
}
+ (BOOL)textViewChangedCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 50 == 0;
}
+ (BOOL)textViewBeginChangedCxsdcontent:(NSInteger)CXSDContent {
    return CXSDContent % 5 == 0;
}

@end
