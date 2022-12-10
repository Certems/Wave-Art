ArrayList<wormSign> signs = new ArrayList<wormSign>();
ArrayList<String> sand = new ArrayList<String>();
PVector col = new PVector(230,200,130);
PFont asciiFont;

float tMax = 38;

void setup(){
    fullScreen();
    asciiFont = createFont("Courier",5,true);
    wormSign newSign = new wormSign(new PVector(width/2.0, height/2.0), 1000.0, 6.0);
    signs.add(newSign);
    //createSand(3.0);
}
void draw(){
    background(col.x, col.y, col.z);
    //drawSand(5.0);
    drawAllWormSigns();
    overlay();
}
void keyPressed(){
    if(key == '1'){
        wormSign newSign = new wormSign(new PVector(mouseX, mouseY), 50.0, 5.0);
        signs.add(newSign);
        createSand(5.0);
    }
    //wavenumber
    if(key == '3'){
        signs.get(0).k++;
    }
    if(key == '2'){
        signs.get(0).k--;
    }
    //Wavespeed
    if(key == '5'){
        signs.get(0).w+= 1.0/60.0;
    }
    if(key == '4'){
        signs.get(0).w-= 1.0/60.0;
    }

    //Wavespeed
    if(key == 'x'){
        tMax++;
    }
    if(key == 'z'){
        tMax--;
    }
}

void overlay(){
    pushStyle();
    textSize(20);
    text(frameRate, 30,30);
    text(frameCount, 30,60);
    text(tMax, 30,90);
    popStyle();
}
void createSand(float incSize){
    sand.clear();
    incSize*=4;
    for(float j=0; j<height; j+=incSize){
        String sandStrip = "";
        for(float i=0; i<width; i+=incSize){
            boolean notInSign = true;
            for(int z=0; z<signs.size(); z++){
                if(pow(signs.get(z).origin.x -i,2)+pow(signs.get(z).origin.y -j,2) < pow(signs.get(z).rZone/2.0,2)){
                    notInSign = false;
                    break;
                }
            }
            if(notInSign){
                String asciiUnit = "";
                int asciiChoice = floor(random(0,100));
                if(asciiChoice >= 0){
                    asciiUnit = "#";}
                if(asciiChoice >= 80){
                    asciiUnit = "%";}
                if(asciiChoice >= 90){
                    asciiUnit = "@";}
                sandStrip += asciiUnit;
            }
            else{
                String asciiUnit = " ";
                sandStrip += asciiUnit;
            }
        }
        sand.add(sandStrip);
    }
}
void drawSand(float incSize){
    textFont(asciiFont,4*incSize);
    fill(0);
    textAlign(LEFT);
    for(int i=0; i<sand.size(); i++){
        text(sand.get(i), 0, 4*i*incSize);
    }
}
void drawAllWormSigns(){
    for(int i=0; i<signs.size(); i++){
        signs.get(i).display();
    }
}

class wormSign{
    PVector origin;

    float rZone;
    float time = 0.0;
    float A = 255.0;
    float k = 4.0;
    float w = 10.0/60.0;

    float mUnit;

    wormSign(PVector signEpicentre, float signRadius, float incrementSize){
        origin = signEpicentre;
        rZone  = signRadius;
        mUnit = incrementSize;
    }

    void display(){
        animate();
        updateWandR();
    }
    void updateWandR(){
        /*
        Faster moving sand as the worm approaches the surface
        */
        //k += time/600000.0;
        //w += time/6000.0;
        //if(rZone < 400.0){
        //    rZone += time/600.0;
        //}
        
    }
    void animate(){
        /*
        y = A sin(kx - wt), 
        y=strength, 
        A=max strength, 
        x=distance from origin,
        k=waveNumber
        w=waveSpeed
        */
        pushStyle();
        noStroke();
        for(float j=-rZone/2.0; j<=rZone/2.0; j+=mUnit){
            for(float i=-rZone/2.0; i<=rZone/2.0; i+=mUnit){
                if( pow(i,2) + pow(j,2) < pow(rZone/2.0,2) ){   //If in radius
                    float x = sqrt(pow(i,2)+pow(j,2));
                    //Multi-Colouring
                    fill(abs(255.0*-2*i/rZone), 0,abs(255.0*-2*j/rZone));
                    //drawEllipse(A*sin(k*x - w*time), new PVector(origin.x +i, origin.y +j), mUnit);
                    drawAcii(A*sin(k*x - w*time), new PVector(origin.x +i, origin.y +j), mUnit);
                }
            }
        }
        popStyle();

        time ++;

        //if(frameCount<=38){
        //    saveFrame("waveGif-##.png");
        //}
        //if(time >= tMax){
        //    time = 0;
        //}
    }
}

void drawEllipse(float str, PVector pos, float incSize){
    fill(str);
    ellipse(pos.x, pos.y, incSize, incSize);
}
void drawAcii(float str, PVector pos, float incSize){
    /*
    1 2 3 4 5 6 7
    . ; % & #
    */
    pushStyle();
    textFont(asciiFont,5.0);
    //fill(0);
    String asciiUnit = "";
    if(str>255.0*0.10){
        asciiUnit = "·";}
    if(str>255.0*0.25){
        asciiUnit = "▫";}
    if(str>255.0*0.40){
        asciiUnit = "◻";}
    if(str>255.0*0.55){
        asciiUnit = "▪";}
    if(str>255.0*0.70){
        asciiUnit = "▩";}
    if(str>255.0*0.85){
        asciiUnit = "◼";}
    textSize(2.0*incSize);
    text(asciiUnit, pos.x, pos.y);
    popStyle();
}
