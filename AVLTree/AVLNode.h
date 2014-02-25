//
//  AVLNode.h
//  AVL tree / Node
//
//  Inspired by Chris Cavanagh
//  https://gist.github.com/BobStrogg/8449933


@interface AVLNode : NSObject

@property (readonly) u_long index;
@property (nonatomic, strong) id value;

- (id)initWithValue:(id)value andIndex:(u_long)index;

- (AVLNode *)newWithValue:(id)value andIndex:(u_long)newValueIndex;
- (AVLNode *)newWithoutValueOnIndex:(u_long)index;

- (int) balance;
- (int) count;
- (int) depth;

- (AVLNode *) left;
- (AVLNode *) right;
- (NSArray *) allObjects;

@end