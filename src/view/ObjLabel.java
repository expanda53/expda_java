package view;

import org.eclipse.swt.SWT;


public class ObjLabel extends ObjDefault {
	private int align=SWT.CENTER;

	public int getAlign() {
		return align;
	}

	public void setAlign(String align) {
		if (align.equalsIgnoreCase("CENTER")) this.align = SWT.CENTER;
		if (align.equalsIgnoreCase("LEFT")) this.align = SWT.LEFT;
		if (align.equalsIgnoreCase("RIGHT")) this.align = SWT.RIGHT;
	}


}
