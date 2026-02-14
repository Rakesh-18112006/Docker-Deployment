import { WebSocketServer } from 'ws';
import { prisma } from '@repo/database';

const wss = new WebSocketServer({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('Client connected');

  ws.on('message', async (message) => {
    console.log(`Received message: ${message}`);
      
   await prisma.user.create({
        data : {
            username: message.toString(),
            password: Date.now().toString() 
        }
   })

    
    ws.send(`Message received: ${message}`);
  });

  ws.on('close', () => {
    console.log('Client disconnected');
  });
});