package com.ui.log {
	import com.ui.componet.base.ItemBase;
	import com.ui.componet.Label;
	import com.util.CommonUtils;
	import flash.events.MouseEvent;
	
	/**
	 * 日志条目
	 * @author taojianlong 2014-3-26 22:11
	 */
	public class LogItem extends ItemBase{
		
		private var lab:Label;
		private var timeLab:Label;
		
		private var _logData:LogData;
		private var _isOver:Boolean = false;		
		
		public function LogItem() {
			
			super( 600 , 30 , 0xcccccc , 0.5 );
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			lab = new Label();
			lab.width = 440;
			lab.height = 20;
			lab.y = 5;
			this.addElement( lab );
			
			timeLab = new Label();
			timeLab.width = 160;
			timeLab.algin = "left";
			timeLab.x = 440;
			timeLab.y = 5;
			this.addElement( timeLab );
			
			this.addEventListener( MouseEvent.ROLL_OVER , mouseHandler ); 
			this.addEventListener( MouseEvent.ROLL_OUT , mouseHandler );
			this.addEventListener( MouseEvent.MOUSE_DOWN , mouseHandler );
			this.addEventListener( MouseEvent.MOUSE_UP , mouseHandler );
		}
		
		private function mouseHandler( event:MouseEvent ):void {
			
			var color:uint = 0xcccccc;
			if ( event.type == MouseEvent.ROLL_OVER ) {
				color = 0x00ff00;
			}
			else if ( event.type == MouseEvent.MOUSE_DOWN ) {
				color = 0xff0000;
			}
			
			this.drawRect( 600 , 30 , color , 0.5 )
		}
		
		public function set logData( value:LogData ):void {
			
			_logData = value;
			
			if ( _logData ) {
				lab.htmlText = CommonUtils.getColorHtmlText( _logData.id + ". " , "#00ff00" ) + CommonUtils.getColorHtmlText( _logData.title.toString() , "#00ffcc" ) ;
				timeLab.htmlText = CommonUtils.getColorHtmlText( _logData.time.toString() , "#0000ff" );
			}
			else {
				lab.htmlText = "";
				timeLab.htmlText = "";
			}
		}
		/**
		 * 日志数据
		 */
		public function get logData():LogData {
			
			return _logData;
		}
		
		public function set isOver( value:Boolean ):void {
			
			_isOver = value;
			
			_isOver ? this.drawRect( 600 , 30 , 0xcccccc , 0.5 ) : this.drawRect( 600 , 30 , 0x00ff00 , 0.5 );
		}
		
		public function get isOver():Boolean {
			
			return _isOver;
		}
	}

}