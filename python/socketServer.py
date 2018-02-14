import socketserver

class MyTCPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        
        # Receive the data
        self.data = self.request.recv(1024).strip()
        print("{} wrote:".format(self.client_address[0]))
        print(self.data)
        
        # Reverse the string and send back the result
        
        self.request.sendall(self.data[::-1])

if __name__ == "__main__":
    HOST, PORT = "localhost", 1234

    # Create the server, binding to localhost on port 1234
    server = socketserver.TCPServer((HOST, PORT), MyTCPHandler)

    server.serve_forever()