package com.ui.log {
	
	import com.greensock.easing.Back;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.manager.AlertManager;
	import com.manager.LogManager;
	import com.manager.UIManager;
	import com.pool.ObjectPool;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Container;
	import com.ui.componet.PageCompent;
	import com.ui.event.PageEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 日志系统
	 * @author taojianlong 2014-3-26 22:04
	 */
	public class LogUI extends BaseUI {
		
		private var xml:XML =   <data>
				<Container id="container" x="50" y="50" />
				<Button id="addBtn" x="370" y="570" label="添加日志" outSourceClass="common|blue_btn_out" overSourceClass="common|blue_btn_over" downSourceClass="common|blue_btn_down" />
				<Button id="closeBtn" x="730" y="5" label="" outSourceClass="common|close_out" overSourceClass="common|close_over" downSourceClass="common|close_down" />
				<PageCompent id="pageCompent" x="310" y="530" labelColor="#3c64bf" isAuto="true" labelFontSize="15" labelWidth="100" labelOffsetY="5" items="10" />
			</data>
			
		private var container:Container;
		private var pageCompent:PageCompent;
		
		public function LogUI() {
			
			super(xml, 800, 600, 0x00000, 0.8);		
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
		}
		
		override protected function removeFromStageHandler(event:Event):void {
			
			super.removeFromStageHandler(event);
		}
		
		override protected function init():void {
			
			super.init();
			
			container = this.getElementById("container");
			pageCompent = this.getElementById("pageCompent");
		
			pageCompent.setPrevBtnSource("common|page_prev_btn_out", "common|page_prev_btn_over", "common|page_prev_btn_down");
			pageCompent.setNextBtnSource("common|page_next_btn_out", "common|page_next_btn_over", "common|page_next_btn_down");
			
			pageCompent.addEventListener(PageEvent.NEXT_PAGE, nextPageHandler);
			pageCompent.addEventListener(PageEvent.PREV_PAGE, prevPageHandler);
			
			//this.updateLogList();//更新日志列表
			pageCompent.data = LogManager.Instance.logList;	
			pageCompent.showPage( pageCompent.pages , pageCompent.pages );
			var list:Array = pageCompent.getPageData( pageCompent.pages );
			this.showLog( list );//显示最后一页 2015/7/20 22:41
		}
		
		//更新日志列表
		public function updateLogList():void {
			
			pageCompent.data = LogManager.Instance.logList;			
			showLog( pageCompent.currentPageData );
		}
		
		private function prevPageHandler( event:PageEvent ):void {
			
			showLog( pageCompent.currentPageData );
		}
		
		private function nextPageHandler( event:PageEvent ):void {
			
			showLog( pageCompent.currentPageData );
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			var btn:Button = event.target as Button;
			var logItem:LogItem = event.target as LogItem;
			clickBtn(btn);
			clickLogItem(logItem);
		}
		
		private function clickBtn(btn:Button):void {
			
			switch (btn && btn.id) {
				
				//添加日志
				case "addBtn": 
					AlertManager.Instance.openLogWriteAlert();
					break;
				
				//关闭按钮
				case "closeBtn": 
					UIManager.Instance.closeLogUI();
					break;
			}
		}
		
		private function clickLogItem( logItem:LogItem ):void {
			
			if ( logItem ) {
				AlertManager.Instance.openLogReadAlert( logItem.logData );
			}
		}
		
		private function showLog( logList:Array ):void {
			
			//var logList:Array = LogManager.Instance.logList;
			
			container.removeAll( true );
			var t1:TimelineMax = new TimelineMax();
			var logItem:LogItem;
			for (var i:int = 0; i < logList.length; i++ ) {
				
				logItem = ObjectPool.getObjectPool( LogItem ).getObject() as LogItem;
				logItem.logData = logList[i] as LogData;
				logItem.alpha = 0;				
				logItem.x = 50;
				logItem.y = 50 + i * logItem.height;
				
				container.addElement( logItem );
				
				//t1.append( TweenLite.to( logItem , 0.3  , { alpha:1 , ease:Back.easeOut } ) );
				t1.insert( TweenLite.to( logItem , 0.3 , { delay:i*0.1 , alpha:1 , ease:Back.easeOut } ) );
			}
		}
		
	}

}