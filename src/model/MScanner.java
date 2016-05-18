package model;

import symbol.Scanner;
import symbol.ScannerDevice;
import symbol.ScannerListener;
import symbol.Symbol;

public class MScanner {
	Scanner scanner=null;
	ScannerDevice[] devList;
	private String currentResult; 
	boolean exiting, stopScanning;
	ScannerListener sl;
	
	public MScanner (ScannerListener sl) throws Exception{
		super();
		this.sl = sl;
		//devList = Symbol.getScannerDeviceList();
		//this.scanner = new Scanner(devList[0]);
	}
	
	public void scannerOff() throws Exception{
			if (scanner!=null){
				if (scanner.isEnable()){
                    scanner.cancelAll();
                    scanner.disable();
                    scanner.dispose();
				}
			}
	}
	public void scannerOn() throws Exception{
		if (scanner==null) {
			devList = Symbol.getScannerDeviceList();
			this.scanner = new Scanner(devList[0]);			
		}
		if (!scanner.isEnable()) scanner.enable();
		stopScanning=false;
		exiting = false;

                if (!stopScanning)
                {
                    // Submit a read request with a listener that is notified when the read completed.
                    // Use the default parameters for this sample.
                    // Submit the read only when this is the foreground application.
                    scanner.read(null, sl);
                    // Wait until the read is completed to submit another read
                    // or the application gained the focus.
//                  	wait();
                }
                else
                {
//                    Thread.sleep(1000);
                }
			
        //}
		
	}
/*
	public void readNotify(ScanReadInfo result) {
		// TODO Auto-generated method stub
		int status = result.getStatus();
        switch (status){
            case Constants.READ_SUCCESS:
                if (result.data instanceof TextData){
                		currentResult = result.data.toString();
                        //System.out.println("Data: " + ((TextData) result.data).text + "\n");
                }
                break;
            case Constants.READ_ABORT:
                // Read is cancelled when application is inactivated.
                break;
            case Constants.READ_INCOMPATIBLE:
            {
                // Other scanning application submitted an impompatible read
                // before us.
                stopScanning = true;
                //btnScan.setLabel("Continue");
                //scanData.append("Another application is using the scanner.\n");
                //scanData.append("Please close that application and then \nclick the Continue button.\n");
                
                break;
            }
            case Constants.READ_PENDING:
                System.out.println("Read pending...\n");
                break;
            case Constants.READ_TIMEOUT:
                System.out.println("Read timed out!\n");

                break;
            default:
                System.out.println("Error : " + status + "\n");

        }
		
        notifyAll();

	}
	*/
	public void cancel(){
		scanner.cancelAll();
	}

	public String getCurrentResult() {
		return currentResult;
	}

	public void setCurrentResult(String currentResult) {
		this.currentResult = currentResult;
	}
	
	
	

}
