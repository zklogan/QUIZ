

int firstSensor = 0;    // first analog sensor
int secondSensor = 0;   // second analog sensor
int thirdSensor = 0;    // digital sensor
char inByte = 0;         // incoming serial byte
int ledPin =13;
const int motorPin = 3;
boolean  value = false;
 
void setup()
{
  // start serial port at 9600 bps:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo onlyt
  }

//  pinMode(2, INPUT);   // digital sensor is on digital pin 2
  pinMode(ledPin, OUTPUT);   // digital sensor is on digital pin 2
  pinMode(motorPin, OUTPUT);
  establishContact();  // send a byte to establish contact until receiver responds 
}

void loop()
{

  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte =(char) Serial.read();
    value = !value;

    if(inByte == 'Y'){
      digitalWrite(ledPin,HIGH);
      digitalWrite(motorPin,HIGH);
    }
    else if (inByte =='N'){
      digitalWrite(ledPin,LOW);  
    }
    else if (inByte =='V'){
      digitalWrite(ledPin,LOW); 
     digitalWrite(motorPin,LOW); 
    }
    else{
      digitalWrite(motorPin, LOW);
    }
      //    Serial.print(inByte);
      
    Serial.print('X');
    
    // read first analog input, divide by 4 to make the range 0-255:
//    firstSensor = analogRead(A0)/4;
//    // delay 10ms to let the ADC recover:
//    delay(10);
//    // read second analog input, divide by 4 to make the range 0-255:
//    secondSensor = analogRead(1)/4;
//    // read  switch, map it to 0 or 255L
//    thirdSensor = map(digitalRead(2), 0, 1, 0, 255);  
//    // send sensor values:
//    Serial.write(firstSensor);
//    Serial.write(secondSensor);
//    Serial.write(thirdSensor);               
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}

