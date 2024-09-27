#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include "DHT.h"


// WiFi settings
const char *wifiName = "Ahii"; // Enter your WiFi name
const char *password = "25072003";  // Enter WiFi password


// MQTT Broker settings
const char *mosquittoServer = "172.20.10.4"; 
const char *id = "B21DCCN268";
String user = "B21DCCN268";
String mqttPassword = "123";
const char *topicData = "topic/temp-humidity-light";
const char *topicResponse = "topic/response";
const char *topicAction = "topic/action";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// DHT Sensor settings
#define DPIN 4  
#define DTYPE DHT11  
DHT dht(DPIN, DTYPE);

// Light Sensor settings
#define LIGHT A0 

void setup() {

  Serial.begin(115200);

  setUpDHTSensor();

  setUpLed();

  setUpLightSensor();

  connectToWifi();

  connectToBroker();

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
    Serial.println("Connecting to wifi.........");
  }
  Serial.println("Connected Wifi successfully.");
}

void connectToBroker() {
  client.setServer(mosquittoServer, mqtt_port);
  client.setCallback(callback);
  
  while (!client.connected()) {
  
    Serial.printf("The client %s connects to the MQTT broker\n", id);
  
    if (client.connect(id, user.c_str(), mqttPassword.c_str())) {
      Serial.println("Connected to MQTT successfully");
      subscribe();
    } else {
      Serial.print("Connect to MQTT failed with status: ");
      Serial.println(client.state());
      delay(2000);
    }
  }
}

void subscribe() {
    client.subscribe(topicData);
    client.subscribe(topicResponse);
    client.subscribe(topicAction);
}

void callback(char* topic, byte* payload, unsigned int length) {
  // Convert payload to string
  String message;
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  String status = "UNKNOWN";
  if (strcmp(topic, topicAction) == 0) {
      Serial.print("Message arrived on topic: ");
      Serial.print(topic);
      Serial.print(". Message: ");
      Serial.println(message);
      client.publish(topicResponse, message.c_str());
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
    client.publish(topicResponse, message.c_str());
  }
}


void loop() {
  client.loop();


  static unsigned long lastPublishTime = 0;
  unsigned long currentMillis = millis();
  
  if (currentMillis - lastPublishTime >= 2000) { 
    lastPublishTime = currentMillis;

    // Read temperature and humidity from DHT sensor
    float tc = dht.readTemperature(false);  
    float hu = dht.readHumidity();          

    if (isnan(tc) || isnan(hu)) {
      Serial.println("Failed to read from DHT sensor!");
      return;
    }

    float light = analog Read(0);
    float windy = random(0, 10001) / 100.0; 

    String payload = "{";
    payload += "\"temperature\": ";
    payload += tc;
    payload += ", \"humidity\": "; 
    payload += hu;
    payload += ", \"light\": ";
    payload += light;
    payload += ", \"windy\": ";
    payload += windy;
    payload += "}";

    Serial.println(payload);

    client.publish(topicData, payload.c_str());
    delay(1000);

  }
}


