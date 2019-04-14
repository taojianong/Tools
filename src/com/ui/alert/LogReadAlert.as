package com.ui.alert {
	
	import com.manager.AlertManager;
	import com.manager.LogManager;
	import com.manager.TopManager;
	import com.ui.componet.Alert;
	import com.ui.componet.Button;
	import com.ui.componet.Label;
	import com.ui.componet.TextInput;
	import com.ui.log.LogData;
	import com.util.CommonUtils;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 日志读取框
	 * @author taojianlong 2014-3-29 1:29
	 */
	public class LogReadAlert extends BaseAlert {
		
		private var xml:XML =      <data>	
				<Label text="标题" x="50" y="90" color="#ffffff" />
				<TextInput id="titleTxt" width="333" height="24" x="50" y="110" maxChars="50" color="#00ff00" algin="left" fontSize="18" border="true" borderColor="#00ff00" />
				<Label text="内容" x="50" y="140" color="#ffffff" />
				<TextInput id="textTxt" width="333" height="160" x="50" y="160" maxChars="200" color="#00ff00" algin="left" fontSize="18" border="true" borderColor="#00ff00" />	
				<TextInput id="timeTxt" width="333" height="24" x="50" y="330" maxChars="50" color="#00ff00" algin="left" fontSize="18" border="true" borderColor="#00ff00" />
				
				<Button id="modifyBtn" x="40" y="365" label="修改" outSourceClass="common|hero_show_btn_out" overSourceClass="common|hero_show_btn_over" downSourceClass="common|hero_show_btn_down" />
				<Button id="saveBtn" x="290" y="365" label="保存" outSourceClass="common|hero_show_btn_out" overSourceClass="common|hero_show_btn_over" downSourceClass="common|hero_show_btn_down" />
			</data>
		
		private var titleTxt:TextInput;
		private var textTxt:TextInput;
		private var timeTxt:TextInput;
		private var modifyBtn:Button; //修改按钮
		private var saveBtn:Button; //保存按钮
		
		public function LogReadAlert() {
			
			super();
			
			this.showBtn(Alert.OK);
			setLabel("确定", "取消");
			setTitle("读日志");
			
			uiAnalytic.analyzeTo(xml, this, init);
			
			setOffset(-5, -13, 10, -6, 23);
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
			
			this.okFunc = AlertManager.Instance.closeLogReadAlert;
			this.noFunc = AlertManager.Instance.closeLogReadAlert;
			this.closeFunc = AlertManager.Instance.closeLogReadAlert;
		}
		
		override protected function removeFromStageHandler(event:Event):void {
			
			super.removeFromStageHandler(event);
			
			titleTxt.text = "";
			textTxt.text = "";
			timeTxt.text = "";
			
			_logData = null;
			
			this.isModify = false;
		}
		
		override protected function init():void {
			
			titleTxt = this.getElementById("titleTxt");
			textTxt = this.getElementById("textTxt");
			timeTxt = this.getElementById("timeTxt");
			modifyBtn = this.getElementById("modifyBtn");
			saveBtn = this.getElementById("saveBtn");
			
			textTxt.toMult(333, 160);
			
			this.isModify = false;
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			if (!(event.target is TextInput)) {
				this.isModify = false;
			}
			
			var btn:Button = event.target as Button;
			
			clickBtn(btn);
		}
		
		private function clickBtn(btn:Button):void {
			
			switch (btn && btn.id) {
				
				case "modifyBtn": 
					this.isModify = true;
					break;
				
				case "saveBtn": 
					_logData.title = titleTxt.text;
					_logData.text = textTxt.text;
					_logData.time = "" + CommonUtils.DateToString( new Date() );//timeTxt.text;
					var isModify:Boolean = LogManager.Instance.modifyLog(_logData);
					if (isModify) {
						TopManager.Instance.showInfo("修改成功");
						AlertManager.Instance.closeLogReadAlert();
					}
					break;
			}
		}
		
		//是否可修改
		private function set isModify(value:Boolean):void {
			
			titleTxt.mouseEnabled = textTxt.mouseEnabled = timeTxt.mouseEnabled = value;
		}
		
		private var _logData:LogData;
		
		public function set logData(value:LogData):void {
			
			_logData = value;
			if (value) {
				
				titleTxt.text = value.title;
				textTxt.text = value.text;
				timeTxt.text = value.time;
			}
		}
		
		override public function get mouseChildren():Boolean 
		{
			return super.mouseChildren;
		}
		
		override public function set mouseChildren(value:Boolean):void 
		{
			super.mouseChildren = value;
		}
		
		override public function get mouseEnabled():Boolean 
		{
			return super.mouseEnabled;
		}
		
		override public function set mouseEnabled(value:Boolean):void 
		{
			super.mouseEnabled = value;
		}
	}

}