package model;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.ArrayList;


public class Tcpclient {
	private String ip;
	private String port;
	//private String user;
	private Socket socket;
	
	public Tcpclient(String ip, String port, String user) throws Exception{
		this.ip = ip;
		this.port = port;
		//this.user = user;
		//socket = new Socket (this.ip, Integer.parseInt(this.port));
		//socket.setSoTimeout(1000);
		
		SocketAddress sockaddr = new InetSocketAddress(this.ip, Integer.parseInt(this.port));
		this.socket = new Socket();
		this.socket.connect(sockaddr, 10000);
		//this.socket.setSoLinger(true, 0); //nullánál azonnal bezárja
		//int x = this.socket.getSoLinger();
		//System.out.println(x);
		
	}
	
	public void reconnect() throws Exception{
		this.disconnect();
		this.socket=null;
//			socket = new Socket (this.ip, Integer.parseInt(this.port));
			SocketAddress sockaddr = new InetSocketAddress(this.ip, Integer.parseInt(this.port));
			this.socket = new Socket();
			this.socket.connect(sockaddr, 10000);

		
	}
	public void disconnect() throws Exception {
		if (this.socket!=null) {

		this.socket.close();
		}

	}
	public ArrayList sendMessage(String msg) throws Exception{
		PrintWriter out;
		BufferedReader s_in;
		String responseLine = null;
		ArrayList response = new ArrayList();
		out = null;
		s_in = null;
		out = new PrintWriter (socket.getOutputStream(), true);
		s_in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		out.println (msg);
		while ((responseLine = s_in.readLine()) != null   ) 
		{
				     if (responseLine.indexOf("::END")>-1) break;
				     else if (responseLine.toUpperCase().indexOf("SERVERHEZ CSATL")==-1) response.add(responseLine);
		}
		return response;
	}

	
	public void socketClose(){
		try {
			socket.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
	

}
