package com.ui.calendar {
	
	import com.manager.CalendarManager;
	import com.manager.UIManager;
	import com.model.TimeObject;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Clock;
	import com.ui.componet.Container;
	import com.ui.componet.Label;
	import com.ui.componet.SelectBox;
	import com.ui.event.SelectEvent;
	import com.ui.UIEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 时间系统
	 * @author taojianlong 2014-4-30 23:01
	 */
	public class CalendarUI extends BaseUI {
		
		private var clock:Clock;
		private var prev_btn:Button;
		private var con_1:Container;
		private var con_2:Container;
		private var ymLab:Label; //显示年月
		private var timeLab:Label; //显示当前时间
		private var titLab:Label;
		
		private var sb_1:SelectBox;
		private var sb_2:SelectBox;
		private var sb_3:SelectBox;
		
		private var curYear:Number;
		private var curMonth:Number;
		private var curDay:Number;
		
		private var closePlate:ClosePlate;
		
		private var xml:XML =   <data>		
				<Label id="titLab"    x="0"   y="10" width="800" height="46" color="#008000" algin="center" fontSize="24" />
				<Clock  id="clock"    x="200" y="200" radius="100" hourLong="40" minuteLong="60" secondLong="80" />
				<Label  id="timeLab"  x="100" y="340" label="" width="200" height="100" algin="center" color="#00ff00" fontSize="16" />
				<Button id="prev_btn" x="415" y="50" label="上一月" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down"/>
				<Label  id="ymLab"    x="475" y="50" label="" width="140" height="30" algin="center" color="#00ff00" fontSize="16" />
				<Button id="next_btn" x="615" y="50" label="下一月" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down"/>
				<Container id="con_1" x="340" y="100" mouseEnabled="true" />
				<Container id="con_2" x="340" y="160" mouseEnabled="true" mouseChildren="true" />
				<Button id="close_btn" x="770" y="5" label="" outSourceClass="common|close_out" overSourceClass="common|close_over" downSourceClass="common|close_down" />
			
			</data>
		
		public function CalendarUI() {
			
			super(xml, 800, 600, 0, 1);
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			con_1 = this.getElementById("con_1");
			con_2 = this.getElementById("con_2");
			ymLab = this.getElementById("ymLab");
			timeLab = this.getElementById("timeLab");
			titLab = this.getElementById("titLab");
			
			closePlate = new ClosePlate();
			closePlate.x = 10;
			closePlate.y = 440;
			this.addChild(closePlate);
			
			titLab.text = "时间系统";
			
			var i:int = 0;
			var cItem:CalendItem;
			for (i = 0; i < 7; i++) {
				cItem = new CalendItem();
				cItem.id = "cItem_" + i;
				cItem.x = i * (cItem.width + 0);
				cItem.show(CalendarConst.weekObj[i]);
				con_1.addElement(cItem);
			}
			
			for (i = 0; i < 42; i++) {
				cItem = new CalendItem();
				cItem.id = "dItem_" + i;
				cItem.x = int(i % 7) * (cItem.width + 0);
				cItem.y = int(i / 7) * (cItem.height + 0);
				//cItem.show( "" + i );
				con_2.addElement(cItem);
			}
			
			con_2.addEventListener(MouseEvent.MOUSE_OVER, con2MouseHandler);
			con_2.addEventListener(MouseEvent.MOUSE_OUT, con2MouseHandler);
			
			initData();
		}
		
		private function con2MouseHandler(event:MouseEvent):void {
			
			var cItem:CalendItem = event.target as CalendItem;
			
			if (cItem) {
				cItem.isOver = event.type == MouseEvent.MOUSE_OVER;
			}
		}
		
		//初始化数据
		private function initData():void {
			
			curYear  = this.year;
			curMonth = this.month;
			curDay 	 = this.day;
			
			ymLab.text = curYear + "年" + curMonth + "月";
			
			showTimeLab();
			showCalendarInfo(curYear, curMonth);
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			var btn:Button = event.target as Button;
			
			clickBtn(btn);
		}
		
		private function clickBtn(btn:Button):void {
			
			switch (btn && btn.id) {
				
				//上一年
				case "prev_btn": 
					curMonth--;
					if (curMonth < 1) {
						curMonth = 12;
						curYear--;
					}
					showCalendarInfo(curYear, curMonth);
					break;
				
				//下一年
				case "next_btn": 
					curMonth++;
					if (curMonth > 12) {
						curMonth = 1;
						curYear++;
					}
					showCalendarInfo(curYear, curMonth);
					break;
				
				//关闭
				case "close_btn": 
					UIManager.Instance.closeCalendarUI();
					break
			}
		}
		
		private function selectHandler(event:SelectEvent):void {
		
		}
		
		private function showCalendarInfo(year:Number, month:Number):void {
			
			ymLab.text = curYear + "年" + curMonth + "月";
			
			//显示上个月信息
			var prevMonth:int = month - 1;
			var prevYear:int = year;
			if (prevMonth < 1) {
				prevMonth = 12;
				prevYear--;
			}
			var prevObject:TimeObject = TimeObject.getTimeObject(prevYear, prevMonth, 1);
			var prevMonthDays:int = prevObject.monthDays;
			
			//显示当前月1号对应的时间
			var timeObject:TimeObject = TimeObject.getTimeObject(curYear, curMonth, 1);
			var monthDays:int = timeObject.monthDays;
			var week:int = timeObject.week; //当前星期几 0 ~ 6
			
			//显示下个月信息
			var nextMonth:int = month + 1;
			var nextYear:int = year;
			if (nextMonth > 12) {
				nextMonth = 1;
				nextYear++;
			}
			var nextObject:TimeObject = TimeObject.getTimeObject(nextYear, nextMonth, 1);
			var nextMonthDays:int = nextObject.monthDays;
			
			//计算显示的号数
			var i:int = 0;
			var days:Array = []; //存储42个天数，上个月最后几天 + 当前月天数 + 下个月前几天
			var curDay:int = 0;
			var nextDay:int = 0;
			var cItem:CalendItem;
			if (week == 0) {
				week = 7;
			}
			for (i = 0; i < 42; i++) {
				
				var y:Number, m:Number, d:Number;
				var labColor:uint, bottomColor:uint;
				if (week > 0 && i < week) {
					y = prevYear;
					m = prevMonth;
					d = prevMonthDays - (week - i) + 1;
					labColor = 0x8080FF;
					bottomColor = 0x800040;
				} else if (i > (week + monthDays - 1)) {
					nextDay++;
					y = nextYear;
					m = nextMonth;
					d = nextDay;
					labColor = 0x8080FF;
					bottomColor = 0x800040;
				} else {
					curDay++;
					y = curYear;
					m = curMonth;
					d = curDay;
					labColor = 0x00FFFF;					
					bottomColor = 0x8080C0;
					if ( this.year == curYear && this.month == curMonth && this.day == curDay ) {
						labColor = 0xFF0080;
						bottomColor = 0x00ff00;
					}
				}
				
				days[i] = d;
				
				cItem = con_2.getElementById("dItem_" + i);
				if (cItem != null) {
					cItem.clear();
					cItem.timeObject = TimeObject.getTimeObject(y, m, d);
					cItem.show(days[i] + "");
					cItem.labColor = labColor;
					cItem.bottomColor = bottomColor;
				}
			}
			//trace( "显示号数: " + days );
		
		}
		
		/**
		 * 每秒计时渲染
		 */
		public function sceondRender():void {
			
			if (!this.isStage) {
				return;
			}
			
			showTimeLab();
		}
		
		private function showTimeLab():void {
			
			if (timeLab != null) {
				
				var hour:String = this.timeObject.hour < 10 ? "0" + this.timeObject.hour : "" + this.timeObject.hour;
				var minutes:String = this.timeObject.minutes < 10 ? "0" + this.timeObject.minutes : "" + this.timeObject.minutes;
				var seconds:String = this.timeObject.seconds < 10 ? "0" + this.timeObject.seconds : "" + this.timeObject.seconds;
				
				timeLab.text = hour + ":" + minutes + ":" + seconds + "\n" + CalendarConst.weekObj[this.timeObject.week + 10] + "\n" + this.timeObject.toString();
			}
		}
		
		//---------------------------------------------------------
		
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