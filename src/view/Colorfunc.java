package view;


import java.lang.reflect.Field;

import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.Device;
import org.eclipse.swt.widgets.Display;



public class Colorfunc {
	private static Color toSwtColor(Device device, java.awt.Color color) {
		Color c = new org.eclipse.swt.graphics.Color(device,
                color.getRed(), color.getGreen(), color.getBlue());
        return c;
    }

	public static Color getColor(String colorstr, int defColor){
		Display display = Display.getCurrent();
		Color color = display.getSystemColor(defColor);
		Color listForeground = color;
		Color hexc = null;
		if (colorstr!="") {
			try {
				hexc= Colorfunc.toSwtColor((Device)display,java.awt.Color.decode(colorstr));
			} catch (NumberFormatException e1) {
				// TODO Auto-generated catch block
				hexc=null;
			}

			try {
				if (hexc==null){
					Field field = Class.forName("java.awt.Color").getField(colorstr.toUpperCase());
					color = toSwtColor((Device)display,(java.awt.Color)field.get(null));
				}
				else color = hexc;
			} catch (Exception e) {
				color = listForeground; // Not defined
			}
		}
//		hexc.dispose();
//		listForeground.dispose();
		return color;

	}

}
