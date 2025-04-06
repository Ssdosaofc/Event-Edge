require('dotenv').config();
const UserService=require('../services/user_services');
const nodeMailer=require('nodemailer');
const jwt=require('jsonwebtoken');
const bcrypt=require('bcrypt');
const crypto = require('crypto');
const UserModel = require('../model/user_model');


exports.register= async(req,res,next)=>{
    try{
        const {name,email,password} =req.body;

        const successRes=await UserService.registerUser(name,email,password);

        res.json({status:true,success:"User Registerd Successfully"});
    }catch(error){
        throw error
    }
}

exports.login= async(req,res,next)=>{
    try{
        const {email,password} =req.body;

        const user = await UserService.checkuser(email);
        // console.log("-----------user--------------",user);
        if(!user){
            throw new Error('User dont exist');
        }

        const isMatch =await user.comparePassword(password);

        if(isMatch==false){
            throw new Error("Password invalid");
        }
        let tokenData = {_id:user._id,email:user.email};

        const token= await UserService.generateToken(tokenData,"secretKey",'24h')
        

        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production', // Use HTTPS in production
            sameSite: 'strict',
            maxAge: 24 * 60 * 60 * 1000 // 24 hours
        });

        res.status(200).json({ status: true, success: "Login successful" });
    

    }catch(error){
        next(error);
    }
}

exports.logout = async (req, res, next) => {
    try {
        // Clear the token cookie
        res.clearCookie('token', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict'
        });

        res.status(200).json({ status: true, success: "User logged out successfully" });
    } catch (error) {
        next(error); // Pass errors to error handler
    }
};

// Forgot Password
exports.forgotPassword = async (req, res, next) => {
    try {
        const { email } = req.body;

        const user = await UserService.checkuser(email);
        if (!user) {
            return res.status(404).json({ status: false, error: 'User not found' });
        }

        const tokenData = { _id: user._id, email: user.email }; // ✅ Define tokenData
        const token = await UserService.generateToken(tokenData, 'myverystrongsecretkey', '1h');

        user.resetToken = token;
        user.resetTokenExpiry = Date.now() + 3600000; // 1 hour
        await user.save();

        // Send email code here (not shown)
        res.status(200).json({ status: true, message: 'Reset link sent to your email.' });

    } catch (error) {
        next(error);
    }
};

// Reset Password
exports.resetPassword = async (req, res, next) => {
    try {
        const { token } = req.params;
        const { password } = req.body;

        const decoded = jwt.verify(token, 'myverystrongsecretkey');
        const user = await UserModel.findOne({
            _id: decoded._id,
            resetToken: token,
            resetTokenExpiry: { $gt: Date.now() }
        });

        if (!user) return res.status(400).json({ status: false, error: "Invalid or expired token" });

        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(password, salt);
        user.resetToken = undefined;
        user.resetTokenExpiry = undefined;
        await user.save();

        res.status(200).json({ status: true, success: "Password has been reset successfully" });
    } catch (error) {
        next(error);
    }
};

