package model;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;



public class PHPClient {
	private HttpURLConnection connection=null;
	private String charset = "UTF-8";
	private String URL = "";
	
	//convert InputStream to String
	private static ArrayList IStreamToString(InputStream is) {
 
		BufferedReader br = null;
		ArrayList response = new ArrayList();
		String line;
		try {
 
			br = new BufferedReader(new InputStreamReader(is));
			while ((line = br.readLine()) != null) {
				response.add(line);
			}
 
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
 
		return response;
 
	}	
	public PHPClient(String url) throws Exception{
		//url = URLEncoder.encode(url, charset);
		this.setURL(url);
	}
	

	public ArrayList sendMessage(String msg) throws Exception{
		boolean mehet = false ;
		try {
			
			connection = (HttpURLConnection) new URL(getURL()).openConnection();
			connection.setDoOutput(true);
			connection.setDoInput(true);
			connection.setRequestMethod("POST");
			connection.setRequestProperty("Accept-Charset", this.charset);
			connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=" + this.charset);
			mehet=true;
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		ArrayList response = new ArrayList();		
		if (mehet) {
			String[] urlTags = Stringfunc.split(msg," ");
			String newUrl = "";
			if (urlTags.length>0) { 
				for (int ix=0;ix<urlTags.length;ix++) {
					String curr = URLEncoder.encode(urlTags[ix], charset);
	//				String curr = urlTags[ix];
					if (ix==0) newUrl += "?command="+curr;
					else newUrl += "&p"+Integer.toString(ix)+"="+curr;
				}
			}
	//		System.out.println(this.getURL() + newUrl);
			try {
				connection.getOutputStream().write((this.getURL() + newUrl).getBytes(this.charset));
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			finally {
				try {
					connection.getOutputStream().close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			InputStream resp=null;
			try {
				resp = connection.getInputStream();
				response = IStreamToString(resp);
				
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			finally {
				try {
					resp.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		return response;
	}

	public String getURL() {
		return URL;
	}

	public void setURL(String URL) {
		this.URL = URL;
	}

	
	

}
