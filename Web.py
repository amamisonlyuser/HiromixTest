import http.server
import socketserver
import os

# Define the directory to serve
WEB_DIR = "build/web"
PORT = 8000

# Change to the web build directory
os.chdir(WEB_DIR)

# Create an HTTP server
Handler = http.server.SimpleHTTPRequestHandler
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving Flutter Web on http://localhost:{PORT}")
    print("Press Ctrl+C to stop the server")
    httpd.serve_forever()
