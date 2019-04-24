package p2;

public class Renamed2 {

	public void m1(String[] array) {
		int[] ints = new int[array.length];
		for (int i =0; i < array.length; i++) {
			String a = array[i];
			ints[i] = a.length();
			System.out.println("The " + i + "th String length is: " + ints[i]);
		}
	}
	
	public String m2(String s) {
		return s.trim().toUpperCase();
	} 
	
	public int m3(String[] array) {
		boolean[] booleans = new boolean[array.length];
		int count = 0;
		
		for (int i =0; i < array.length; i++) {
			String a = array[i];
			booleans[i] = a.length() > 5;
			if(booleans[i]) {
				count ++;
			}
		}
		
		return count;
	}
}
