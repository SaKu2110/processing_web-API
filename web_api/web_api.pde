import processing.net.*;
Server server;

int port = 9000;
String[] request;

void setup() {
  server = new Server(this, port);
  println("Launch Server: " + server.ip() + ":" + port);
}

void draw() {
  Client client = server.available();

  if (client != null) {
    if (client.available() > 0) {
      request = trim(split(client.readString(), '\n'));

      if (RequestCheck("GET", "/html")) HTMLHandler(client);
      if (RequestCheck("POST", "/json")) JSONHandler(client);
      client.stop();
    }
  }
}

boolean RequestCheck(String method, String path) {
  return (trim(split(request[0], ' '))[0].equals(method) && 
    trim(split(request[0], ' '))[1].equals(path))? true: false;
}

void HTMLHandler(Client client) {
  String[] html = loadStrings( "html/hello.html" );
  client.write("HTTP/1.1 200 OK\n");
  client.write("Content-Type: text/html\n");
  client.write("\n");
  for (int i = 0; i < html.length; i++) {
    client.write(html[i]);
  }
}

void JSONHandler(Client client) {
  String json = "";
  for (int i = 11; i < request.length; i++) json += request[i];
  client.write("HTTP/1.1 200 OK\n");
  client.write("Content-Type: application/json\n");
  client.write("\n");
  client.write(json);
}
