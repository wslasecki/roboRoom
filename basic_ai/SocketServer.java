import java.io.*;
import java.net.Socket;

public class SocketServer implements Runnable {
    private Socket server;
    private String line;
    
    private BufferedReader in;
    private PrintWriter out;
    
    private InputMediator im;
    
    
    SocketServer(Socket server, InputMediator inIM) {
      this.server = server;
      this.im = inIM;
      
      try { 
	      in = new BufferedReader(new InputStreamReader(server.getInputStream()));
	      out = new PrintWriter(server.getOutputStream());
      } catch (Exception err){
    	  System.out.println("SocketServer constructor error.");
      }
      
    }
    
    public void disconnect(){
		//System.out.println("disconnecting client: " + server.getInetAddress().getHostName());
		//out.println("disconnect");
		//out.flush();
		
		//in.notify();
		
		
		try {
			server.close();
		} catch(IOException err){
			System.out.println("Couldn't close socket connection: " + err.getLocalizedMessage());
		}
		
		
	}

    public void run () {
    	System.out.println("Running...");
    	try {
    		// Get input from the client
	        while((line = in.readLine()) != null && !line.equals(".")) {
	        	//System.out.println("Received:: " + line);
	        	im.input(line.trim());
	        }
	
	        server.close();
    	} catch (IOException ioe) {
    		System.out.println("IOException on socket listen [run]: " + ioe);
    		ioe.printStackTrace();
    	}
      
    }
}

