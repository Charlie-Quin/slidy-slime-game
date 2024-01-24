shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	COLOR = texture(TEXTURE,UV);
	
	float threshHold = 0.98;
	
	if (COLOR.r > threshHold && COLOR.g > threshHold && COLOR.b > threshHold){
		COLOR = vec4(1.0,1.0,1.0,0.0);
	} 
	
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
