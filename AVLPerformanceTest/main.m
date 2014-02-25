#import "AVLNode.h"
#import "MGBenchmark.h"
#import "MGBenchmarkSession.h"


void runPerformanceTests()
{
	NSString *description;
	MGBenchStart(@"AVLPerformanceTest");


	AVLNode *avlTree = [[AVLNode alloc] initWithValue:@1 andIndex:1];
	int j = 0;
	for (; j < 500000; j++)
	{
		avlTree = [avlTree newWithValue:@(1) andIndex:(unsigned long)j];
	}


	description = [NSString stringWithFormat:@"Created all %i elements of avl tree", j];
	MGBenchStep(@"AVLPerformanceTest", description);


	NSArray *allEntries = avlTree.allObjects;


	description = [NSString stringWithFormat:@"Got all %i elements of avl tree", j];
	MGBenchStep(@"AVLPerformanceTest", description);



	AVLNode *node = avlTree.left;
	int i = 0;
	for (; i < avlTree.depth; i++)
	{
		if(node.left)
		{
			node = node.left;
		}
		else if(node.right)
		{
			node = node.right;
		}
		else
		{
			break;
		}
		
		node.value = @(100 + i);
	}



	description = [NSString stringWithFormat:@"Changed value of %i elements in avl tree", i];
	MGBenchStep(@"AVLPerformanceTest", description);



	for (; j >= 0; j--)
	{
		avlTree = [avlTree newWithoutValueOnIndex:(unsigned long)j];
	}

	

	MGBenchStep(@"AVLPerformanceTest", @"Removed all elements from avl tree");

    MGBenchEnd(@"AVLPerformanceTest");
}



int main(int argc, const char * argv[])
{
    @autoreleasepool
	{
        runPerformanceTests();
    }
	
    return 0;
}