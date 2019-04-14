package com.manager {
	
	import com.manager.UIManager;
	import com.ui.alert.LogReadAlert;
	import com.ui.alert.LogWriteAlert;
	import com.ui.componet.Alert;
	import com.ui.componet.Rect;
	import com.ui.log.LogData;
	import com.UIGlobal;
	
	/**
	 * Alert 管理 2013/7/30 15:49
	 * @author cl
	 */
	public class AlertManager {
		
		private static var instance:AlertManager;
		private static var alertMsk:Rect;
		
		/**
		 * 显示Alert 可显示多个
		 * 
		 * @param	info      显示信息
		 * @param	title     显示标题
		 * @param	flag      显示参数
		 * @param	isHtml    是否显示HtmlText
		 * @param	parent    容器
		 * @param	okFunc    确认执行方法
		 * @param	noFunc    取消执行方法
		 * @param	closeFunc 关闭执行方法
		 */
		/*public static function show( info:String , title:String = "" ,  flag:int = 1 , isHtml:Boolean = false , data:Object = null , okFunc:Function = null , noFunc:Function = null , closeFunc:Function = null ):void {
			
			var alert:Alert = ObjectPool.getObjectPool( Alert ).getObject( 350 , 150 , UIGlobal.STAGE_WIDTH , UIGlobal.STAGE_HEIGHT ) as Alert;
			alert.show( info , title , flag , isHtml , data );
			alert.okFunc = okFunc;
			alert.noFunc = noFunc;
			alert.closeFunc = closeFunc;
			UIManager.addElement( alert , UIGlobal.topLayer , -1 , -1 );
		}*/
		
		/**
		 * 显示提示框,只显示一个
		 * 
		 * @param	info
		 * @param	title
		 * @param	isShadow 是否遮罩后面
		 * @param	flag     Alert.OK 只有确定按钮 , ( Alert.OK | Alert.CANCEL  确定和取消按钮！) 
		 * @param	isHtml
		 * @param	okFunc
		 * @param	noFunc
		 * @param	closeFunc
		 */
		public static function showAlert( info:String , title:String = "" , isShadow:Boolean = true , flag:int = 1 , isHtml:Boolean = false , data:Object = null , okFunc:Function = null , noFunc:Function = null , closeFunc:Function = null ):void {
			
			
			okFunc = okFunc || hideAlert;
			noFunc = noFunc || hideAlert;
			closeFunc = closeFunc || hideAlert;
			Alert.showAlert( info , title , flag , isHtml , data , UIGlobal.alertLayer , okFunc , noFunc , closeFunc );
			
			//设置Alert的皮肤			
			Alert.alert.setTitle( title , 28 , 0x9a7443 );
			Alert.alert.drawBack( 430 , 384 , UIGlobal.STAGE_WIDTH , UIGlobal.STAGE_HEIGHT );
			Alert.alert.backgroundClass = "common|alert_back";// 0xffccff;
			Alert.alert.setYesSourceClass( "common|hero_show_btn_out" , "common|hero_show_btn_over" ,  "common|hero_show_btn_down");
			Alert.alert.setNoSourceClass( "common|hero_show_btn_out" , "common|hero_show_btn_over" ,  "common|hero_show_btn_down" );
			Alert.alert.setCloseSourceClass( "common|close_out" , "common|close_over" ,  "common|close_down" );				
			
			if ( flag == Alert.OK ) {
				Alert.alert.setOffset( 0 , -13 , 5 , -23 , 24 );
			}
			else {
				Alert.alert.setOffset( 80 , -13 , 5 , -23 , 24 );
			}			
			Alert.alert.setLabel( "确定" , "取消" );
			
			//显示遮罩
			if ( isShadow ) {	
				alertMsk = alertMsk || new Rect( UIGlobal.STAGE_WIDTH , UIGlobal.STAGE_HEIGHT , 0x000000 , 0.8 );
				UIManager.addElement( alertMsk , UIGlobal.alertLayer , -1 , -1 );
				alertMsk.toBottom();
			}
			else {
				UIManager.removeElement( alertMsk , UIGlobal.alertLayer );
			}
		}
		
		/**
		 * 关闭提示框
		 */
		public static function hideAlert():void {
			
			Alert.hideAlert();
			UIManager.removeElement( alertMsk , UIGlobal.alertLayer );		
		}
		
		//----------------------------------------------------------------
		
		public function openLogWriteAlert():void {
			
			UIGlobal.logWriteAlert = UIGlobal.logWriteAlert || new LogWriteAlert();
			
			addElement( UIGlobal.logWriteAlert );
		}
		
		public function closeLogWriteAlert():void {
			
			removeElement( UIGlobal.logWriteAlert );
		}
		
		public function openLogReadAlert( logData:LogData ):void {
			
			UIGlobal.logReadAlert = UIGlobal.logReadAlert || new LogReadAlert();
			UIGlobal.logReadAlert.logData = logData;
			
			addElement( UIGlobal.logReadAlert );
		}
		
		public function closeLogReadAlert():void {
			
			removeElement( UIGlobal.logReadAlert );
		}
		
		//-----------------------------------------------------------------
		/**
		 * 添加弹框
		 * @param	alert
		 * @param	isLock  是否锁定界面
		 */
		public function addElement( alert:Alert , isLock:Boolean = true ):void {
			
			if ( !isLock ) {				
				UIManager.addElement( alert , UIGlobal.alertLayer );
			}
			else {
				alertMsk = alertMsk || new Rect( UIGlobal.STAGE_WIDTH , UIGlobal.STAGE_HEIGHT , 0x000000 , 0.8 );		
				UIManager.addElement( alertMsk , UIGlobal.alertLayer , 0 , 0);
				
				if (alert != null) {					
					alert.x = UIGlobal.STAGE_WIDTH / 2  - alert.width / 2;
					alert.y = UIGlobal.STAGE_HEIGHT / 2 - alert.height / 2;
				}				
				UIManager.addElement( alert , UIGlobal.alertLayer , -1 , -1 );
			}
		}
		
		/**
		 * 移除弹框
		 * @param	alert
		 */
		public function removeElement( alert:Alert ):void {
			
			UIManager.removeElement( alertMsk , UIGlobal.alertLayer );	
			UIManager.removeElement( alert , UIGlobal.alertLayer );	
		}
		
		public function removeAllAlerts():void {
			
			UIManager.removeElement( alertMsk , UIGlobal.alertLayer );
			
			UIGlobal.alertLayer.removeAll();			
		}		
		
		public static function get Instance():AlertManager {
			
			return instance = instance || new AlertManager();
		}
	}

}