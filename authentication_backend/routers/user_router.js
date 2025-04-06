const router=require('express').Router();
const USerController=require('../controller/user_controller');
const UserService = require('../services/user_services');


router.post('/registeration',USerController.register);
router.post('/login',USerController.login);
router.post('/logout', USerController.logout);


router.post('/forgot-password', USerController.forgotPassword);
router.post('/reset-password/:token', USerController.resetPassword);


module.exports=router;