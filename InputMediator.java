import java.io.BufferedWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

// Simplest IM ever
public class InputMediator {
	// Track the name of the agent this IM controls
	String self = null;
	String target = null;
	
	private String roboHost = "10.34.69.83";//"localhost";
	private int roboPort = 12345;
	
	// Logger value decls
	//HashMap<KeyEventDescription, Double> weightAvrg = null;
	PrintWriter roboOut = null;
	
	HashMap<String,Agent> agentSet;
	
	ArrayList<SocketServer> robot = new ArrayList<SocketServer>();
	private Socket server;
	
	private double epsilon;
	
	
	public InputMediator(String inSelf, String inTarget) {
		//
		agentSet = new HashMap<String,Agent>();
		self = inSelf;
		target = inTarget;
		
		epsilon = 10;
		
		try {
			server = new Socket(roboHost, roboPort);
			roboOut = new PrintWriter(server.getOutputStream());
		}
		catch( IOException ioe ) {
			ioe.printStackTrace();
		}
	}
	
	// Receive input from the socket connection (one line per call)
	public boolean input(String data) {
		//
		//System.out.println("Got input! " + data);
		
		Agent curAgent = parseAgentData(data);
		
		// Add or update the set of agents
		agentSet.put(curAgent.name, curAgent);
		
//		System.out.println("ONWARD!!.");
//		roboOut.write("forward\n\r") ;
//		roboOut.flush();
//		
////		try {
////			Thread.sleep(2000);
////		}
////		catch (Exception e) {
////			e.printStackTrace();
////		}
//		
//		System.out.println("Okay, that's enough of that...");
//		roboOut.write("stop\n\r") ;
//		roboOut.flush();
		
		if( curAgent.name.equals(self) ) {
			// Update based on new Self location
			System.out.println("Self found! Cease spiritual quest.");
			if( agentSet.containsKey(target) ) {
				System.out.println("Nemesis found! Commence epic quest.");
				String toMoveDir = findDirTo(agentSet.get(target));
				System.out.println("Questing towards... " + toMoveDir + "!");
				roboOut.write( toMoveDir + "\n") ;
				roboOut.flush();
			}
			else {
				System.out.println("No target.");
			}
			
		}
		else {
			// Update based on other Agent's new location
			System.out.println(curAgent.name + " != " + self);
		}
		
		// General behaviors 
		//findAllDirs();
		
		return true;
	}
	
	private Agent parseAgentData( String inStr ) {
		String[] inAry = inStr.split(",");
		
		return ( new Agent(inAry[0], Float.parseFloat(inAry[1]), Float.parseFloat(inAry[2]), Float.parseFloat(inAry[3])) );
	}

	
	/****  START - Direction Functions  ****/
	
	
	private String findDirTo(Agent a2) {
		return findDir(agentSet.get(self), a2);
	}

	
	private void findAllDirs() {
		// For each other agent, find the direction needed to get to them
		Iterator<String> itr = agentSet.keySet().iterator();
		while( itr.hasNext() ) {
			String cur = itr.next();
			
			if( agentSet.get(self) != null && cur != self ) {
				System.out.println( cur + " :: " + findDirTo(agentSet.get(cur)) );
			}
		}
		
	}
	
	// Find the direction that a1 needs to move in to get closer to facing a2
	private String findDir(Agent a1, Agent a2) {
		//
		System.out.println("\nUsing: " + a1 + " | " + a2);
		double targetBearing = Math.toDegrees(Math.atan2(a2.xLoc-a1.xLoc, a2.yLoc-a1.yLoc)) + 180.0;
		double bearingDiff = (((((a1.orientation+360)%360) - ((targetBearing+360)%360))+360) % 360);
		
		System.out.println("Bearing: " + targetBearing + ">  " + a1.orientation + "(" + (a2.yLoc-a1.yLoc) + "," + (a2.xLoc-a1.xLoc) + ")");
		System.out.println("Bearing Diff: " + bearingDiff);
		
		double distToGo = Math.sqrt(Math.pow(a2.xLoc-a1.xLoc,2) + Math.pow(a2.yLoc-a1.yLoc,2));
		System.out.println("Distance to goal: " + distToGo);
		
		if( distToGo < 0.1 ) {
			//
			return "stop";
		}
		else if( bearingDiff < epsilon ) {
			return "forward";
		}
		else if( (a1.orientation - targetBearing + 180)%360 < 180 ) {
			return "left";
		}
		else {
			return "right";
		}
		
	}
	
	
	/****  END - Direction Functions  ****/
	
}
