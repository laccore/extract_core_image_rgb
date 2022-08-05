#@File(label = "Input directory", style = "directory") input
#@File(label = "Output directory", style = "directory") output

processFolder(input);

function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (k=0; k < list.length; k++) {
		print(list[k]);
		processImage(list[k], output);
	}
}

function processImage(file, output) {
	print("Processing: " + input + File.separator + file);
	open(file);


	originalName = getTitle();
	originalNameWithoutExt = replace( originalName , ".tif" , "");
	
	
	Stack.getDimensions(width, height, channels, slices, frames);
	makeRectangle(0, height * 0.25, width, height / 2);
	run("Crop");
	
	
		
	for (j=0; j<channels; j++) {
		if (j==0) {
			color = "r";
		}
		else if (j==1) {
			color = "g";
		}
		else if (j==2) {
			color = "b";
		}
		else {
			color = "u";
		}

		run("Select All");
		run("Plot Profile");

		
		Plot.getValues(x, y);
		if (j==0) {
			for (i = 0; i < x.length; i++)
			{
				setResult("x", i, x[i]*1.5);
			}
		}
		for (i = 0; i < y.length; i++) {
			setResult(color, i, y[i]);
		}
		close();
				
		run("Next Slice [>]");
	}

	profileSaveName = originalNameWithoutExt + ".csv";
	savePath = output + File.separator + profileSaveName;

	print("Saving: " + savePath);
	saveAs("Measurements", savePath );

	run("Clear Results");
	close();
}
