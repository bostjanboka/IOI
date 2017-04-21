PImage source;       // Source mask image
PImage destination;  // Destination image
PImage upload; //image uploaded by user

color osnova=color(40);
color [] barva ={
  color(0),
  color(40),
  color(80),
  color(120),
  color(160),
  color(200)

};
int fillColor=0;

//spremeljivke za array filtriranih slik
PImage [] filters=new PImage[6];


//velikosti copicev
int big=50;
int middle=30;
int small=10;

//intenzivnosti uporabljenega filtra - oz stopnja uporabe stila
int low=0;
int mid=1;
int high=2;

//margin za nalaganje slike
int margin=50;

//dimenzije nalozene slike
int uploadX;
int uploadY;

String imageLoc2="";
String imageName="";

//naslovi nalozenih slik
String [] imageLoc=new String[6];

//lokacija osnovne slike;

void setup() {
    size(400, 400);
  selectInput("Select a file to process:", "fileSelected");
}

void setup2(){
  imageLoc[0] = dataPath("")+"/out1/"+ imageName;
  imageLoc[1] = dataPath("")+"/out2/"+ imageName;
  imageLoc[2] = dataPath("")+"/out3/"+ imageName;
  imageLoc[3] = dataPath("")+"/out4/"+ imageName;
  imageLoc[4] = dataPath("")+"/out5/"+ imageName;
  imageLoc[5] = dataPath("")+"/out6/"+ imageName;

  
  println(sketchPath(""));
  String commandToRun = "./run_process.sh "+ imageLoc2.replaceFirst(imageName, "")+ " "+dataPath("")+"/";
  //File workingDir = new File("/home/boka/fast-neural-style/"); 
  File workingDir = new File(sketchPath("")+"/../"); 
  String returnedValues;

  
try {
    Process p = Runtime.getRuntime().exec(commandToRun, null, workingDir);
    int i = p.waitFor();
    if (i == 0) {
    }
    else {
    }
  }

  // if there is an error, let us know
  catch (Exception e) {
    println("Error running command!"); 
    println(e);
  }
  
  println("done");
  
  

  //source = loadImage("C:\\Users\\Nejka\\Downloads\\koncna (53).png");  
  // The destination image is created as a blank image the same size as the source.
 // destination = createImage(source.width, source.height, RGB);
  //ozadje = loadImage("C:\\Users\\Nejka\\Downloads\\prenos.jpg");  
  //ozadje.loadPixels();
  //image(ozadje, 0,0);
  //print(ozadje.pixels.length);
  
  //zamenjaj filter ozadja
for(int i=0; i<6; i++){
      filters[i]=uploadImage(imageLoc[i], filters[i]);
      //image(filters[i], 10*i, 10*i);
}
    //invert=uploadImage(imageLoc1, invert);
    upload=uploadImage(imageLoc2, upload);
    println("upload: "+upload.height+", "+upload.width);
    //println("invart: "+invert.height+", "+invert.width);
    //invert.filter(INVERT);    
    image(upload, margin,margin);
     //image(invert, 0,0);
  
  
  //narisi gumbe spodaj
  for(int i=0; i<6; i++){
      int x=margin+i*50;
      fill(255,0,0);
      stroke(0,60,0);
      rect(x, height-30, 48, 20);
  }  
 //narisi gumb za render
  rect(0,0,60,50);
  
}

void draw() {  
     
}

//resizes the image from given location on disk 
//max 300x300 px
PImage uploadImage(String location, PImage goal){
  goal=loadImage(location);
  if(goal.height>300){
      goal.resize(0,300);
  }
  if(goal.width>300){
      goal.resize(300,0);
  }
  uploadX=goal.width;
  uploadY=goal.height;
  return goal;
}


void mouseDragged(){
  //barvaj ko se se pomikamo s pritisnjenim gumbom
  if(mouseX<uploadX+margin&&mouseX>margin&&mouseY>margin&&mouseY<uploadY+margin){
  fill(fillColor);
  noStroke();
  ellipse(mouseX, mouseY, big,big);   
}

}
void mousePressed(){
  
  //spremeni barvo glede na pritisnjeni gumb
   for(int i=0; i<6; i++){
     int x=margin+i*50;
     if(mouseX>x&&mouseX<x+48&&mouseY<height-10&&mouseY>height-30){
                 fillColor=40*i;
                 //print(fillColor);
     }    
  }
  
  
  //pobarvaj sliko ob kliku z misko
  if(mouseX<uploadX+margin&&mouseX>margin&&mouseY>margin&&mouseY<uploadY+margin){
      fill(fillColor);
      noStroke();
      ellipse(mouseX, mouseY, big,big);
   }
  
  
  if(mouseX<60&&mouseX>0&&mouseY>0&&mouseY<50){
      //dobi sliko na ekranu
  source=get(50,50,upload.width,upload.height);

//naredi novo prazno sliko - zdaj imamo prazno, osnovno in invertirano
destination = createImage(source.width, source.height, RGB);
println(destination.pixels[15]);

  source.loadPixels();
  destination.loadPixels();

  
  
//preglej vse piksle in določi kateri filter mora nastaviti
  for (int x = 0; x < upload.width; x++) {
    for (int y = 0; y < upload.height; y++ ) {
      int loc = x + y*upload.width;
     // int izd= x + y*upload.width;
      // Test the brightness against the threshold
      for(int i=0; i<6; i++){
      if (red(source.pixels[loc])==red(barva[i])&& green(source.pixels[loc])==green(barva[i])&& blue(source.pixels[loc])==blue(barva[i])) {
        destination.pixels[loc]  = filters[i].pixels[loc];//color(255,0,0);  // red
      }  else {
        //destination.pixels[loc]  = filters[3].pixels[loc];    // blue
      }
      
      }
      //ozadna slika
     if (red(destination.pixels[loc])==red(barva[0])&& green(destination.pixels[loc])==green(barva[0])&& blue(destination.pixels[loc])==blue(barva[0])){
      destination.pixels[loc]  = upload.pixels[loc];
     }
      
      
    }
  }
  

  // We changed the pixels in destination
  destination.updatePixels();
  // Display the destination
 image(destination,50,50);
  //image(invert,50,50);
  destination.save("slika2");
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    imageLoc2 = selection.getAbsolutePath();
    String[] list = split(selection.getAbsolutePath(), '/');
    imageName = list[list.length-1];
    //imageLoc2 = imageLoc2.replaceFirst(imageName, "");
    setup2();
  }
}