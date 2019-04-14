package com.ui.calendar {
	
	import com.model.TimeObject;
	import com.ui.componet.base.ItemBase;
	import com.ui.componet.Label;
	import com.ui.componet.Rect;
	
	/**
	 * 显示日期条目，如周日，
	 * @author taojianlong 2014-5-1 23:14
	 */
	public class CalendItem extends ItemBase {
		
		private var botRect:Rect;//底部矩形，用于显示状态
		private var lab:Label;
		private var cLab:Label;//农历显示
		private var topRect:Rect;	
		
		private var _bottomColor:uint = 0xcccccc;
		private var _labColor:uint = 0x000000;
		private var _timeObject:TimeObject; //数据信息
		
		public function CalendItem() {
			
			super( 60 , 60 , 0 , 0 );
			
			init();
			
			this.showBorder();
			
			this.mouseChildren = false;
			this.mouseEnabled  = true;
		}
		
		private function init():void {
			
			botRect = new Rect( this.width , this.height , _bottomColor , 0.3 );
			this.addElement( botRect );
			
			lab = new Label();
			lab.width = this.width;
			lab.height = this.height / 2;
			lab.fontSize = 20;
			lab.color = 0x000000;// 0xffffff;
			lab.algin = "center";
			lab.verticalCenter = 0;
			this.addElement( lab );
			
			
			cLab = new Label();
			cLab.width = this.width;
			cLab.height = this.height / 2;
			cLab.fontSize = 20;
			cLab.color = 0x000000;// 0xffffff;
			cLab.algin = "center";
			
		}
		
		/**
		 * 显示信息
		 * @param	info  星期，号数
		 * @param	china 农历信息,如初一
		 */
		public function show( info:String , china:String = "" ):void {
			
			lab.text = info;
			
			if ( china != "" ) { //显示农历
				lab.y = 0;
				cLab.text = china;				
				cLab.y = lab.y + lab.height;
				this.addElement( cLab );
			}
			else {
				lab.verticalCenter = 0;
				cLab.text = "";
				this.removeElement( cLab );
			}
		}
		
		public function set selected( value:Boolean ):void {
			
			if ( topRect == null ) {
				topRect = new Rect( this.width , this.height , 0xcccccc , 0.5 );
			}
			value ? this.addElement( topRect ) : this.removeElement( topRect );
		}
		
		public function set isOver( value:Boolean ):void {
			
			botRect.color = value ? 0x808080 : _bottomColor;
		}
		
		public function set timeObject( value:TimeObject ):void {
			
			_timeObject = value;
			
			if ( _timeObject ) {
				var str:String = _timeObject.toString();
				this.toolTip = str;
			}
		}
		/**
		 * 时间对象
		 */
		public function get timeObject():TimeObject {
			
			return _timeObject;
		}
		
		public function set bottomColor( value:uint ):void {
			
			_bottomColor = value;
			
			botRect.color = _bottomColor;
		}	
		/**
		 * 底部颜色
		 * @param value 
		 */
		public function get bottomColor():uint {
			
			return _bottomColor;
		}		
		
		public function set labColor( value:uint ):void {
			
			_labColor = value;
			
			lab.color = value;
		}
		/**
		 * 标签颜色
		 */
		public function get labColor():uint {
			
			return _labColor;
		}
		
		//-------------------------------------------------------------------
		
		override public function clear():void {
			
			show( "" );
			this.selected = false;
			_timeObject   = null;
			this.toolTip  = null;
			this.bottomColor = 0xcccccc;
		}
		
		/**显示动态高度边框**/
		override public function showBorder(color:uint = 0xff0000, isClear:Boolean = true):void {
			
			boderLayer.graphics.clear();
			boderLayer.graphics.lineStyle(1, color, 1);
			boderLayer.graphics.beginFill( 0xcccccc , 0.5 );
			boderLayer.graphics.drawRect(0, 0, this.width, this.height);
			boderLayer.graphics.endFill();
		}
		
	}

}