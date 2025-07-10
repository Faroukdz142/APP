// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Hello there`
  String get registerWelcome {
    return Intl.message(
      'Hello there',
      name: 'registerWelcome',
      desc: '',
      args: [],
    );
  }

  /// `Register to enjoy all the features we have to offer.`
  String get registerText {
    return Intl.message(
      'Register to enjoy all the features we have to offer.',
      name: 'registerText',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get loginText {
    return Intl.message(
      'Sign in to continue',
      name: 'loginText',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with google`
  String get google {
    return Intl.message(
      'Sign in with google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with google`
  String get googleRegister {
    return Intl.message(
      'Sign up with google',
      name: 'googleRegister',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forget {
    return Intl.message(
      'Forget Password?',
      name: 'forget',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get credit {
    return Intl.message(
      'Credit',
      name: 'credit',
      desc: '',
      args: [],
    );
  }

  /// `Products Cart`
  String get prodCart {
    return Intl.message(
      'Products Cart',
      name: 'prodCart',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get noAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message(
      'Sign Up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number should not be empty!`
  String get phoneNumberEmpty {
    return Intl.message(
      'Phone Number should not be empty!',
      name: 'phoneNumberEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get phoneNumberWrong {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'phoneNumberWrong',
      desc: '',
      args: [],
    );
  }

  /// `Choose Area`
  String get chooseArea {
    return Intl.message(
      'Choose Area',
      name: 'chooseArea',
      desc: '',
      args: [],
    );
  }

  /// `Choose Date`
  String get chooseDate {
    return Intl.message(
      'Choose Date',
      name: 'chooseDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose Time`
  String get chooseTime {
    return Intl.message(
      'Choose Time',
      name: 'chooseTime',
      desc: '',
      args: [],
    );
  }

  /// `Otp was resent successully`
  String get otpReSent {
    return Intl.message(
      'Otp was resent successully',
      name: 'otpReSent',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Don't worry! Please enter the email adress associated with your account`
  String get forgetText {
    return Intl.message(
      'Don\'t worry! Please enter the email adress associated with your account',
      name: 'forgetText',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset {
    return Intl.message(
      'Reset Password',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Set your new password`
  String get setNew {
    return Intl.message(
      'Set your new password',
      name: 'setNew',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new password twice below to reset a new password`
  String get resetText {
    return Intl.message(
      'Enter your new password twice below to reset a new password',
      name: 'resetText',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Trust Laundry !`
  String get title1 {
    return Intl.message(
      'Welcome to Trust Laundry !',
      name: 'title1',
      desc: '',
      args: [],
    );
  }

  /// `Easy booking`
  String get title2 {
    return Intl.message(
      'Easy booking',
      name: 'title2',
      desc: '',
      args: [],
    );
  }

  /// `Track your laundry!`
  String get title3 {
    return Intl.message(
      'Track your laundry!',
      name: 'title3',
      desc: '',
      args: [],
    );
  }

  /// `Say goodbye to the stress of laundry day. Our seamless service ensures that your laundry is handled with care and returned clean and refreshed. Whether it's a quick wash or special treatment, enjoy fast, reliable, and convenient laundry solutions that meet your needs.`
  String get desc1 {
    return Intl.message(
      'Say goodbye to the stress of laundry day. Our seamless service ensures that your laundry is handled with care and returned clean and refreshed. Whether it\'s a quick wash or special treatment, enjoy fast, reliable, and convenient laundry solutions that meet your needs.',
      name: 'desc1',
      desc: '',
      args: [],
    );
  }

  /// `We are here to meet your needs. Choose from a range of laundry services, set your preferred pickup and delivery times, and leave the rest to us. From regular laundry to delicate fabrics.`
  String get desc2 {
    return Intl.message(
      'We are here to meet your needs. Choose from a range of laundry services, set your preferred pickup and delivery times, and leave the rest to us. From regular laundry to delicate fabrics.',
      name: 'desc2',
      desc: '',
      args: [],
    );
  }

  /// `Stay informed with instant updates on your laundry's progress. Receive notifications at every step - from the moment your laundry is picked up until it's returned to you. Track your order with ease and enjoy peace of mind knowing where your laundry is at all times.`
  String get desc3 {
    return Intl.message(
      'Stay informed with instant updates on your laundry\'s progress. Receive notifications at every step - from the moment your laundry is picked up until it\'s returned to you. Track your order with ease and enjoy peace of mind knowing where your laundry is at all times.',
      name: 'desc3',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Email Verification`
  String get verifyEmail {
    return Intl.message(
      'Email Verification',
      name: 'verifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Check your mail box`
  String get checkEmail {
    return Intl.message(
      'Check your mail box',
      name: 'checkEmail',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to you, tap on the url to confirm your email.`
  String get verifyText {
    return Intl.message(
      'A verification email has been sent to you, tap on the url to confirm your email.',
      name: 'verifyText',
      desc: '',
      args: [],
    );
  }

  /// `Go Back to login`
  String get backTo {
    return Intl.message(
      'Go Back to login',
      name: 'backTo',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get currentPwd {
    return Intl.message(
      'Current password',
      name: 'currentPwd',
      desc: '',
      args: [],
    );
  }

  /// `Password Wrong!`
  String get pwdWrong {
    return Intl.message(
      'Password Wrong!',
      name: 'pwdWrong',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Verification Code`
  String get verifCode {
    return Intl.message(
      'Enter Verification Code',
      name: 'verifCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter code that we have sent to your phone`
  String get verifText {
    return Intl.message(
      'Enter code that we have sent to your phone',
      name: 'verifText',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Username should not be empty!`
  String get usernameEmpty {
    return Intl.message(
      'Username should not be empty!',
      name: 'usernameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Username too short!`
  String get usernameShort {
    return Intl.message(
      'Username too short!',
      name: 'usernameShort',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message(
      'My Orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get acc {
    return Intl.message(
      'Account',
      name: 'acc',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appS {
    return Intl.message(
      'App Settings',
      name: 'appS',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get profile {
    return Intl.message(
      'My Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `My subscriptions`
  String get mySubs {
    return Intl.message(
      'My subscriptions',
      name: 'mySubs',
      desc: '',
      args: [],
    );
  }

  /// `My notifications`
  String get notifs {
    return Intl.message(
      'My notifications',
      name: 'notifs',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `What service do you need today?`
  String get ser {
    return Intl.message(
      'What service do you need today?',
      name: 'ser',
      desc: '',
      args: [],
    );
  }

  /// `Have a good day!`
  String get goodDay {
    return Intl.message(
      'Have a good day!',
      name: 'goodDay',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get discover {
    return Intl.message(
      'Discover',
      name: 'discover',
      desc: '',
      args: [],
    );
  }

  /// `Our pricing`
  String get pricing {
    return Intl.message(
      'Our pricing',
      name: 'pricing',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get subs {
    return Intl.message(
      'Subscriptions',
      name: 'subs',
      desc: '',
      args: [],
    );
  }

  /// `Have any questions?`
  String get qst {
    return Intl.message(
      'Have any questions?',
      name: 'qst',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Your message here`
  String get message {
    return Intl.message(
      'Your message here',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `You need to login to view all app features!`
  String get needLogin {
    return Intl.message(
      'You need to login to view all app features!',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `Ironing`
  String get iron {
    return Intl.message(
      'Ironing',
      name: 'iron',
      desc: '',
      args: [],
    );
  }

  /// `Wash & dry`
  String get wash {
    return Intl.message(
      'Wash & dry',
      name: 'wash',
      desc: '',
      args: [],
    );
  }

  /// `Darning`
  String get darning {
    return Intl.message(
      'Darning',
      name: 'darning',
      desc: '',
      args: [],
    );
  }

  /// `Dry Cleaning`
  String get dry {
    return Intl.message(
      'Dry Cleaning',
      name: 'dry',
      desc: '',
      args: [],
    );
  }

  /// `Balance: `
  String get balance {
    return Intl.message(
      'Balance: ',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `kwd`
  String get kwd {
    return Intl.message(
      'kwd',
      name: 'kwd',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Booking`
  String get book {
    return Intl.message(
      'Booking',
      name: 'book',
      desc: '',
      args: [],
    );
  }

  /// `Carpets & Funiture`
  String get carpets {
    return Intl.message(
      'Carpets & Funiture',
      name: 'carpets',
      desc: '',
      args: [],
    );
  }

  /// `Clothes & Blankets`
  String get clothes {
    return Intl.message(
      'Clothes & Blankets',
      name: 'clothes',
      desc: '',
      args: [],
    );
  }

  /// `Request a driver`
  String get req {
    return Intl.message(
      'Request a driver',
      name: 'req',
      desc: '',
      args: [],
    );
  }

  /// `1e`
  String get ban1 {
    return Intl.message(
      '1e',
      name: 'ban1',
      desc: '',
      args: [],
    );
  }

  /// `2e`
  String get ban2 {
    return Intl.message(
      '2e',
      name: 'ban2',
      desc: '',
      args: [],
    );
  }

  /// `from 10am to 2pm`
  String get morning {
    return Intl.message(
      'from 10am to 2pm',
      name: 'morning',
      desc: '',
      args: [],
    );
  }

  /// `from 3pm to 8pm`
  String get evening {
    return Intl.message(
      'from 3pm to 8pm',
      name: 'evening',
      desc: '',
      args: [],
    );
  }

  /// `Choose driver request date`
  String get date {
    return Intl.message(
      'Choose driver request date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Choose request period`
  String get time {
    return Intl.message(
      'Choose request period',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Get a credit of`
  String get get {
    return Intl.message(
      'Get a credit of',
      name: 'get',
      desc: '',
      args: [],
    );
  }

  /// `Add to cart`
  String get add {
    return Intl.message(
      'Add to cart',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Address settings`
  String get addressSet {
    return Intl.message(
      'Address settings',
      name: 'addressSet',
      desc: '',
      args: [],
    );
  }

  /// `Choose address`
  String get chooseAddress {
    return Intl.message(
      'Choose address',
      name: 'chooseAddress',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Add a new address`
  String get addAddress {
    return Intl.message(
      'Add a new address',
      name: 'addAddress',
      desc: '',
      args: [],
    );
  }

  /// `Modify Address`
  String get modifyAddress {
    return Intl.message(
      'Modify Address',
      name: 'modifyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address title`
  String get addressTitle {
    return Intl.message(
      'Address title',
      name: 'addressTitle',
      desc: '',
      args: [],
    );
  }

  /// `Appartement`
  String get appartement {
    return Intl.message(
      'Appartement',
      name: 'appartement',
      desc: '',
      args: [],
    );
  }

  /// `Appartement number`
  String get appartementNumber {
    return Intl.message(
      'Appartement number',
      name: 'appartementNumber',
      desc: '',
      args: [],
    );
  }

  /// `Street`
  String get street {
    return Intl.message(
      'Street',
      name: 'street',
      desc: '',
      args: [],
    );
  }

  /// `Boulevard`
  String get boulevard {
    return Intl.message(
      'Boulevard',
      name: 'boulevard',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get building {
    return Intl.message(
      'Building',
      name: 'building',
      desc: '',
      args: [],
    );
  }

  /// `Added new`
  String get addSuccess {
    return Intl.message(
      'Added new',
      name: 'addSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get updateSuccess {
    return Intl.message(
      'Updated',
      name: 'updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Try again!`
  String get tryAgain {
    return Intl.message(
      'Try again!',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Delivery address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Location details copied to clipboard!`
  String get copiedToClipboard {
    return Intl.message(
      'Location details copied to clipboard!',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get longitude {
    return Intl.message(
      'Longitude',
      name: 'longitude',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get area {
    return Intl.message(
      'Area',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Apartment Number`
  String get apartmentNum {
    return Intl.message(
      'Apartment Number',
      name: 'apartmentNum',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get notAvailable {
    return Intl.message(
      'Not Available',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Pickup date & time`
  String get pickupDateAndTime {
    return Intl.message(
      'Pickup date & time',
      name: 'pickupDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `Delivery date & time`
  String get deliveryDateAndTime {
    return Intl.message(
      'Delivery date & time',
      name: 'deliveryDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Choose Payment method`
  String get paymentMethod {
    return Intl.message(
      'Choose Payment method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Pickup Date: `
  String get pickupDate {
    return Intl.message(
      'Pickup Date: ',
      name: 'pickupDate',
      desc: '',
      args: [],
    );
  }

  /// `Delivery date: `
  String get deliveryDate {
    return Intl.message(
      'Delivery date: ',
      name: 'deliveryDate',
      desc: '',
      args: [],
    );
  }

  /// `Payment info`
  String get paymentInfo {
    return Intl.message(
      'Payment info',
      name: 'paymentInfo',
      desc: '',
      args: [],
    );
  }

  /// `Total price:`
  String get totalPrice {
    return Intl.message(
      'Total price:',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Number of items: `
  String get numberOfItems {
    return Intl.message(
      'Number of items: ',
      name: 'numberOfItems',
      desc: '',
      args: [],
    );
  }

  /// `Special Instructions`
  String get specialInstructions {
    return Intl.message(
      'Special Instructions',
      name: 'specialInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Your balance is too low, check our subsciptions!`
  String get balanceLow {
    return Intl.message(
      'Your balance is too low, check our subsciptions!',
      name: 'balanceLow',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get okContinue {
    return Intl.message(
      'Continue',
      name: 'okContinue',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Online Payment`
  String get onlinePay {
    return Intl.message(
      'Online Payment',
      name: 'onlinePay',
      desc: '',
      args: [],
    );
  }

  /// `Admin Panel`
  String get adminPanel {
    return Intl.message(
      'Admin Panel',
      name: 'adminPanel',
      desc: '',
      args: [],
    );
  }

  /// `Total Users`
  String get totalUsers {
    return Intl.message(
      'Total Users',
      name: 'totalUsers',
      desc: '',
      args: [],
    );
  }

  /// `Total Orders`
  String get totalOrders {
    return Intl.message(
      'Total Orders',
      name: 'totalOrders',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Driver Requests`
  String get driverRequests {
    return Intl.message(
      'Driver Requests',
      name: 'driverRequests',
      desc: '',
      args: [],
    );
  }

  /// `There are no driver requests actually!`
  String get noReq {
    return Intl.message(
      'There are no driver requests actually!',
      name: 'noReq',
      desc: '',
      args: [],
    );
  }

  /// `User Id: `
  String get userId {
    return Intl.message(
      'User Id: ',
      name: 'userId',
      desc: '',
      args: [],
    );
  }

  /// `Request Id: `
  String get reqId {
    return Intl.message(
      'Request Id: ',
      name: 'reqId',
      desc: '',
      args: [],
    );
  }

  /// `Request Date & Time: `
  String get reqDT {
    return Intl.message(
      'Request Date & Time: ',
      name: 'reqDT',
      desc: '',
      args: [],
    );
  }

  /// `Date: `
  String get date2 {
    return Intl.message(
      'Date: ',
      name: 'date2',
      desc: '',
      args: [],
    );
  }

  /// `Period: `
  String get period {
    return Intl.message(
      'Period: ',
      name: 'period',
      desc: '',
      args: [],
    );
  }

  /// `A notification is sent to the user!`
  String get notifSent {
    return Intl.message(
      'A notification is sent to the user!',
      name: 'notifSent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Request`
  String get cancelReq {
    return Intl.message(
      'Cancel Request',
      name: 'cancelReq',
      desc: '',
      args: [],
    );
  }

  /// `Driver Sent`
  String get driverSent {
    return Intl.message(
      'Driver Sent',
      name: 'driverSent',
      desc: '',
      args: [],
    );
  }

  /// `Manage Items`
  String get manageItems {
    return Intl.message(
      'Manage Items',
      name: 'manageItems',
      desc: '',
      args: [],
    );
  }

  /// `Order Id: `
  String get orderId {
    return Intl.message(
      'Order Id: ',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `Order Status: `
  String get orderStatus {
    return Intl.message(
      'Order Status: ',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Not payed`
  String get notPayed {
    return Intl.message(
      'Not payed',
      name: 'notPayed',
      desc: '',
      args: [],
    );
  }

  /// `Payment Id: `
  String get paymentId {
    return Intl.message(
      'Payment Id: ',
      name: 'paymentId',
      desc: '',
      args: [],
    );
  }

  /// `Amount: `
  String get amount {
    return Intl.message(
      'Amount: ',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Order date & time: `
  String get orderDateAndTime {
    return Intl.message(
      'Order date & time: ',
      name: 'orderDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `item`
  String get item {
    return Intl.message(
      'item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Message:`
  String get messagee {
    return Intl.message(
      'Message:',
      name: 'messagee',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }

  /// `Dry Cleaning`
  String get dryCleaning {
    return Intl.message(
      'Dry Cleaning',
      name: 'dryCleaning',
      desc: '',
      args: [],
    );
  }

  /// `Laundry Carpets`
  String get laundryCarpets {
    return Intl.message(
      'Laundry Carpets',
      name: 'laundryCarpets',
      desc: '',
      args: [],
    );
  }

  /// `Laundry`
  String get laundry {
    return Intl.message(
      'Laundry',
      name: 'laundry',
      desc: '',
      args: [],
    );
  }

  /// `Blankets & Linen`
  String get blanketsAndLinen {
    return Intl.message(
      'Blankets & Linen',
      name: 'blanketsAndLinen',
      desc: '',
      args: [],
    );
  }

  /// `Pressing`
  String get pressing {
    return Intl.message(
      'Pressing',
      name: 'pressing',
      desc: '',
      args: [],
    );
  }

  /// `Notifications Center`
  String get notifCenter {
    return Intl.message(
      'Notifications Center',
      name: 'notifCenter',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get content {
    return Intl.message(
      'Content',
      name: 'content',
      desc: '',
      args: [],
    );
  }

  /// `Send a notification to all users`
  String get sendNotifToAllUsers {
    return Intl.message(
      'Send a notification to all users',
      name: 'sendNotifToAllUsers',
      desc: '',
      args: [],
    );
  }

  /// `My Notifications`
  String get myNotifs {
    return Intl.message(
      'My Notifications',
      name: 'myNotifs',
      desc: '',
      args: [],
    );
  }

  /// `You have no notifications yet!`
  String get noNotifs {
    return Intl.message(
      'You have no notifications yet!',
      name: 'noNotifs',
      desc: '',
      args: [],
    );
  }

  /// `You have no items in cart yet!`
  String get cartEmpty {
    return Intl.message(
      'You have no items in cart yet!',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `You have no orders yet!`
  String get noOrders {
    return Intl.message(
      'You have no orders yet!',
      name: 'noOrders',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status: `
  String get paymentStatus {
    return Intl.message(
      'Payment Status: ',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Status: `
  String get status {
    return Intl.message(
      'Status: ',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Loading Items, please wait...`
  String get loadingItems {
    return Intl.message(
      'Loading Items, please wait...',
      name: 'loadingItems',
      desc: '',
      args: [],
    );
  }

  /// `My driver requests`
  String get myRequests {
    return Intl.message(
      'My driver requests',
      name: 'myRequests',
      desc: '',
      args: [],
    );
  }

  /// `You have no driver requests yet!`
  String get noDriverRequests {
    return Intl.message(
      'You have no driver requests yet!',
      name: 'noDriverRequests',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this request?`
  String get cancelRequestSure {
    return Intl.message(
      'Are you sure you want to cancel this request?',
      name: 'cancelRequestSure',
      desc: '',
      args: [],
    );
  }

  /// `Request cancelled successfully, a notification was sent to the user`
  String get reqCancelled {
    return Intl.message(
      'Request cancelled successfully, a notification was sent to the user',
      name: 'reqCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure delete this address`
  String get addressSure {
    return Intl.message(
      'Are you sure delete this address',
      name: 'addressSure',
      desc: '',
      args: [],
    );
  }

  /// `Message sent successfully`
  String get messageSent {
    return Intl.message(
      'Message sent successfully',
      name: 'messageSent',
      desc: '',
      args: [],
    );
  }

  /// `Carpet`
  String get item_carpet {
    return Intl.message(
      'Carpet',
      name: 'item_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Special Carpet`
  String get item_special_carpet {
    return Intl.message(
      'Special Carpet',
      name: 'item_special_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Mats`
  String get item_mats {
    return Intl.message(
      'Mats',
      name: 'item_mats',
      desc: '',
      args: [],
    );
  }

  /// `Tent`
  String get item_tent {
    return Intl.message(
      'Tent',
      name: 'item_tent',
      desc: '',
      args: [],
    );
  }

  /// `Tablecloth`
  String get item_tablecloth {
    return Intl.message(
      'Tablecloth',
      name: 'item_tablecloth',
      desc: '',
      args: [],
    );
  }

  /// `Standard Carpet`
  String get subitem_standard_carpet {
    return Intl.message(
      'Standard Carpet',
      name: 'subitem_standard_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Large Carpet`
  String get subitem_large_carpet {
    return Intl.message(
      'Large Carpet',
      name: 'subitem_large_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Handmade Special Carpet`
  String get subitem_handmade_special_carpet {
    return Intl.message(
      'Handmade Special Carpet',
      name: 'subitem_handmade_special_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Luxury Special Carpet`
  String get subitem_luxury_special_carpet {
    return Intl.message(
      'Luxury Special Carpet',
      name: 'subitem_luxury_special_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Small Mats`
  String get subitem_small_mats {
    return Intl.message(
      'Small Mats',
      name: 'subitem_small_mats',
      desc: '',
      args: [],
    );
  }

  /// `Large Mats`
  String get subitem_large_mats {
    return Intl.message(
      'Large Mats',
      name: 'subitem_large_mats',
      desc: '',
      args: [],
    );
  }

  /// `Small Tent`
  String get subitem_small_tent {
    return Intl.message(
      'Small Tent',
      name: 'subitem_small_tent',
      desc: '',
      args: [],
    );
  }

  /// `Large Tent`
  String get subitem_large_tent {
    return Intl.message(
      'Large Tent',
      name: 'subitem_large_tent',
      desc: '',
      args: [],
    );
  }

  /// `Standard Tablecloth`
  String get subitem_standard_tablecloth {
    return Intl.message(
      'Standard Tablecloth',
      name: 'subitem_standard_tablecloth',
      desc: '',
      args: [],
    );
  }

  /// `Premium Tablecloth`
  String get subitem_premium_tablecloth {
    return Intl.message(
      'Premium Tablecloth',
      name: 'subitem_premium_tablecloth',
      desc: '',
      args: [],
    );
  }

  /// `Sofa`
  String get item_sofa {
    return Intl.message(
      'Sofa',
      name: 'item_sofa',
      desc: '',
      args: [],
    );
  }

  /// `Seats`
  String get item_seats {
    return Intl.message(
      'Seats',
      name: 'item_seats',
      desc: '',
      args: [],
    );
  }

  /// `Majlis`
  String get item_majlis {
    return Intl.message(
      'Majlis',
      name: 'item_majlis',
      desc: '',
      args: [],
    );
  }

  /// `Standard Sofa`
  String get subitem_standard_sofa {
    return Intl.message(
      'Standard Sofa',
      name: 'subitem_standard_sofa',
      desc: '',
      args: [],
    );
  }

  /// `Luxury Sofa`
  String get subitem_luxury_sofa {
    return Intl.message(
      'Luxury Sofa',
      name: 'subitem_luxury_sofa',
      desc: '',
      args: [],
    );
  }

  /// `Single Seat`
  String get subitem_single_seat {
    return Intl.message(
      'Single Seat',
      name: 'subitem_single_seat',
      desc: '',
      args: [],
    );
  }

  /// `Double Seat`
  String get subitem_double_seat {
    return Intl.message(
      'Double Seat',
      name: 'subitem_double_seat',
      desc: '',
      args: [],
    );
  }

  /// `Small Majlis`
  String get subitem_small_majlis {
    return Intl.message(
      'Small Majlis',
      name: 'subitem_small_majlis',
      desc: '',
      args: [],
    );
  }

  /// `Large Majlis`
  String get subitem_large_majlis {
    return Intl.message(
      'Large Majlis',
      name: 'subitem_large_majlis',
      desc: '',
      args: [],
    );
  }

  /// `Suit`
  String get item_suit {
    return Intl.message(
      'Suit',
      name: 'item_suit',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get item_shoes {
    return Intl.message(
      'Shoes',
      name: 'item_shoes',
      desc: '',
      args: [],
    );
  }

  /// `Tie`
  String get item_tie {
    return Intl.message(
      'Tie',
      name: 'item_tie',
      desc: '',
      args: [],
    );
  }

  /// `Wedding Dress`
  String get item_wedding_dress {
    return Intl.message(
      'Wedding Dress',
      name: 'item_wedding_dress',
      desc: '',
      args: [],
    );
  }

  /// `Jacket`
  String get item_jacket {
    return Intl.message(
      'Jacket',
      name: 'item_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Business Suit`
  String get subitem_business_suit {
    return Intl.message(
      'Business Suit',
      name: 'subitem_business_suit',
      desc: '',
      args: [],
    );
  }

  /// `Casual Suit`
  String get subitem_casual_suit {
    return Intl.message(
      'Casual Suit',
      name: 'subitem_casual_suit',
      desc: '',
      args: [],
    );
  }

  /// `Leather Shoes`
  String get subitem_leather_shoes {
    return Intl.message(
      'Leather Shoes',
      name: 'subitem_leather_shoes',
      desc: '',
      args: [],
    );
  }

  /// `Sneakers`
  String get subitem_sneakers {
    return Intl.message(
      'Sneakers',
      name: 'subitem_sneakers',
      desc: '',
      args: [],
    );
  }

  /// `Silk Tie`
  String get subitem_silk_tie {
    return Intl.message(
      'Silk Tie',
      name: 'subitem_silk_tie',
      desc: '',
      args: [],
    );
  }

  /// `Polyester Tie`
  String get subitem_polyester_tie {
    return Intl.message(
      'Polyester Tie',
      name: 'subitem_polyester_tie',
      desc: '',
      args: [],
    );
  }

  /// `Traditional Wedding Dress`
  String get subitem_traditional_wedding_dress {
    return Intl.message(
      'Traditional Wedding Dress',
      name: 'subitem_traditional_wedding_dress',
      desc: '',
      args: [],
    );
  }

  /// `Modern Wedding Dress`
  String get subitem_modern_wedding_dress {
    return Intl.message(
      'Modern Wedding Dress',
      name: 'subitem_modern_wedding_dress',
      desc: '',
      args: [],
    );
  }

  /// `Bomber Jacket`
  String get subitem_bomber_jacket {
    return Intl.message(
      'Bomber Jacket',
      name: 'subitem_bomber_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Blazer Jacket`
  String get subitem_blazer_jacket {
    return Intl.message(
      'Blazer Jacket',
      name: 'subitem_blazer_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Mattress`
  String get item_mattress {
    return Intl.message(
      'Mattress',
      name: 'item_mattress',
      desc: '',
      args: [],
    );
  }

  /// `Bed covers`
  String get item_bed_covers {
    return Intl.message(
      'Bed covers',
      name: 'item_bed_covers',
      desc: '',
      args: [],
    );
  }

  /// `Bed Sheets`
  String get item_bed_sheets {
    return Intl.message(
      'Bed Sheets',
      name: 'item_bed_sheets',
      desc: '',
      args: [],
    );
  }

  /// `Pillows`
  String get item_pillows {
    return Intl.message(
      'Pillows',
      name: 'item_pillows',
      desc: '',
      args: [],
    );
  }

  /// `Sleeping Wear`
  String get item_sleeping_wear {
    return Intl.message(
      'Sleeping Wear',
      name: 'item_sleeping_wear',
      desc: '',
      args: [],
    );
  }

  /// `Towel`
  String get item_towel {
    return Intl.message(
      'Towel',
      name: 'item_towel',
      desc: '',
      args: [],
    );
  }

  /// `Single Mattress`
  String get subitem_single_mattress {
    return Intl.message(
      'Single Mattress',
      name: 'subitem_single_mattress',
      desc: '',
      args: [],
    );
  }

  /// `Double Mattress`
  String get subitem_double_mattress {
    return Intl.message(
      'Double Mattress',
      name: 'subitem_double_mattress',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Bed Cover`
  String get subitem_cotton_bed_cover {
    return Intl.message(
      'Cotton Bed Cover',
      name: 'subitem_cotton_bed_cover',
      desc: '',
      args: [],
    );
  }

  /// `Silk Bed Cover`
  String get subitem_silk_bed_cover {
    return Intl.message(
      'Silk Bed Cover',
      name: 'subitem_silk_bed_cover',
      desc: '',
      args: [],
    );
  }

  /// `King Size Bed Sheet`
  String get subitem_king_size_bed_sheet {
    return Intl.message(
      'King Size Bed Sheet',
      name: 'subitem_king_size_bed_sheet',
      desc: '',
      args: [],
    );
  }

  /// `Queen Size Bed Sheet`
  String get subitem_queen_size_bed_sheet {
    return Intl.message(
      'Queen Size Bed Sheet',
      name: 'subitem_queen_size_bed_sheet',
      desc: '',
      args: [],
    );
  }

  /// `Standard Pillow`
  String get subitem_standard_pillow {
    return Intl.message(
      'Standard Pillow',
      name: 'subitem_standard_pillow',
      desc: '',
      args: [],
    );
  }

  /// `Memory Foam Pillow`
  String get subitem_memory_foam_pillow {
    return Intl.message(
      'Memory Foam Pillow',
      name: 'subitem_memory_foam_pillow',
      desc: '',
      args: [],
    );
  }

  /// `Two-Seater Sofa`
  String get subitem_two_seater_sofa {
    return Intl.message(
      'Two-Seater Sofa',
      name: 'subitem_two_seater_sofa',
      desc: '',
      args: [],
    );
  }

  /// `Three-Seater Sofa`
  String get subitem_three_seater_sofa {
    return Intl.message(
      'Three-Seater Sofa',
      name: 'subitem_three_seater_sofa',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Pajamas`
  String get subitem_cotton_pajamas {
    return Intl.message(
      'Cotton Pajamas',
      name: 'subitem_cotton_pajamas',
      desc: '',
      args: [],
    );
  }

  /// `Silk Pajamas`
  String get subitem_silk_pajamas {
    return Intl.message(
      'Silk Pajamas',
      name: 'subitem_silk_pajamas',
      desc: '',
      args: [],
    );
  }

  /// `Wooden Seat`
  String get subitem_wooden_seat {
    return Intl.message(
      'Wooden Seat',
      name: 'subitem_wooden_seat',
      desc: '',
      args: [],
    );
  }

  /// `Plastic Seat`
  String get subitem_plastic_seat {
    return Intl.message(
      'Plastic Seat',
      name: 'subitem_plastic_seat',
      desc: '',
      args: [],
    );
  }

  /// `Door Mat`
  String get subitem_door_mat {
    return Intl.message(
      'Door Mat',
      name: 'subitem_door_mat',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom Mat`
  String get subitem_bathroom_mat {
    return Intl.message(
      'Bathroom Mat',
      name: 'subitem_bathroom_mat',
      desc: '',
      args: [],
    );
  }

  /// `Traditional Majlis`
  String get subitem_traditional_majlis {
    return Intl.message(
      'Traditional Majlis',
      name: 'subitem_traditional_majlis',
      desc: '',
      args: [],
    );
  }

  /// `Modern Majlis`
  String get subitem_modern_majlis {
    return Intl.message(
      'Modern Majlis',
      name: 'subitem_modern_majlis',
      desc: '',
      args: [],
    );
  }

  /// `Rectangular Tablecloth`
  String get subitem_rectangular_tablecloth {
    return Intl.message(
      'Rectangular Tablecloth',
      name: 'subitem_rectangular_tablecloth',
      desc: '',
      args: [],
    );
  }

  /// `Round Tablecloth`
  String get subitem_round_tablecloth {
    return Intl.message(
      'Round Tablecloth',
      name: 'subitem_round_tablecloth',
      desc: '',
      args: [],
    );
  }

  /// `Hand Towel`
  String get subitem_hand_towel {
    return Intl.message(
      'Hand Towel',
      name: 'subitem_hand_towel',
      desc: '',
      args: [],
    );
  }

  /// `Bath Towel`
  String get subitem_bath_towel {
    return Intl.message(
      'Bath Towel',
      name: 'subitem_bath_towel',
      desc: '',
      args: [],
    );
  }

  /// `Luxury Carpet`
  String get subitem_luxury_carpet {
    return Intl.message(
      'Luxury Carpet',
      name: 'subitem_luxury_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Antique Special Carpet`
  String get subitem_antique_special_carpet {
    return Intl.message(
      'Antique Special Carpet',
      name: 'subitem_antique_special_carpet',
      desc: '',
      args: [],
    );
  }

  /// `Pant`
  String get item_pant {
    return Intl.message(
      'Pant',
      name: 'item_pant',
      desc: '',
      args: [],
    );
  }

  /// `T-shirt`
  String get item_tshirt {
    return Intl.message(
      'T-shirt',
      name: 'item_tshirt',
      desc: '',
      args: [],
    );
  }

  /// `Dress`
  String get item_dress {
    return Intl.message(
      'Dress',
      name: 'item_dress',
      desc: '',
      args: [],
    );
  }

  /// `Skirt`
  String get item_skirt {
    return Intl.message(
      'Skirt',
      name: 'item_skirt',
      desc: '',
      args: [],
    );
  }

  /// `Shorts`
  String get item_shorts {
    return Intl.message(
      'Shorts',
      name: 'item_shorts',
      desc: '',
      args: [],
    );
  }

  /// `Sweater`
  String get item_sweater {
    return Intl.message(
      'Sweater',
      name: 'item_sweater',
      desc: '',
      args: [],
    );
  }

  /// `Blouse`
  String get item_blouse {
    return Intl.message(
      'Blouse',
      name: 'item_blouse',
      desc: '',
      args: [],
    );
  }

  /// `Vest`
  String get item_vest {
    return Intl.message(
      'Vest',
      name: 'item_vest',
      desc: '',
      args: [],
    );
  }

  /// `Scarf`
  String get item_scarf {
    return Intl.message(
      'Scarf',
      name: 'item_scarf',
      desc: '',
      args: [],
    );
  }

  /// `Knickers`
  String get item_knickers {
    return Intl.message(
      'Knickers',
      name: 'item_knickers',
      desc: '',
      args: [],
    );
  }

  /// `Short Pant`
  String get subitem_short_pant {
    return Intl.message(
      'Short Pant',
      name: 'subitem_short_pant',
      desc: '',
      args: [],
    );
  }

  /// `Sport Pant`
  String get subitem_sport_pant {
    return Intl.message(
      'Sport Pant',
      name: 'subitem_sport_pant',
      desc: '',
      args: [],
    );
  }

  /// `Jeans`
  String get subitem_jeans {
    return Intl.message(
      'Jeans',
      name: 'subitem_jeans',
      desc: '',
      args: [],
    );
  }

  /// `Cotton T-shirt`
  String get subitem_cotton_tshirt {
    return Intl.message(
      'Cotton T-shirt',
      name: 'subitem_cotton_tshirt',
      desc: '',
      args: [],
    );
  }

  /// `Polyester T-shirt`
  String get subitem_polyester_tshirt {
    return Intl.message(
      'Polyester T-shirt',
      name: 'subitem_polyester_tshirt',
      desc: '',
      args: [],
    );
  }

  /// `Casual Dress`
  String get subitem_casual_dress {
    return Intl.message(
      'Casual Dress',
      name: 'subitem_casual_dress',
      desc: '',
      args: [],
    );
  }

  /// `Evening Dress`
  String get subitem_evening_dress {
    return Intl.message(
      'Evening Dress',
      name: 'subitem_evening_dress',
      desc: '',
      args: [],
    );
  }

  /// `Leather Jacket`
  String get subitem_leather_jacket {
    return Intl.message(
      'Leather Jacket',
      name: 'subitem_leather_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Denim Jacket`
  String get subitem_denim_jacket {
    return Intl.message(
      'Denim Jacket',
      name: 'subitem_denim_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Mini Skirt`
  String get subitem_mini_skirt {
    return Intl.message(
      'Mini Skirt',
      name: 'subitem_mini_skirt',
      desc: '',
      args: [],
    );
  }

  /// `Maxi Skirt`
  String get subitem_maxi_skirt {
    return Intl.message(
      'Maxi Skirt',
      name: 'subitem_maxi_skirt',
      desc: '',
      args: [],
    );
  }

  /// `Denim Shorts`
  String get subitem_denim_shorts {
    return Intl.message(
      'Denim Shorts',
      name: 'subitem_denim_shorts',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Shorts`
  String get subitem_cotton_shorts {
    return Intl.message(
      'Cotton Shorts',
      name: 'subitem_cotton_shorts',
      desc: '',
      args: [],
    );
  }

  /// `Wool Sweater`
  String get subitem_wool_sweater {
    return Intl.message(
      'Wool Sweater',
      name: 'subitem_wool_sweater',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Sweater`
  String get subitem_cotton_sweater {
    return Intl.message(
      'Cotton Sweater',
      name: 'subitem_cotton_sweater',
      desc: '',
      args: [],
    );
  }

  /// `Silk Blouse`
  String get subitem_silk_blouse {
    return Intl.message(
      'Silk Blouse',
      name: 'subitem_silk_blouse',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Blouse`
  String get subitem_cotton_blouse {
    return Intl.message(
      'Cotton Blouse',
      name: 'subitem_cotton_blouse',
      desc: '',
      args: [],
    );
  }

  /// `Winter Vest`
  String get subitem_winter_vest {
    return Intl.message(
      'Winter Vest',
      name: 'subitem_winter_vest',
      desc: '',
      args: [],
    );
  }

  /// `Summer Vest`
  String get subitem_summer_vest {
    return Intl.message(
      'Summer Vest',
      name: 'subitem_summer_vest',
      desc: '',
      args: [],
    );
  }

  /// `Wool Scarf`
  String get subitem_wool_scarf {
    return Intl.message(
      'Wool Scarf',
      name: 'subitem_wool_scarf',
      desc: '',
      args: [],
    );
  }

  /// `Silk Scarf`
  String get subitem_silk_scarf {
    return Intl.message(
      'Silk Scarf',
      name: 'subitem_silk_scarf',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Knickers`
  String get subitem_cotton_knickers {
    return Intl.message(
      'Cotton Knickers',
      name: 'subitem_cotton_knickers',
      desc: '',
      args: [],
    );
  }

  /// `Silk Knickers`
  String get subitem_silk_knickers {
    return Intl.message(
      'Silk Knickers',
      name: 'subitem_silk_knickers',
      desc: '',
      args: [],
    );
  }

  /// `Socks`
  String get item_socks {
    return Intl.message(
      'Socks',
      name: 'item_socks',
      desc: '',
      args: [],
    );
  }

  /// `Ankle Socks`
  String get subitem_ankle_socks {
    return Intl.message(
      'Ankle Socks',
      name: 'subitem_ankle_socks',
      desc: '',
      args: [],
    );
  }

  /// `Crew Socks`
  String get subitem_crew_socks {
    return Intl.message(
      'Crew Socks',
      name: 'subitem_crew_socks',
      desc: '',
      args: [],
    );
  }

  /// `Gloves`
  String get item_gloves {
    return Intl.message(
      'Gloves',
      name: 'item_gloves',
      desc: '',
      args: [],
    );
  }

  /// `Leather Gloves`
  String get subitem_leather_gloves {
    return Intl.message(
      'Leather Gloves',
      name: 'subitem_leather_gloves',
      desc: '',
      args: [],
    );
  }

  /// `Wool Gloves`
  String get subitem_wool_gloves {
    return Intl.message(
      'Wool Gloves',
      name: 'subitem_wool_gloves',
      desc: '',
      args: [],
    );
  }

  /// `Cap`
  String get item_cap {
    return Intl.message(
      'Cap',
      name: 'item_cap',
      desc: '',
      args: [],
    );
  }

  /// `Baseball Cap`
  String get subitem_baseball_cap {
    return Intl.message(
      'Baseball Cap',
      name: 'subitem_baseball_cap',
      desc: '',
      args: [],
    );
  }

  /// `Snapback Cap`
  String get subitem_snapback_cap {
    return Intl.message(
      'Snapback Cap',
      name: 'subitem_snapback_cap',
      desc: '',
      args: [],
    );
  }

  /// `Bra`
  String get item_bra {
    return Intl.message(
      'Bra',
      name: 'item_bra',
      desc: '',
      args: [],
    );
  }

  /// `Sports Bra`
  String get subitem_sports_bra {
    return Intl.message(
      'Sports Bra',
      name: 'subitem_sports_bra',
      desc: '',
      args: [],
    );
  }

  /// `Lace Bra`
  String get subitem_lace_bra {
    return Intl.message(
      'Lace Bra',
      name: 'subitem_lace_bra',
      desc: '',
      args: [],
    );
  }

  /// `Baby Clothes`
  String get item_baby_clothes {
    return Intl.message(
      'Baby Clothes',
      name: 'item_baby_clothes',
      desc: '',
      args: [],
    );
  }

  /// `Baby Romper`
  String get subitem_baby_romper {
    return Intl.message(
      'Baby Romper',
      name: 'subitem_baby_romper',
      desc: '',
      args: [],
    );
  }

  /// `Baby Shirt`
  String get subitem_baby_shirt {
    return Intl.message(
      'Baby Shirt',
      name: 'subitem_baby_shirt',
      desc: '',
      args: [],
    );
  }

  /// `Uniform`
  String get item_uniform {
    return Intl.message(
      'Uniform',
      name: 'item_uniform',
      desc: '',
      args: [],
    );
  }

  /// `School Uniform`
  String get subitem_school_uniform {
    return Intl.message(
      'School Uniform',
      name: 'subitem_school_uniform',
      desc: '',
      args: [],
    );
  }

  /// `Work Uniform`
  String get subitem_work_uniform {
    return Intl.message(
      'Work Uniform',
      name: 'subitem_work_uniform',
      desc: '',
      args: [],
    );
  }

  /// `Thobe`
  String get item_thobe {
    return Intl.message(
      'Thobe',
      name: 'item_thobe',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Thobe`
  String get subitem_cotton_thobe {
    return Intl.message(
      'Cotton Thobe',
      name: 'subitem_cotton_thobe',
      desc: '',
      args: [],
    );
  }

  /// `Silk Thobe`
  String get subitem_silk_thobe {
    return Intl.message(
      'Silk Thobe',
      name: 'subitem_silk_thobe',
      desc: '',
      args: [],
    );
  }

  /// `Shirt`
  String get item_shirt {
    return Intl.message(
      'Shirt',
      name: 'item_shirt',
      desc: '',
      args: [],
    );
  }

  /// `Formal Shirt`
  String get subitem_formal_shirt {
    return Intl.message(
      'Formal Shirt',
      name: 'subitem_formal_shirt',
      desc: '',
      args: [],
    );
  }

  /// `Casual Shirt`
  String get subitem_casual_shirt {
    return Intl.message(
      'Casual Shirt',
      name: 'subitem_casual_shirt',
      desc: '',
      args: [],
    );
  }

  /// `Party Dress`
  String get item_party_dress {
    return Intl.message(
      'Party Dress',
      name: 'item_party_dress',
      desc: '',
      args: [],
    );
  }

  /// `Cocktail Dress`
  String get subitem_cocktail_dress {
    return Intl.message(
      'Cocktail Dress',
      name: 'subitem_cocktail_dress',
      desc: '',
      args: [],
    );
  }

  /// `Gown`
  String get subitem_gown {
    return Intl.message(
      'Gown',
      name: 'subitem_gown',
      desc: '',
      args: [],
    );
  }

  /// `Muslim Cap`
  String get item_muslim_cap {
    return Intl.message(
      'Muslim Cap',
      name: 'item_muslim_cap',
      desc: '',
      args: [],
    );
  }

  /// `Cotton Muslim Cap`
  String get subitem_cotton_muslim_cap {
    return Intl.message(
      'Cotton Muslim Cap',
      name: 'subitem_cotton_muslim_cap',
      desc: '',
      args: [],
    );
  }

  /// `Silk Muslim Cap`
  String get subitem_silk_muslim_cap {
    return Intl.message(
      'Silk Muslim Cap',
      name: 'subitem_silk_muslim_cap',
      desc: '',
      args: [],
    );
  }

  /// `Suit`
  String get suit {
    return Intl.message(
      'Suit',
      name: 'suit',
      desc: '',
      args: [],
    );
  }

  /// `Business Suit`
  String get business_suit {
    return Intl.message(
      'Business Suit',
      name: 'business_suit',
      desc: '',
      args: [],
    );
  }

  /// `Casual Suit`
  String get casual_suit {
    return Intl.message(
      'Casual Suit',
      name: 'casual_suit',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get shoes {
    return Intl.message(
      'Shoes',
      name: 'shoes',
      desc: '',
      args: [],
    );
  }

  /// `Leather Shoes`
  String get leather_shoes {
    return Intl.message(
      'Leather Shoes',
      name: 'leather_shoes',
      desc: '',
      args: [],
    );
  }

  /// `Sneakers`
  String get sneakers {
    return Intl.message(
      'Sneakers',
      name: 'sneakers',
      desc: '',
      args: [],
    );
  }

  /// `Tie`
  String get tie {
    return Intl.message(
      'Tie',
      name: 'tie',
      desc: '',
      args: [],
    );
  }

  /// `Silk Tie`
  String get silk_tie {
    return Intl.message(
      'Silk Tie',
      name: 'silk_tie',
      desc: '',
      args: [],
    );
  }

  /// `Polyester Tie`
  String get polyester_tie {
    return Intl.message(
      'Polyester Tie',
      name: 'polyester_tie',
      desc: '',
      args: [],
    );
  }

  /// `Wedding Dress`
  String get wedding_dress {
    return Intl.message(
      'Wedding Dress',
      name: 'wedding_dress',
      desc: '',
      args: [],
    );
  }

  /// `Traditional Wedding Dress`
  String get traditional_wedding_dress {
    return Intl.message(
      'Traditional Wedding Dress',
      name: 'traditional_wedding_dress',
      desc: '',
      args: [],
    );
  }

  /// `Modern Wedding Dress`
  String get modern_wedding_dress {
    return Intl.message(
      'Modern Wedding Dress',
      name: 'modern_wedding_dress',
      desc: '',
      args: [],
    );
  }

  /// `Jacket`
  String get jacket {
    return Intl.message(
      'Jacket',
      name: 'jacket',
      desc: '',
      args: [],
    );
  }

  /// `Bomber Jacket`
  String get bomber_jacket {
    return Intl.message(
      'Bomber Jacket',
      name: 'bomber_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Blazer Jacket`
  String get blazer_jacket {
    return Intl.message(
      'Blazer Jacket',
      name: 'blazer_jacket',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to continue?`
  String get sureContinue {
    return Intl.message(
      'Are you sure to continue?',
      name: 'sureContinue',
      desc: '',
      args: [],
    );
  }

  /// `There are no reports actually!`
  String get noReports {
    return Intl.message(
      'There are no reports actually!',
      name: 'noReports',
      desc: '',
      args: [],
    );
  }

  /// `You have no subscriptions yet!`
  String get noSubs {
    return Intl.message(
      'You have no subscriptions yet!',
      name: 'noSubs',
      desc: '',
      args: [],
    );
  }

  /// `Added request successfully!`
  String get reqAdded {
    return Intl.message(
      'Added request successfully!',
      name: 'reqAdded',
      desc: '',
      args: [],
    );
  }

  /// `Added Banner successfully`
  String get addedBanner {
    return Intl.message(
      'Added Banner successfully',
      name: 'addedBanner',
      desc: '',
      args: [],
    );
  }

  /// `Done, tap to update`
  String get doneBanner {
    return Intl.message(
      'Done, tap to update',
      name: 'doneBanner',
      desc: '',
      args: [],
    );
  }

  /// `Add english banner`
  String get enBanner {
    return Intl.message(
      'Add english banner',
      name: 'enBanner',
      desc: '',
      args: [],
    );
  }

  /// `Add arabic banner`
  String get arBanner {
    return Intl.message(
      'Add arabic banner',
      name: 'arBanner',
      desc: '',
      args: [],
    );
  }

  /// `Banners`
  String get banners {
    return Intl.message(
      'Banners',
      name: 'banners',
      desc: '',
      args: [],
    );
  }

  /// `Manage Sections`
  String get manageSections {
    return Intl.message(
      'Manage Sections',
      name: 'manageSections',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this sections?`
  String get sureDeleteSection {
    return Intl.message(
      'Are you sure to delete this sections?',
      name: 'sureDeleteSection',
      desc: '',
      args: [],
    );
  }

  /// `Section details`
  String get secDetails {
    return Intl.message(
      'Section details',
      name: 'secDetails',
      desc: '',
      args: [],
    );
  }

  /// `Section title english`
  String get secTitleEnglish {
    return Intl.message(
      'Section title english',
      name: 'secTitleEnglish',
      desc: '',
      args: [],
    );
  }

  /// `Section title arabic`
  String get secTitleArabic {
    return Intl.message(
      'Section title arabic',
      name: 'secTitleArabic',
      desc: '',
      args: [],
    );
  }

  /// `Image picked!`
  String get imagePicked {
    return Intl.message(
      'Image picked!',
      name: 'imagePicked',
      desc: '',
      args: [],
    );
  }

  /// `Pick image`
  String get pickImage {
    return Intl.message(
      'Pick image',
      name: 'pickImage',
      desc: '',
      args: [],
    );
  }

  /// `Section added successfully`
  String get secAdded {
    return Intl.message(
      'Section added successfully',
      name: 'secAdded',
      desc: '',
      args: [],
    );
  }

  /// `Add a new section`
  String get addSec {
    return Intl.message(
      'Add a new section',
      name: 'addSec',
      desc: '',
      args: [],
    );
  }

  /// `Category Details`
  String get catDetails {
    return Intl.message(
      'Category Details',
      name: 'catDetails',
      desc: '',
      args: [],
    );
  }

  /// `Category title arabic`
  String get catAr {
    return Intl.message(
      'Category title arabic',
      name: 'catAr',
      desc: '',
      args: [],
    );
  }

  /// `Category title english`
  String get catEn {
    return Intl.message(
      'Category title english',
      name: 'catEn',
      desc: '',
      args: [],
    );
  }

  /// `Added Category Successfully`
  String get addedCat {
    return Intl.message(
      'Added Category Successfully',
      name: 'addedCat',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCat {
    return Intl.message(
      'Add Category',
      name: 'addCat',
      desc: '',
      args: [],
    );
  }

  /// `SubItem details`
  String get subitemDetails {
    return Intl.message(
      'SubItem details',
      name: 'subitemDetails',
      desc: '',
      args: [],
    );
  }

  /// `SubItem title arabic`
  String get subAr {
    return Intl.message(
      'SubItem title arabic',
      name: 'subAr',
      desc: '',
      args: [],
    );
  }

  /// `SubItem title english`
  String get subEn {
    return Intl.message(
      'SubItem title english',
      name: 'subEn',
      desc: '',
      args: [],
    );
  }

  /// `SubItem added successfully`
  String get subAdded {
    return Intl.message(
      'SubItem added successfully',
      name: 'subAdded',
      desc: '',
      args: [],
    );
  }

  /// `Item added successfully`
  String get itemAdded {
    return Intl.message(
      'Item added successfully',
      name: 'itemAdded',
      desc: '',
      args: [],
    );
  }

  /// `Add a new subitem`
  String get addSub {
    return Intl.message(
      'Add a new subitem',
      name: 'addSub',
      desc: '',
      args: [],
    );
  }

  /// `Item details`
  String get itemDetails {
    return Intl.message(
      'Item details',
      name: 'itemDetails',
      desc: '',
      args: [],
    );
  }

  /// `Item title arabic`
  String get itemAr {
    return Intl.message(
      'Item title arabic',
      name: 'itemAr',
      desc: '',
      args: [],
    );
  }

  /// `Item title english`
  String get itemEn {
    return Intl.message(
      'Item title english',
      name: 'itemEn',
      desc: '',
      args: [],
    );
  }

  /// `Add a new item`
  String get addItem {
    return Intl.message(
      'Add a new item',
      name: 'addItem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this section`
  String get sureDeleteSec {
    return Intl.message(
      'Are you sure to delete this section',
      name: 'sureDeleteSec',
      desc: '',
      args: [],
    );
  }

  /// `Modifed section details successfully`
  String get modifedSec {
    return Intl.message(
      'Modifed section details successfully',
      name: 'modifedSec',
      desc: '',
      args: [],
    );
  }

  /// `Deleted section successfully`
  String get deleteSec {
    return Intl.message(
      'Deleted section successfully',
      name: 'deleteSec',
      desc: '',
      args: [],
    );
  }

  /// `Item was updated successfully`
  String get itemUpdated {
    return Intl.message(
      'Item was updated successfully',
      name: 'itemUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Update Picture`
  String get updatedPic {
    return Intl.message(
      'Update Picture',
      name: 'updatedPic',
      desc: '',
      args: [],
    );
  }

  /// `Deleted item successfully`
  String get deleteItem {
    return Intl.message(
      'Deleted item successfully',
      name: 'deleteItem',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this item?`
  String get sureDeleteItem {
    return Intl.message(
      'Are you sure to delete this item?',
      name: 'sureDeleteItem',
      desc: '',
      args: [],
    );
  }

  /// `Terms & conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms & conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy & Policy`
  String get privacyP {
    return Intl.message(
      'Privacy & Policy',
      name: 'privacyP',
      desc: '',
      args: [],
    );
  }

  /// `Our products`
  String get ourProducts {
    return Intl.message(
      'Our products',
      name: 'ourProducts',
      desc: '',
      args: [],
    );
  }

  /// `Logout successful`
  String get logoutSuc {
    return Intl.message(
      'Logout successful',
      name: 'logoutSuc',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accSettings {
    return Intl.message(
      'Account Settings',
      name: 'accSettings',
      desc: '',
      args: [],
    );
  }

  /// `Manage Products`
  String get manageProducts {
    return Intl.message(
      'Manage Products',
      name: 'manageProducts',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message(
      'Add Product',
      name: 'addProduct',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this product`
  String get sureDeleteProduct {
    return Intl.message(
      'Are you sure to delete this product',
      name: 'sureDeleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `New items will be added soon`
  String get itemsSoon {
    return Intl.message(
      'New items will be added soon',
      name: 'itemsSoon',
      desc: '',
      args: [],
    );
  }

  /// `Order Placed`
  String get placed {
    return Intl.message(
      'Order Placed',
      name: 'placed',
      desc: '',
      args: [],
    );
  }

  /// `Order In Progress`
  String get inProg {
    return Intl.message(
      'Order In Progress',
      name: 'inProg',
      desc: '',
      args: [],
    );
  }

  /// `Out for delivery`
  String get outForDelivery {
    return Intl.message(
      'Out for delivery',
      name: 'outForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `at `
  String get at {
    return Intl.message(
      'at ',
      name: 'at',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get currentLoc {
    return Intl.message(
      'Current Location',
      name: 'currentLoc',
      desc: '',
      args: [],
    );
  }

  /// `Address details`
  String get addressDetails {
    return Intl.message(
      'Address details',
      name: 'addressDetails',
      desc: '',
      args: [],
    );
  }

  /// `Al Asimah`
  String get asimah {
    return Intl.message(
      'Al Asimah',
      name: 'asimah',
      desc: '',
      args: [],
    );
  }

  /// `Hawalli`
  String get hawalli {
    return Intl.message(
      'Hawalli',
      name: 'hawalli',
      desc: '',
      args: [],
    );
  }

  /// `Farwaniya`
  String get farwaniya {
    return Intl.message(
      'Farwaniya',
      name: 'farwaniya',
      desc: '',
      args: [],
    );
  }

  /// `Mubarak Al-Kabeer`
  String get mubarakAlKabeer {
    return Intl.message(
      'Mubarak Al-Kabeer',
      name: 'mubarakAlKabeer',
      desc: '',
      args: [],
    );
  }

  /// `Al Jahra`
  String get jahra {
    return Intl.message(
      'Al Jahra',
      name: 'jahra',
      desc: '',
      args: [],
    );
  }

  /// `Al Ahmadi`
  String get ahmadi {
    return Intl.message(
      'Al Ahmadi',
      name: 'ahmadi',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Please fill the necessary address informations`
  String get necessaryData {
    return Intl.message(
      'Please fill the necessary address informations',
      name: 'necessaryData',
      desc: '',
      args: [],
    );
  }

  /// `Your order was added successfully`
  String get orderSuc {
    return Intl.message(
      'Your order was added successfully',
      name: 'orderSuc',
      desc: '',
      args: [],
    );
  }

  /// `Credit added successfully check your balance`
  String get subSuc {
    return Intl.message(
      'Credit added successfully check your balance',
      name: 'subSuc',
      desc: '',
      args: [],
    );
  }

  /// `In case you continue, our team will contact you soon!`
  String get sureReq {
    return Intl.message(
      'In case you continue, our team will contact you soon!',
      name: 'sureReq',
      desc: '',
      args: [],
    );
  }

  /// `Please add the request date`
  String get addReqDate {
    return Intl.message(
      'Please add the request date',
      name: 'addReqDate',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you can only send one driver request every 24 hours. Please try again later.`
  String get errorDriverReq {
    return Intl.message(
      'Sorry, you can only send one driver request every 24 hours. Please try again later.',
      name: 'errorDriverReq',
      desc: '',
      args: [],
    );
  }

  /// `No special instructions`
  String get noInstructions {
    return Intl.message(
      'No special instructions',
      name: 'noInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Effective Date: October 23, 2024`
  String get effective_date {
    return Intl.message(
      'Effective Date: October 23, 2024',
      name: 'effective_date',
      desc: '',
      args: [],
    );
  }

  /// `Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our app.`
  String get introduction_content {
    return Intl.message(
      'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your information when you use our app.',
      name: 'introduction_content',
      desc: '',
      args: [],
    );
  }

  /// `2. Information We Collect`
  String get info_we_collect {
    return Intl.message(
      '2. Information We Collect',
      name: 'info_we_collect',
      desc: '',
      args: [],
    );
  }

  /// `- Personal Information: Name, email, phone number, etc.\n- Usage Data: Information on how the app is accessed and used.\n- Location Data: If you permit, we collect location data to provide location-based services.`
  String get info_we_collect_content {
    return Intl.message(
      '- Personal Information: Name, email, phone number, etc.\n- Usage Data: Information on how the app is accessed and used.\n- Location Data: If you permit, we collect location data to provide location-based services.',
      name: 'info_we_collect_content',
      desc: '',
      args: [],
    );
  }

  /// `3. How We Use Your Information`
  String get how_we_use {
    return Intl.message(
      '3. How We Use Your Information',
      name: 'how_we_use',
      desc: '',
      args: [],
    );
  }

  /// `We use the collected data to:\n- Provide and maintain our service\n- Improve and personalize user experience\n- Contact you with updates and promotional offers\n- Ensure security and prevent fraud`
  String get how_we_use_content {
    return Intl.message(
      'We use the collected data to:\n- Provide and maintain our service\n- Improve and personalize user experience\n- Contact you with updates and promotional offers\n- Ensure security and prevent fraud',
      name: 'how_we_use_content',
      desc: '',
      args: [],
    );
  }

  /// `4. Sharing Your Information`
  String get sharing_info {
    return Intl.message(
      '4. Sharing Your Information',
      name: 'sharing_info',
      desc: '',
      args: [],
    );
  }

  /// `We do not share your personal information with third parties except for the purposes of providing our services or as required by law.`
  String get sharing_info_content {
    return Intl.message(
      'We do not share your personal information with third parties except for the purposes of providing our services or as required by law.',
      name: 'sharing_info_content',
      desc: '',
      args: [],
    );
  }

  /// `5. Your Rights`
  String get your_rights {
    return Intl.message(
      '5. Your Rights',
      name: 'your_rights',
      desc: '',
      args: [],
    );
  }

  /// `You have the right to access, modify, or delete your personal data. You can contact us at any time to exercise these rights.`
  String get your_rights_content {
    return Intl.message(
      'You have the right to access, modify, or delete your personal data. You can contact us at any time to exercise these rights.',
      name: 'your_rights_content',
      desc: '',
      args: [],
    );
  }

  /// `6. Contact Us`
  String get contact_us {
    return Intl.message(
      '6. Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions about this Privacy Policy, please contact us at: trustlaundry@hotmail.com`
  String get contact_us_content {
    return Intl.message(
      'If you have any questions about this Privacy Policy, please contact us at: trustlaundry@hotmail.com',
      name: 'contact_us_content',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get introduction {
    return Intl.message(
      'Introduction',
      name: 'introduction',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to our laundry app. By using the app, you agree to the following terms and conditions.`
  String get introduction_for_terms {
    return Intl.message(
      'Welcome to our laundry app. By using the app, you agree to the following terms and conditions.',
      name: 'introduction_for_terms',
      desc: '',
      args: [],
    );
  }

  /// `User Accounts and Registration`
  String get user_accounts {
    return Intl.message(
      'User Accounts and Registration',
      name: 'user_accounts',
      desc: '',
      args: [],
    );
  }

  /// `Users must create an account to place orders and access services.`
  String get user_accounts_content {
    return Intl.message(
      'Users must create an account to place orders and access services.',
      name: 'user_accounts_content',
      desc: '',
      args: [],
    );
  }

  /// `Creating and Managing Orders`
  String get creating_orders {
    return Intl.message(
      'Creating and Managing Orders',
      name: 'creating_orders',
      desc: '',
      args: [],
    );
  }

  /// `Users can create laundry orders and track their status in the app.`
  String get creating_orders_content {
    return Intl.message(
      'Users can create laundry orders and track their status in the app.',
      name: 'creating_orders_content',
      desc: '',
      args: [],
    );
  }

  /// `Payment and Fees`
  String get payment_and_fees {
    return Intl.message(
      'Payment and Fees',
      name: 'payment_and_fees',
      desc: '',
      args: [],
    );
  }

  /// `Payments are made online. Additional charges may apply for special services.`
  String get payment_and_fees_content {
    return Intl.message(
      'Payments are made online. Additional charges may apply for special services.',
      name: 'payment_and_fees_content',
      desc: '',
      args: [],
    );
  }

  /// `Order Cancellation and Refunds`
  String get cancellation_and_refunds {
    return Intl.message(
      'Order Cancellation and Refunds',
      name: 'cancellation_and_refunds',
      desc: '',
      args: [],
    );
  }

  /// `Users can cancel orders before processing begins. Refunds depend on the order status.`
  String get cancellation_and_refunds_content {
    return Intl.message(
      'Users can cancel orders before processing begins. Refunds depend on the order status.',
      name: 'cancellation_and_refunds_content',
      desc: '',
      args: [],
    );
  }

  /// `User Responsibilities`
  String get user_responsibilities {
    return Intl.message(
      'User Responsibilities',
      name: 'user_responsibilities',
      desc: '',
      args: [],
    );
  }

  /// `Users must provide accurate information and collect orders on time.`
  String get user_responsibilities_content {
    return Intl.message(
      'Users must provide accurate information and collect orders on time.',
      name: 'user_responsibilities_content',
      desc: '',
      args: [],
    );
  }

  /// `Limitations of Liability`
  String get limitations_of_liability {
    return Intl.message(
      'Limitations of Liability',
      name: 'limitations_of_liability',
      desc: '',
      args: [],
    );
  }

  /// `The app is not responsible for delays caused by unforeseen circumstances.`
  String get limitations_of_liability_content {
    return Intl.message(
      'The app is not responsible for delays caused by unforeseen circumstances.',
      name: 'limitations_of_liability_content',
      desc: '',
      args: [],
    );
  }

  /// `Modifications to the Service`
  String get modifications_to_service {
    return Intl.message(
      'Modifications to the Service',
      name: 'modifications_to_service',
      desc: '',
      args: [],
    );
  }

  /// `We reserve the right to modify the service at any time.`
  String get modifications_to_service_content {
    return Intl.message(
      'We reserve the right to modify the service at any time.',
      name: 'modifications_to_service_content',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contact_info {
    return Intl.message(
      'Contact Information',
      name: 'contact_info',
      desc: '',
      args: [],
    );
  }

  /// `If you have questions, please contact us at trustlaundry@hotmail.com.`
  String get contact_info_content {
    return Intl.message(
      'If you have questions, please contact us at trustlaundry@hotmail.com.',
      name: 'contact_info_content',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newPwd {
    return Intl.message(
      'New password',
      name: 'newPwd',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get confirmPwd {
    return Intl.message(
      'Confirm new password',
      name: 'confirmPwd',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password!`
  String get confirmEmpty {
    return Intl.message(
      'Please confirm your new password!',
      name: 'confirmEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match!`
  String get pwdNotMatch {
    return Intl.message(
      'Passwords do not match!',
      name: 'pwdNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully!`
  String get pwdUpdated {
    return Intl.message(
      'Password updated successfully!',
      name: 'pwdUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Password field should not be empty!`
  String get passwordEmpty {
    return Intl.message(
      'Password field should not be empty!',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password too weak!`
  String get passwordWeak {
    return Intl.message(
      'Password too weak!',
      name: 'passwordWeak',
      desc: '',
      args: [],
    );
  }

  /// `Password too short!`
  String get passwordShort {
    return Intl.message(
      'Password too short!',
      name: 'passwordShort',
      desc: '',
      args: [],
    );
  }

  /// `Email invalid!`
  String get emailWrong {
    return Intl.message(
      'Email invalid!',
      name: 'emailWrong',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get emailEmpty {
    return Intl.message(
      'Email cannot be empty',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already {
    return Intl.message(
      'Already have an account?',
      name: 'already',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPwd {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPwd',
      desc: '',
      args: [],
    );
  }

  /// `Fast Price`
  String get fastPrice {
    return Intl.message(
      'Fast Price',
      name: 'fastPrice',
      desc: '',
      args: [],
    );
  }

  /// `fast`
  String get mousta3jil {
    return Intl.message(
      'fast',
      name: 'mousta3jil',
      desc: '',
      args: [],
    );
  }

  /// `No fast`
  String get noMousta3jil {
    return Intl.message(
      'No fast',
      name: 'noMousta3jil',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe Now`
  String get subscribeNow {
    return Intl.message(
      'Subscribe Now',
      name: 'subscribeNow',
      desc: '',
      args: [],
    );
  }

  /// `Save more`
  String get saveMore {
    return Intl.message(
      'Save more',
      name: 'saveMore',
      desc: '',
      args: [],
    );
  }

  /// `to have`
  String get taghsel {
    return Intl.message(
      'to have',
      name: 'taghsel',
      desc: '',
      args: [],
    );
  }

  /// `Washing + Ironing + Fragrance`
  String get ghasil {
    return Intl.message(
      'Washing + Ironing + Fragrance',
      name: 'ghasil',
      desc: '',
      args: [],
    );
  }

  /// `Pickup and delivery of clothes is free`
  String get freeDelivery {
    return Intl.message(
      'Pickup and delivery of clothes is free',
      name: 'freeDelivery',
      desc: '',
      args: [],
    );
  }

  /// `title in arabic`
  String get productAr {
    return Intl.message(
      'title in arabic',
      name: 'productAr',
      desc: '',
      args: [],
    );
  }

  /// `title in english`
  String get productEn {
    return Intl.message(
      'title in english',
      name: 'productEn',
      desc: '',
      args: [],
    );
  }

  /// `Price after discount`
  String get priceAfterDiscount {
    return Intl.message(
      'Price after discount',
      name: 'priceAfterDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get prDescription {
    return Intl.message(
      'Product Description',
      name: 'prDescription',
      desc: '',
      args: [],
    );
  }

  /// `Request Product`
  String get reqPr {
    return Intl.message(
      'Request Product',
      name: 'reqPr',
      desc: '',
      args: [],
    );
  }

  /// `rate`
  String get rater {
    return Intl.message(
      'rate',
      name: 'rater',
      desc: '',
      args: [],
    );
  }

  /// `Rate this product`
  String get rate {
    return Intl.message(
      'Rate this product',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Sorry we cannot pickup your laundry at the specified timing, please choose another timing (time must be at lease 4h from now)`
  String get sorryForNotPicking {
    return Intl.message(
      'Sorry we cannot pickup your laundry at the specified timing, please choose another timing (time must be at lease 4h from now)',
      name: 'sorryForNotPicking',
      desc: '',
      args: [],
    );
  }

  /// `Please select a time between 8:00 AM and 6:00 PM`
  String get selectPeriodCorrect {
    return Intl.message(
      'Please select a time between 8:00 AM and 6:00 PM',
      name: 'selectPeriodCorrect',
      desc: '',
      args: [],
    );
  }

  /// `Title in arabic`
  String get titleAr {
    return Intl.message(
      'Title in arabic',
      name: 'titleAr',
      desc: '',
      args: [],
    );
  }

  /// `Title in english`
  String get titleEn {
    return Intl.message(
      'Title in english',
      name: 'titleEn',
      desc: '',
      args: [],
    );
  }

  /// `Content in arabic`
  String get contentAr {
    return Intl.message(
      'Content in arabic',
      name: 'contentAr',
      desc: '',
      args: [],
    );
  }

  /// `Content in english`
  String get contentEn {
    return Intl.message(
      'Content in english',
      name: 'contentEn',
      desc: '',
      args: [],
    );
  }

  /// `Email or password is incorrect, try again`
  String get emailOrPwdWrong {
    return Intl.message(
      'Email or password is incorrect, try again',
      name: 'emailOrPwdWrong',
      desc: '',
      args: [],
    );
  }

  /// `Manage password`
  String get managePwd {
    return Intl.message(
      'Manage password',
      name: 'managePwd',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Products Requests`
  String get reqProd {
    return Intl.message(
      'Products Requests',
      name: 'reqProd',
      desc: '',
      args: [],
    );
  }

  /// `You have no products requests`
  String get noReqProd {
    return Intl.message(
      'You have no products requests',
      name: 'noReqProd',
      desc: '',
      args: [],
    );
  }

  /// `Total products orders`
  String get totalProdOrders {
    return Intl.message(
      'Total products orders',
      name: 'totalProdOrders',
      desc: '',
      args: [],
    );
  }

  /// `Successully added the product, our team will contact you soon to confirm your order`
  String get addedToCard {
    return Intl.message(
      'Successully added the product, our team will contact you soon to confirm your order',
      name: 'addedToCard',
      desc: '',
      args: [],
    );
  }

  /// `Service: `
  String get service {
    return Intl.message(
      'Service: ',
      name: 'service',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
