package main;

public class FieldRemovedExt extends FieldRemoved {

	public int fieldRemovedClientExt() {
		return fieldRemoved;
	}
	
	public int fieldRemovedClientSuper() {
		return super.fieldRemoved;
	}
}
