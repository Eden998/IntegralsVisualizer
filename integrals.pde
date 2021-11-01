int SCREEN_SIZE = 1000;
int TOP_UI = SCREEN_SIZE - 250;
int[] separate_line = {0, TOP_UI, SCREEN_SIZE, TOP_UI};
int GRID_SIZE = 20;
int GRAPH_DENS = 20;
int SLIDERS_START = 200;
int SLIDERS_END = SCREEN_SIZE - 200;
int SLIDERS_RADIUS = 30;
int CHANGE_WIDTH = 52;
int CHANGE_HEIGHT = 25;
int CHANGE_MENU_WIDTH = 500;
int CHANGE_MENU_HEIGHT = 300;
int CHANGE_MENU_CORNER = 20;
String DECIMAL_REG = "-?[0-9]+\\.?[0-9]+|-?[0-9]+";
String NATURAL_REG = "[0-9]+";
String[] matches;
color functionColor = color(175, 0, 0);
color INTEGRAL_FILL = color(0, 128, 0, 150);


// ######################### CLASSES #########################

class rangeSlider { 
  float lowestVal, highestVal, currLeftVal, currRightVal, currLeftPos, currRightPos;
  float h = TOP_UI + (SCREEN_SIZE - TOP_UI) / 3;
  boolean leftSlide = false;
  boolean rightSlide = false;
  boolean leftChange = false;
  boolean rightChange = false;
  String leftString = "";
  String rightString = "";
  rangeSlider (float low, float high) {
    lowestVal = low; 
    highestVal = high;
    initialize();
  } 
  
  void initialize(){
    currLeftVal = lowestVal;
    currRightVal = highestVal;
    currLeftPos = SLIDERS_START;
    currRightPos = SLIDERS_END;
  }
  
  void changeLowest(float lowest){
    if(lowest < highestVal)
      lowestVal = lowest;
      initialize();
  }
  
  void changeHighest(float highest){
    if(highest > lowestVal)
      highestVal = highest;
      initialize();
  }
  
  void drawSlider(){
    update();
    line(SLIDERS_START, h, SLIDERS_END, h);
    circle(currLeftPos, h, SLIDERS_RADIUS);
    circle(currRightPos, h, SLIDERS_RADIUS);
    textSize(14);
    fill(0);
    text(nf(currLeftVal, 0, 1), currLeftPos, h + 30);
    text(nf(currRightVal, 0, 1), currRightPos, h + 30);
    textSize(20);
    text(nf(lowestVal, 0, 1), SLIDERS_START - 50, h + 7); // Lowest value text
    text(nf(highestVal, 0, 1), SLIDERS_END + 50, h + 7); // Highest value text
    textSize(14);
    fill(255);
    rectMode(CENTER);
    strokeWeight(2);
    rect(SLIDERS_START - 125, h, CHANGE_WIDTH, CHANGE_HEIGHT); // Left change rect
    rect(SLIDERS_END + 125, h, CHANGE_WIDTH, CHANGE_HEIGHT); //Right change rect
    if (leftChange || rightChange){
      rect(SCREEN_SIZE / 2, SCREEN_SIZE / 2, CHANGE_MENU_WIDTH, CHANGE_MENU_HEIGHT, CHANGE_MENU_CORNER);
      fill(0);
      textSize(50);
      text("Enter A Number:", SCREEN_SIZE / 2, (SCREEN_SIZE / 2) - 70);
      if(leftChange == true)
        text(leftString, SCREEN_SIZE / 2, (SCREEN_SIZE / 2) + 20);
      if(rightChange == true)
        text(rightString, SCREEN_SIZE / 2, (SCREEN_SIZE / 2) + 20);
    }
    textSize(14);
    fill(0);
    rectMode(CORNER); 
    strokeWeight(6);
    text("change", SLIDERS_START - 125, h + 5); // Left change text
    text("change", SLIDERS_END + 125, h + 5); // Right change text
  }
  
  void update() {
    if (mousePressed) {
      if(overLeftSlider())
        leftSlide = true;
      if(overRightSlider())
        rightSlide = true;
      if (overLeftChange() && !rightChange && !leftSlide && !rightSlide)
        leftChange = true;
      if (overRightChange() && !leftChange && !leftSlide && !rightSlide)
        rightChange = true;
    }
    if (!mousePressed) {
      leftSlide = false;
      rightSlide = false;
    }
    if (leftSlide) {
      currLeftPos = constrain(mouseX, SLIDERS_START, currRightPos - 50);
      float prop = (currLeftPos - SLIDERS_START) / (SLIDERS_END - SLIDERS_START);
      currLeftVal = lowestVal + (highestVal - lowestVal) * prop;
    }
    if (rightSlide) {
      currRightPos = constrain(mouseX, currLeftPos + 50, SLIDERS_END);
      float prop = (currRightPos - SLIDERS_START) / (SLIDERS_END - SLIDERS_START);
      currRightVal = lowestVal + (highestVal - lowestVal) * prop;
    }
    if (leftChange)
    {
      if (keyPressed == true)
      {
        if (key == ENTER) //change to button
        {
          matches = match(leftString, DECIMAL_REG);
          if(matches == null)
          {
            leftString = "";
            leftChange = false;
          }
          else if (matches[0] == leftString)
            changeLowest(float(matches[0]));
            leftString = "";
            leftChange = false;
        }
        else if (key == BACKSPACE && leftString.length() != 0)
          leftString = leftString.substring(0, leftString.length() - 1);
        else if (key >= '0' && key <= '9' || key == '.' || key == '-')
          leftString += key;
       }
    }
    if (rightChange)
    {
      if (keyPressed == true)
      {
        if (key == ENTER) //change to button
        {
          matches = match(rightString, DECIMAL_REG);
          if(matches == null)
          {
            rightString = "";
            rightChange = false;
          }
          else if (matches[0] == rightString)
            changeHighest(float(matches[0]));
            rightString = "";
            rightChange = false;
        }
        else if (key == BACKSPACE && rightString.length() != 0)
          rightString = rightString.substring(0, rightString.length() - 1);
        else if (key >= '0' && key <= '9' || key == '.' || key == '-')
          rightString += key;
       }
    }
  }
  
  boolean overLeftSlider(){
    if (dist(currLeftPos, h, mouseX, mouseY) < SLIDERS_RADIUS)
      return true;
    else
      return false;
  }
  
  boolean overRightSlider(){
    if (dist(currRightPos, h, mouseX, mouseY) < SLIDERS_RADIUS)
      return true;
    else
      return false;
  }
  
  boolean overLeftChange(){
    if (abs(mouseY - h) < (CHANGE_HEIGHT / 2) && abs(mouseX - (SLIDERS_START - 100)) < (CHANGE_WIDTH / 2))
      return true;
    else
      return false;
  }
  
  boolean overRightChange(){
    if (abs(mouseY - h) < (CHANGE_HEIGHT / 2) && abs(mouseX - (SLIDERS_END + 100)) < (CHANGE_WIDTH / 2))
      return true;
    else
      return false;
  }
} 


class intergralDensitySlider { 
  
  float lowestVal, highestVal, currPos;
  int currVal;
  float h = TOP_UI + ((SCREEN_SIZE - TOP_UI) / 3) * 2;
  boolean slide = false;
  boolean leftChange = false;
  boolean rightChange = false;
  String leftString = "";
  String rightString = "";
  
  intergralDensitySlider (float low, float high) {  
    lowestVal = low; 
    highestVal = high;
    initialize();
  } 
  
  void initialize(){
    currVal = int((lowestVal + highestVal) / 2);
    currPos = (SLIDERS_START + SLIDERS_END) / 2;;
  }
  
  void changeLowest(float lowest){
    if(lowest < highestVal)
      lowestVal = int(lowest);
      initialize();
  }
  
  void changeHighest(float highest){
    if(highest > lowestVal)
      highestVal = int(highest);
      initialize();
  }
  
  void drawSlider(){
    update();
    line(SLIDERS_START, h, SLIDERS_END, h);
    circle(currPos, h, SLIDERS_RADIUS);
    textSize(14);
    fill(0);
    text(currVal, currPos, h + 30);
    textSize(20);
    text(nf(lowestVal, 0, 0), SLIDERS_START - 40, h + 7); // Lowest value text
    text(nf(highestVal, 0, 0), SLIDERS_END + 40, h + 7); // Highest value text
    textSize(14);
    fill(255);
    rectMode(CENTER);
    strokeWeight(2);
    rect(SLIDERS_START - 125, h, CHANGE_WIDTH, CHANGE_HEIGHT); // Left change rect
    rect(SLIDERS_END + 125, h, CHANGE_WIDTH, CHANGE_HEIGHT); // Right change rect
    if (leftChange || rightChange){
      rect(SCREEN_SIZE / 2, SCREEN_SIZE / 2, CHANGE_MENU_WIDTH, CHANGE_MENU_HEIGHT, CHANGE_MENU_CORNER);
      fill(0);
      textSize(50);
      text("Enter A Number:", SCREEN_SIZE / 2, (SCREEN_SIZE / 2) - 70);
      if(leftChange == true)
        text(leftString, SCREEN_SIZE / 2, (SCREEN_SIZE / 2) + 20);
      if(rightChange == true)
        text(rightString, SCREEN_SIZE / 2, (SCREEN_SIZE / 2) + 20);
    }
    textSize(14);
    fill(0);
    rectMode(CORNER); 
    strokeWeight(6);
    text("change", SLIDERS_START - 125, h + 5); // Left change text
    text("change", SLIDERS_END + 125, h + 5); // Right change text
    fill(255);
  }
  
  void update() {
    if (mousePressed) {
      if (overSlider())
        slide = true;
      if (overLeftChange() && !rightChange && !slide)
        leftChange = true;
      if (overRightChange() && !leftChange && !slide)
        rightChange = true;
    }
    if (!mousePressed) {
      slide = false;
    }
    if (slide) {
      currPos = constrain(mouseX, SLIDERS_START, SLIDERS_END);
      float prop = (currPos - SLIDERS_START) / (SLIDERS_END - SLIDERS_START);
      currVal = int(lowestVal + (highestVal - lowestVal) * prop);
    }
    if (leftChange)
    {
      if (keyPressed == true)
      {
        if (key == ENTER) //change to button
        {
          matches = match(leftString, NATURAL_REG);
          if(matches == null)
          {
            leftString = "";
            leftChange = false;
          }
          else if (matches[0] == leftString)
            changeLowest(float(matches[0]));
            leftString = "";
            leftChange = false;
        }
        else if (key == BACKSPACE && leftString.length() != 0)
          leftString = leftString.substring(0, leftString.length() - 1);
        else if (key >= '0' && key <= '9' || key == '.' || key == '-')
          leftString += key;
       }
    }
    if (rightChange)
    {
      if (keyPressed == true)
      {
        if (key == ENTER) //change to button
        {
          matches = match(rightString, NATURAL_REG);
          if(matches == null)
          {
            rightString = "";
            rightChange = false;
          }
          else if (matches[0] == rightString)
            changeHighest(float(matches[0]));
            rightString = "";
            rightChange = false;
        }
        else if (key == BACKSPACE && rightString.length() != 0)
          rightString = rightString.substring(0, rightString.length() - 1);
        else if (key >= '0' && key <= '9' || key == '.' || key == '-')
          rightString += key;
       }
    }
  }
  
  boolean overSlider(){
    if (dist(currPos, h, mouseX, mouseY) < SLIDERS_RADIUS)
      return true;
    else
      return false;
  }
  
  boolean overLeftChange(){
    if (abs(mouseY - h) < (CHANGE_HEIGHT / 2) && abs(mouseX - (SLIDERS_START - 100)) < (CHANGE_WIDTH / 2))
      return true;
    else
      return false;
  }
  
  boolean overRightChange(){
    if (abs(mouseY - h) < (CHANGE_HEIGHT / 2) && abs(mouseX - (SLIDERS_END + 100)) < (CHANGE_WIDTH / 2))
      return true;
    else
      return false;
  }
  
} 

// ######################### Func #########################

void setup() 
{
  background(255);
  size(1000, 1000);
  strokeWeight(6);
  fill(255, 255, 255);
  textAlign(CENTER);
}

float lowDensity = 5;
float highDensity = 10000;
float leftRange = -100;
float rightRange = 100;
intergralDensitySlider intergral_dens_slider = new intergralDensitySlider(lowDensity, highDensity);
rangeSlider range_slider = new rangeSlider(leftRange, rightRange);
float integral_sum = 0;

void draw(){
  background(255);
  draw_grid();
  draw_func();
  draw_rect();
  draw_UI();
  draw_integral();
}


//void mouseClicked() {
//  if (mouseX == ) {
//    value = 255;
//  } else {
//    value = 0;
//  }
//}

void mouseWheel(MouseEvent event) {
  if (GRID_SIZE > 5 && event.getCount() == -1)
    GRID_SIZE += event.getCount();
  else if (event.getCount() == 1)
    GRID_SIZE += event.getCount();
}

void draw_UI(){
  rect(0, TOP_UI, SCREEN_SIZE, SCREEN_SIZE - TOP_UI);
  line(separate_line[0], separate_line[1], separate_line[2], separate_line[3]);
  intergral_dens_slider.drawSlider();
  range_slider.drawSlider();
}

void draw_grid(){
  float HALF_SCREEN = SCREEN_SIZE / 2;
  line(HALF_SCREEN, 0, HALF_SCREEN, TOP_UI); // Vertical line
  line(0, HALF_SCREEN, SCREEN_SIZE, HALF_SCREEN); // Horizonal line
  strokeWeight(10 / GRID_SIZE);
  float line_placement = HALF_SCREEN / (GRID_SIZE);
  for(int i = 1; i < GRID_SIZE; i++)
  {
    line(HALF_SCREEN + i * line_placement, 0, HALF_SCREEN + i * line_placement, TOP_UI);
    line(HALF_SCREEN - i * line_placement, 0, HALF_SCREEN - i * line_placement, TOP_UI);
    line(0, HALF_SCREEN + i * line_placement, SCREEN_SIZE, HALF_SCREEN + i * line_placement);
    line(0, HALF_SCREEN - i * line_placement, SCREEN_SIZE, HALF_SCREEN - i * line_placement);
  }
  strokeWeight(6);
}

void draw_func(){
  int dens = SCREEN_SIZE * GRAPH_DENS;
  float scale = dens / (GRID_SIZE * 2.0);
  float curr;
  float val;
  stroke(functionColor);
  strokeWeight(3);
  for(int point = - dens / 2; point <= dens / 2; point++)
  {
    curr = point / scale;
    val = calc_func(curr);
    point((curr * scale) / GRAPH_DENS + SCREEN_SIZE / 2, val * (float(SCREEN_SIZE) / (GRID_SIZE * 2)) + SCREEN_SIZE / 2); 
  }
  stroke(0);
  strokeWeight(6);
}

float calc_func(float x){
  float func = x * sin(x);
  return -func;
}

void draw_rect(){
   integral_sum = 0;
   strokeWeight(0);
   fill(INTEGRAL_FILL);
   float square_size = (SCREEN_SIZE / (GRID_SIZE * 2.0));
   for(int i = 0; i < intergral_dens_slider.currVal ; i++)
   {
     float left = range_slider.currLeftVal + (range_slider.currRightVal - range_slider.currLeftVal) * (float(i) /intergral_dens_slider.currVal);
     float right = range_slider.currLeftVal + (range_slider.currRightVal - range_slider.currLeftVal) * (float(i + 1) /intergral_dens_slider.currVal);
     float leftPos = SCREEN_SIZE / 2 + left * square_size;
     float rightPos = SCREEN_SIZE / 2 + right * square_size;
     float rect_high = calc_func((right + left) / 2) * (-1) * square_size;
     rect(leftPos, SCREEN_SIZE / 2 - rect_high, rightPos - leftPos, rect_high);
     integral_sum += ((rightPos - leftPos) * rect_high) / pow(square_size, 2);
   }
   fill(255);
   strokeWeight(6);
}

void draw_integral(){
   fill(0);
   textSize(25);
   text("The integral is: " + integral_sum, SCREEN_SIZE / 2, SCREEN_SIZE - 200);
   fill(255);
   strokeWeight(6);
}

void draw_change(){
   
}
