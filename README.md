## Introduction

This is an immutable avl tree implementation in Objective-C, that supports the basic features of this data structure.
For more general info visit [wikipedia](http://en.wikipedia.org/wiki/AVL_tree). If you want to know more in detail check out the GeeksforGeeks articles on [insertion](http://www.geeksforgeeks.org/avl-tree-set-1-insertion/) and [deletion](http://www.geeksforgeeks.org/avl-tree-set-2-deletion/).

### Features

* Add nodes with a custom index value to the tree
* Remove nodes with a custom index value from the tree
* Get all nodes as an array
* Get the left child node of a node
* Get the right child node of a node
* Get the depth of the subtree of a node
* Get the balance of the subtree of a node
* Get the number of nodes in the subtree of a node

## Installation via CocoaPods

- Install CocoaPods. See [http://cocoapods.org](http://cocoapods.org)
- Add the AVLTree reference to your Podfile:
``
    platform :ios
    	pod 'AVLTree'
    end
``
- Run `pod install` or `pod update` from the command line

## Contribution

This library is released under the [MIT licence](http://opensource.org/licenses/MIT). Feel free to contribute!

Also, follow me on Twitter if you like: [@StephanPartzsch](https://twitter.com/StephanPartzsch).
