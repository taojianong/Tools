package com.ui.alert {
	import com.manager.AlertManager;
	import com.manager.LogManager;
	import com.ui.componet.TextInput;
	import com.ui.log.LogData;
	import com.util.CommonUtils;
	import flash.events.Event;
	
	/**
	 * 写日志弹框
	 * @author taojianlong 2014-3-27 23:45
	 */
	public class LogWriteAlert extends BaseAlert {
		
		private var xml:XML =   <data>	
		        <Label text="标题" x="50" y="90" color="#ffffff" />
				<TextInput id="titleTxt" width="333" height="24" x="50" y="110" maxChars="50" color="#00ff00" algin="left" fontSize="18" border="true" borderColor="#00ff00" />
				<Label text="内容" x="50" y="150" color="#ffffff" />
				<TextInput id="textTxt" width="333" height="180" x="50" y="170" maxChars="200" color="#00ff00" algin="left" fontSize="18" border="true" borderColor="#00ff00" />	
			</data>
			
		private var titleTxt:TextInput;
		private var textTxt:TextInput;		
		
		public function LogWriteAlert() {
				
			super();
			
			setLabel("确定", "取消");
			setTitle("写日志");
			
			uiAnalytic.analyzeTo(xml, this, init);
			
			setOffset(80, -13, 10, -6, 23);
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
			
			this.okFunc = writeLog;// AlertManager.Instance.closeLogWriteAlert;
			this.noFunc = AlertManager.Instance.closeLogWriteAlert;
			this.closeFunc = AlertManager.Instance.closeLogWriteAlert;
			
			titleTxt.text = "";
			textTxt.text = "";
		}
		
		override protected function init():void {
			
			super.init();
			
			titleTxt = this.getElementById("titleTxt");
			textTxt  = this.getElementById("textTxt");	
			
			textTxt.toMult( 333 , 180 );
		}
		
		private function writeLog():void {
			
			AlertManager.Instance.closeLogWriteAlert();
			
			var logData:LogData = new LogData();
			logData.id = LogManager.Instance.logItems;
			logData.title = titleTxt.text;
			logData.text = textTxt.text;
			logData.time = "" + CommonUtils.DateToString( new Date() );
			
			LogManager.Instance.addLogData( logData );
		}
	}

}