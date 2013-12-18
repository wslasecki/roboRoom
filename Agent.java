
public class Agent {
	String name;
	double xLoc, yLoc;
	double orientation;
	
	
	public Agent(String inName, double inX, double inY, double inOri) {
		//
		name = inName;
		xLoc = inX;
		yLoc = inY;
		orientation = inOri;
		
		System.out.println("Created --> " + toString());
	};
	
	
	public String toString() {
		return ("[" + name + ": " + ", {" + xLoc + "," + yLoc + "}, " + orientation + "]");
	}
}
