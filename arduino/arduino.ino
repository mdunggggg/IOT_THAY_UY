#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <ESP8266HTTPClient.h> 
#include "DHT.h"

#define Log(X) Serial.println("=========>>>>> " + String(X))
#define LogI(X) Serial.print("=====>>>>> " + String(X))
#define MAX_WORDS 10    // Số từ tối đa trong mảng
#define MAX_WORD_LENGTH 20  // Độ dài tối đa của mỗi từ

char words[MAX_WORDS][MAX_WORD_LENGTH]; 

// WiFi settings
const char *wifiName = "Ahii"; // Enter your WiFi name
const char *password = "25072003";  // Enter WiFi password


// MQTT Broker settings
const char *mosquittoServer = "172.20.10.2"; // Enter your MQTT broker IP
const char *topic = "topic/temp-humidity-light";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// DHT Sensor settings
#define DPIN 4       // D2-GPI04
#define DTYPE DHT11  
DHT dht(DPIN, DTYPE);

// Light Sensor settings
#define LIGHT A0 // D1-GPI05

void setup() {
  // Set software serial baud to 115200
  Serial.begin(115200);

  setUpDHTSensor();

  setUpLed();

  setUpLightSensor();

  // Connect to WiFi
  connectToWifi();


  // Connect to the MQTT broker (Mosquitto)
  connectToBroker();

  // Subscribe to the topic
  client.subscribe(topic);
}

void setUpDHTSensor() {
  dht.begin();
}

void setUpLightSensor() {
  pinMode(LIGHT, INPUT);
}

void setUpLed() {
  pinMode(D6, OUTPUT);
  pinMode(D7, OUTPUT);
  pinMode(D8, OUTPUT);
}

void connectToWifi() {
  WiFi.begin(wifiName, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Log("Connecting to WiFi...");
  }
  Log("Connected to the WiFi network successfully");
}

void connectToBroker() {
  client.setServer(mosquittoServer, mqtt_port);
  client.setCallback(callback);
  
  while (!client.connected()) {
    String client_id = "B21DCCN268";
    
    Serial.printf("The client %s connects to the MQTT broker\n", client_id.c_str());
  
    if (client.connect(client_id.c_str())) {
      Log("MQTT broker connected");
      client.subscribe("topic/change_light");
    } else {
      LogI("Failed with state ");
      Log(client.state());
      delay(2000);
    }
  }
}
void callback(char* topic, byte* payload, unsigned int length) {
  // Convert payload to string
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  String status = "UNKNOWN";
  if (strcmp(topic, "topic/change_light") == 0) {
      Serial.print("Message arrived on topic: ");
      Serial.print(topic);
      Serial.print(". Message: ");
      Serial.println(message);
    if(message == "on light") {
        digitalWrite(D6, HIGH);
    }

    if(message == "off light") {
      digitalWrite(D6, LOW);
    }

     if(message == "on fan") {
        digitalWrite(D7, HIGH);
    }

    if(message == "off fan") {
       digitalWrite(D7, LOW);
    }

     if(message == "on air-condition") {
      digitalWrite(D8, HIGH); 
    }

    if(message == "off air-condition") {
       digitalWrite(D8, LOW);
    }
  }
}





void loop() {
  client.loop();

  // Only publish sensor data if a certain time interval has passed
  static unsigned long lastPublishTime = 0;
  unsigned long currentMillis = millis();
  
  if (currentMillis - lastPublishTime >= 8000) { 
    lastPublishTime = currentMillis;

    // Read temperature and humidity from DHT sensor
    float tc = dht.readTemperature(false);  
    float hu = dht.readHumidity();          

    if (isnan(tc) || isnan(hu)) {
      Log("Failed to read from DHT sensor!");
      return;
    }

    float light = analogRead(0);

    // Create a JSON payload with the sensor data
    String payload = "{";
    payload += "\"temperature\": ";
    payload += tc;
    payload += ", \"humidity\": ";
    payload += hu;
    payload += ", \"light\": ";
    payload += light;
    payload += "}";

    //Serial.println(payload);

    // Publish the payload to the MQTT topic
    client.publish(topic, payload.c_str());
    delay(2000);

  }
}



