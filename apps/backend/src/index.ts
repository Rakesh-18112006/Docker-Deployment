import express from 'express';
import "dotenv/config";
import { prisma } from '@repo/database';

const app = express();
 
app.use(express.json());

app.get('/', ( req , res ) => {
    res.send('Hello World! raki');
});

app.post('signup' , ( req , res ) => {
    const { username , password } = req.body;
    if ( !username || !password ) {
        return res.status(400).json({ message : 'Username and password are required' });
    }
   
     prisma.user.create({
        data : {
            username,
            password 
        }
    }).then(user => {
        res.status(201).json({ message : 'User created successfully', user });
    }).catch(error => {
        console.error(error);
        res.status(500).json({ message : 'Internal server error' });
    });
})
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
