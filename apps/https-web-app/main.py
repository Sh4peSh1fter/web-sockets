from fastapi import FastAPI
import ssl

app = FastAPI()

ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ssl_context.load_cert_chain(certfile='/etc/ssl/certs/server.crt', keyfile='/etc/ssl/certs/server.key')

@app.get("/")
async def read_root():
    return {"message": "this is an https web app (using fastapi)"}