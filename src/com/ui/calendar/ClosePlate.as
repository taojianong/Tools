package com.ui.calendar {
	
	import com.manager.AlertManager;
	import com.manager.CalendarManager;
	import com.manager.FileManager;
	import com.manager.IRender;
	import com.model.TimeObject;
	import com.ui.BaseUI;
	import com.ui.componet.Alert;
	import com.ui.componet.Button;
	import com.ui.componet.Label;
	import com.ui.componet.SelectBox;
	import com.ui.componet.TextInput;
	import com.ui.UIEvent;
	import com.util.CommonUtils;
	import com.util.FileUtils;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	/**
	 * 关机模块
	 * @author taojianlong 2015/9/27 12:18
	 */
	public class ClosePlate extends BaseUI implements IRender{
		
		private var xml:XML = 
			<data>		
			
				<Label  id="lab_0"  x="0" y="-20" label="---------------------关机时间---------------------" width="320" height="20" algin="center" color="#00ff00" fontSize="16" />	
				<Button id="confim_btn" x="0" y="120" label="确定关机" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down"/>
				<Button id="right_btn" x="100" y="120" label="立刻关机" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down"/>
				<Button id="cancel_btn" x="200" y="120" label="取消关机" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down"/>
				<Button id="restart_btn" x="300" y="120" label="重新启动" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down"/>
				
				<Label  id="lab_1"  x="0" y="0" label="年" width="20" height="20" algin="center" color="#00ff00" fontSize="16" />								
				<Label  id="lab_2"  x="100" y="0" label="月" width="20" height="20" algin="center" color="#00ff00" fontSize="16" />
				<Label  id="lab_3"  x="200" y="0" label="日" width="20" height="20" algin="center" color="#00ff00" fontSize="16" />
				<SelectBox  id="sb_1"  x="0" y="0"  labelHeight="25" btnOutClass="common|com_down_out"  btnOverClass="common|com_down_over"  btnDownClass="common|com_down_down"/>
				<SelectBox  id="sb_2"  x="100" y="0"  labelHeight="25" btnOutClass="common|com_down_out"  btnOverClass="common|com_down_over"  btnDownClass="common|com_down_down"/>
				<SelectBox  id="sb_3"  x="200" y="0"  labelHeight="25" btnOutClass="common|com_down_out"  btnOverClass="common|com_down_over"  btnDownClass="common|com_down_down"/>
				
				<TextInput  id="inpTxt_1"  x="70" y="40" label="" width="40" height="20" algin="center" color="#00ff00" border="true" borderColor="#00ffff" fontSize="16" />
				<TextInput  id="inpTxt_2"  x="130" y="40" label="" width="40" height="20" algin="center" color="#00ff00" border="true" borderColor="#00ffff" fontSize="16" />
				<TextInput  id="inpTxt_3"  x="190" y="40" label="" width="40" height="20" algin="center" color="#00ff00" border="true" borderColor="#00ffff" fontSize="16" />
				
				<Label  id="lab_4"  x="0" y="80" label="" width="320" height="25" algin="center" color="#00ff00" fontSize="16" />
			</data>
		
		private var sb_1:SelectBox;
		private var sb_2:SelectBox;
		private var sb_3:SelectBox;
		
		private var inpTxt_1:TextInput;
		private var inpTxt_2:TextInput;
		private var inpTxt_3:TextInput;
		
		private var lab_4:Label;
		
		public function ClosePlate() {
			
			super(xml, 320, 200);		
		}
		
		override protected function createComplete(event:UIEvent):void {
			super.createComplete(event);
			
			sb_1 = this.getElementById("sb_1");
			sb_2 = this.getElementById("sb_2");
			sb_3 = this.getElementById("sb_3");
			
			inpTxt_1 = this.getElementById("inpTxt_1");
			inpTxt_2 = this.getElementById("inpTxt_2");
			inpTxt_3 = this.getElementById("inpTxt_3");
			
			lab_4 = this.getElementById("lab_4");
			
			sb_1.list = ["2015", "2016"];
			sb_2.list = ["01", "02", "03", "04", "05", "06"];
			sb_3.list = ["0", "1", "2", "3", "4", "5", "6"];
			
			this.upateTime();			
		}
		
		private function upateTime():void {
			
			sb_1.text = "" + this.year;
			sb_2.text = "" + this.month;
			sb_3.text = "" + this.day;
			
			inpTxt_1.text = "" + this.timeObject.hour;
			inpTxt_2.text = "" + this.timeObject.minutes;
			inpTxt_3.text = "" + this.timeObject.seconds;
			
			lab_4.text = "";
		}
		
		private var lastTime:Number = 0;//倒计时剩余时间,秒		
		
		override protected function clickHandler(event:MouseEvent):void {
			
			var btn:Button = event.target as Button;
			
			switch (btn && btn.id) {
				
				//确定关机
				case "confim_btn":
					
					var year:int 	= int(sb_1.text);
					var month:int 	= int(sb_2.text);
					var day:int 	= int(sb_3.text);
					var hour:int 	= int(inpTxt_1.text);
					var min:int		= int(inpTxt_2.text);
					var sec:int		= int(inpTxt_3.text);
					
					var to:TimeObject = TimeObject.getTimeObject( year , month , day , hour , min , sec );					
					lastTime = ( to.utcTime - CalendarManager.Instance.timeObject.utcTime ) / 1000;
					lastTime = lastTime < 0 ? 0 : lastTime;
					if ( lastTime > 0 ) {
						CalendarManager.Instance.addRender( this );
					}
					else {
						CalendarManager.Instance.removeRender( this );
					}
					break;
				
				//立刻关机
				case "right_btn":
					Alert.showAlert("是否立即关闭计算机?" , "立刻关机" , Alert.OK | Alert.CANCEL , false , null , null , this.closeComputer);
					break;
				
				//取消关机
				case "cancel_btn":
					this.cancelComputer();
					break;
					
				//重启
				case "restart_btn":
					this.restartComputer();
					break;
			}
		}
		
		private var isAuto:Boolean = true;
		/**每秒渲染**/
		public function render():void {
			
			if ( lastTime <= 0 ) {	
				lab_4.text = "";
				lastTime = 0;
				CalendarManager.Instance.removeRender( this );
				if ( isAuto ) {
					this.closeComputer();
				}else {
					Alert.showAlert("是否离开关机","是否关机" , Alert.OK | Alert.CANCEL , false , null , null , this.closeComputer );
				}
			}
			else {
				lab_4.text = "剩余时间: " +  TimeObject.timeToStr( lastTime , true );
				lastTime--;
			}
		}
		
		//关闭电脑
		private function closeComputer():void {
			
			trace("立刻关机");
			var data:String = "shutdown.exe -s -t 0";
			var url:String = File.applicationDirectory.nativePath + "/bat/close.bat"; 
			trace("url: " + url);
			FileManager.Instance.saveFile( data , url , FileUtils.FILE_BAT );
			
			//执行
			FileManager.Instance.openBatFile( "bat/close.bat" );
		}
		
		//取消自动关机
		private function cancelComputer():void {
			
			var data:String = "shutdown -a";
			var url:String = File.applicationDirectory.nativePath + "/bat/close.bat"; 
			FileManager.Instance.saveFile( data , url , FileUtils.FILE_BAT );
			
			//执行
			FileManager.Instance.openBatFile( "bat/close.bat" );
		}
		
		//重启计算机
		private function restartComputer():void {
			
			var data:String = "restart";
			var url:String = File.applicationDirectory.nativePath + "/bat/close.bat"; 
			FileManager.Instance.saveFile( data , url , FileUtils.FILE_BAT );
			
			//执行文件
			FileManager.Instance.openBatFile( "bat/close.bat" );
		}
		
		public function get year():Number {
			
			return this.timeObject.year;
		}
		
		public function get month():Number {
			
			return this.timeObject.month;
		}
		
		public function get day():Number {
			
			return this.timeObject.day;
		}
		
		public function get timeObject():TimeObject {
			
			return CalendarManager.Instance.timeObject;
		}
	}
}