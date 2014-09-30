/* Arduino Projects for Dummies
 * by Brock Craft 
 *
 * Chapter 12: Building a Home Sensing Station
 * Reads values from Analog Sensors on Pins 2,3 and 4
 * Posts these values as three datastreams to 
 * a single Xively feed.
 *
 * Requires:
 * HttpClient library at: https://github.com/amcewen/HttpClient
 * Xively library at: https://github.com/xively/xively-arduino
 * Based on example code written by Adrian McEwen with
 * modifications by Sam Mulube
 *
 * v0.1 15.05.2013
*/

#include <SPI.h>
#include <Ethernet.h>
#include <HttpClient.h>
#include <Xively.h>

// Replace the text below with your API_KEY and FEED_ID from Xively!
// Otherwise the code will not work!
#define API_KEY "***** YOUR API KEY GOES HERE *****" // your Xively API key goes here
#define FEED_ID ***** YOUR FEED ID GOES HERE ***** // your Xively feed ID goes here

// MAC address for your Ethernet shield
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };

// Analog pins we're monitoring (0 and 1 are used by the Ethernet shield's SD card)

const int lightSensorPin=2;
const int tempPin1=3;
const int tempPin2=4;

unsigned long lastConnectionTime = 0;                // last time we connected to Xively
const unsigned long connectionInterval = 15000;      // delay between connecting to Xively in milliseconds

// Initialize the Xively library

// Define the strings for our datastream IDs
char sensorId1[] = "light";  // Light level (LDR)
char sensorId2[] = "temp1";  // Temperature sensor 1  (TMP36)
char sensorId3[] = "temp2";  // Temperature sensor 2  (TMP36)
 
// Create three datastreams for the feed
XivelyDatastream datastreams[] = {
  XivelyDatastream(sensorId1, strlen(sensorId1), DATASTREAM_FLOAT),
  XivelyDatastream(sensorId2, strlen(sensorId2), DATASTREAM_FLOAT),
  XivelyDatastream(sensorId3, strlen(sensorId3), DATASTREAM_FLOAT),
};

// Wrap the 3 datastreams into one feed
XivelyFeed feed(FEED_ID, datastreams, 3 /* number of datastreams */);

// Create the ethernet client and Xively client
EthernetClient client;
XivelyClient xivelyclient(client);

void setup() {
  Serial.begin(9600);
  Serial.println("Initializing network");
  while (Ethernet.begin(mac) != 1) {
    Serial.println("Error getting IP address via DHCP, trying again...");
    delay(15000);
  }
  Serial.println("Network initialized");
  Serial.println("Ready.");
}

void loop() {
  // main program loop
  if (millis() - lastConnectionTime > connectionInterval) {
    // read a value from the Light sensor pin (2)
    float lightLevel = map(analogRead(lightSensorPin),0,1023,0,100);
    // send it to Xively (sensor , 
    sendData(0, lightLevel);  // the 0 is the index number of this stream in the datastreams[] array
   
    // read the datastream back from Xively
    getData(0); // This is optional. Just prints what you sent to Xively to the Serial Monitor
    
    float temperature1 = ((getVoltage(tempPin1) -.5) * 100L);
    //convert from 10 mv per degree with 500 mV offset, to degrees ((voltage - 500mV) * 100)
 
    // send it to Xively
    sendData(1, temperature1); // the 1 is the index number of this stream in the datastreams[] array
   
    // read the datastream back from Xively
    getData(1);
    
    float temperature2 = ((getVoltage(tempPin2) -.5) * 100L);
    // send it to Xively
    sendData(2, temperature2); // the 2 is the index number of this stream in the datastreams[] array

    // read the datastream back from Xively
    getData(2);
    // update connection time so we wait before connecting again
    lastConnectionTime = millis();
 
    Serial.println("Waiting for next reading");
    Serial.println("========================");
  }
}

// send the supplied value to Xively, printing some debug information as we go
void sendData(int streamIndexNumber, float sensorValue) {
  datastreams[streamIndexNumber].setFloat(sensorValue);~~~

  Serial.print("Sensor value is: ");
  Serial.println(datastreams[streamIndexNumber].getFloat());

  Serial.println("Uploading to Xively");
  int ret = xivelyclient.put(feed, API_KEY);
  //Serial.print("PUT return code: ");
  //Serial.println(ret);
}

// get the value of the datastream from Xively, printing out the values we received
void getData(int stream) {
  Serial.println("Reading the data back from Xively");

  int request = xivelyclient.get(feed, API_KEY);
  //Serial.print("GET return code: ");
  //Serial.println(request);

  if (request > 0) {
    Serial.print("Datastream: ");
    Serial.println(feed[stream]);

    Serial.print("Sensor value: ");
    Serial.println(feed[stream].getFloat());
    Serial.println("========================");
  }
}

float getVoltage(int pin){
//Converts from a 0 to 1024 digital reading from 0 to 5 volts
//in ~ 5 millivolt increments
return (analogRead(pin) * .004882814);
}
