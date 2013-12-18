import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;


public class CombineServer {
	  private static int incoming_port=8000;
	  //private static int action_port=1134;
	  
	  private InputMediator im;
	  
	  // Listen for incoming connections and handle them
	  public static void main(String[] args) {
		  CombineServer cs = new CombineServer();
	  }

	  
	  public CombineServer() {
		  im = new InputMediator("0", "7");
		  
		  startServer();
	  }

	  public void startServer() {
		ArrayList<SocketServer> clients = new ArrayList<SocketServer>();
		  
	    try {
	    	  //Socket server;
		      ServerSocket listener = new ServerSocket(incoming_port);
		      Socket server;
		      System.out.println("Starting server...");
		      
		      
		      
		      // Keep spawning new threads.
		      while(true) {
		    	System.out.print(",");
		        server = listener.accept();
		        
		        SocketServer conn_c = new SocketServer(server, im);
		        clients.add(conn_c);
		        Thread t = new Thread(conn_c);
		        t.start();
		      }
		    } catch (IOException ioe) {
		    	System.out.println("IOException on socket listen [combine server]: " + ioe);
		      	ioe.printStackTrace();
		    } catch (Exception err){
		    	System.out.println("error! [combine server]: " + err.getLocalizedMessage() + "\n" + err.getStackTrace());
		    } finally {
		    
		    	System.exit(0);
		    }
	  }

}
