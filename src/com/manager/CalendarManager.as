package com.manager {
	import com.model.TimeObject;
	import com.UIGlobal;
	import com.util.DMap;
	
	
	/**
	 * 时间系统管理
	 * @author taojianlong 2014-5-2 0:58
	 */
	public class CalendarManager {
		
		private var _timeObject:TimeObject;
		
		public function CalendarManager() {
			
			_timeObject = new TimeObject( new Date().time );
		}
		
		/**
		 * 当前日期时间
		 */
		public function get timeObject():TimeObject {
			
			return _timeObject;
		}
		
		//每秒刷新
		public function sceondRender():void {
			
			_timeObject.utcTime += 1000;
			
			if ( UIGlobal.calendarUI != null ) {
				UIGlobal.calendarUI.sceondRender();
			}
			
			for each( var iRender:IRender in renderMap.d ) {
				iRender.render();
			}
		}
		
		private var renderMap:DMap = new DMap();
		/**添加渲染对象**/
		public function addRender( iRender:IRender ):void {
		
			renderMap.put( iRender , iRender );
		}
		
		/**移除渲染对象**/
		public function removeRender( iRender:IRender ):void {
		
			renderMap.remove( iRender );
		}
		
		//------------------------------------------------------
		private static var instance:CalendarManager;
		
		public static function get Instance():CalendarManager {
			
			return instance = instance || new CalendarManager();
		}
	}

}