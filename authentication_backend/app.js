const express=require("express");
const body_parser=require('body-parser');
const userRouter=require('./routers/user_router');
const cors = require('cors');

const app=express();

app.use(cors()); 
app.use(body_parser.json());
app.use('/api',userRouter);

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ status: false, error: err.message });
});

module.exports=app;