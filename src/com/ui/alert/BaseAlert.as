package com.ui.alert {
	import com.ui.componet.Alert;
	import com.UIGlobal;
	
	
	/**
	 * 基类提示框
	 * @author cl 2014/2/13 13:27
	 */
	public class BaseAlert extends Alert{
		
		public function BaseAlert() {
			
			super(460, 384, UIGlobal.STAGE_WIDTH, UIGlobal.STAGE_HEIGHT);
			
			this.backgroundClass = "common|alert_back";
			this.setYesSourceClass( "common|hero_show_btn_out" , "common|hero_show_btn_over" , "common|hero_show_btn_down" );
			this.setNoSourceClass( "common|hero_show_btn_out" , "common|hero_show_btn_over" , "common|hero_show_btn_down" );
			this.setCloseSourceClass( "common|close_out" , "common|close_over" , "common|close_down" );
			
			yesBtn.bottom  = 33;
			noBtn.bottom   = 33;
			closeBtn.top   = 4;
			closeBtn.right = 5;
			closeBtn.label = "";
			
			this.showBtn( Alert.OK | Alert.CANCEL );
			
			setOffset( 80 , -13 , 10 , -28 , 23 );			
		}
		
		//初始化界面
		protected function init():void { }
		
		
	}

}