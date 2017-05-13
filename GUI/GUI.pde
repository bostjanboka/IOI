PImage source;       // Source mask image
PImage destination;  // Destination image
PImage upload; //image uploaded by user
PImage originalImage;
PImage mask;
PImage empty;

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
PImage [] filters=new PImage[7];


//velikosti copicev
int big=25;
int middle=15;
int small=5;

int[] sizeF = new int[]{small, middle, big};
int[] filterOrder;

//intenzivnosti uporabljenega filtra - oz stopnja uporabe stila
int low=0;
int mid=1;
int high=2;

//margin za nalaganje slike
int margin=50;
int indexFilter =0;
int indexSizeF = 1;

//dimenzije nalozene slike
int uploadX;
int uploadY;

String imageLoc2="";
String imageName="";
boolean imageLoaded = false;

//naslovi nalozenih slik
String [] imageLoc=new String[6];

//lokacija osnovne slike;

void setup() {
    size(1000, 800);
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
  catch (Exception e) {
    println("Error running command!"); 
    println(e);
  }
  
  println("done");
  //zamenjaj filter ozadja
    for(int i=1; i<7; i++){
          filters[i]=uploadImage(imageLoc[i-1], filters[i], 1);
    }
    filterOrder = new int[filters.length];
    for(int i=0; i < filterOrder.length; i++){
     filterOrder[i] = i; 
    }
    filters[0]=uploadImage(imageLoc2, filters[0], 255);
    upload = filters[0].copy();
    mask = upload.copy();
    imageLoaded = true;
    
    for(int x=0; x < upload.width; x++){
     for(int y=0; y < upload.height; y++){
      int loc = x + y*mask.width;
      mask.pixels[loc]  = color(0,0,0);
     }
    }
    empty = mask.copy();
}

void draw() {  
  clear();
  background(220);
  if(imageLoaded){
      for(int i=0; i < filterOrder.length; i++){
       //image(filters[filterOrder[i]],margin,margin);
       println(filterOrder[i]);
      }
      image(upload,margin,margin);
  }
 
     //narisi gumbe spodaj
  for(int i=0; i<6; i++){
      int x=margin+i*50;
      fill(255,0,0);
      stroke(0,60,0);
      rect(x, height-30, 48, 20);
  }  
  
  for(int i=0; i < 3; i++){
   int y = margin + sizeF[0] + i * sizeF[i]*2;
   fill(255,0,0);
   stroke(0,60,0);
   ellipse(width-sizeF[2]-5, y, sizeF[i]*2, sizeF[i]*2);
  }
 //narisi gumb za render
  rect(0,0,60,50);
  fill(30,30,30,50);
  if(mouseX> margin && mouseX < margin + filters[0].width && mouseY > margin && mouseY < margin + filters[0].height){
    ellipse(mouseX, mouseY, sizeF[indexSizeF]*2, sizeF[indexSizeF]*2);
  }
  
}

//resizes the image from given location on disk 
//max 300x300 px
PImage uploadImage(String location, PImage goal, int alpha){
  goal=loadImage(location);
  goal.resize(0,700);
  goal.resize(700,0);
  
  uploadX=goal.width;
  uploadY=goal.height;
  
  for (int x = 0; x < goal.width; x++) {
    for (int y = 0; y < goal.height; y++ ) {
      int loc = x + y*goal.width;
      color r = (int)red(goal.pixels[loc]);
      color g = (int)green(goal.pixels[loc]);
      color b = (int)blue(goal.pixels[loc]);
      goal.pixels[loc]  = color(r,g,b,alpha);
    }
}
  goal.updatePixels();
  return goal.copy();
}


void PaintImage(){
 int startX = mouseX-margin-sizeF[indexSizeF];
int startY = mouseY-margin-sizeF[indexSizeF];
if(startX < 0)
  startX = 0;
 if(startY < 0)
   startY = 0;

for (int x = startX; x < filters[indexFilter].width && x < mouseX -margin+ sizeF[indexSizeF]; x++) {
    for (int y = startY; y < filters[indexFilter].height-2 && y < mouseY -margin+ sizeF[indexSizeF]; y++ ) {
      PVector rad = new PVector(x - (mouseX-margin), y - (mouseY-margin));
      int loc = x + y*filters[indexFilter].width;
      if(rad.mag() > sizeF[indexSizeF] || red(mask.pixels[loc])==1){
       continue; 
      }
      
      
      
      float opac = 0.7;
      float iopac = 1- opac;
      
      color r = (int)(red(filters[indexFilter].pixels[loc])*opac);
      color g = (int)(green(filters[indexFilter].pixels[loc])*opac);
      color b = (int)(blue(filters[indexFilter].pixels[loc])*opac);
      
      color r_ = (int)(red(upload.pixels[loc])*iopac);
      color g_ = (int)(green(upload.pixels[loc])*iopac);
      color b_ = (int)(blue(upload.pixels[loc])*iopac);
      
      mask.pixels[loc] = color(1,0,0);
      
      upload.pixels[loc]  = color(r+r_,g+g_,b+b_);
    }
}
boolean startMoving=false;
 upload.updatePixels(); 
 for(int i=0; i < filterOrder.length; i++){
   if(filterOrder[i]==indexFilter){
    startMoving = true; 
   }else if(startMoving){
     filterOrder[i-1] = filterOrder[i];
   }
 }
 filterOrder[filterOrder.length-1] = indexFilter;
}

void mouseDragged(){
  PaintImage();


}
void mousePressed(){
   for(int i=0; i<6; i++){
     int x=margin+i*50;
     if(mouseX>x&&mouseX<x+48&&mouseY<height-10&&mouseY>height-30){
                 fillColor=40*i;
                 indexFilter =i+1;
     }    
  }
  for(int i=0; i < 3; i++){
   int y = margin + sizeF[0] + i * sizeF[i]*2;
   if(mouseX > width-sizeF[2]-5 - sizeF[i] && mouseX < width-sizeF[2]-5 + sizeF[i] && mouseY > y - sizeF[i] && mouseY < y + sizeF[i]){
     indexSizeF = i;
   }

  }
  
  //pobarvaj sliko ob kliku z misko
  if(mouseX<uploadX+margin&&mouseX>margin&&mouseY>margin&&mouseY<uploadY+margin){
      fill(fillColor);
      noStroke();
      ellipse(mouseX, mouseY, big,big);
   }
  
  
  if(mouseX<60&&mouseX>0&&mouseY>0&&mouseY<50 || true){
      //dobi sliko na ekranu
  source=get(50,50,filters[0].width,filters[0].height);

  //naredi novo prazno sliko - zdaj imamo prazno, osnovno in invertirano
  destination = createImage(source.width, source.height, RGB);
  println(destination.pixels[15]);

  source.loadPixels();
  destination.loadPixels();

  //destination = upload;
  mask = empty.copy();
  PaintImage();
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
    setup2();
  }
}