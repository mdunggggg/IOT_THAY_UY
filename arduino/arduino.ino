#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include "DHT.h"

// WiFi settings
const char *ssid = "Ahii"; // Enter your WiFi name
const char *password = "25072003";  // Enter WiFi password

// MQTT Broker settings
const char *mqtt_broker = "172.20.10.2"; // Enter your MQTT broker IP
const char *topic = "test/topic";
const int mqtt_port = 1883;

WiFiClient espClient;
PubSubClient client(espClient);

// DHT Sensor settings
#define DPIN 4        // Pin to connect DHT sensor (GPIO number, D2 on ESP8266)
#define DTYPE DHT11   // Define DHT sensor type, DHT11 or DHT22
DHT dht(DPIN, DTYPE);

void setup() {
  // Set software serial baud to 115200
  Serial.begin(115200);

  // Initialize DHT sensor
  dht.begin();

  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to the WiFi network");

  // Connect to the MQTT broker
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
  
  while (!client.connected()) {
    String client_id = "Hoang Manh Dung";
    
    Serial.printf("The client %s connects to the MQTT broker\n", client_id.c_str());
    
    if (client.connect(client_id.c_str())) {
      Serial.println("MQTT broker connected");
    } else {
      Serial.print("Failed with state ");
      Serial.print(client.state());
      delay(2000);
    }
  }
  
  // Subscribe to the topic
  client.subscribe(topic);
}

void callback(char *topic, byte *payload, unsigned int length) {
  Serial.print("Message arrived in topic: ");
  Serial.println(topic);
  Serial.print("Message: ");
  
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  
  Serial.println();
  Serial.println(" - - - - - - - - - - - -");
}

void loop() {
  client.loop();

  // Read temperature and humidity from DHT sensor
  float tc = dht.readTemperature(false);  // Read temperature in Celsius
  float tf = dht.readTemperature(true);   // Read temperature in Fahrenheit
  float hu = dht.readHumidity();          // Read humidity

  // Check if any reads failed and exit early (to try again).
  if (isnan(tc) || isnan(tf) || isnan(hu)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Print sensor data to the Serial Monitor
  // Serial.print("Temp: ");
  // Serial.print(tc);
  // Serial.print(" C, ");
  // Serial.print(tf);
  // Serial.print(" F, Hum: ");
  // Serial.print(hu);
  // Serial.println("%");

  // Create a JSON payload with the sensor data
  String payload = "{";
  payload += "\"temperature_celsius\": ";
  payload += tc;
  payload += ", \"temperature_fahrenheit\": ";
  payload += tf;
  payload += ", \"humidity\": ";
  payload += hu;
  payload += "}";

  // Publish the payload to the MQTT topic
  client.publish(topic, payload.c_str());

  // Wait 2 seconds before the next loop
  delay(2000);
}
