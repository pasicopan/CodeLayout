CodeLayout
==========

Alternative to autolayout

Motivation
==========

When IPhone6 and IPhone6+ come out, anyone said that the AutoLayout is the ONLY way to go, also StoryBoard. But I'm not a fan of 
StoryBoard, and also not a fan to do bunch of if else. Then I got the idea to create a library to do layout in code which provides
no less feature than AutoLayout.

Note: CodeLayout is in early stage, api not firmed yet.

Usage
==========

You can specify a view's layout by

```Swift
left: PrevWidth * 0.3, width: ParentWidth * 0.4 - 40, vcenter: ParentHeight * 0.5, height: Value(100)
```

It will set the view's frame by: x equals to the 30% of prev view's width, width as 40% of parent width then minus 40. Verticle center
in parent view and height with absolute value 100.

The Above view's layout is meaningless, but it demos how flexible it is. 

Features
===========

Specify view's layout by left, right, hcenter, width, top, bottom, vcenter, height. Take left, right, hcenter, width as example,
you set any two values of them, their values can be calculated. E.g, left: 20, right: 60 => hcenter: 40, width: 40.

Very expressive syntax. 
```
left: PrevRight + 20   put the view 20 after the prev view
width: ParentWidth - 40, hcenter: ParentWidth * 0.5  put the view at center of parent view, with left margin and right margin 20
width: NextLeft - MeLeft - 20
```
