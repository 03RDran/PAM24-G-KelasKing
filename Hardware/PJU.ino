#include <WiFi.h>
#include <Wire.h>
#include <RTClib.h>
#include <Adafruit_GPS.h>

// Replace with your network credentials
#define SSID     "Redmi Pro"
#define PASSWORD "mandibau"

// Replace with your SERVER details
#define SERVER "192.168.109.204" 
// ip laptop (local server), ganti wifi ganti ip
#define PORT   8080 // HTTP PORT for local SERVER

// Unique lamp ID
#define LAMP_ID 1 // Set a unique ID for each lamp

// RTC object
RTC_DS3231 rtc;

// GPS object
Adafruit_GPS GPS(&Serial1);

// Relay pin
const int relayPin = 25;

// Voltage and Current Sensor pins
const int lampVoltagePin = 36; // ADC1
const int lampCurrentPin = 39; // ADC2
const int batteryVoltagePin = 34; // ADC3
const int batteryCurrentPin = 35; // ADC4
const int solarVoltagePin = 32; // ADC5
const int solarCurrentPin = 33; // ADC6

// Variables to store sensor data
float lampVoltage;
float lampCurrent;
float batteryVoltage;
float batteryCurrent;
float solarVoltage;
float solarCurrent;

WiFiClient client;

void setup() {
  // Initialize Serial
  Serial.begin(115200);
  
  // Initialize WiFi
  WiFi.begin(SSID, PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  // Initialize I2C for RTC
  Wire.begin(21, 22);  // SDA, SCL

  // Initialize RTC
  if (!rtc.begin()) {
    Serial.println("Couldn't find RTC");
    while (1);
  }
  if (rtc.lostPower()) {
    rtc.adjust(DateTime(F( _DATE), F(TIME_)));
  }

  // Initialize GPS
  GPS.begin(9600);

  // Initialize relay pin
  pinMode(relayPin, OUTPUT);
  digitalWrite(relayPin, LOW); // Turn off the relay by default
}

void loop() {
  // Read voltage and current sensor data for lamp
  lampVoltage = analogRead(lampVoltagePin) * (3.3 / 4095.0) * 11; // Example calculation
  lampCurrent = analogRead(lampCurrentPin) * (3.3 / 4095.0) / 0.066; // Example calculation
  
  // Read voltage and current sensor data for battery
  batteryVoltage = analogRead(batteryVoltagePin) * (3.3 / 4095.0) * 11; // Example calculation
  batteryCurrent = analogRead(batteryCurrentPin) * (3.3 / 4095.0) / 0.066; // Example calculation

  // Read voltage and current sensor data for solar panel
  solarVoltage = analogRead(solarVoltagePin) * (3.3 / 4095.0) * 11; // Example calculation
  solarCurrent = analogRead(solarCurrentPin) * (3.3 / 4095.0) / 0.066; // Example calculation

  // Get current time
  DateTime now = rtc.now();

  // Get GPS data
  char c = GPS.read();
  if (GPS.newNMEAreceived()) {
    if (!GPS.parse(GPS.lastNMEA())) {
      return;
    }
  }

  // Turn on/off relay based on time
  if (now.hour() >= 18 || now.hour() < 6) {
    digitalWrite(relayPin, HIGH); // Turn on the lamp
  } else {
    digitalWrite(relayPin, LOW); // Turn off the lamp
  }

  String key[] = {
    "LAMP_VOLTAGE",
    "LAMP_CURRENT",
    "BATT_VOLTAGE",
    "BATT_CURRENT",
    "SOLAR_VOLTAGE",
    "SOLAR_CURRENT",
    "LATITUDE",
    "LONGITUDE"
  };

  float data[] = { 
    lampVoltage, 
    lampCurrent, 
    batteryVoltage, 
    batteryCurrent, 
    solarVoltage, 
    solarCurrent,
    GPS.latitude, 
    GPS.longitude
  };

  // Send data to SERVER
  for (int i = 0; i < sizeof(data) / sizeof(data[0]); i++) {
    if (client.connect(SERVER, PORT)) {
      String postData = "{\"lamp_id\": \"" + String(LAMP_ID) + "\"" +
                        ", \"sensor_key\": \"" + key[i] + "\"" + 
                        ", \"sensor_value\": \"" + String(data[i]) + "\"}";
      
      client.println("POST /sensor-data HTTP/1.1");
      client.println("Host: " + String(SERVER));
      client.println("Content-Type: application/json");
      client.print("Content-Length: ");
      client.println(postData.length());
      client.println();
      client.println(postData);
      client.stop();
    }
  }

  // Print sensor data to Serial Monitor
  Serial.println("----- Sensor Data -----");
  Serial.print("Lamp ID: ");
  Serial.println(LAMP_ID);
  Serial.print("Lamp Voltage: ");
  Serial.print(lampVoltage);
  Serial.println(" V");
  Serial.print("Lamp Current: ");
  Serial.print(lampCurrent);
  Serial.println(" A");
  Serial.print("Battery Voltage: ");
  Serial.print(batteryVoltage);
  Serial.println(" V");
  Serial.print("Battery Current: ");
  Serial.print(batteryCurrent);
  Serial.println(" A");
  Serial.print("Solar Voltage: ");
  Serial.print(solarVoltage);
  Serial.println(" V");
  Serial.print("Solar Current: ");
  Serial.print(solarCurrent);
  Serial.println(" A");

  // Print GPS data to Serial Monitor
  Serial.print("Latitude: ");
  Serial.println(GPS.latitude, 6);
  Serial.print("Longitude: ");
  Serial.println(GPS.longitude, 6);

  // Print RTC time to Serial Monitor
  Serial.print("Current Time: ");
  Serial.print(now.year(), DEC);
  Serial.print('/');
  Serial.print(now.month(), DEC);
  Serial.print('/');
  Serial.print(now.day(), DEC);
  Serial.print(" ");
  Serial.print(now.hour(), DEC);
  Serial.print(':');
  Serial.print(now.minute(), DEC);
  Serial.print(':');
  Serial.print(now.second(), DEC);
  Serial.println();

  delay(10000); // Send data every 10 seconds
}