package com.manager {
	
	import com.ui.calendar.CalendarUI;
	import com.ui.encrypt.EncryptUI;
	import com.ui.excel.ExcelToolUI;
	import com.ui.gif.GifToolUI;
	import com.ui.log.LogUI;
	import com.ui.swftool.SwfToolUI;
	import com.ui.xml.IXMLItem;
	import com.ui.xml.XMLItemReadUI;
	import com.ui.xml.XMLParserUI;
	import com.UIGlobal;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * UI管理器
	 * @author taojianlong 2014-3-23 17:23
	 */
	public class UIManager {
		
		/**
		 * 打开加密解密界面
		 */
		public function openEncryptUI():void {		
			
			UIGlobal.encryptUI = UIGlobal.encryptUI || new EncryptUI();
			
			addElement( UIGlobal.encryptUI , UIGlobal.uiLayer );
		}
		
		/**
		 * 关闭加密解密界面
		 */
		public function closeEncryptUI():void {
		
			
			removeElement( UIGlobal.encryptUI , UIGlobal.uiLayer );
		}
		
		//ExcelToolUI 表格处理工具
		public function openExcelToolUI():void {
		
			UIGlobal.excelToolUI = UIGlobal.excelToolUI || new ExcelToolUI();
			
			addElement( UIGlobal.excelToolUI , UIGlobal.uiLayer );
		}
		
		public function closeExcelToolUI():void {
			
			removeElement( UIGlobal.excelToolUI , UIGlobal.uiLayer  );
		}
		
		//CalendarUI 时间系统
		public function openCalendarUI():void {
		
			UIGlobal.calendarUI = UIGlobal.calendarUI || new CalendarUI();
			
			addElement( UIGlobal.calendarUI , UIGlobal.uiLayer );
		}
		
		public function closeCalendarUI():void {
			
			removeElement( UIGlobal.calendarUI , UIGlobal.uiLayer  );
		}
		
		
		//XMLItemReadUI		
		public function openXMLItemReadUI( iXmlItem:IXMLItem ):void {
			
			UIGlobal.xmlItemReadUI = UIGlobal.xmlItemReadUI || new XMLItemReadUI();
			UIGlobal.xmlItemReadUI.target = iXmlItem;
			
			addElement( UIGlobal.xmlItemReadUI , UIGlobal.uiLayer );
		}
		
		public function closeXMLItemReadUI():void {
			
			removeElement( UIGlobal.xmlItemReadUI , UIGlobal.uiLayer  );
		}
		
		//XMLParserUI
		public function openXMLParserUI():void {
			
			UIGlobal.xmlParserUI = UIGlobal.xmlParserUI || new XMLParserUI();
			
			addElement( UIGlobal.xmlParserUI , UIGlobal.uiLayer );
		}
		
		public function closeXMLParserUI():void {
			
			removeElement( UIGlobal.xmlParserUI , UIGlobal.uiLayer  );
		}
		
		//LogUI
		public function openLogUI():void {
			
			UIGlobal.logUI = UIGlobal.logUI || new LogUI();
			
			addElement( UIGlobal.logUI , UIGlobal.uiLayer );
		}
		
		public function closeLogUI():void {
			
			removeElement( UIGlobal.logUI , UIGlobal.uiLayer );
		}
		
		//SwfToolUI
		
		public function openSwfToolUI():void {
		
			UIGlobal.swfToolUI = UIGlobal.swfToolUI || new SwfToolUI();
			
			addElement( UIGlobal.swfToolUI , UIGlobal.uiLayer );
		}
		
		public function closeSwfToolUI():void {
			
			removeElement( UIGlobal.swfToolUI , UIGlobal.uiLayer );
		}
		
		//GifToolUI
		
		public function openGifToolUI():void {
			
			UIGlobal.gifToolUI = UIGlobal.gifToolUI || new GifToolUI();
			
			addElement( UIGlobal.gifToolUI , UIGlobal.uiLayer );
		}
		
		public function closeGifToolUI():void {
			
			removeElement( UIGlobal.gifToolUI , UIGlobal.uiLayer );
		}
		
		
		//--------------------------------------------------
		
		/**
		 * 移除所有UI界面层元件
		 */
		public function removeAllUILayerElements():void {
		
			while ( UIGlobal.uiLayer.numChildren > 1 ) {
				UIGlobal.uiLayer.removeChildAt( 0 );
			}
		}
		
		/**
		 * 添加元件到容器中
		 * @param	element
		 * @param	container
		 * @param	ox
		 * @param	oy
		 */
		public static function addElement( element:DisplayObject , container:DisplayObjectContainer , ox:Number = -1 , oy:Number = -1 ):void {
			
			if ( container && element && !container.contains( element ) ) {
				
				element.x = ox==-1 ? ( UIGlobal.STAGE_WIDTH - element.width ) / 2 : ox;
				element.y = oy==-1 ? ( UIGlobal.STAGE_HEIGHT - element.height ) / 2 : oy;
				
				container.addChild( element );
			}
		}
		
		/**
		 * 移除指定元件
		 * @param	element
		 * @param	container
		 */
		public static function removeElement( element:DisplayObject , container:DisplayObjectContainer ):void {
			
			if ( container && element && container.contains( element ) ) {
				container.removeChild( element );
			}
		}
		
		//-----------------------------------------------------------------
		
		private static var instance:UIManager;
		public static function get Instance():UIManager {
			
			return instance = instance || new UIManager();
		}
	}

}