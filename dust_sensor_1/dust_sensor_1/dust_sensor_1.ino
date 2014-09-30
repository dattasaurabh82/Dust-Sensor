int pin = 8;
unsigned long duration;
unsigned long starttime;
unsigned long sampletime_ms = 30000;//sampe 30s ;
unsigned long lowpulseoccupancy = 0;
float ratio = 0;
float concentration = 0;

void setup() {
  Serial.begin(9600);
  pinMode(8,INPUT);
  starttime = millis();//get the current time;
  pinMode(7, OUTPUT);
  digitalWrite(7, HIGH);
}

void loop() 
{
  duration = pulseIn(pin, LOW);
  lowpulseoccupancy = lowpulseoccupancy+duration;

  if ((millis()-starttime) > sampletime_ms)//if the sampel time == 30s
  {
    ratio = lowpulseoccupancy/(sampletime_ms*10.0);  // Integer percentage 0=>100
    concentration = 1.1*pow(ratio,3)-3.8*pow(ratio,2)+520*ratio+0.62; // using spec sheet curve
    Serial.print("Lowpulseoccupancy: ");
    Serial.print(lowpulseoccupancy);
    Serial.print("Ratio: ");
    Serial.println(ratio);
    Serial.println("Conc.: ");
    Serial.println(concentration);
    Serial.println();
  }
}
