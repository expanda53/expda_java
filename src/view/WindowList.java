package view;

import java.util.ArrayList;

public class WindowList {
	private static ArrayList<> list = new ArrayList();

	public static ArrayList<> getWindowList() {
		return list;
	}

	public static int addWindow(String windowName) {
		int res = -1;
		if (!windowExists(windowName)) {
			getWindowList().add(windowName);
			res = getWindowList().indexOf(windowName);
		}
		return res;
	}
	
	public static boolean windowExists(String windowName){
		return  (getWindowList().indexOf(windowName)>=0); 
	}
	
	public static boolean delWindow(String windowName){
		getWindowList().remove(windowName);
		return !windowExists(windowName);
	}
}
