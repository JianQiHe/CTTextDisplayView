# CTTextDisplayView

CTTextDisplayView 是一个CoreText完成的图文混排视图，主要用于文本中显示表情@#URL等，类似于QQ、微博的评论图文功能。

最近做一个图文混排功能，网上找到了几个比较好的库，但是都达不到自己想要的简单粗暴的效果，于是借鉴TQRichTextView的思想写了CTTextDisplayView，解决了文本中系统英文/自带emoji表情行距不一样、表情大小定制、字距等一些问题，并没有处理号码、邮箱及更多定制功能，代码简单易修改，所以需要的可以自己修改定制。

示例:

  效果:xxx@张三xxx

  代码:xxx@{张三}xxx 或 xxx@{张三:id}xxx
	


  效果:xxx#过年了#xxx

  代码:xxx#{过年了}xxx  或  xxx#{过年了:id}xxx



  效果:张三 回复 李四

  代码:${张三} 回复 ${李四:id}


********************* 注意: 此代码只作学习参考，不建议直接使用于实际项目中 ********************
********************* e-mail: 347991555@qq.com                 *********************

![image](https://github.com/BrownCN023/CTTextDisplayView/blob/master/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%882%E6%97%A5%20%E4%B8%8B%E5%8D%885.30.39.png)

![image](https://github.com/BrownCN023/CTTextDisplayView/blob/master/Simulator%20Screen%20Shot%202016%E5%B9%B44%E6%9C%882%E6%97%A5%20%E4%B8%8B%E5%8D%885.30.43.png)




