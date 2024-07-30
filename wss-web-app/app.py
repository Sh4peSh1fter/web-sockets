import asyncio
import websockets
import ssl

async def echo(websocket):
    async for message in websocket:
        await websocket.send(message)

ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ssl_context.load_cert_chain(certfile='/etc/ssl/certs/server.crt', keyfile='/etc/ssl/certs/server.key')

async def main():
    async with websockets.serve(echo, '0.0.0.0', 3001, ssl=ssl_context):
        await asyncio.Future() 

asyncio.run(main())