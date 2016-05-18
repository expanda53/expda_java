package view;



import model.Fusion;
import model.Ini;

import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

public class Form {
	public static void main(String[] args) {
		Display display=Display.getDefault();
		Shell shell = new Shell(display);
		Ini.Create(shell);
		Fusion.Init();
	    SWTFrame login = new SWTFrame("login", display,shell,"");
	    if ( login.pane!=null) {
			while (!shell.isDisposed())
				if (!login.getDisplay().readAndDispatch()) {
					login.getDisplay().sleep();
					if (WindowList.getWindowList().size()==1) {
						if (login.pane.getShell().getVisible()==false) {
							login.pane.getShell().setVisible(true);
							login.pane.setFocus();
						}
					}
				}
			if (login.pane.getTcp()!=null) login.pane.getTcp().socketClose();
	    }
    	display.dispose();
    	System.exit(0);
		
	}
}
