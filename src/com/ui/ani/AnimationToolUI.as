package com.ui.ani {
	
	import com.ui.BaseUI;
	
	/**
	 * 动画工具处理界面,自定义动画格式(.ani)=动画图片资源+动画配置文件
	 * @author taojianlong 2014/10/6 22:22
	 */
	public class AnimationToolUI extends BaseUI{
		
		private var xml:XML = 	
							<data>
								
							</data>;
		
		public function AnimationToolUI() {
			
			super( xml , 800 , 600 );
		}
	
	}
}