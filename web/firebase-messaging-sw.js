importScripts('https://www.gstatic.com/firebasejs/10.1.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.1.0/firebase-messaging-compat.js');

   /*Update with yours config*/
  const firebaseConfig = {
        apiKey: "AIzaSyDyIg9FytYP3784AuOVm4K4QGYofdZFoe4",
      authDomain: "compra-c8725.firebaseapp.com",
      projectId: "compra-c8725",
      storageBucket: "compra-c8725.appspot.com",
      messagingSenderId: "325176695118",
      appId: "1:325176695118:web:470a718620eb609fcb661f",
      measurementId: "G-TLP8YFH46T",
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  messaging.onMessage((payload) => {
  console.log('Message received. ', payload);
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  })});