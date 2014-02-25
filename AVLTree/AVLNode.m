//
//  AVLNode.h
//  AVL tree / Node
//
//  Inspired by Chris Cavanagh
//  https://gist.github.com/BobStrogg/8449933


#import "AVLNode.h"

@implementation AVLNode
{
	AVLNode *_left;
	AVLNode *_right;
	int _count;
	int _depth;
}

- (AVLNode *)left
{
	return _left;
}

- (AVLNode *)right
{
	return _right;
}

- (int)count
{
	return _count;
}

- (int)depth
{
	return _depth;
}

- (int)balance
{
	return _left.depth - _right.depth;
}

- (id)initWithValue:(id)value andIndex:(u_long)index
{
	return [self initWithValue:value left:nil right:nil index:index];
}

- (id)initWithValue:(id)value
			   left:(AVLNode *)left
			  right:(AVLNode *)right
			  index:(u_long)index
{
	if ((self = [super init]))
	{
		[self setValue:value left:left right:right index:index];
	}

	return self;
}

- (void)setValue:(id)value
			left:(AVLNode *)left
		   right:(AVLNode *)right
		   index:(u_long)index
{
	_value = value;
	_left = left;
	_right = right;
	_count = 1 + _left.count + _right.count;
	_depth = 1 + MAX( _left.depth, _right.depth );
	_index = index;
}

- (AVLNode *)fixRootBalance
{
	int balance = [self balance];

	if (abs(balance) < 2)
	{
		return self;
	}

	if (balance == 2)
	{
		int leftBalance = [_left balance];

		if (leftBalance == 1 || leftBalance == 0)
		{
			//Easy case:
			return [self rotateToRight];
		}

		if (leftBalance == -1)
		{
			//Rotate LeftDictionary:
			AVLNode *newLeft = [_left rotateToLeft];
			AVLNode *newRoot = [self newOrMutate:_value left:newLeft right:_right index:_index];

			return [newRoot rotateToRight];
		}

		[NSException raise:@"LeftDictionary too unbalanced" format:@"LeftDictionary too unbalanced: %d", leftBalance];
	}

	if (balance == -2)
	{
		int rightBalance = [_right balance];

		if (rightBalance == -1 || rightBalance == 0)
		{
			//Easy case:
			return [self rotateToLeft];
		}

		if (rightBalance == 1)
		{
			//Rotate RightDictionary:
			AVLNode *newRight = [_right rotateToRight];
			AVLNode *newRoot = [self newOrMutate:_value left:_left right:newRight index:_index];

			return [newRoot rotateToLeft];
		}

		[NSException raise:@"RightDictionary too unbalanced" format:@"RightDictionary too unbalanced: %d", rightBalance];
	}

	//In this case we can show: |balance| > 2
	[NSException raise:@"Tree too out of balance" format:@"Tree too out of balance: %d", balance];

	return nil;
}

- (AVLNode *)newWithValue:(id)value andIndex:(u_long)newValueIndex
{
	AVLNode *newLeft = _left;
	AVLNode *newRight = _right;

	id newValue = _value;
	u_long newIndex = _index;

	if (newValueIndex < _index)
	{
		if (!_left)
		{
			newLeft = [[AVLNode alloc] initWithValue:value andIndex:newValueIndex];
		}
		else
		{
			newLeft = [_left newWithValue:value andIndex:newValueIndex];
		}
	}
	else if (newValueIndex > _index)
	{
		if (!_right)
		{
			newRight = [[AVLNode alloc] initWithValue:value andIndex:newValueIndex];
		}
		else
		{
			newRight = [_right newWithValue:value andIndex:newValueIndex];
		}
	}

	else
	{
		newValue = value;
		newIndex = newValueIndex;
	}

	AVLNode *newRoot = [self newOrMutate:newValue left:newLeft right:newRight index:newIndex];

	return [newRoot fixRootBalance];
}

- (AVLNode *)newWithoutValueOnIndex:(u_long)removedValueIndex
{
	BOOL found = NO;
	
	return [self removedValueOnIndex:removedValueIndex found:&found];
}

- (AVLNode *)removedValueOnIndex:(u_long)removedValueIndex
							 found:(BOOL *)found
{
	if (removedValueIndex < _index)
	{
		AVLNode *newLeft = [_left removedValueOnIndex:removedValueIndex found:found];

		if (!*found)
		{
			//Not found, so nothing changed
			return self;
		}

		AVLNode *newRoot = [self newOrMutate:_value left:newLeft right:_right index:_index];

		return [newRoot fixRootBalance];
	}

	if (removedValueIndex > _index)
	{
		AVLNode *newRight = [_right removedValueOnIndex:removedValueIndex found:found];

		if (!*found)
		{
			//Not found, so nothing changed
			return self;
		}

		AVLNode *newRoot = [self newOrMutate:_value left:_left right:newRight index:_index];

		return [newRoot fixRootBalance];
	}

	//found it
	*found = YES;
	return [self removeRoot];
}

- (AVLNode *)removeMax:(AVLNode **)max
{
	if (!_right)
	{
		//We are the max:
		*max = self;
		return _left;
	}
	else
	{
		//Go down:
		AVLNode *newRight = [_right removeMax:max];
		AVLNode *newRoot = [self newOrMutate:_value left:_left right:newRight index:_index];

		return [newRoot fixRootBalance];
	}
}

- (AVLNode *)removeMin:(AVLNode **)min
{
	if (!_left)
	{
		//We are the minimum:
		*min = self;

		return _right;
	}
	else
	{
		//Go down:
		AVLNode *newLeft = [_left removeMin:min];
		AVLNode *newRoot = [self newOrMutate:_value left:newLeft right:_right index:_index];

		return [newRoot fixRootBalance];
	}
}

- (AVLNode *)removeRoot
{
	if (!_left)
	{
		return _right;
	}

	if (!_right)
	{
		return _left;
	}

	//Neither are empty:
	if (_left->_count < _right->_count)
	{
		//LeftDictionary has fewer, so promote from RightDictionary to minimize depth
		AVLNode *min;
		AVLNode *newRight = [_right removeMin:&min];
		AVLNode *newRoot = [self newOrMutate:min.value left:_left right:newRight index:min.index];

		return [newRoot fixRootBalance];
	}
	else
	{
		AVLNode *max;
		AVLNode *newLeft = [_left removeMax:&max];
		AVLNode *newRoot = [self newOrMutate:max.value left:newLeft right:_right index:max.index];

		return [newRoot fixRootBalance];
	}
}

- (AVLNode *)rotateToRight
{
	AVLNode *leftLeft = _left.left;
	AVLNode *leftRight = _left.right;
	AVLNode *newRight = [self newOrMutate:_value left:leftRight right:_right index:_index];

	return [_left newOrMutate:_left.value left:leftLeft right:newRight index:_left.index];
}

- (AVLNode *)rotateToLeft
{
	AVLNode *rightLeft = _right.left;
	AVLNode *rightRight = _right.right;
	AVLNode *newLeft = [self newOrMutate:_value left:_left right:rightLeft index:_index];

	return [_right newOrMutate:_right.value left:newLeft right:rightRight index:_right.index];
}

- (AVLNode *)newOrMutate:(id)newValue left:(AVLNode *)newLeft right:(AVLNode *)newRight index:(u_long)index
{
	return [[AVLNode alloc] initWithValue:newValue left:newLeft right:newRight index:index];
}

- (NSArray *)allObjects
{
	NSMutableArray *result = [NSMutableArray new];
	[self fillArray:result];

	return result;
}

- (void)fillArray:(NSMutableArray *)array
{
	if (_left)
	{
		[_left fillArray:array];
	}

	if (_value)
	{
		[array addObject:_value];
	}

	if (_right)
	{
		[_right fillArray:array];
	}
}

@end