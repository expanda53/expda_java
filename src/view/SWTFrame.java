package view;

import model.MScanner;
import model.Stringfunc;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;

import symbol.ScanReadInfo;
import symbol.ScannerListener;
import symbol.TextData;
import viewmodel.Xmlpanel;

public class SWTFrame implements ScannerListener {
	Label label;
	String param;
	String[] openparams=null;
	exPane pane;
	private Shell shell;
	public MScanner scanner = null;
	private Display display;
	WindowList wlist = new WindowList();
	public SWTFrame(final String param,Display display,Shell shell,String params){
	// get the display
	this.display = display;
	this.param = param;
	this.openparams=Stringfunc.split(params, "@@") ;

	
	int newwinid = WindowList.addWindow(param);
	
	if (newwinid!=-1) {
		// create the main window
		if (shell==null) shell = new Shell(getDisplay());
		else this.setShell(shell);
		
		//shell.setLayout(new RowLayout(SWT.VERTICAL));
		shell.setLayout(null);
		shell.addListener(SWT.Close, new Listener() {
		      public void handleEvent(Event event) {
		    	  try {
					pane.setScannerOff();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					System.out.println(e.getMessage());
					e.printStackTrace();
					showMessage("Lézer kikapcsolás nem sikerült.");

				}
		    	  try {
					if (pane.getTcp()!=null) pane.getTcp().disconnect();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    	  //pane.sendGetExecute("EXIT", false);
	//	        event.doit = false;
	//	    	  System.exit(0);
	//	    	  System.out.println("Closing...");
		    	  if (WindowList.delWindow(param)) {
		    		  
		    	  }
		      }
		    });
		shell.setBounds(display.getBounds());
		
		shell.setBackground(Display.getCurrent().getSystemColor(SWT.COLOR_DARK_GRAY));
		Xmlpanel p = new Xmlpanel(this.param + ".xml",this);
		Object[] t = p.panelBeolvas();
		if (t!=null){
			pane = new exPane(shell,this.getDisplay());
			try {
			  scanner = new MScanner(this);
			}
			catch (Exception e){
				scanner = null;
				System.out.println(e.getMessage());
				e.printStackTrace();
				showMessage("Lézer inicializálás nem sikerült.");
				
			
			}
			pane.setScanner(scanner);
			pane.setObjects(t);
			if (pane.createPanel(this.openparams)) {
				// open the main window		
				shell.open();
				pane.setFocus();
				run();
			}
			else {
				//		letezo ablak megnyitasa
			}
		}
	}
}
	
	
	private void scanResult() {
		Display.getDefault().asyncExec(new Runnable() {
	        public void run() {
				try {
					pane.getAktBCodeObj().valueTo( pane.getScanner().getCurrentResult() );
					String msg = pane.getAktBCodeObj().getSqlAfterTrigger();
					pane.sendGetExecute(msg,true);
					msg = pane.getAktBCodeObj().getLuaAfterTrigger();
					pane.luaInit(msg);
				}
				catch (Exception e){
					e.printStackTrace();
					System.out.println(e.getMessage());
					showMessage("Leolvasás nem sikerült.");
				}
        
    }
});		
	
	}
	public void readNotify(ScanReadInfo result) {
		if (result.data == null) return;
		try {
			// TODO Auto-generated method stub
			pane.getScanner().setCurrentResult(((TextData) result.data).text);
			scanResult();
			//		notifyAll();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			System.out.println(e.getMessage());
			showMessage("Leolvasás nem sikerült.");
			
		}
	}
	
	
	private void run(){
		try {
			if (pane.getSqlOnCreate()!=null) {
				pane.showWaitbox("");
				pane.sendGetExecute(pane.getSqlOnCreate(),true);
			}
			if (pane.getLuaOnCreate()!=null) {
				pane.showWaitbox("");
				pane.luaInit(pane.getLuaOnCreate());
			}
		}
		catch (Exception e){
			e.printStackTrace();
			System.out.println(e.getMessage());
			showMessage("Panel indítás nem sikerült.");
		}
		pane.hideWaitbox();		
		  
	}


	public Display getDisplay() {
		return display;
	}


	public Shell getShell() {
		return shell;
	}


	public void setShell(Shell shell) {
		this.shell = shell;
	}

	private void showMessage(String p1) {
		MessageBox msg = new MessageBox(this.shell);
		msg.setMessage(p1);
		msg.open();
	}

}
