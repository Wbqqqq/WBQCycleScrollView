# WbqCycleScrollView
一款基于SDCycleScrollView基础上加强的无限轮转图，支持自定义视图。

## 由来
SDCycleScrollView很好用,但是我在开发中经常碰到一些需要自定义的视图，这个时候我就不得不去改他的源码，我就想基于他，封装一个更好用的框架，显然，SDCycleScrollView的作者貌似已经不更新了，我希望能把这个项目持续更新下去，如果有更好的写法，请推荐给我。

### 用法

<pre><code>
self.v = [[WbqCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, 375, 200)];
self.v.pageControlStyle = WbqCycleCHIPageControlJalapenoStyle;
self.v.delegate = self;
self.v.dataSource = self;
self.v.customNumofPage = 5;

-(UIView * )cellView:(WbqCycleScrollView *)cycleScrollView viewForItemAtIndex:(NSInteger)index
{
   UIView * view = [[UIView alloc]initWithFrame:self.v.bounds];
   view.backgroundColor = [UIColor colorWithRed:index * 0.1 green:0.5 blue:0.5 alpha:1];
   return view;
}

</code></pre>

只要使用这个数据源方法就可以很方便实现自定义的视图了，其他的用法与SDCycleScrollView的用法基本一样，保持了他的原汁原味。


## 联系方式

我的邮箱：353351363@qq.com. 同样是我的QQ。 如果什么BUG、建议的话，在Issues向我提就好啦。 

## PS

我顺便把pageControl的样式也改了，用的是CHIPageControl，多种样式。效果很炫哦，快来试试吧~。

