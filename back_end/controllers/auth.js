const db = require('../models/models');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { body, validationResult } = require('express-validator');
const SALT = process.env.AUTH_SALT;
const notificationAdmin = require('./push_notification')

const login = async (req, res) => {
  try {

    await body('email').isEmail().normalizeEmail().run(req);
    await body('password').isLength({ min: 8 }).trim().escape().run(req);

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const { email, password } = req.body;

    const user = await db.User.findOne({ email });
    if (!user) {
      return res.status(404).json({ success: false, message: 'Invalid email' });
    }

    if (user.role === 'HealthcareProvider' && user.status === 'Pending') {
      const admin = await db.User.findOne({ role: "Admin" })
      const notification = new db.Notification({
        userId: admin._id,
        message: `please check new signup attempt`,
      });
      await notification.save();
      const notificationData = {
        id: notification._id,
        fileId: user._id,
        title: `${user.type} waiting for your approvel `,
        body: `please check Health care providers list`,
      };
      await notificationAdmin.sendPushNotification(
        admin._id,
        notificationData
      );
      return res.status(200).json({ success: false, message: 'Your demand is still under verification.\n Please wait for admin approval .' });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ success: false, message: 'Invalid password' });
    }

    delete user._doc['password'];
    const token = jwt.sign(
      { id: user._id, email: user.email, role: user.role },
      process.env.AUTH_PRIVATE_KEY,
      { expiresIn: '48h' }
    );

    return res.status(200).json({
      success: true,
      message: `You have successfully\n logged in as ${user.role}`,
      token,
      information: {
        _id: user._id,
        email: user.email,
        role: user.role,
        picture: user.picture,
      },
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      message: 'An error occurred\n while logging in',
      error: error.message,
    });
  }
};

const signup = async (req, res) => {
  const { firstname, lastname, email, password, type, name, role } = req.body;
  console.log(req.body);
  try {
    const existingUser = await db.User.findOne({ email });
    if (existingUser) {
      return res.status(401).json({ success: false, error: 'User already exists' });
    }

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(422).json({ success: false, errors: errors.array() });
    }

    let newUser;
    if (role === 'Patient') {
      if (!firstname || !lastname) {
        return res.status(400).json({
          success: false,
          error: 'First name and last name are required for patient role',
        });
      }
      newUser = new db.Patient({ firstname, lastname, email, password });
    } else if (role === 'HealthcareProvider') {
      if (type === 'Doctor') {
        if (!firstname || !lastname) {
          return res.status(400).json({
            success: false,
            error: 'First name and last name are required for doctor',
          });
        }
        newUser = new db.HealthcareProvider({ type, firstname, lastname, email, password });
        console.log(newUser);
      } else {
        if (!name) {
          return res.status(400).json({
            success: false,
            error: 'Type and name are required for healthcare provider',
          });
        }
        newUser = new db.HealthcareProvider({ type, name, email, password });
      }
    } else {
      return res.status(400).json({ success: false, error: 'Role must be "Patient" or "HealthcareProvider"' });
    }

    if (role === 'Patient' || (role === 'HealthcareProvider' && type === 'Doctor')) {
      newUser.name = `${firstname} ${lastname}`;
    }

    const salt = await bcrypt.genSalt(SALT);
    const hashedPassword = await bcrypt.hash(password, salt);
    newUser.password = hashedPassword;
    const savedUser = await newUser.save();
    console.log(savedUser);

    
    const token = jwt.sign(
      { id: savedUser._id, email: savedUser.email, role: savedUser.role },
      process.env.AUTH_PRIVATE_KEY,
      { expiresIn: '48h' }
    );

    return res.status(201).json({
      success: true,
      message: `${savedUser.role} created successfully`,
      informations: {
        _id: savedUser._id,
        email: savedUser.email,
      },
      token,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: 'Server error' });
  }
};

const adminSignup = async (req, res) => {
  const { firstname, lastname, email, password } = req.body;
  console.log("1")

  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({ success: false, errors: errors.array() });
  }

  try {

    const existingUser = await db.User.findOne({ email });
    if (existingUser) {
      return res.status(401).json({ success: false, error: 'User already exists' });
    }


    const newAdmin = new db.Admin({ firstname, lastname, email, password });
    newAdmin.name = `${firstname} ${lastname}`


    const salt = await bcrypt.genSalt(SALT);
    const hashedPassword = await bcrypt.hash(password, salt);
    newAdmin.password = hashedPassword;
    const savedAdmin = await newAdmin.save();


    const token = jwt.sign(
      { id: savedAdmin._id, email: savedAdmin.email, role: savedAdmin.role },
      process.env.AUTH_PRIVATE_KEY,
      { expiresIn: '48h' }
    );


    return res.status(201).json({
      success: true,
      message: 'Admin created successfully',
      admin: {
        id: savedAdmin._id,
        email: savedAdmin.email,
      },
      token,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      success: false,
      error: 'An error occurred\n while creating the admin',
      message: error.message,
    });
  }
};

const auth = {
  login,
  signup,
  adminSignup,
};

module.exports = auth;
