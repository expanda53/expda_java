package model;



import com.symbol.fusion.*;
import com.symbol.fusion.wlan.*;


public class Fusion {

	
	private static Adapter adapter;         //instance of Adapter
	private static boolean teszt = Ini.isTeszt();
	
	public static void Init() {
		try {
			if (!teszt) {
				//System.out.println("Fusion init start");
				//System.out.println("wlan create");
				Wlan wlan = new Wlan(FusionConstants.FusionAccessType.STATISTICS_MODE);
				//System.out.println("getFirstAdapter");
		        adapter = wlan.getAdapters().get(0);
		        //System.out.println("Fusion init done");
			}

		}
		catch (Exception e){
			e.printStackTrace();
		}
		
        
	}
	


	public static int getWlanStrength() {
		if (!teszt) {
			try {
				return adapter.getSignalQuality();
			}
			catch (Exception e) {
				e.printStackTrace();
				return 1;
			}
			
			
				
		}
		else {
			return 1;
		}
	}


	
	

}
