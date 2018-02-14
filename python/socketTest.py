import socket
import unittest

class TestSocketServer(unittest.TestCase):

    # Set up socket connection before tests start
    def setUp(self):
        HOST, PORT = "localhost", 1234
        # Create a socket
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect((HOST, PORT))

    # Close connection on completion of tests
    def tearDown(self):
        self.sock.close()
        
        
    def testCorrect(self):
        # Define sent and correct strings
        sendString = 'this is test1'
        correctString = '1tset si siht'
        
        # Send and receive data
        self.sock.sendall(bytes(sendString + "\n", "utf-8"))
        received = str(self.sock.recv(1024), "utf-8")
        
        # Check if receieved data is correct
        self.assertEqual(received, correctString)
        
        
    def testIncorrect(self):
        # Define sent string. This will be compared to make sure the server does 
        # not send back the same string
        sendString = 'this is test2'

        
        # Send and receive data
        self.sock.sendall(bytes(sendString + "\n", "utf-8"))
        received = str(self.sock.recv(1024), "utf-8")
        
        # Check if receieved data is correct
        self.assertNotEqual(received, sendString)
        

        
if __name__ == '__main__':
    unittest.main()
    