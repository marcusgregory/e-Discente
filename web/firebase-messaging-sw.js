importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCurVNnancHobYHW35inanXhkHz24bQ7vg",
  authDomain: "e-discente-2dbb4.firebaseapp.com",
  databaseURL: "e-discente-2dbb4.firebaseapp.com",
  projectId: "e-discente-2dbb4",
  storageBucket: "e-discente-2dbb4.appspot.com",
  messagingSenderId: "356886769409",
  appId: "1:356886769409:web:b9e0ee7288b01f35db3500",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
